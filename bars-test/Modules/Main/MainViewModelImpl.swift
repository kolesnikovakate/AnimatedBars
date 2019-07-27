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
    private let networkService: NetworkService
    
    init(networkService: NetworkService = NetworkServiceImpl()) {
        self.networkService = networkService
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
    
    func getInfo() {
        updateBarsInfo()
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
}