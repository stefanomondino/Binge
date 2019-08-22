//
//  Pickers.swift
//  App
//
//  Created by Stefano Mondino on 05/06/18.
//  Copyright © 2018 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Boomerang
import Model

public typealias ObservableError = Observable<Error?>

protocol PickerItemViewModelType: AnyObject, ItemViewModelType, InteractionViewModelType {
    var currentSelectedTitle: Observable<String> { get }
    var title: String { get set }
    var identifier: Identifier { get set }
    var enabledIf: Observable<Bool> { get set }
    var placeholder: String { get set }
    var error: ObservableError { get set }
    var externalSelection: Selection? { get set }
    func with(viewIdentifier: ViewIdentifier) -> Self
}

public typealias FocusAction = () -> Void

protocol FocusablePickerType: class {
    var focus: BehaviorRelay<()> { get }
    var nextFocusAction: FocusAction { get set }
    var previousFocusAction: FocusAction { get set }
    
}
extension FocusablePickerType {
    func setFocusItems(previous: FocusablePickerType? = nil, next: FocusablePickerType? = nil) {
        if let previous = previous {
            self.previousFocusAction = { previous.setFocus() }
        }
        if let next = next {
            self.nextFocusAction = { next.setFocus() }
        }
    }
    func setFocus() {
        focus.accept(())
    }
}
extension Array where Element: FocusablePickerType {
    func withFocus() -> [Element] {
        return self.reduce([]) { acc, e in
            if let last = acc.last {
                last.setFocusItems(next: e)
                e.setFocusItems(previous: last)
            }
            return acc + [e]
        }
    }
}
protocol ListPickerItemViewModelType: PickerItemViewModelType, ListViewModelType, SceneViewModelType {
    var dataHolder: DataHolder { get set }
    func with(dataObservable: Observable<DataGroup>) -> Self
}

extension ListPickerItemViewModelType {
    var isFormSheet: Bool {
        return true
    }
    
    func with(dataObservable: Observable<DataGroup>) -> Self {
        self.dataHolder = DataHolder(data: dataObservable)
        return self
    }
    func convert(model: ModelType, at indexPath: IndexPath, for type: String?) -> IdentifiableViewModelType? {
        return nil
    }
//    func itemViewModel(fromModel model: ModelType) -> ItemViewModelType? {
//        switch model {
//            //Example to customize picker for particular models
//        //case let model as Product : return ListItemViewModel(product: model)
//        case let model as ModelWithTitle : return ListPickerElementItemViewModel(model: model)
//        default : return model as? ItemViewModelType
//        }
//    }
}

protocol PickerItemViewModel: PickerItemViewModelType {
    associatedtype T
}
extension PickerItemViewModel {
    
    public var currentSelectedTitle: Observable<String> {
        return .just("")
    }
    
    public func with(externalSelection: Selection) -> Self {
        self.externalSelection = externalSelection
        return self
    }
    
    public func with(title: String) -> Self {
        self.title = title
        return self
    }
    
    public func with(placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }
    
    public func with(viewIdentifier: ViewIdentifier) -> Self {
        self.identifier = viewIdentifier
        return self
    }
    
    public func with(error: ObservableError) -> Self {
        self.error = error
        return self
    }
    
    public func with(enabledIf: Observable<Bool>) -> Self {
        self.enabledIf = enabledIf
        return self
    }
    
    public func select(item: T?) {
        switch self.model {
        case let relay as BehaviorRelay<T> :
            if let item = item { relay.accept(item) }
        case let relay as BehaviorRelay<T?> :
            relay.accept(item)
        case let relay as BehaviorRelay<[T]> :
            relay.accept(relay.value + [item].compactMap {$0})
        default : break
        }
    }
    public func clear(emptyItem: T? = nil) {
        switch self.model {
        case let relay as BehaviorRelay<T> :
            if let item = emptyItem { relay.accept(item) }
        case let relay as BehaviorRelay<T?> :
            relay.accept(nil)
        case let relay as BehaviorRelay<[T]> :
            relay.accept([])
        default : break
        }
    }
}

