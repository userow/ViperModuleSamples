class AuthSmsInteractor {
    weak var presenter: AuthSmsInteractorOutput!
    var service: AuthV2ServiceProtocol!
    var requestId: String!
}

extension AuthSmsInteractor: AuthSmsInteractorInput {

    func uploadSmsCode(_ phone: String, _ sms: String, _ requestId: String) {
        service.enterSmsCode(phone: phone, smsCode: sms, requestId: requestId, success: { (routeData) in
            self.presenter.didReceiveRouteData(routeData)
        }, failure: { error in
            self.presenter.didGetUploadSmsCodeError(error!)
        })
    }

    func makeRequestRepeatSms(_ requestId: String, _ phone: String) {
        service.repeatSmsCode(phone: phone, requestId: requestId, success: { (requestId) in
            print(requestId ?? "")
            self.presenter.didRequestRepeatSms()
        }, failure: { error in
            self.presenter.didGetRequestRepeatSmsError(error!)
        })
    }

    func makeLoginWithOutPassword(_ routeData: AuthRouteData, _ phone: String) {
        service.loginWithoutPassword(phone: phone, enteringId: routeData.enteringId, success: { (authLoginResponsData) in
            if let data = authLoginResponsData {
                self.presenter.makeLoginWithOutPassword(data)
            } else {
                self.presenter.handleError(MBError.init(text: "Неизвестная ошибка"))
            }
        }, failure: { error in
            self.presenter.handleError(error!)
        })
    }

    func sendStartRegistration(phone: String, enteringId: String?) {
        weak var weakSelf = self
        self.service.startRegistration(phone: phone, enteringId: enteringId,
                success: { startRegistrationResponse in
                    weakSelf?.presenter.didStartRegistrationSuccess(with: startRegistrationResponse)
                },
                failure: { error in
                    weakSelf?.presenter.didStartRegistrationFailed(with: error)
                })
    }
}
