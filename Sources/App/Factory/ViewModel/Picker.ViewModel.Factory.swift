//
//  PickerViewModelFactory.swift
//  App
//
//  Created by Stefano Mondino on 02/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Boomerang
import Foundation
import Model
import RxRelay
import RxSwift

protocol PickerViewModelFactory {
    func email(relay: BehaviorRelay<String?>, title: String) -> FormViewModelType
    func password(relay: BehaviorRelay<String?>, title: String) -> FormViewModelType
    func themes(routes: PublishRelay<Route>) -> FormViewModelType
}

struct DefaultPickerViewModelFactory: PickerViewModelFactory {
    let container: RootContainer
    let validator: Validator = DefaultValidator()

    func email(relay: BehaviorRelay<String?>, title: String) -> FormViewModelType {
        let info = FormAdditionalInfo(title: .just(title), errorString: .just(""), keyboardType: .email)
        return StringPickerViewModel(relay: relay, info: info) {
            self.validator.validate($0, for: .email)
        }
    }

    func password(relay: BehaviorRelay<String?>, title: String) -> FormViewModelType {
        let info = FormAdditionalInfo(title: .just(title), errorString: .just(""), keyboardType: .password)
        return StringPickerViewModel(relay: relay, info: info) {
            self.validator.validate($0, for: .password)
        }
    }

    func themes(routes: PublishRelay<Route>) -> FormViewModelType {
        let info = FormAdditionalInfo(title: .just("Theme"), errorString: .just(""), keyboardType: .default)
        let useCase = container.model.useCases.themes
        let themes = useCase.themes()
        let factory = container.viewModels.items
        let items = themes.map { $0.map { factory.settingsValue(title: $0.name, identifier: $0.identifier) } }
        let relay = BehaviorRelay<DescriptionItemViewModel?>(value: nil)
        let viewModel = SingleSelectionListPickerViewModel(items: items,
                                                           value: relay,
                                                           info: info, layout: SceneIdentifier.settingsList,
                                                           routeFactory: container.routeFactory,
                                                           routes: routes)
        useCase.currentTheme()
            .flatMapLatest { current -> Observable<DescriptionItemViewModel?> in
                items.map { $0.first(where: { $0.uniqueIdentifier.stringValue == current.identifier }) }
            }
            .distinctUntilChanged()
            .bind(to: relay)
            .disposed(by: viewModel.disposeBag)

        relay.asObservable()
            .compactMap { $0?.uniqueIdentifier.stringValue }
            .distinctUntilChanged()
            .flatMapLatest { id -> Observable<Theme?> in
                themes.map { $0.first(where: { $0.identifier == id }) }
            }
            .compactMap { $0 }
            .bind { useCase.changeCurrentTheme($0) }
            .disposed(by: viewModel.disposeBag)

        return viewModel
    }
}
