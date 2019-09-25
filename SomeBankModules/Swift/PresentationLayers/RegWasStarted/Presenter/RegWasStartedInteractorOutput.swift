protocol RegWasStartedInteractorOutput: class {
    func madeLoginWithOutPassword(_ authLoginResponsData: AuthLoginResponsData?)
    func madeStartRegistration(_ startRegistrationResponse: StartRegistrationResponse)
    func handleError(error: MBError?)
}
