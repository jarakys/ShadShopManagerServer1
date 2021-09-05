//
//  File.swift
//  
//
//  Created by Kirill on 05.09.2021.
//

import Vapor

struct ConnectedServiceResponse: Content {
    var id: String?
    var token: String
    var accountName: String
}
