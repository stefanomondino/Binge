//
//  UIView+Component.swift
//  App
//
//  Created by Stefano Mondino on 20/03/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Boomerang
import SnapKit

enum ComponentPosition {
    case fill
    case none
    case top
    case bottom
    case custom((UIView) -> Void)
}

extension UIView {
    func install(viewModel: ItemViewModelType, position: ComponentPosition = .fill) -> UIView? {
        guard let view = (viewModel.identifier as? ViewIdentifier)?.view() else { return nil }
        self.addSubview(view)
        (view as? ViewModelCompatibleType)?.set(viewModel: viewModel)
        
        switch position {
        case .fill : view.snp.makeConstraints { $0.edges.equalToSuperview() }
        case .top: view.snp.makeConstraints { $0.left.right.top.equalToSuperview() }
        case .bottom: view.snp.makeConstraints { $0.left.right.bottom.equalToSuperview() }
        case .none: break
        case .custom(let closure) : closure(view)
        }
        return view
    }
}
