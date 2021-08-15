//
//  File.swift
//  
//
//  Created by Kirill on 15.08.2021.
//

import Vapor
import Fluent

struct InitialInstagramData: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(InstagramDataDb.schema)
            .id()
            .field("type", .enum(.init(name: "StatusType", cases: ["draft", "active"])), .required)
            .field("price", .double, .required)
            .field("description", .string)
            .field("user_id", .uuid, .required, .references("users", "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(InstagramDataDb.schema).delete()
    }
}
