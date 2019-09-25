class RegWasStartedRouter {
    weak var view: UIViewController!

    public func openPasswordModule(_ phone: String, _ enteringId: String) {
        let enterPasswordViewController = EnterPasswordAssembly.assemble(with: phone, enteringId: enteringId)
        self.view.navigationController?.pushViewController(enterPasswordViewController, animated: true)
    }

    public func openSetPinModule() {
        guard let viewController = MBPinWireframe.create() else {
            fatalError("Не смогли создать MBPinViewController через MBPinWireframe")
        }
        self.view.present(viewController, animated: true)
    }

    public func popToRoot() {
        self.view.navigationController?.popToRootViewController(animated: true)
    }

}
