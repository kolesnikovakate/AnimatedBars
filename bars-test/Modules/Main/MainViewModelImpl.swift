//
//  MainViewModelImpl.swift
//  bars-test
//
//  Created by Ekaterina Kolesnikova on 27/07/2019.
//  Copyright © 2019 kolesnikovakate. All rights reserved.
//

import RxCocoa
import RxSwift

final class MainViewModelImpl {
    
    private let disposeBag = DisposeBag()
    private let barsInfo = BehaviorRelay<[BarInfo]>(value: [])
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let isConnectedRelay = BehaviorRelay<Bool>(value: false)
    private let networkService: NetworkService
    
    private enum Constants {
        static let timerSecondsInterval: Int = 10
    }
    
    init(networkService: NetworkService = NetworkServiceImpl()) {
        self.networkService = networkService
        subscribeTimer()
    }
}

// MARK: - MainViewModel
extension MainViewModelImpl: MainViewModel {
    var dataSource: Driver<[BarInfo]> {
        return self.barsInfo
            .asDriver(onErrorJustReturn: [])
    }
    
    var isLoading: Driver<Bool> {
        return self.isLoadingRelay.asDriver()
    }
    
    var isConnected: Driver<Bool> {
        return self.isConnectedRelay.asDriver()
    }
    
    func toggleConnectState() {
        isConnectedRelay.accept(!isConnectedRelay.value)
    }
}

// MARK: - Private
private extension MainViewModelImpl {
    func updateBarsInfo() {
        isLoadingRelay.accept(true)
        networkService
            .getBarsInfo()
            .asObservable()
            .do(onNext: {[unowned self] _ in
                self.isLoadingRelay.accept(false)
            })
            .bind(to: barsInfo)
            .disposed(by: disposeBag)
    }
    
    func subscribeTimer() {
        isConnectedRelay
            .asObservable()
            .flatMapLatest {  isRunning in
                isRunning ? Observable<Int>.timer(.seconds(0),
                                                  period: .seconds(Constants.timerSecondsInterval),
                                                  scheduler: MainScheduler.instance)
                    : .empty()
            }
            .do(onNext: {[unowned self] _ in
                self.updateBarsInfo()
            })
            .subscribe()
            .disposed(by: disposeBag)
    }
}
