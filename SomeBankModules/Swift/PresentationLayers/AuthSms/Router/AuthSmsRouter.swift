class AuthSmsRouter {
    weak var view: UIViewController!

    public func openPasswordModul(_ phone: String, _ enteringId: String) {
        let enterPasswordViewController = EnterPasswordAssembly.assemble(with: phone, enteringId: enteringId)
        self.view.navigationController?.pushViewController(enterPasswordViewController, animated: true)
    }

    public func openRegWasStarted(_ phone: String, authRouteData: AuthRouteData) {
        let regWasStartedVC = RegWasStartedAssembly.assemble(with: phone, authRouteData: authRouteData)
        self.view.navigationController?.pushViewController(regWasStartedVC, animated: true)
    }

    func openSetPinScreen() {
        guard let viewController = MBPinWireframe.create() else {
            fatalError("Не смогли создать MBPinViewController через MBPinWireframe")
        }
        self.view.present(viewController, animated: true)
    }

    func popToRoot() {
        self.view.navigationController?.popViewController(animated: true)
    }
}
