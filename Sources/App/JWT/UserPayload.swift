//
//  File.swift
//  
//
//  Created by Kirill on 15.08.2021.
//

import Vapor
import JWT

struct UserPayload: JWTPayload {
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case isPremium = "isPremium"
    }
    
    // The "sub" (subject) claim identifies the principal that is the
    // subject of the JWT.
    var subject: SubjectClaim
    
    // The "exp" (expiration time) claim identifies the expiration time on
    // or after which the JWT MUST NOT be accepted for processing.
    var expiration: ExpirationClaim
    
    // Custom data.
    // If true, the user is an admin.
    var isPremium: Bool
    
    // Run any additional verification logic beyond
    // signature verification here.
    // Since we have an ExpirationClaim, we will
    // call its verify method.
    func verify(using signer: JWTSigner) throws {
        try self.expiration.verifyNotExpired()
    }
}
