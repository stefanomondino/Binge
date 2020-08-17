//
//  PersonDetailUseCase.swift
//  Model
//
//  Created by Stefano Mondino on 13/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift

public protocol PersonDetailUseCase {
    func personDetail(for person: Person) -> Observable<PersonInfo>
    func cast(for person: Person) -> Observable<[ItemContainer]>
}
