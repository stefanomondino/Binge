//
//  UIView+KeyboardAvoidable.swift
//  App
//
//  Created by Alberto Bo on 26/01/2020.
//  Copyright © 2020 Synesthesia. All rights reserved.
//
#if !os(iOS)
    import RxSwift
    import UIKit
    public protocol KeyboardAvoidable: UIViewController {
        func setupKeyboardAvoiding() -> Disposable
    }

    public extension KeyboardAvoidable {
        func setupKeyboardAvoiding() -> Disposable {
            return Disposables.create()
        }
    }
#else
    import Boomerang
    import RxCocoa
    import RxSwift
    import UIKit

    private struct AssociatedKeys {
        static var typist = "typist"
    }

    public protocol KeyboardAvoidable: UIViewController {
        var keyboardAvoidingView: UIView { get }
        var paddingForAvoidingView: CGFloat { get }
        var bottomConstraint: NSLayoutConstraint? { get }
        func setupKeyboardAvoiding() -> Disposable
    }

    public extension KeyboardAvoidable {
        var bottomConstraint: NSLayoutConstraint? {
            return keyboardAvoidingView.superview?.constraints.filter {
                ($0.firstAttribute == .bottom && ($0.firstItem as? UIView) == self.keyboardAvoidingView) ||
                    ($0.secondAttribute == .bottom && ($0.secondItem as? UIView) == self.keyboardAvoidingView)
            }.first
        }

        private var typist: Typist {
            guard let lookup = objc_getAssociatedObject(self, &AssociatedKeys.typist) as? Typist else {
                let typist = Typist()
                objc_setAssociatedObject(self, &AssociatedKeys.typist, typist, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return typist
            }
            return lookup
        }

        var paddingForAvoidingView: CGFloat {
            // Calculate bottom difference for Tab bar and stuff.
            if let rootView = UIApplication.shared.delegate?.window??.rootViewController?.view {
                let rect = view.convert(view.frame, to: rootView)
                let padding = -(rootView.bounds.height - rect.height - rect.minY)
                return padding
            }
            return 0
        }

        var direction: CGFloat {
            return ((bottomConstraint?.firstItem as? UIView) == keyboardAvoidingView) ? -1 : 1
        }

        func setupKeyboardAvoiding() -> Disposable {
            let viewController = self as UIViewController
            var originalValue = (bottomConstraint?.constant ?? 0) * direction

            let disappear = viewController.rx
                .viewWillDisappear()
                .subscribe(onNext: { [weak viewController] _ in
                    viewController?.view.endEditing(true)
                })

            let appear = viewController.rx
                .viewWillAppear()
                .enumerated()
                .flatMapLatest { [weak self] tuple -> Observable<Typist.KeyboardOptions> in
                    guard let self = self else { return .empty() }
                    if tuple.index == 0 {
                        originalValue = (self.bottomConstraint?.constant ?? 0) * self.direction
                    }
                    return self.typist.rx
                        .keyboardFrameOptions()
                        .takeUntil(self.rx.viewDisappear())
                }
                .subscribe(onNext: { [weak self] options in
                    guard let self = self else { return }
                    let optionBottom = options.bottomValue == 0 ? 0 : options.bottomValue + self.paddingForAvoidingView
                    let value = originalValue + optionBottom

                    let animationValue = value == originalValue ? originalValue : self.direction * abs(value)
                    if self.bottomConstraint?.constant == animationValue { return }
                    Logger.log("Resizing Keyboard with value for constraint: \(value)", level: .verbose)
                    self.bottomConstraint?.constant = animationValue
                    UIView.animate(withDuration: options.animationDuration,
                                   delay: 0.0,
                                   options: [UIView.AnimationOptions(curve: options.animationCurve)],
                                   animations: { [weak self] in self?.view.layoutIfNeeded() },
                                   completion: nil)
                })
            return CompositeDisposable(appear, disappear)
        }
    }

    extension Reactive where Base: Typist {
        func keyboardFrameOptions() -> Observable<Typist.KeyboardOptions> {
            return Observable.create { [weak base] (obs) -> Disposable in
                base?.on(event: .willHide) {
                    obs.onNext($0)
                }.on(event: .didHide) {
                    obs.onNext($0)
                }.on(event: .willShow) {
                    obs.onNext($0)
                }.on(event: .didShow) {
                    obs.onNext($0)
                }.on(event: .willChangeFrame) {
                    obs.onNext($0)
                }.on(event: .didChangeFrame) {
                    obs.onNext($0)
                }.start()
                return Disposables.create()
            }
        }
    }

    extension UIView.AnimationCurve {
        var timingFunctionName: CAMediaTimingFunctionName {
            switch self {
            case .easeIn: return .easeIn
            case .easeOut: return .easeOut
            case .easeInOut: return CAMediaTimingFunctionName.easeInEaseOut
            //        case .linear: return .linear
            default: return .linear
            }
        }
    }

    extension Typist.KeyboardOptions {
        var bottomValue: CGFloat {
            return ((UIApplication.shared.delegate?.window??.bounds.height ?? 0) - endFrame.origin.y)
        }
    }

    // swiftlint:disable line_length
    /**
     Typist is small, drop-in Swift UIKit keyboard manager for iOS apps. It helps you manage keyboard's screen presence and behavior without notification center and Objective-C.

     Declare what should happen on what event and `start()` listening to keyboard events. Like so:

     ```
     let keyboard = Typist.shared

     func configureKeyboard() {
     keyboard
     .on(event: .didShow) { (options) in
     print("New Keyboard Frame is \(options.endFrame).")
     }
     .on(event: .didHide) { (options) in
     print("It took \(options.animationDuration) seconds to animate keyboard out.")
     }
     .start()
     }
     ```

     Usage of both—`shared` singleton, or your own instance of `Typist`—is considered to be OK depending on what you want to accomplish. However, **do not use singleton** when two or more objects (`UIViewController`s, most likely) using `Typist.shared` are presented on screen simultaneously. This will cause one of the controllers to fail at receiving keyboard events.

     You _must_ call `start()` for callbacks to be triggered. Calling `stop()` on instance will stop callbacks from triggering, but callbacks themselves won't be dismissed, thus you can resume event callbacks by calling `start()` again.

     To remove all event callbacks, call `clear()`.
     */
    public class Typist: NSObject {
        /// Returns the shared instance of Typist, creating it if necessary.
        public static let shared = Typist()

        /// Inert/immutable objects which carries all data that keyboard has at the event of happening.
        public struct KeyboardOptions {
            /// Identifies whether the keyboard belongs to the current app. With multitasking on iPad, all visible apps are notified when the keyboard appears and disappears. The value of this key is `true` for the app that caused the keyboard to appear and `false` for any other apps.
            public let belongsToCurrentApp: Bool

            /// Identifies the start frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the `convertRect:fromWindow:` method) or to view coordinates (using the `convertRect:fromView:` method) before using it.
            public let startFrame: CGRect

            /// Identifies the end frame of the keyboard in screen coordinates. These coordinates do not take into account any rotation factors applied to the window’s contents as a result of interface orientation changes. Thus, you may need to convert the rectangle to window coordinates (using the `convertRect:fromWindow:` method) or to view coordinates (using the `convertRect:fromView:` method) before using it.
            public let endFrame: CGRect

            /// Constant that defines how the keyboard will be animated onto or off the screen.
            public let animationCurve: UIView.AnimationCurve

            /// Identifies the duration of the animation in seconds.
            public let animationDuration: Double

            /// Maps the animationCurve to it's respective `UIView.AnimationOptions` value.
            public var animationOptions: UIView.AnimationOptions {
                switch animationCurve {
                case UIView.AnimationCurve.easeIn:
                    return UIView.AnimationOptions.curveEaseIn
                case UIView.AnimationCurve.easeInOut:
                    return UIView.AnimationOptions.curveEaseInOut
                case UIView.AnimationCurve.easeOut:
                    return UIView.AnimationOptions.curveEaseOut
                case UIView.AnimationCurve.linear:
                    return UIView.AnimationOptions.curveLinear
                @unknown default:
                    fatalError()
                }
            }
        }

        /// TypistCallback
        public typealias TypistCallback = (KeyboardOptions) -> Void

        /// Keyboard events that can happen. Translates directly to `UIKeyboard` notifications from UIKit.
        public enum KeyboardEvent {
            /// Event raised by UIKit's `.UIKeyboardWillShow`.
            case willShow

            /// Event raised by UIKit's `.UIKeyboardDidShow`.
            case didShow

            /// Event raised by UIKit's `.UIKeyboardWillShow`.
            case willHide

            /// Event raised by UIKit's `.UIKeyboardDidHide`.
            case didHide

            /// Event raised by UIKit's `.UIKeyboardWillChangeFrame`.
            case willChangeFrame

            /// Event raised by UIKit's `.UIKeyboardDidChangeFrame`.
            case didChangeFrame
        }

        /// Declares Typist behavior. Pass a closure parameter and event to bind those two. Without calling `start()` none of the closures will be executed.
        ///
        /// - parameter event: Event on which callback should be executed.
        /// - parameter do: Closure of code which will be executed on keyboard `event`.
        /// - returns: `Self` for convenience so many `on` functions can be chained.
        @discardableResult
        public func on(event: KeyboardEvent, do callback: TypistCallback?) -> Self {
            callbacks[event] = callback
            return self
        }

        public func toolbar(scrollView: UIScrollView) -> Self {
            self.scrollView = scrollView
            return self
        }

        /// Starts listening to events and calling corresponding events handlers.
        public func start() {
            let center = NotificationCenter.default

            for event in callbacks.keys {
                center.addObserver(self, selector: event.selector, name: event.notification, object: nil)
            }
        }

        /// Stops listening to keyboard events. Callback closures won't be cleared, thus calling `start()` again will resume calling previously set event handlers.
        public func stop() {
            let center = NotificationCenter.default
            center.removeObserver(self)
        }

        /// Clears all event handlers. Equivalent of setting `nil` for all events.
        public func clear() {
            callbacks.removeAll()
        }

        deinit {
            stop()
        }

        // MARK: - How sausages are made

        internal var callbacks: [KeyboardEvent: TypistCallback] = [:]

        internal func keyboardOptions(fromNotificationDictionary userInfo: [AnyHashable: Any]?) -> KeyboardOptions {
            var currentApp = true
            if #available(iOS 9.0, *) {
                if let value = (userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue {
                    currentApp = value
                }
            }

            var endFrame = CGRect()
            if let value = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                endFrame = value
            }

            var startFrame = CGRect()
            if let value = (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                startFrame = value
            }

            var animationCurve = UIView.AnimationCurve.linear
            if let index = (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
                let value = UIView.AnimationCurve(rawValue: index) {
                animationCurve = value
            }

            var animationDuration: Double = 0.0
            if let value = (userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
                animationDuration = value
            }

            return KeyboardOptions(belongsToCurrentApp: currentApp, startFrame: startFrame, endFrame: endFrame, animationCurve: animationCurve, animationDuration: animationDuration)
        }

        // MARK: - UIKit notification handling

        @objc internal func keyboardWillShow(note: Notification) {
            callbacks[.willShow]?(keyboardOptions(fromNotificationDictionary: note.userInfo))
        }

        @objc internal func keyboardDidShow(note: Notification) {
            callbacks[.didShow]?(keyboardOptions(fromNotificationDictionary: note.userInfo))
        }

        @objc internal func keyboardWillHide(note: Notification) {
            callbacks[.willHide]?(keyboardOptions(fromNotificationDictionary: note.userInfo))
        }

        @objc internal func keyboardDidHide(note: Notification) {
            callbacks[.didHide]?(keyboardOptions(fromNotificationDictionary: note.userInfo))
        }

        @objc internal func keyboardWillChangeFrame(note: Notification) {
            callbacks[.willChangeFrame]?(keyboardOptions(fromNotificationDictionary: note.userInfo))
            _options = keyboardOptions(fromNotificationDictionary: note.userInfo)
        }

        @objc internal func keyboardDidChangeFrame(note: Notification) {
            callbacks[.didChangeFrame]?(keyboardOptions(fromNotificationDictionary: note.userInfo))
            _options = keyboardOptions(fromNotificationDictionary: note.userInfo)
        }

        // MARK: - Input Accessory View Support

        fileprivate var scrollView: UIScrollView? {
            didSet {
                scrollView?.keyboardDismissMode = .interactive // allows dismissing keyboard interactively
                scrollView?.addGestureRecognizer(panGesture)
            }
        }

        fileprivate lazy var panGesture: UIPanGestureRecognizer = { [unowned self] in
            let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer))
            recognizer.delegate = self
            return recognizer
        }()

        fileprivate var _options: KeyboardOptions?

        @IBAction func handlePanGestureRecognizer(recognizer: UIPanGestureRecognizer) {
            var useWindowCoordinates = true
            var window: UIWindow?
            var bounds: CGRect = .zero

            // check to see if we can access the UIApplication.sharedApplication property. If not, due to being in an extension context where sharedApplication isn't
            // available, grab the screen bounds and use the screen to determine the touch's absolute location.
            let sharedApplicationSelector = NSSelectorFromString("sharedApplication")
            if let applicationClass = NSClassFromString("UIApplication"), applicationClass.responds(to: sharedApplicationSelector) {
                if let application = UIApplication.perform(sharedApplicationSelector).takeUnretainedValue() as? UIApplication, let appWindow = application.windows.first {
                    window = appWindow
                    bounds = appWindow.bounds
                }
            } else {
                useWindowCoordinates = false
                bounds = UIScreen.main.bounds
            }

            guard
                let options = _options,
                case .changed = recognizer.state,
                let view = recognizer.view
            else { return }

            let location = recognizer.location(in: view)

            var absoluteLocation: CGPoint

            if useWindowCoordinates {
                absoluteLocation = view.convert(location, to: window)
            } else {
                absoluteLocation = view.convert(location, to: UIScreen.main.coordinateSpace)
            }

            var frame = options.endFrame
            frame.origin.y = max(absoluteLocation.y, bounds.height - frame.height)
            frame.size.height = bounds.height - frame.origin.y
            let event = KeyboardOptions(belongsToCurrentApp: options.belongsToCurrentApp, startFrame: options.startFrame, endFrame: frame, animationCurve: options.animationCurve, animationDuration: options.animationDuration)
            callbacks[.willChangeFrame]?(event)
        }
    }

    private extension Typist.KeyboardEvent {
        var notification: NSNotification.Name {
            switch self {
            case .willShow:
                return UIResponder.keyboardWillShowNotification
            case .didShow:
                return UIResponder.keyboardDidShowNotification
            case .willHide:
                return UIResponder.keyboardWillHideNotification
            case .didHide:
                return UIResponder.keyboardDidHideNotification
            case .willChangeFrame:
                return UIResponder.keyboardWillChangeFrameNotification
            case .didChangeFrame:
                return UIResponder.keyboardDidChangeFrameNotification
            }
        }

        var selector: Selector {
            switch self {
            case .willShow:
                return #selector(Typist.keyboardWillShow(note:))
            case .didShow:
                return #selector(Typist.keyboardDidShow(note:))
            case .willHide:
                return #selector(Typist.keyboardWillHide(note:))
            case .didHide:
                return #selector(Typist.keyboardDidHide(note:))
            case .willChangeFrame:
                return #selector(Typist.keyboardWillChangeFrame(note:))
            case .didChangeFrame:
                return #selector(Typist.keyboardDidChangeFrame(note:))
            }
        }
    }

    extension Typist: UIGestureRecognizerDelegate {
        public func gestureRecognizer(_: UIGestureRecognizer, shouldReceive _: UITouch) -> Bool {
            return scrollView?.keyboardDismissMode == .interactive
        }

        public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
            return gestureRecognizer === panGesture
        }
    }

    // MARK: UIView extensions (convenience)

    extension UIView.AnimationOptions {
        public init(curve: UIView.AnimationCurve) {
            switch curve {
            case .easeIn:
                self = [.curveEaseIn]
            case .easeOut:
                self = [.curveEaseOut]
            case .easeInOut:
                self = [.curveEaseInOut]
            case .linear:
                self = [.curveLinear]
            @unknown default:
                self = [.curveLinear]
            }
        }
    }
#endif
