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
        auth.post("connectService", use: connectService)
    }
    
    func login(req: Request) throws -> EventLoopFuture<UserResponseModel> {
        let loginModelRequest = try req.content.decode(UserLoginRequestModel.self)
        return DatabaseManager.loginUser(user: loginModelRequest, on: req.db).map({ user in
            let jwt = JWTManager.getJWTToken(user: user, on: req) ?? ""
            return UserResponseModel(id: user.id?.uuidString ?? "", token: jwt, login: user.login, connectedServices: [])
        })
    }
    
    func register(req: Request) throws -> EventLoopFuture<UserResponseModel> {
        let registerModelRequest = try req.content.decode(UserCreateRequestModel.self)
        return DatabaseManager.createUser(user: registerModelRequest, on: req.db, in: req.eventLoop).map({ user in
            let jwt = JWTManager.getJWTToken(user: user, on: req) ?? ""
            return UserResponseModel(id: user.id?.uuidString ?? "", token: jwt, login: user.login, connectedServices: [])
        })
    }
    
    func connectService(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let payload = try req.jwt.verify(as: UserPayload.self)
        let connectServiceModelRequest = try req.content.decode(UserConnectServiceRequestModel.self)
        
        return DatabaseManager.connectService(to: payload.subject.value, serivce: connectServiceModelRequest, on: req.db, in: req.eventLoop).map({ result in
            if result {
                return .ok
            }
            return .badRequest
        })
    }
}
