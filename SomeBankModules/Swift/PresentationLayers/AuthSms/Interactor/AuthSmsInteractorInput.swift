protocol AuthSmsInteractorInput: class {
    func uploadSmsCode(_ phone: String, _ requestId: String, _ sms: String)
    func makeRequestRepeatSms(_ requestId: String, _ phone: String)
    func makeLoginWithOutPassword(_ routeData: AuthRouteData, _ phone: String)
    func sendStartRegistration(phone: String, enteringId: String?)
}
