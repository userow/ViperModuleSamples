import InputMask

class AuthSmsPresenter {
    weak var view: AuthSmsViewInput!
    var interactor: AuthSmsInteractorInput!
    var router: AuthSmsRouter!
    var textManager: AuthSmsTextManagerProtocol!
    public var phone: String!
    var enteringId: String?
    var isEnteredSms: Bool = false
    public var requestId: String!
}

extension AuthSmsPresenter: AuthSmsModuleInput {

}

extension AuthSmsPresenter: AuthSmsViewOutput {
    func viewDidLoad() {
    }

    func didEnterSms(_ sms: String) {
        if isEnteredSms == false {
            interactor.uploadSmsCode(phone, sms, requestId)
            isEnteredSms = true
        }
    }

    func requestRepeatSms() {
        interactor.makeRequestRepeatSms(phone, requestId)
    }

    private func startRegistrationProcessing() {
        self.interactor.sendStartRegistration(phone: phone, enteringId: enteringId)
    }

    func phoneString() -> String {
        if let mask =  try? Mask.getOrCreate(withFormat: AuthPhoneFieldFormatter.phoneMask()) {
            let caretString = CaretString(string: "+7" + phone)
            return mask.apply(toText: caretString).formattedText.string
        }
        return phone
    }
}

extension AuthSmsPresenter: AuthSmsInteractorOutput {
    func didReceiveRouteData(_ authRouteData: AuthRouteData) {
        isEnteredSms = false
        enteringId = authRouteData.enteringId ?? ""
        switch authRouteData.routeType {
        case .login:
            interactor.makeLoginWithOutPassword(authRouteData, phone)
            print("login")
        case .loginWithPassword:
            router.openPasswordModul(phone, authRouteData.enteringId ?? "")
            print("loginWithPassword")
        case .registration:
            self.startRegistrationProcessing()
        case .restartRegistrationOrLogin:
            print("restartRegistrationOrLogin")
            router.openRegWasStarted(phone, authRouteData: authRouteData)
        case .restartRegistrationOrLoginWithPassword:
            print("restartRegistrationOrLoginWithPassword")
            router.openRegWasStarted(phone, authRouteData: authRouteData)
        case .none:
            print("none")
        }
    }

    func didGetUploadSmsCodeError(_ error: MBError) {
        isEnteredSms = false
        handleError(error)
    }

    func didGetRequestRepeatSmsError(_ error: MBError) {
        handleError(error)
    }

    func handleError(_ error: MBError) {
        switch error.type {
        case SmsWrongCode:
            view.wrongSmsCode()
        case UserHasNotCompanies, TimeOut, InternetConnectionOffline:
            view.stopAnimation()
            error.show()
        case InvalidCaptcha:
            error.show()
            view.stopAnimation()
            router.popToRoot()
        default:
            error.show()
            view.stopAnimation()
        }
    }

    func makeLoginWithOutPassword(_ authLoginResponsData: AuthLoginResponsData) {
        self.router.openSetPinScreen()//router.openPasswordModul(phone, enteringId ?? "")
    }

    func didRequestRepeatSms() {
        self.view.didRequestRepeatSms()
    }

    func didStartRegistrationSuccess(with response: StartRegistrationResponse) {
        self.router.openSetPinScreen()
    }

    func didStartRegistrationFailed(with error: MBError?) {
        guard let error = error else {
            return
        }
        self.handleError(error)
    }
}
