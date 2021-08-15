//
//  File.swift
//  
//
//  Created by Kirill on 13.08.2021.
//

import Vapor

enum Service: String, Codable {
    case insta
    case rozetka
    case wooCommerce
    case promUa
    case none
}

struct UserConnectServiceRequestModel: Content {
    var service: Service
}

