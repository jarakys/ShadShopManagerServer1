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
            return UserResponseModel(id: user.id?.uuidString ?? "", token: jwt, login: user.login, connectedServices: user.services.compactMap({ item in Service.init(rawValue: item) }))
        })
    }
    
    func register(req: Request) throws -> EventLoopFuture<UserResponseModel> {
        let registerModelRequest = try req.content.decode(UserCreateRequestModel.self)
        return DatabaseManager.createUser(user: registerModelRequest, on: req.db, in: req.eventLoop).map({ user in
            let jwt = JWTManager.getJWTToken(user: user, on: req) ?? ""
            return UserResponseModel(id: user.id?.uuidString ?? "", token: jwt, login: user.login, connectedServices: user.services.compactMap({ item in Service.init(rawValue: item) }))
        })
    }
    
    func connectService(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let payload = try req.jwt.verify(as: UserPayload.self)
        let connectServiceModelRequest = try req.content.decode(UserConnectServiceRequestModel.self)
        return DatabaseManager.getUser(by: payload.subject.value, on: req.db).map({ user in
            if !user.services.contains(connectServiceModelRequest.service.rawValue) {
                user.services.append(connectServiceModelRequest.service.rawValue)
            }
            user.save(on: req.db)
            return HTTPStatus.ok
        })
    }
}

