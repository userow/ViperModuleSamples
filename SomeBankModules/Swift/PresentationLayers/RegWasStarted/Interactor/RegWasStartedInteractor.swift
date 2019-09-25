class RegWasStartedInteractor {
    weak var presenter: RegWasStartedInteractorOutput!
    var authService: AuthV2ServiceProtocol!
}

extension RegWasStartedInteractor: RegWasStartedInteractorInput {

    func sendStartRegistration(phone: String, enteringId: String?) {
        authService.startRegistration(phone: phone, enteringId: enteringId, success: { [weak self] startRegistrationResponse in
            self?.presenter.madeStartRegistration(startRegistrationResponse)
        },
                                      failure: { [weak self] error in
                                        self?.presenter.handleError(error: error)
        })
    }

    func sendLoginWithOutPassword(phone: String, enteringId: String?) {
        authService.loginWithoutPassword(phone: phone, enteringId: enteringId, success: { [weak self] authLoginResponsData in
            self?.presenter.madeLoginWithOutPassword(authLoginResponsData)
        }, failure: { [weak self] error in
            self?.presenter.handleError(error: error)
        })
    }

}
