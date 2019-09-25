class AuthPhoneInteractor {
    weak var presenter: AuthPhoneInteractorOutput!
    var service: AuthV2ServiceProtocol!
}

extension AuthPhoneInteractor: AuthPhoneInteractorInput {
    func authSend(_ phone: String) {
        MBCommonStorageService().userFromStorage().phone = "7" + phone

        service.sendPhone(phone: phone,
                          success: { requestId in
            print("requestId = \(String(describing: requestId))")
            self.presenter.didReceiveSendAuthResponse(requestId)
        },
                          failure: { (error) in
            self.presenter.didReceiveSendAuthError(error)
        })
    }
}
