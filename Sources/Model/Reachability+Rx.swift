//
//  Reachability+Rx.swift
//  App
//
//  Created by Stefano Mondino on 05/03/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

public struct Reachability: ReactiveCompatible {
    public enum NetworkType {
        case wifi
        case cellular
    }
    public enum Status {
        
        case reachable(NetworkType)
        case unreachable
    }
    
    public static var currentStatus: Reachability.Status {
        if !networkReachability.isReachable {
            return .unreachable
        } else {
            return .reachable(networkReachability.isReachableOnWWAN ? .cellular : .wifi)
        }
    }
    
    private static let networkReachability = NetworkReachabilityManager()!
    fileprivate static let status: Observable<Reachability.Status> = {
        return Observable.create { obs in
            Reachability.networkReachability.listener = { status in
                switch status {
                case .notReachable:
                    obs.onNext(.unreachable)
                case .reachable(let type):
                    switch type {
                    case .ethernetOrWiFi: obs.onNext(.reachable(.wifi))
                    default: obs.onNext(.reachable(.cellular))
                    }
                default:
                    break
                }
            }
            Reachability.networkReachability.startListening()
            return Disposables.create {
                Reachability.networkReachability.stopListening()
            }
            }.share(replay: 1, scope: .forever)
    }()
}
public extension Reactive where Base == Reachability {
    static var status: Observable<Reachability.Status> {
        return Base.status
    }
}
