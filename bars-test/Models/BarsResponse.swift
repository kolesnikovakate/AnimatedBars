//
//  BarsResponse.swift
//  bars-test
//
//  Created by Ekaterina Kolesnikova on 27/07/2019.
//  Copyright © 2019 kolesnikovakate. All rights reserved.
//

struct BarsResponse {
    let bars: [BarInfo]
}

// MARK: - Decodable
extension BarsResponse: Decodable {
}
