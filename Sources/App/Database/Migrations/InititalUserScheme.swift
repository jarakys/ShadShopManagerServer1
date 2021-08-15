//
//  File.swift
//  
//
//  Created by Kirill on 13.08.2021.
//

import Vapor
import Fluent

struct InititalUserScheme: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users")
            .id()
            .field("login", .string, .required)
            .field("password", .string, .required)
            .field("services", .array(of: .string))
            .unique(on: "login")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("users").delete()
    }
}
