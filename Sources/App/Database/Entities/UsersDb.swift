//
//  File.swift
//  
//
//  Created by Kirill on 13.08.2021.
//

import Vapor
import Fluent

final class UsersDb: Model {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "login")
    var login: String
    @Field(key: "password")
    var password: String
    @Children(for: \.$userDb)
    var connectedServices: [ConnectedServicesDb]
    
    init() { }
    
    init(id: UUID? = nil, login: String, password: String, connectedServices: [ConnectedServicesDb]) {
        self.id = id
        self.login = login
        self.password = password
        self.connectedServices = connectedServices
    }
}
