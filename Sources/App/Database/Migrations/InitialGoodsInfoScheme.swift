//
//  File.swift
//
//
//  Created by Kirill on 15.08.2021.
//

import Vapor
import Fluent

struct InitialGoodsInfoData: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(GoodsInfo.schema)
            .id()
            .field("color", .string, .required)
            .field("count", .string, .required)
            .field("price", .array(of: .string))
            .field("instagram_data_id", .uuid, .required, .references(InstagramDataDb.schema, "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(GoodsInfo.schema).delete()
    }
}
