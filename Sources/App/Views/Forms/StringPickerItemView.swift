//
//  StringPickerView.swift
//  App
//
//  Created by Stefano Mondino on 02/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import RxCocoa
import RxSwift
import UIKit

class StringPickerItemView: UIView, WithViewModel {
    var disposeBag: DisposeBag = DisposeBag()

    @IBOutlet var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        if textField == nil {
            textField = UITextField()
            addSubview(textField)
            textField.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.height.equalTo(50)
            }
        }

        textField.layer.borderWidth = 2
    }

    func configure(with viewModel: ViewModel) {
        disposeBag = DisposeBag()
        textField.inputView = nil
        switch viewModel {
        case let string as StringPickerViewModel: configure(with: string)
        case let picker as RxListViewModel & FormViewModelType: configure(with: picker)
        default: break
        }
    }

    private func receiveFocus(from observable: Observable<Void>) {
        observable
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in self?.textField?.becomeFirstResponder() })
            .disposed(by: disposeBag)
    }

    func setStyle(_ info: FormAdditionalInfo) {
        switch info.keyboardType {
        case .email:
            textField.keyboardType = .emailAddress
            textField.autocorrectionType = .no
            textField.isSecureTextEntry = false
        case .password:
            textField.keyboardType = .default
            textField.isSecureTextEntry = true
            textField.autocorrectionType = .no
        default:
            textField.keyboardType = .default
            textField.isSecureTextEntry = false
            textField.autocorrectionType = .default
        }
    }

    func configure(with viewModel: StringPickerViewModel) {
        setStyle(viewModel.additionalInfo)
        textField.rx.textInput
            .text
            .map { $0 ?? "" }
            .distinctUntilChanged()
            .bind(to: viewModel.value)
            .disposed(by: disposeBag)

        viewModel.textValue
            .distinctUntilChanged()
            .drive(textField.rx.text)
            .disposed(by: disposeBag)

        textField.rx.controlEvent(.editingDidEnd)
            .bind { viewModel.onNext?() }
            .disposed(by: disposeBag)

        receiveFocus(from: viewModel.focus.asObservable())

        Observable.combineLatest(viewModel.errors, viewModel.value) { errors, value -> UIColor in
            if value?.isEmpty == true { return .clear }
            if errors != nil { return .red }
            return (value ?? "").isEmpty ? .black : .green
        }
        .asDriver(onErrorJustReturn: .black)
        .map { $0.cgColor }
        .drive(onNext: { [weak self] in
            self?.textField.layer.borderColor = $0
        })
        .disposed(by: disposeBag)
    }

    func configure(with viewModel: RxListViewModel & FormViewModelType) {
        setStyle(viewModel.additionalInfo)
        #if os(iOS)
            let picker = UIPickerView()

            viewModel.sectionsRelay
                .map { $0.flatMap { $0.items } }
                .asDriver(onErrorJustReturn: [])
                .drive(picker.rx.itemTitles) { _, item in
                    (item as? CustomStringConvertible)?.description
                    // return items.map { ($0 as? CustomStringConvertible)?.description }
                }
                .disposed(by: disposeBag)

            viewModel.textValue
                .distinctUntilChanged()
                .drive(textField.rx.text)
                .disposed(by: disposeBag)

            picker.rx.itemSelected
                .bind { viewModel.selectItem(at: IndexPath(item: $0, section: $1)) }
                .disposed(by: disposeBag)

            textField.inputView = picker

            receiveFocus(from: viewModel.focus.asObservable())

            viewModel.reload()
        #endif
    }
}
