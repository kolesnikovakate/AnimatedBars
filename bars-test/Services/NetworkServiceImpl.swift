//
//  NetworkServiceImpl.swift
//  bars-test
//
//  Created by Ekaterina Kolesnikova on 27/07/2019.
//  Copyright © 2019 kolesnikovakate. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class NetworkServiceImpl: NetworkService {
    
    private let jsonDecoder: JSONDecoder
    private let scheduler: SchedulerType

    init(jsonDecoder: JSONDecoder = JSONDecoder(), scheduler: SchedulerType = SerialDispatchQueueScheduler(qos: .userInitiated)) {
        self.jsonDecoder = jsonDecoder
        self.scheduler = scheduler
    }

    private var baseURL: URL {
        guard let baseUrl = URL(string: "https://bars-test.herokuapp.com") else {
            fatalError("Base URL is not correct")
        }
        return baseUrl
    }
    
    private enum Endpoint {
        static let bars = "bars"
    }

    func getBarsInfo() -> Single<[BarInfo]> {
        return URLSession.shared.rx
            .data(request: URLRequest(url: baseURL.appendingPathComponent(Endpoint.bars)))
            .observeOn(scheduler)
            .map { [jsonDecoder] in try jsonDecoder.decode(Response<BarsResponse>.self, from: $0) }
            .map { $0.response.bars }
            .asSingle()
    }
}
