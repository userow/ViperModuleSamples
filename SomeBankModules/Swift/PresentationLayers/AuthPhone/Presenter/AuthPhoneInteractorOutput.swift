protocol AuthPhoneInteractorOutput: class {
    func didReceiveSendAuthResponse(_ requestId: String?)
    func didReceiveSendAuthError(_ error: MBError?)
}
