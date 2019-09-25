//
//  AuthV2Service.swift
//  
//
//  Created by Paul Vasilenko on 16/08/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation

@objc
protocol AuthV2ServiceProtocol: class {
    func sendPhone(phone: String, success: @escaping (_ requestId: String?) -> Void, failure: @escaping (_ error: MBError?) -> Void)
    func enterSmsCode(phone: String, smsCode: String, requestId: String, success: @escaping (_ route: AuthRouteData) -> Void, failure: @escaping (_ error: MBError?) -> Void)
    func repeatSmsCode(phone: String, requestId: String, success: @escaping (_ requestId: String?) -> Void, failure: @escaping (_ error: MBError?) -> Void)

    func loginWithoutPassword(phone: String, enteringId: String?, success: @escaping (_ loginResponse: AuthLoginResponsData?) -> Void, failure: @escaping (MBError?) -> Void)
    func loginWithPassword(phone: String, password: String, enteringId: String?, success: @escaping (_ loginResponse: AuthLoginResponsData?) -> Void, failure: @escaping (MBError?) -> Void)

    func setEmailAndPassword(email: String, password: String, success: @escaping () -> Void, failure: @escaping (MBError?) -> Void)

    func startRegistration(phone: String, enteringId: String?, success: @escaping (StartRegistrationResponse) -> Void, failure: @escaping (MBError?) -> Void)
}

private struct Routes {
    static let sendPhone = "v2/auth/mobile/phone" /// самый первый экран, отсылаем телефон
    static let enterSmsCode = "v2/auth/mobile/enterSmsCode" /// юзер ввел код из смс/пуша
    static let repeatSmsCode = "v2/auth/mobile/repeatSmsCode" /// нужно прислать код заново

    // ??? что это ??? куда это ??? а. это метод который дёргает Front
//    static let checkLoginByPush = "v2/auth/checkloginbypush" /// проверяем, авторизировался ли юзер через мобилку
//    static let setLoginByPush = "v2/auth/setLoginByPush"/// только мобилки) - юзер авторизовался через мобилку или отказался - внесено в старый сервис MBAuthBackend

    // До этих вызовов идёт проверка что же вернул роутинг
    static let loginWithoutPassword = "v2/auth/loginWithoutPassword" /// выполнить все нужные действия для входа в ЛК
    static let loginWithPassword = "v2/auth/loginWithPassword" /// проверить пароль и выполнить все нужные действия для входа в ЛК
    static let startRegistration = "v2/auth/startRegistration" /// начать регистрацию
//    static let saveName = "v2/auth/name" /// сохранить имя ??? Front метод ??? ДА!
//    static let showChangePasswordPanel = "v2/auth/showChangePasswordPanel" /// нужно показывать панель смены пароля?
    static let setEmailAndPassword = "v2/auth/setEmailAndPassword" /// устанавливает email и пароль для компании
}

@objcMembers
final class AuthV2Service: AuthV2ServiceProtocol {

    private var sessionManager = MBURLSessionManager()

