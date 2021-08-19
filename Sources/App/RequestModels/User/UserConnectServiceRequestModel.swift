//
//  File.swift
//  
//
//  Created by Kirill on 13.08.2021.
//

import Vapor

struct UserConnectServiceRequestModel: Content {
    var service: Service
    var token: String
    var accountName: String
}
