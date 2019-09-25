//
//  AuthData.swift
//
//
//  Created by Paul Vasilenko on 16/08/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation

/*
 "Route": "RestartRegistrationOrLoginWithPassword",
 "ExistingCompanyName": "ООО Ромашка",
 "EnteringId": "17c34729-4557-41d9-894a-fa5c2c1a019e"
 */

@objcMembers
class AuthRouteData: NSObject, Decodable {
    var route: String?
    var existingCompanyName: String?
    var enteringId: String?

    private enum CodingKeys: String, CodingKey {
        case route = "Route"
        case existingCompanyName = "ExistingCompanyName"
        case enteringId = "EnteringId"
    }

    public enum RouteType: String, CaseIterable {
        case none
        case login = "Login"
        case registration = "Registration"
        case loginWithPassword = "LoginWithPassword"
        case restartRegistrationOrLogin = "RestartRegistrationOrLogin" // !!! логин БЕЗ пароля !!!
        case restartRegistrationOrLoginWithPassword = "RestartRegistrationOrLoginWithPassword" // !!! логин с паролем !!!
    }
}

extension AuthRouteData {

    var routeType: RouteType {
        return RouteType(rawValue: self.route ?? "") ?? .none
    }
}

class AuthRequestIdData: Decodable {
    var requestId: String?

    private enum CodingKeys: String, CodingKey {
        case requestId = "RequestId"
    }
}

@objcMembers
class AuthLoginResponsData: NSObject, Decodable {
    var secretKey: String?
    var userId: String?
    var token: String?
    var serverUtcTimestamp: Int?
    var email: String?
    var crossDomainToken: String?
    var xToken: String?

    private enum CodingKeys: String, CodingKey {
        case secretKey = "SecretKey"
        case userId = "UserId"
        case token = "Token"
//        case serverUtcTimestamp = "ServerUtcTimestamp"
        case email = "Email"
        case crossDomainToken = "CrossDomainToken"
    }
}

@objc class StartRegistrationResponse: NSObject, Decodable {
    var secretKey: String
    var clientUid: String
    var userId: String
    var token: String
    var serverUtcTimestamp: Int?
    var email: String?
    var crossDomainToken: String?

    var xToken: String?
    var companyId: String?

    private enum CodingKeys: String, CodingKey {
        case secretKey = "SecretKey"
        case clientUid = "ClientUid"
        case userId = "UserId"
        case token = "Token"
        case serverUtcTimestamp = "ServerUtcTimestamp"
        case email = "Email"
        case crossDomainToken = "CrossDomainToken"
    }
}
