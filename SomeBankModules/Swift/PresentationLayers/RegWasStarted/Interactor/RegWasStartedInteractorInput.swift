protocol RegWasStartedInteractorInput: class {
    func sendStartRegistration(phone: String, enteringId: String?)
    func sendLoginWithOutPassword(phone: String, enteringId: String?)
}
