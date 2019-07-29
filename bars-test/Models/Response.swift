//
//  Response.swift
//  bars-test
//
//  Created by Ekaterina Kolesnikova on 27/07/2019.
//  Copyright © 2019 kolesnikovakate. All rights reserved.
//

struct Response<ResponseType: Decodable> {
    let status: Int
    let response: ResponseType
}

// MARK: - Decodable
extension Response: Decodable {
}
