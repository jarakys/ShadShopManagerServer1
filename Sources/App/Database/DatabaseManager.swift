//
//  File.swift
//  
//
//  Created by Kirill on 13.08.2021.
//

import Vapor
import Fluent

final class DatabaseManager {
    static func createUser(user: UserCreateRequestModel, on database: Database, in eventLoop: EventLoop) -> EventLoopFuture<UsersDb> {
        let promise = eventLoop.makePromise(of: UsersDb.self)
        let userDb = UsersDb(id: nil, login: user.login, password: user.password)
        userDb.create(on: database).whenComplete({ result in
            if case .failure = result {
                promise.fail(Abort(.badRequest, reason: "User already exist"))
            } else {
                promise.succeed(userDb)
            }
        })
        return promise.futureResult
    }
    
    static func loginUser(user: UserLoginRequestModel, on database: Database, in eventLoop: EventLoop) -> EventLoopFuture<UsersDb> {
        let promise = eventLoop.makePromise(of: UsersDb.self)
        let userDb = UsersDb.query(on: database).group(.and) { group in
            group.filter(\.$login == user.login).filter(\.$password == user.password)
        }.first().whenComplete({ result in
            if case let .success(.some(user)) = result {
                user.$connectedServices.load(on: database).whenComplete({ loadResult in
                    if case .failure = loadResult {
                        promise.fail(Abort(.internalServerError, reason: "Cannot load connectedServices"))
                        return
                    }
                    promise.succeed(user)
                })
            } else {
                promise.fail(Abort(.badRequest, reason: "User not found"))
            }
        })
        return promise.futureResult
    }
    
    static func getUser(by id: String, on database: Database) -> EventLoopFuture<UsersDb> {
        UsersDb.find(UUID(id), on: database).unwrap(or: Abort(.notFound))
    }
    
    static func connectService(to userId: String, service: UserConnectServiceRequestModel, on database: Database, in eventLoop: EventLoop) -> EventLoopFuture<Bool> {
        let promise = eventLoop.makePromise(of: Bool.self)
        
        getServices(userId: userId, on: database, in: eventLoop).whenComplete({ result in
            if case let .success(connectedServices) = result {
                if !connectedServices.contains(where: { $0.service.rawValue == service.service.rawValue }) {
                    let serviceDb = ConnectedServicesDb(userId: UUID(userId) ?? UUID(), token: service.token, accountName: service.accountName, service: service.service)
                    serviceDb.save(on: database).whenComplete({result in
                        if case .failure = result {
                            promise.fail(Abort(.badRequest, reason: "Error with save service"))
                        } else {
                            promise.succeed(true)
                        }
                        return
                    })
                } else {
                    promise.fail(Abort(.badRequest, reason: "Service already connected"))
                }
            } else {
                promise.fail(Abort(.badRequest, reason: "Error with save service"))
            }
        })
        return promise.futureResult
    }
    
    static func updateService(to userId: String, service: UserUpdateServiceRequestModel, on database: Database, in eventLoop: EventLoop) -> EventLoopFuture<Bool> {
        let promise = eventLoop.makePromise(of: Bool.self)
        
        getService(serviceId: UUID(service.id), on: database).whenComplete({ result in
            if case let .success(connectedService) = result {
                connectedService.accountName = service.accountName
                connectedService.token = service.token
                connectedService.save(on: database).whenComplete({ result in
                    if case .failure = result {
                        promise.fail(Abort(.badRequest, reason: "Error with save service"))
                    } else {
                        promise.succeed(true)
                    }
                    return
                })
            } else {
                promise.fail(Abort(.badRequest, reason: "Server error"))
            }
        })
        return promise.futureResult
    }
    
    static func getServices(userId: String, on database: Database, in eventLoop: EventLoop) -> EventLoopFuture<[ConnectedServicesDb]> {
        
        let serviceDbQuery = ConnectedServicesDb.query(on: database)
        return serviceDbQuery.filter(\.$userId, .equal, UUID(userId) ?? UUID()).all()
    }
    
    static func getService(serviceId: UUID?, on database: Database) -> EventLoopFuture<ConnectedServicesDb> {
        ConnectedServicesDb.find(serviceId, on: database).unwrap(or: Abort(.badRequest))
    }
}
