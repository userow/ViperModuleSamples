enum RegWasStartedFlowState {
    case unknown
}

class RegWasStartedPresenter {
    public weak var view: RegWasStartedViewInput!
    public var interactor: RegWasStartedInteractorInput!
    public var router: RegWasStartedRouter!
    public var authRouteData: AuthRouteData!
    public var phone: String!
}

extension RegWasStartedPresenter {

}

extension RegWasStartedPresenter: RegWasStartedModuleInput {

}

extension RegWasStartedPresenter: RegWasStartedViewOutput {
    func viewDidLoad() {
        if let company = authRouteData.existingCompanyName {
            self.view.setCompanyName(company)
        }
    }

    func continueRegistration() {
        if authRouteData.routeType == .restartRegistrationOrLoginWithPassword {
            // если restartRegistrationOrLoginWithPassword - enterPassword, PIN, reg
            router.openPasswordModule(phone, authRouteData.enteringId ?? "")
        } else if authRouteData.routeType == .restartRegistrationOrLogin {
            view.startAnimating()
            interactor.sendLoginWithOutPassword(phone: phone, enteringId: authRouteData.enteringId)
        }
    }

    func restartRegistration() {
        view.startAnimating()
        interactor.sendStartRegistration(phone: phone, enteringId: authRouteData.enteringId)
    }

    func changePhone() {
        router.popToRoot()
    }
}

extension RegWasStartedPresenter: RegWasStartedInteractorOutput {
    func madeLoginWithOutPassword(_ authLoginResponsData: AuthLoginResponsData?) {
        self.view.stopAnimating()
        self.router.openSetPinModule()
    }

    func madeStartRegistration(_ startRegistrationResponse: StartRegistrationResponse) {
        self.view.stopAnimating()
        self.router.openSetPinModule()
    }

    func handleError(error: MBError?) {
        view.stopAnimating()
        if let err = error {
            err.show()
        } else {
            let err = MBError.init(text: "Неизвестная ошибка")
            err?.show()
        }
    }
}
