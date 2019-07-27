//
//  MainViewModel.swift
//  bars-test
//
//  Created by Ekaterina Kolesnikova on 27/07/2019.
//  Copyright © 2019 kolesnikovakate. All rights reserved.
//

import struct RxCocoa.Driver

protocol MainViewModel {
    
    var dataSource: Driver<[BarInfo]> { get }
    var isLoading: Driver<Bool> { get }
    
    func toggleConnectState()
}
