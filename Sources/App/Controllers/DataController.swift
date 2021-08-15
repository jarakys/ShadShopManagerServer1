//
//  File.swift
//
//
//  Created by Kirill on 13.08.2021.
//

import Vapor

struct DataController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")
//        auth.post("login", use: login)
//        auth.post("register", use: register)
//        auth.post("connectService", use: connectService)
    }
    
    func instagramData(req: Request) {
        
    }
}
