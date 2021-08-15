//
//  File.swift
//
//
//  Created by Kirill on 13.08.2021.
//

import Vapor
import Fluent

enum StatusType: String, Codable {
    case draft
    case active
}

final class InstagramDataDb: Model {
    static let schema = "instagram_data"
    
    @ID(key: .id)
    var id: UUID?
    
    @Enum(key: "type")
    var type: StatusType
    @Field(key: "price")
    var price: Double
    @Field(key: "description")
    var description: String
    @Children(for: \.$instagramDataDb)
    var goodInfos: [GoodsInfo]
    
    init() { }
    
    init(id: UUID? = nil, type: StatusType, price: Double, infos: [GoodsInfo]) {
        self.id = id
        self.type = type
        self.price = price
        self.goodInfos = infos
    }
}

final class GoodsInfo: Model {
    static let schema = "goods_infos"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "color")
    var color: String
    @Field(key: "count")
    var count: Int
    @OptionalField(key: "price")
    var price: Double?
    @Parent(key: "instagram_data_id")
    var instagramDataDb: InstagramDataDb
    
    init() { }
    
    init(id: UUID? = nil, color: String, count: Int, price: Double) {
        self.id = id
        self.color = color
        self.count = count
        self.price = price
    }
}
