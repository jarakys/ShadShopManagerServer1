//
//  File.swift
//
//
//  Created by Kirill on 13.08.2021.
//

import Vapor
import Fluent

final class ConnectedServicesDb: Model {
    static let schema = "connected_services"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "token")
    var token: String
    @Field(key: "account_name")
    var accountName: String
    @Enum(key: "service")
    var service: Service
    @Parent(key: "user_id")
    var userDb: UsersDb
    @Field(key: "user_id_field")
    var userId: UUID
    
    init() { }
    
    init(id: UUID? = nil, userId: UUID, token: String, accountName: String, service: Service) {
        self.id = id
        self.token = token
        self.accountName = accountName
        self.service = service
        self.$userDb.id = userId
        self.userId = userId
    }
}