    /// ??? нужно ли возвращать RequestId ? вроде как нет по заверениям @ (Android dev) но возвращаю
    func sendPhone(phone: String, success: @escaping (String?) -> Void, failure: @escaping (MBError?) -> Void) {
        MBUserDefaultsManager.setUserPhone(phone)
        if phone == "0000000011" {
            sessionManager = MBURLSessionManager(baseUrl: MBURLSessionManager.urlForAppleReview())
        }
        let parameters = [
            "CellPhone": phone
        ]
        let request: MBURLRequest = MBURLRequest(method: POST, urlString: sessionManager.urlString(Routes.sendPhone), parameters: parameters)
        sessionManager.make(request as URLRequest, success: { data, _, error in
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    let authData = try decoder.decode(AuthRequestIdData.self, from: jsonData)
                    success(authData.requestId)
                } catch let parsingError {
                    print("Error", parsingError)
                    failure(MBError.init(text: parsingError.localizedDescription))
                }
            } else {
                failure(MBError.init(text: error?.localizedDescription ?? ""))
            }
        }, failure: { error in
            failure(error)
        })
    }

    /// Возвращает в success (AuthRouteData) - роутинг и данные
    func enterSmsCode(phone: String, smsCode: String, requestId: String, success: @escaping (AuthRouteData) -> Void, failure: @escaping (MBError?) -> Void) {
        let parameters = ["CellPhone": phone]
        let request: MBURLRequest = MBURLRequest(method: POST, urlString: MBURLSessionManager.baseUrl() + Routes.enterSmsCode, parameters: parameters)
        request.addValue(smsCode, forHTTPHeaderField: "MB-SMS-VALIDATION")
        request.addValue(requestId, forHTTPHeaderField: "RequestSmsId")
        sessionManager.make(request as URLRequest, success: { data, _, error in
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    let authData = try decoder.decode(AuthRouteData.self, from: jsonData)
                    success(authData)
                } catch let parsingError {
                    print("Error", parsingError)
                    failure(MBError.init(text: parsingError.localizedDescription))
                }
            } else {
                failure(MBError.init(text: error?.localizedDescription ?? ""))
            }
        }, failure: { error in
            failure(error)
        })
    }

    func repeatSmsCode(phone: String, requestId: String, success: @escaping (String?) -> Void, failure: @escaping (MBError?) -> Void) {
        let parameters = ["CellPhone": phone]
        let request: MBURLRequest = MBURLRequest.init(method: POST, urlString: MBURLSessionManager.baseUrl() + Routes.repeatSmsCode, parameters: parameters)
        request.addValue(requestId, forHTTPHeaderField: "RequestSmsId")
        sessionManager.make(request as URLRequest, success: { data, _, error in
            // возвращает "RequestId": "8b0e7393-0798-4958-9214-091c7f302c20"
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    let authData = try decoder.decode(AuthRequestIdData.self, from: jsonData)
                    success(authData.requestId)
                } catch let parsingError {
                    print("Error", parsingError)
                    failure(MBError.init(text: parsingError.localizedDescription))
                }
            }
        }, failure: { error in
            failure(error)
        })
    }

    func loginWithoutPassword(phone: String, enteringId: String?, success: @escaping (AuthLoginResponsData?) -> Void, failure: @escaping (MBError?) -> Void) {
        let parameters = [
            "CellPhone": phone,
            "EnteringId": enteringId ?? ""
        ]
        let request: MBURLRequest = MBURLRequest.init(method: POST, urlString: sessionManager.urlString(Routes.loginWithoutPassword), parameters: parameters)
        sessionManager.make(request as URLRequest, success: { data, response, error in
            // возвращает "RequestId": "8b0e7393-0798-4958-9214-091c7f302c20"
            let httpResponse = response as? HTTPURLResponse
            let xToken = httpResponse?.allHeaderFields["X-Token"] as? String
            MBStorage.sharedManager().user.token = xToken
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    let authData = try decoder.decode(AuthLoginResponsData.self, from: jsonData)
                    authData.xToken = xToken
                    AESCrypt.saveSecretKey(authData.secretKey ?? "")
                    if MBUserDefaultsManager.deviceIdentity() == nil {
                        if let cookies = HTTPCookieStorage.shared.cookies {
                            if cookies.count > 0 {
                                let cookieName = cookies.first?.name ?? ""
                                if cookieName == "DeviceIdentity" {
                                    let deviceIdentity = "\(cookieName)=\(cookies.first?.value ?? "")"
                                    MBUserDefaultsManager.setDeviceIdentity(deviceIdentity)
                                }
                            }
                        }
                    }
                    success(authData)
                } catch let parsingError {
                    print("Error", parsingError)
                    failure(MBError.init(text: parsingError.localizedDescription))
                }
            } else {
                failure(MBError.init(text: error?.localizedDescription ?? ""))
            }
        }, failure: { error in
            failure(error)
        })
    }

    func loginWithPassword(phone: String, password: String, enteringId: String?, success: @escaping (AuthLoginResponsData?) -> Void, failure: @escaping (MBError?) -> Void) {
        var parameters = [
            "CellPhone": phone,
            "Password": password
        ]
        if let enteringId = enteringId {
            parameters["EnteringId"] = enteringId
        }
        let request: MBURLRequest = MBURLRequest.init(method: POST, urlString: sessionManager.urlString(Routes.loginWithPassword), parameters: parameters)
        sessionManager.make(request as URLRequest, success: { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            let xToken = httpResponse?.allHeaderFields["X-Token"] as? String
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    let authData = try decoder.decode(AuthLoginResponsData.self, from: jsonData)
                    authData.xToken = xToken
                    success(authData)
                } catch let parsingError {
                    print("Error", parsingError)
                    failure(MBError.init(text: parsingError.localizedDescription))
                }
            } else {
                failure(MBError.init(text: error?.localizedDescription ?? ""))
            }
        }, failure: { error in
            failure(error)
        })
    }

    func startRegistration(phone: String, enteringId: String?, success: @escaping (StartRegistrationResponse) -> Void, failure: @escaping (MBError?) -> Void) {
        var parameters = [
            "CellPhone": phone,
            "Package": "optimal"
        ]
        if let enteringId = enteringId {
            parameters["EnteringId"] = enteringId
        }
        let request: MBURLRequest = MBURLRequest.init(method: POST, urlString: sessionManager.urlString(Routes.startRegistration), parameters: parameters)
        sessionManager.make(request as URLRequest, success: { data, response, error in
            let httpResponse = response as? HTTPURLResponse
            let xToken = httpResponse?.allHeaderFields["X-Token"] as? String
            MBStorage.sharedManager().user.token = xToken
            let companyId = httpResponse?.allHeaderFields["CompanyId"] as? String
            if let jsonData = data {
                do {
                    let decoder = JSONDecoder()
                    let startRegistration = try decoder.decode(StartRegistrationResponse.self, from: jsonData)
                    startRegistration.xToken = xToken
                    startRegistration.companyId = companyId
                    AESCrypt.saveSecretKey(startRegistration.secretKey)
                    success(startRegistration)
                } catch let parsingError {
                    print("Error", parsingError)
                    failure(MBError.init(text: parsingError.localizedDescription))
                }
            } else {
                failure(MBError.init(text: error?.localizedDescription ?? ""))
            }
        }, failure: { error in
            failure(error)
        })
    }

    //done: только для фронта
//    func showChangePasswordPanel() {
//
//    }

    func setEmailAndPassword(email: String, password: String, success: @escaping () -> Void, failure: @escaping (MBError?) -> Void) {
        let parameters = [
            "Email": email,
            "Password": password
        ]
        let request: MBURLRequest = MBURLRequest.init(method: POST, urlString: sessionManager.urlString(Routes.setEmailAndPassword), parameters: parameters)

        sessionManager.make(request as URLRequest, success: { _, _, _ in
            success()
        }, failure: { error in
            failure(error)
        })
    }
}
