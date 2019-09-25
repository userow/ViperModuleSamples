protocol AuthSmsViewInput: class {
    func wrongSmsCode()
    func stopAnimation()
    func didRequestRepeatSms()
}
