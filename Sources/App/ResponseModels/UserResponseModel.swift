//
//  File.swift
//  
//
//  Created by Kirill on 13.08.2021.
//

import Vapor

enum Service: String, Codable {
    case instagram
    case rozetka
}

struct UserResponseModel: BaseResponseModel {
    var id: String
    var token: String
    var login: String
    var connectedServices: [Service]
}
