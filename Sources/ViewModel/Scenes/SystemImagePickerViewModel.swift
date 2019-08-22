//
//  SystemImagePickerViewModel.swift
//  ViewModel
//
//  Created by Stefano Mondino on 30/05/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Boomerang

public class SystemImagePickerViewModel: ViewModelType {
    public enum PickerType {
        case camera
        case library
        var title: String {
            switch self {
            case .camera : return "camera"
            case .library : return  "library"
            }
        }
    }
    
    public internal(set) var type: PickerType
    public internal(set) var relay: BehaviorRelay<UIImage?>
    
    var title: String {
        return type.title
    }
    
    public init(type: PickerType, relay: BehaviorRelay<UIImage?>) {
        self.type = type
        self.relay = relay
    }
}
