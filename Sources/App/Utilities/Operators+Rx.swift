//
//  Operators.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

import UIKit

// Two way binding operator between control property and variable, that's all it takes {

infix operator <-> : DefaultPrecedence

func nonMarkedText(_ textInput: UITextInput) -> String? {
    let start = textInput.beginningOfDocument
    let end = textInput.endOfDocument
    
    guard let rangeAll = textInput.textRange(from: start, to: end),
        let text = textInput.text(in: rangeAll) else {
            return nil
    }
    
    guard let markedTextRange = textInput.markedTextRange else {
        return text
    }
    
    guard let startRange = textInput.textRange(from: start, to: markedTextRange.start),
        let endRange = textInput.textRange(from: markedTextRange.end, to: end) else {
            return text
    }
    
    return (textInput.text(in: startRange) ?? "") + (textInput.text(in: endRange) ?? "")
}

func <-> <Base: UITextInput>(textInput: TextInput<Base>, variable: BehaviorRelay<String>) -> Disposable {
    let bindToUIDisposable = variable.asObservable()
        .bind(to: textInput.text)
    let bindToVariable = textInput.text
        .subscribe(onNext: { [weak base = textInput.base] _ in
            guard let base = base else {
                return
            }
            
            let nonMarkedTextValue = nonMarkedText(base)
            
            /**
             In some cases `textInput.textRangeFromPosition(start, toPosition: end)` will return nil even though the underlying
             value is not nil. This appears to be an Apple bug. If it's not, and we are doing something wrong, please let us know.
             The can be reproed easily if replace bottom code with
             
             if nonMarkedTextValue != variable.value {
             variable.value = nonMarkedTextValue ?? ""
             }
             
             and you hit "Done" button on keyboard.
             */
            if let nonMarkedTextValue = nonMarkedTextValue, nonMarkedTextValue != variable.value {
                variable.accept(nonMarkedTextValue)
            }
            }, onCompleted: {
                bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToVariable)
}

func <-> <T>(property: ControlProperty<T>, variable: BehaviorRelay<T>) -> Disposable {
    if T.self == String.self {
        #if DEBUG
        fatalError("It is ok to delete this message, but this is here to warn that you are maybe trying to bind to some `rx.text` property directly to variable.\n" +
            "That will usually work ok, but for some languages that use IME, that simplistic method could cause unexpected issues because it will return intermediate results while text is being inputed.\n" +
            "REMEDY: Just use `textField <-> variable` instead of `textField.rx.text <-> variable`.\n" +
            "Find out more here: https://github.com/ReactiveX/RxSwift/issues/649\n"
        )
        #endif
    }
    
    let bindToUIDisposable = variable.asObservable()
        .bind(to: property)
    let bindToVariable = property
        .subscribe(onNext: { n in
            variable.accept(n)
        }, onCompleted: {
            bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToVariable)
}

// }

public protocol OptionalType {
    associatedtype Wrapped
    
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    public var optional: Wrapped? { return self }
}

// Unfortunately the extra type annotations are required, otherwise the compiler gives an incomprehensible error.
extension Observable where Element: OptionalType {
    func ignoreNil() -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0) } ?? Observable<Element.Wrapped>.empty()
        }
    }
}
extension Driver where Element: OptionalType {
    func ignoreNil() -> Driver<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Driver<Element.Wrapped>.just($0) } ?? Driver<Element.Wrapped>.empty()
        }
    }
}
extension BehaviorRelay where Element == Bool {
    func toggle() {
        self.accept(!self.value) 
    }
}
extension CADisplayLink {
    public static let maximumFps = 60
}

public extension Reactive where Base: CADisplayLink {
    /**
     Link to the Display.
     - Parameter runloop: It can choose RunLoop to link for display. Default is main.
     - Parameter mode: The RunLoopMode has several modes. Default is commonModes. For details about RunLoopMode, see the [documents](https://developer.apple.com/reference/foundation/runloopmode).
     - Parameter fps: Frames per second. Default and max are 60.
     - Returns: Observable of CADisplayLink.
     */
    static func link(to runloop: RunLoop = .main, forMode mode: RunLoop.Mode = .common, fps: Int = Base.maximumFps) -> Observable<CADisplayLink> {
        return RxDisplayLink(to: runloop, forMode: mode, fps: fps).asObservable()
    }
}

public final class RxDisplayLink: ObservableType {
    public typealias Element = CADisplayLink
    
    private let runloop: RunLoop
    private let mode: RunLoop.Mode
    private let fps: Int
    private var observer: AnyObserver<Element>?
    
    @objc dynamic private func displayLinkHandler(link: Element) {
        observer?.onNext(link)
    }
    
    public init(to runloop: RunLoop, forMode mode: RunLoop.Mode, fps: Int) {
        self.runloop = runloop
        self.mode = mode
        self.fps = fps
    }
    
    public func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.Element == Element {
        var displayLink: Element? = Element(target: self, selector: #selector(displayLinkHandler))
        displayLink?.add(to: runloop, forMode: mode)
        if #available(iOS 10.0, tvOS 10.0, *) {
            displayLink?.preferredFramesPerSecond = fps
        } else {
            displayLink?.frameInterval = max(E.maximumFps / fps, 1)
        }
        
        self.observer = AnyObserver<Element>(observer)
        
        return Disposables.create {
            self.observer = nil
            displayLink?.invalidate()
            displayLink = nil
        }
    }
}
