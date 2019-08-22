import UIKit
import Boomerang
import RxSwift
import RxCocoa
import ViewModel
import SwiftRichString

class TextPickerItemView: UIView, ViewModelCompatible {
    
    @IBOutlet var textField: PaddedTextField!
    @IBOutlet var titleLabel: UILabel?
    @IBOutlet weak var bottomBar: UIView!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var textFieldTopConstraint: NSLayoutConstraint?
    @IBOutlet weak var errorLabel: UILabel?
    
    typealias ViewModel = TextPickerItemViewModel
    var paddingConstant: CGFloat = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        if let constant = titleTopConstraint?.constant {
            paddingConstant = constant
            titleTopConstraint?.constant = textFieldTopConstraint?.constant ?? 20
        }
        self.isExclusiveTouch = true
        self.errorLabel?.style = Identifiers.Styles.errorText.style
    }
    func configure(with viewModel: ViewModel) {
        self.disposeBag = DisposeBag()
        
        let theme: TextTheme = viewModel.theme
        let placeholder: String = viewModel.placeholder
        
        if let errorLabel = errorLabel {
            viewModel.error
                .map { $0?.localizedDescription ?? " " }
                .asDriver(onErrorJustReturn: " ")
                .drive(errorLabel.rx.styledText)
                .disposed(by: disposeBag)
        }
        
        switch theme {
        default:
            self.titleLabel?.style = theme.placeholderStyle(isEmpty: viewModel.value.value.isEmpty)
            self.titleLabel?.styledText = placeholder
        }
        
        self.textField.style = theme.fontStyle
        textField.inset = theme.inset
        
        (textField.rx.textInput <-> viewModel.value ).disposed(by: disposeBag)
        
        if self.isPlaceholderForAutosize { return }
        
        textField.tintColor = .blue
        textField.backgroundColor = theme.backgroundColor
        textField.layer.cornerRadius = theme.cornerRadius
        bottomBar.backgroundColor = theme.barColor
        
        self.textField.tintColor = theme.tintColor
        
        let inputType: InputType = viewModel.inputType
        self.textField.setInputType(inputType)
        
        self.textField.enablesReturnKeyAutomatically = true
        self.textField.returnKeyType = viewModel.isLast ? .done : .next
        self.textField.rx
            .controlEvent(UIControl.Event.editingDidEndOnExit)
            .bind {_ in viewModel.nextFocusAction()}
            .disposed(by: disposeBag)
        self.textField.clearButtonMode = .never
        viewModel.focus.asObservable()
            .skip(1)
            .bind {[weak self] in self?.textField.becomeFirstResponder() }
            .disposed(by: disposeBag)
        let isFirstResponderObservable = self.textField.rx.isFirstResponder.startWith(false).distinctUntilChanged()
        let isEmptyObservable = viewModel.value.asObservable().map { $0.count == 0 }.distinctUntilChanged()
        let isValid = viewModel.error.map { $0 == nil }.distinctUntilChanged()
        viewModel.isCurrentlySecured.bind(to: textField.rx.isSecureTextEntry).disposed(by: disposeBag)
        if inputType == .newPassword {
            let secureTextButton = UIButton()
            if #available(iOS 12.0, *) {
                self.textField.passwordRules = UITextInputPasswordRules.init(descriptor: "required: upper; required: lower; required: digit; required: [-().&@?'#,/&quot;+]; minlength: 8;")
            }
            Identifiers.Images.eyePasswordSelected.getImage()
                .asDriver(onErrorJustReturn: UIImage())
                .drive(secureTextButton.rx.highlightedImage())
                .disposed(by: disposeBag)
            secureTextButton.setImage(Identifiers.Images.eyePassword.image, for: .selected)
            secureTextButton.setImage(Identifiers.Images.eyePassword.image, for: [.selected, .highlighted])
            secureTextButton.sizeToFit()
            viewModel.isCurrentlySecured.bind(to: secureTextButton.rx.isSelected).disposed(by: disposeBag)
            secureTextButton.rx.tap.bind { viewModel.isCurrentlySecured.toggle() }.disposed(by: disposeBag)
            
            self.textField.rightView = secureTextButton
            self.textField.rightViewMode = .always
        } else {
            let clearButton = UIButton()
            clearButton.setImage(Identifiers.Images.cancelTextField.image, for: .normal)
            clearButton.setImage(Identifiers.Images.cancelTextField.image.tinted(.clear), for: .disabled)
            
            Observable.combineLatest(isFirstResponderObservable, isEmptyObservable)
                .map({ isFirstResponder, isEmpty -> Bool in
                    return isFirstResponder && !isEmpty
                })
                .distinctUntilChanged()
                .bind(to: clearButton.rx.isEnabled).disposed(by: disposeBag)
            
            clearButton.sizeToFit()
            clearButton.rx.tap.subscribe(onNext: { _ in viewModel.value.accept("")}).disposed(by: disposeBag)
            self.textField.rightView = clearButton
            self.textField.rightViewMode = .always
        }
        
        viewModel.enabledIf.bind(to: self.textField.rx.isEnabled).disposed(by: disposeBag)
        
        Observable.combineLatest(isEmptyObservable, isFirstResponderObservable, isValid)
            .bind(to: self.rx.focusAndValidationStyle())
            .disposed(by: disposeBag)
        
        if let errorLabel = self.errorLabel {
            isEmptyObservable
                .asDriver(onErrorJustReturn: true)
                .drive(errorLabel.rx.isHidden)
                .disposed(by: disposeBag)
        }

        isEmptyObservable
            .flatMapLatest({ isEmpty -> Observable<Bool> in
                if isEmpty {
                    return Observable.just(true).delay(0.2, scheduler: MainScheduler.instance)
                } else {
                    return .just(false)
                }
            })
            .distinctUntilChanged()
            .enumerated()
            .asDriver(onErrorJustReturn: (0, true))
            .map({ return ($0 > 0, $1, theme)})
            .drive(self.rx.animatePlaceholder())
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: TextPickerItemView {
    
    func focusAndValidationStyle() -> Binder<(Bool, Bool, Bool)> {
        return Binder(base) { base, tuple in
            let (isEmpty, isFirstResponder, isValid) = tuple
            let color = (isFirstResponder || isValid) && !isEmpty ? UIColor.blue : .lightGray
            base.bottomBar.backgroundColor = color
        }
    }
    func animatePlaceholder() -> Binder<(Bool, Bool, TextTheme)> {
        return Binder(base) { base, tuple in
            
            let (isAnimatable, isEmpty, theme) = tuple
            
            let smallTopPadding = base.paddingConstant
            let bigTopPadding = base.textFieldTopConstraint?.constant ?? 20
            
            let heightDifference = bigTopPadding - smallTopPadding
            
            if isAnimatable {
                
                let bigFont = theme.placeholderStyle(isEmpty: true)
                let smallFont = theme.placeholderStyle(isEmpty: false)
                
                let scaleFactor: CGFloat = (smallFont.size ?? 12) / (bigFont.size ?? 18)
                let scale: CGFloat = isEmpty ? 1 / scaleFactor : scaleFactor
                let width = base.titleLabel?.bounds.width ?? 0
                let translationX: CGFloat = -1 * ( width * (1.0 - scale) ) / 2.0
                let bigLH = (bigFont.font as? UIFont)?.lineHeight ?? 0
                let smallLH = (smallFont.font as? UIFont)?.lineHeight ?? 0
                let translationY: CGFloat = (heightDifference + ((bigLH - smallLH) / 2.0)) * (isEmpty ? 1 : -1)
                
                UIView.animate(withDuration: 0.15, delay: 0.0, options: [.curveEaseInOut], animations: {
                    base.titleLabel?.transform = CGAffineTransform(scaleX: scale, y: scale).concatenating(CGAffineTransform(translationX: translationX, y: translationY))
                }, completion: { finished in
                    if finished {
                        base.titleLabel?.transform = CGAffineTransform(scaleX: 1, y: 1).concatenating(CGAffineTransform(translationX: 0, y: 0))
                        base.titleTopConstraint?.constant = isEmpty ? bigTopPadding : smallTopPadding
                        base.titleLabel?.style = theme.placeholderStyle(isEmpty: isEmpty)
                    }
                })
            } else {
                base.titleTopConstraint?.constant = isEmpty ? bigTopPadding : smallTopPadding
                base.titleLabel?.style = theme.placeholderStyle(isEmpty: isEmpty)
            }
        }
    }
}
