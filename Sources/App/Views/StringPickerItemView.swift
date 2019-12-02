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
        
        switch viewModel {
        case let string as StringPickerViewModel: self.configure(with: string)
        default: break
        }
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
        
    }
    
}
