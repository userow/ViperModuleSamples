import UIKit

@objc class AuthSmsAssembly: NSObject {
/**
     @param phone - передать только цифры без 7
 */
    @objc static func assemble(_ phone: String, requestId: String) -> UIViewController {
        let view = AuthSmsViewController()
        let router = AuthSmsRouter()
        let presenter = AuthSmsPresenter()
        let interactor = AuthSmsInteractor()
        let textManager = AuthSmsTextManager()

        presenter.phone = phone
        presenter.requestId = requestId
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.textManager = textManager
        presenter.router = router
        interactor.presenter = presenter
        interactor.service = AuthV2Service()
        router.view = view

        return view
    }

}
