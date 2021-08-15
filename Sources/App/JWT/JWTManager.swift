//
//  File.swift
//  
//
//  Created by Kirill on 15.08.2021.
//

import Vapor
import JWT

class JWTManager {
    static func getJWTToken(user: UsersDb, on request: Request) -> String? {
        let payload = UserPayload(
            subject: SubjectClaim(value: user.login),
            expiration: .init(value: .distantFuture),
            isPremium: true
        )
        return try? request.jwt.sign(payload)
    }
}