//class ImagePickerViewModel: ActionSheetViewModel, PickerItemViewModel {
//
//    typealias T = WithImage
//    var itemIdentifier: ListIdentifier = View.imagePicker
//    var placeholder: String = ""
//    let currentImage: Observable<UIImage?>
//    var model: ItemViewModelType.Model = ""
//    var error: ObservableError = .just(nil)
//    var enabledIf: Observable<Bool> = .just(true)
//    var imagesArray: BehaviorRelay<[WithImage]> = BehaviorRelay<[WithImage]>(value: [])
//
//    lazy var selection: Selection = Selection {[weak self] input in
//        if let sself = self {
//            switch input {
//            case .openPicker : self?.externalSelection?.execute(.viewModel(sself))
//            default : break
//            }
//        }
//        return self?.baseSwitch(input: input) ?? .empty()
//    }
//
//    var currentSelectedTitle: Observable<String> {
//        return .just("")
//    }
//
//    init(array relay: BehaviorRelay<[WithImage]>) {
//        self.currentImage = relay.asObservable().flatMapLatest { $0.first?.getImage().map { $0 } ?? .just(nil) }
//        self.model = relay
//        super.init (title: Strings.ImagePicker.pickerTitle.localized,
//                    message: Strings.ImagePicker.pickerMessage.localized,
//                    viewModels: [
//                        SystemImagePickerViewModel(type: .camera, relay: relay),
//                        SystemImagePickerViewModel(type: .library, relay: relay)
//            ])
//
//    }
//
//    func with(externalSelection: Selection) -> Self {
//        super.externalSelection = externalSelection
//        return self
//    }
//}
//
//class ModelPickerViewModel<T: ModelWithTitle> : ListPickerItemViewModelType, PickerItemViewModel {
//    var currentSelectedTitle: Observable<String>
//    var identifier: Identifier
//    var title: String = ""
//    var placeholder: String = ""
//    var error: ObservableError = .just(nil)
//    var externalSelection: Selection?
//    var sceneIdentifier: SceneIdentifier = .listForm
//    var dataHolder: ListDataHolderType = ListDataHolder()
//    var enabledIf: Observable<Bool> = .just(true)
//    var model: ItemViewModelType.Model
//    lazy var selection: Selection = Selection {[weak self] input in
//        if let sself = self {
//            switch input {
//            case .openPicker :
//                self?.externalSelection?.execute(.viewModel(sself))
//                return .empty()
//            case .item(let indexPath) :
//                if let model = self?.model(atIndex: indexPath) as? T {
//                    sself.select(item: model)
//                    return .just(.dismiss)
//                }
//            default : break
//            }
//        }
//        return self?.baseSwitch(input: input) ?? .empty()
//    }
//
//    init(relay: BehaviorRelay<T?>) {
//        self.model = relay
//        currentSelectedTitle = relay.asObservable().map { $0?.title ?? "" }
//    }
//    init(relay: BehaviorRelay<T>) {
//        self.model = relay
//        currentSelectedTitle = relay.asObservable().map { $0.title }
//    }
//    func with(sceneIdentifier identifier: SceneIdentifier) -> Self {
//        self.sceneIdentifier = identifier
//        return self
//    }
//}

//
//class ActionSheetViewModel: SceneViewModelType {
//    //TODO please do not use this kind of VM
//    var sceneIdentifier: SceneIdentifier = .splash
//    var actions: () -> [UIAlertAction] = {  [] }
//    var title: String = ""
//    var message: String = ""
//    var actionsViewModels: [TitleViewModelType] = []
//
//    //this is useful for method composition, do not remove
//    //the "withExternalSelection" method of picker actually populates this value
//    var externalSelection: Selection?
//
//    init(title: String = Strings.Onboarding.userProfileEditPhoto.localized, message: String = "", viewModels: [TitleViewModelType] = []) {
//        self.title = title
//        self.message = message
//        self.actionsViewModels = viewModels
//
//        self.actions = { viewModels.map {vm in
//            UIAlertAction(title: vm.title, style: .default, handler: {[weak self] (_) in
//                //in some cases the actionsheet viewmodel is deallocated before the action is called.
//                self?.externalSelection?.execute(.viewModel(vm))
//            })
//            } + [UIAlertAction(title: Strings.Button.cancel.localized, style: .cancel, handler: nil)]
//        }
//
//    }
//}
