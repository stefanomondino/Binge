//
//  CollectionViewCellFactory.swift
//  Demo
//
//  Created by Stefano Mondino on 22/10/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import UIKit
import Boomerang

public class DefaultCollectionViewCellFactory: CollectionViewCellFactory {

    private var viewFactory: ViewFactory
    
    public init(viewFactory: ViewFactory) {
        self.viewFactory = viewFactory
    }

    public func view(from itemIdentifier: LayoutIdentifier) -> UIView? {
        return viewFactory.view(from: itemIdentifier)
    }

    public func name(from itemIdentifier: LayoutIdentifier) -> String {
        return viewFactory.name(from: itemIdentifier)
    }

    public var defaultCellIdentifier: String {
        return "default"
    }

    public func cellClass(from itemIdentifier: LayoutIdentifier?) -> UICollectionViewCell.Type {
        return ContentCollectionViewCell.self
    }

    public func configureCell(_ cell: UICollectionReusableView, with viewModel: ViewModel) {
        guard let cell = cell as? ContentCollectionViewCell else { return }
        if cell.internalView == nil {
            cell.internalView = viewFactory.view(from: viewModel.layoutIdentifier)
        }
        cell.configure(with: viewModel)
    }
}
