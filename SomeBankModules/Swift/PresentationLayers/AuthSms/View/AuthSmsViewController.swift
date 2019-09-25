import UIKit
import SnapKit

extension AuthSmsViewController {
    struct Appearance {
        let iconImageWidth = 241
        let iconImageHeight = 40
        let offset = 70
    }
}

final class AuthSmsViewController: UIViewController {

    private let appearance = Appearance()

    var presenter: AuthSmsViewOutput!

    lazy var smsView: MBSmsLightContentView = {
        let view = MBSmsLightContentView.init(MBBlueContentType)
        view?.delegate = self
        return view!
    }()

    lazy var imageIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.whiteLogo
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        addSubviews()
        makeConstraints()
        presenter.viewDidLoad()

        smsView.setPhone(presenter.phoneString())
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.smsView.start()
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AuthSmsViewController.tapAction))
        self.view.addGestureRecognizer(tapGesture)
    }

    func addSubviews() {
        view.addSubview(imageIcon)
        view.addSubview(smsView)
    }

    func makeConstraints() {

        imageIcon.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(appearance.offset)
            make.width.equalTo(appearance.iconImageWidth)
            make.height.equalTo(appearance.iconImageHeight)
            make.centerX.equalTo(self.view)
        }

        smsView.snp.makeConstraints { (make) in
            make.top.equalTo(imageIcon.snp.bottom).offset(appearance.offset)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(smsView.bounds.height)
        }
    }

    @objc func tapAction() {
        view.endEditing(true)
    }
}

extension AuthSmsViewController: AuthSmsViewInput {
    func wrongSmsCode() {
        smsView.wrongSmsCode()
    }

    func stopAnimation() {
        smsView.stop()
    }

}

extension AuthSmsViewController: MBSmsLightContentViewDelegate {
    func repeatSmsAction(_ button: MBTitleButton!) {
        presenter.requestRepeatSms()
    }

    func changePhoneAction(_ button: MBTitleButton!) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }

    func enteredSmsCode(_ sms: String!) {
        presenter.didEnterSms(sms)
    }

    func didRequestRepeatSms() {
        smsView.repeatSmsCode()
    }
}
