protocol AuthSmsViewOutput: class {
    func viewDidLoad()
    func didEnterSms(_ sms: String)
    func requestRepeatSms()
    func phoneString() -> String
}
