//
//  File.swift
//  
//
//  Created by Kirill on 15.08.2021.
//

import Vapor
import Fluent

struct InitialConnectedServicesDb: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ConnectedServicesDb.schema)
            .id()
            .field("token", .string, .required)
            .field("account_name", .string, .required)
            .field("service", .array(of: .string))
            .field("user_id", .uuid, .required, .references("users", "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ConnectedServicesDb.schema).delete()
    }
}
