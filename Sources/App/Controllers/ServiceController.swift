//
//  File.swift
//
//
//  Created by Kirill on 13.08.2021.
//

import Vapor

struct ServiceController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let auth = routes.grouped("service")
        auth.post("connectService", use: connectService)
        auth.post("updateService", use: updateService)
    }
    
    func connectService(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let payload = try req.jwt.verify(as: UserPayload.self)
        let connectServiceModelRequest = try req.content.decode(UserConnectServiceRequestModel.self)
        
        return DatabaseManager.connectService(to: payload.subject.value, service: connectServiceModelRequest, on: req.db, in: req.eventLoop).map({ result in
            if result {
                return .ok
            }
            return .badRequest
        })
    }
    
    func updateService(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let payload = try req.jwt.verify(as: UserPayload.self)
        let connectServiceModelRequest = try req.content.decode(UserUpdateServiceRequestModel.self)
        return DatabaseManager.updateService(to: payload.subject.value, service: connectServiceModelRequest, on: req.db, in: req.eventLoop).map({ result in
            if result {
                return .ok
            }
            return .badRequest
        })
    }
}
