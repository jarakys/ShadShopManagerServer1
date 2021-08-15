//
//  File.swift
//  
//
//  Created by Kirill on 13.08.2021.
//

import Vapor

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("auth")
        auth.post("login", use: login)
        auth.post("register", use: register)
    }
    
    func login(req: Request) throws -> EventLoopFuture<UserResponseModel> {
        let loginModelRequest = try req.content.decode(UserLoginRequestModel.self)
        return DatabaseManager.loginUser(user: loginModelRequest, on: req.db).map({ user in
            return UserResponseModel(token: "123456789", login: user.login, connectedService: .none)
        })
    }
    
    func register(req: Request) throws -> EventLoopFuture<UserResponseModel> {
        let registerModelRequest = try req.content.decode(UserCreateRequestModel.self)
        
        return DatabaseManager.createUser(user: registerModelRequest, on: req.db, in: req.eventLoop).map({ user in
            return UserResponseModel(token: "123456789", login: "dimas@pidoras.com", connectedService: .none)
        })
    }
}

