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
        let userDb = UsersDb(id: nil, login: user.login, password: user.password, connectedServices: [])
        userDb.create(on: database).whenComplete({ result in
            if case .failure = result {
                promise.fail(Abort(.badRequest, reason: "User already exist"))
            } else {
                promise.succeed(userDb)
            }
        })
        return promise.futureResult
    }
    
    static func loginUser(user: UserLoginRequestModel, on database: Database) -> EventLoopFuture<UsersDb> {
        let userDb = UsersDb.query(on: database).group(.and) { group in
            group.filter(\.$login == user.login).filter(\.$password == user.password)
        }.first().unwrap(or: Abort(.notFound))
        return userDb
    }
    
    static func getUser(by id: String, on database: Database) -> EventLoopFuture<UsersDb> {
        UsersDb.find(UUID(id), on: database).unwrap(or: Abort(.notFound))
    }
    
    static func connectService(to userId: String, serivce: UserConnectServiceRequestModel, on database: Database, in eventLoop: EventLoop) -> EventLoopFuture<Bool> {
        let promise = eventLoop.makePromise(of: Bool.self)
        getUser(by: userId, on: database).whenComplete({ result in
            if case let .success(user) = result {
                if user.$connectedServices.value?.contains(where: { connectedService in
                    connectedService.service.rawValue == serivce.service.rawValue
                }) == false {
                    user.connectedServices.append(ConnectedServicesDb(token: serivce.token, accountName: serivce.accountName, service: serivce.service))
                    user.save(on: database).whenComplete({ result in
                        if case .failure = result {
                            promise.fail(Abort(.badRequest, reason: "Error with save service"))
                        } else {
                            promise.succeed(true)
                        }
                        return
                    })
                    promise.fail(Abort(.badRequest, reason: "Service already connected"))
                }
            }
        })
        return promise.futureResult
    }
}
