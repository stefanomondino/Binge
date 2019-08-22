//
//  LoginViewModel.swift
//  ViewModel
//

import Foundation
import Boomerang
import Model
import RxSwift
import RxCocoa

/**
    A Boomerang LidyViewModel for Login entity contents.

    It should handle data from ModelLayer, into group it into sections of data values and lazily convert them into ItemViewModels
*/

public struct LoginViewModel: ListViewModelType, SceneViewModelType, InteractionViewModelType, LoadingViewModelType {
    
    public var loadingCount: BehaviorRelay<Int> = BehaviorRelay(value: 0)

    public var sceneIdentifier: SceneIdentifier = Identifiers.Scenes.login
    
    public var dataHolder: DataHolder = DataHolder()
    
    public var selection: Selection = .empty
    
    public var title: String = ""
    
    private let username = BehaviorRelay(value: "")
    private let password = BehaviorRelay(value: "")
    private let errors = BehaviorRelay<[Errors]>(value: [])
    
    let disposeBag = DisposeBag()
    
    init() {

        let usernameError: ObservableError = username.map { $0.count == 0 ? Errors.invalidUsername : nil }
        let passwordError: ObservableError = username.map { $0.count == 0 ? Errors.invalidPassword : nil }
        
        let usernameViewModel = TextPickerItemViewModel(relay: username)
            .with(placeholder: Identifiers.Strings.username.translation)
            .with(inputType: .email)
            .with(error: usernameError)
        
        let passwordViewModel = TextPickerItemViewModel(relay: password)
            .with(inputType: .password)
            .with(placeholder: Identifiers.Strings.password.translation)
            .with(error: passwordError)
        
        Observable.combineLatest([usernameError, passwordError])
            .map { $0.compactMap { $0 as? Errors }}
            .bind(to: errors)
            .disposed(by: disposeBag)
        
        self.dataHolder = DataHolder(data: .just(DataGroup([usernameViewModel, passwordViewModel])))
        
        self.selection = defaultSelection()
    }
    
    public func convert(model: ModelType, at indexPath: IndexPath, for type: String?) -> IdentifiableViewModelType? {
        return nil
    }
    
    public func handleLogin() -> Observable<Interaction> {
        if let error = errors.value.first {
            return Observable.just(.route(ErrorRoute(error: error)))

                .delay(2, scheduler: MainScheduler.instance)
            .bindingLoading(to: self)
        }
        //Implement here login logic
        return Observable.empty()
    }
    
}
