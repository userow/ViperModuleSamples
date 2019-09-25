import UIKit

@objc class AuthPhoneAssembly: NSObject {
    //done: ??? передавать просто телефон а не Settings - для ObjC ??? скорее не надо.
//    (settings: AuthPhoneSettings?)
    @objc static func assemble() -> UIViewController {
        let view = AuthPhoneViewController()
        let router = AuthPhoneRouter()
        let presenter = AuthPhonePresenter()
        let interactor = AuthPhoneInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.service = AuthV2Service()
        router.view = view

        return view
    }

}
