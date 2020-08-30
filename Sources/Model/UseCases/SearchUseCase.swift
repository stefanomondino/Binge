//
//  PersonDetailUseCase.swift
//  Model
//
//  Created by Stefano Mondino on 13/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift

public protocol SearchUseCase {
    func items(query: String, currentPage: Int, pageSize: Int) -> Observable<[TraktItemContainer]>
}
