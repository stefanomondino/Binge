//
//  StringPickerView.swift
//  App
//
//  Created by Stefano Mondino on 02/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import Boomerang
import RxSwift
import RxCocoa

class StringPickerItemView: UIView, WithViewModel {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if self.textField == nil {
            self.textField = UITextField()
            self.addSubview(self.textField)
            self.textField.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    func configure(with viewModel: ViewModel) {
        
        self.disposeBag = DisposeBag()
        self.textField.inputView = nil
        switch viewModel {
        case let string as StringPickerViewModel: self.configure(with: string)
        case let picker as RxListViewModel & FormViewModelType: self.configure(with: picker)
        default: break
        }
    }
    private func receiveFocus(from observable: Observable<()>) {
        observable
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in self?.textField?.becomeFirstResponder() })
            .disposed(by: disposeBag)
    }
    
    
    func configure(with viewModel: StringPickerViewModel) {
        
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

    }
    
    func configure(with viewModel: RxListViewModel & FormViewModelType) {
        let picker = UIPickerView()
        
        viewModel.sectionsRelay
            .map { $0.flatMap { $0.items } }
            .asDriver(onErrorJustReturn: [])
            .drive(picker.rx.itemTitles) { index, item in
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
        
        self.textField.inputView = picker
        
        self.receiveFocus(from: viewModel.focus.asObservable())
        
        viewModel.reload()
    }
}
