import UIKit

class RegWasStartedAssembly {

    static func assemble(with phone: String, authRouteData: AuthRouteData) -> UIViewController {

        let view = RegWasStartedViewController()
        let router = RegWasStartedRouter()
        let presenter = RegWasStartedPresenter()
        let interactor = RegWasStartedInteractor()

        presenter.authRouteData = authRouteData
        presenter.phone = phone
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        interactor.authService = AuthV2Service()
        router.view = view

        return view
    }

}
