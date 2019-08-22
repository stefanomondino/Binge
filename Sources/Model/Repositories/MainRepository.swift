//
//  TestRepository.swift
//  Model
//
//  Created by Stefano Mondino on 12/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift
import Moya

public protocol MainRepositoryType {
    func setup() -> Observable<()>
    
}

public struct MainRepository: MainRepositoryType {
    
//    var dataSource: DataSource = MoyaProvider<API>()
    
    public func setup() -> Observable<()> {
        return .just(())
    }
}
