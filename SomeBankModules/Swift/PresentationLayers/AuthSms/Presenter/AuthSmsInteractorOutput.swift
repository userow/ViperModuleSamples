protocol AuthSmsInteractorOutput: class {
    func didReceiveRouteData(_ authRouteData: AuthRouteData)
    func didGetUploadSmsCodeError(_ error: MBError)
    func didGetRequestRepeatSmsError(_ error: MBError)
    func makeLoginWithOutPassword(_ authLoginResponsData: AuthLoginResponsData)
    func handleError(_ error: MBError)
    func didRequestRepeatSms()

    func didStartRegistrationSuccess(with response: StartRegistrationResponse)
    func didStartRegistrationFailed(with error: MBError?)
}
