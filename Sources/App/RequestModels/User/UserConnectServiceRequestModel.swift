//
//  File.swift
//  
//
//  Created by Kirill on 13.08.2021.
//

import Vapor

struct UserConnectServiceRequestModel: Content {
    enum Service: String, Codable {
        case instagram
    }
    var service: Service
    var token: String
    var accountName: String
}
