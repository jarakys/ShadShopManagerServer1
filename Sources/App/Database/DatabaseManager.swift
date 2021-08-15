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
        let userDb = UsersDb(id: nil, login: user.login, password: user.password, connectedInstagram: false)
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
}
