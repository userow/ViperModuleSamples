class AuthPhoneRouter {
    private struct Texts {
        static let install = "Установить"
        static let cancel = "Отмена"
    }

    weak var view: UIViewController!

    func openAuthSmsModule(_ phone: String, _ requestId: String) {
        let view = AuthSmsAssembly.assemble(phone, requestId: requestId)
        self.view.navigationController?.pushViewController(view, animated: true)
    }

    func openSimChangedModule() {
        DispatchQueue.main.async {
            _ = MBSimChangedPopUpWireframe.present(on: self.view)
        }
    }

    func applicationOutdated(_ error: MBError?) {
        let alertController = UIAlertController(title: "", message: error?.text, preferredStyle: .alert)
        let installAction = UIAlertAction(title: Texts.install, style: .default, handler: { _ in
            MBUser.openAppStoreWithApplication()
        })
        let cancelAction = UIAlertAction(title: Texts.cancel, style: .default, handler: nil)
        alertController.addAction(installAction)
        alertController.addAction(cancelAction)
        self.view.present(alertController, animated: true, completion: nil)
    }

    func openBankNotAvaiLable() {
        DispatchQueue.main.async { [weak self] in
            let modulNotAvailableVC = MBModulNotAvaiLableViewController()
            modulNotAvailableVC.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            modulNotAvailableVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
            modulNotAvailableVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            self?.view.present(modulNotAvailableVC, animated: true, completion: nil)
        }
    }

}
