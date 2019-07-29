//
//  BarInfo.swift
//  bars-test
//
//  Created by Ekaterina Kolesnikova on 27/07/2019.
//  Copyright © 2019 kolesnikovakate. All rights reserved.
//

struct BarInfo {
    let progress: Float
    let color: String
}

// MARK: - Decodable
extension BarInfo: Decodable {
}
