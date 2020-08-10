//
//  Reachability+Rx.swift
//  App
//
//  Created by Stefano Mondino on 05/03/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

public struct Reachability: ReactiveCompatible {
    public enum NetworkType {
        case wifi
        case cellular
    }

    public enum Status {
        case reachable(NetworkType)
        case unreachable

        var isReachable: Bool {
            switch self {
            case .reachable: return true
            case .unreachable: return false
            }
        }
    }

    public static var currentStatus: Reachability.Status {
        if !networkReachability.isReachable {
            return .unreachable
        } else {
            return .reachable(networkReachability.isReachableOnCellular ? .cellular : .wifi)
        }
    }

    private static let networkReachability = NetworkReachabilityManager()!
    fileprivate static let status: Observable<Reachability.Status> = {
        Observable.create { obs in

            Reachability.networkReachability.startListening { status in
                switch status {
                case .notReachable:
                    obs.onNext(.unreachable)
                case let .reachable(type):
                    switch type {
                    case .ethernetOrWiFi: obs.onNext(.reachable(.wifi))
                    default: obs.onNext(.reachable(.cellular))
                    }
                default:
                    break
                }
            }
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
