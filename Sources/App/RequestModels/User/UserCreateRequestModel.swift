//
//  File.swift
//  
//
//  Created by Kirill on 13.08.2021.
//

import Vapor

struct UserCreateRequestModel: Content {
    var login: String
    var password: String
}
