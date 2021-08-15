//
//  File.swift
//  
//
//  Created by Kirill on 13.08.2021.
//

import Vapor

struct UserResponseModel: BaseResponseModel {
    var token: String
    var login: String
    var connectedService: Service
}
