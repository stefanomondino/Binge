//
//  UseCases.swift
//  Model
//
//  Created by Stefano Mondino on 09/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import RxSwift

//Enumerate here every use case
public struct UseCases {
    public static var splash: SplashUseCaseType = SplashUseCase()
    public static var images: ImagesUseCaseType = ImagesUseCase()
    public static var trending: ShowListUseCaseType = ShowListUseCase()
    public static var showDetail: ShowDetailUseCaseType = ShowDetailUseCase()
		//MURRAY PLACEHOLDER - DO NOT REMOVE
}
