enum AuthPhoneFlowState {
    case unknown
}

class AuthPhonePresenter {

    weak var view: AuthPhoneViewInput!
    var interactor: AuthPhoneInteractorInput!
    var router: AuthPhoneRouter!

    var sentPhone: String = ""

    private struct Texts {
        static let phoneErrorText = ""
    }
    private var state: AuthPhoneFlowState = .unknown {
        didSet {
            handleDataFlowState()
        }
    }

    // MARK: Private
    func handleError(_ error: MBError) {
        switch error.type {
        case InvalidCredential, TimeOut, InvalidCaptcha, InternetConnectionOffline, LimitFailedTries, ServerError500:
            error.show()
        case VersionApplicationOutdated:
            self.router.applicationOutdated(error)
        case UPDATE_IN_PROGRESS:
            self.router.openBankNotAvaiLable()
        case SIMChanged:
            self.router.openSimChangedModule()
        default:
            error.show()
        }
    }
}

extension AuthPhonePresenter {
    private func handleDataFlowState() {
        switch state {
        case .unknown:
            break
        }
    }

    func phoneValid(_ phone: String) -> Bool {
        if phone.count != 10 {
            let error = MBError(text: Texts.phoneErrorText)
            error?.show()
            return false
        }
        return true
    }
}

extension AuthPhonePresenter: AuthPhoneViewOutput {

    func becomeClient(_ phone: String) {
        guard phoneValid(phone) else { 	return }
        view.showActivity()
        sentPhone = phone
        interactor.authSend(phone)
    }

    func enterBank(_ phone: String) {
        view.showActivity()
        sentPhone = phone
        interactor.authSend(phone)
    }
}

extension AuthPhonePresenter: AuthPhoneInteractorOutput {
    func didReceiveSendAuthResponse(_ requestId: String?) {
        view.hideActivity()
        router.openAuthSmsModule(sentPhone, requestId ?? "no-request-id")
    }

    func didReceiveSendAuthError(_ error: MBError?) {
        view.hideActivity()
        if let error = error {
            handleError(error)
        }
    }
}
