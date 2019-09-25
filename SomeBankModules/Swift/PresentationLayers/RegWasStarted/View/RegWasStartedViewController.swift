import UIKit
import SnapKit

extension RegWasStartedViewController {
    struct Appearance {
        static let logoTop: CGFloat = 20.0
        static let logoWidth: CGFloat = 144.0
        static let logoHeight: CGFloat = 24.0
        static let logoColor: UIColor = .blue1

        static let stackHoriznontalMargin: CGFloat = 20.0
        static let stackHeights: CGFloat = 374.0
        static let stackVerticalMargin: CGFloat = 70.0
        static let stackVerticalSpace: CGFloat = 8.0

        static let officeImageHeight: CGFloat = 81.0
        static let officeImageWidth: CGFloat = 72.0

        static let labelTopSpace: CGFloat = 24.0
        static let labelFont: UIFont = .regular16
        static let labelColor: UIColor = .graphite1
        static let labelBottomSpace: CGFloat = 32.0

        static let middleButtonHeight: CGFloat = 52.0
        static let middleButtonSpace: CGFloat = 8.0

        static let continueButtonTextColor: UIColor = .white
        static let continueButtonFont: UIFont = .bold16

        static let restartButtonTextColor: UIColor = .graphite2
        static let restartButtonFont: UIFont = .medium16

        static let changePhoneButtonTextColor: UIColor = .graphite3
        static let changePhoneButtonFont: UIFont = .medium12
        static let changePhoneButtonBottom: CGFloat = 40.0
        static let changePhoneButtonWidth: CGFloat = 200.0
        static let changePhoneButtonHeight: CGFloat = 44.0
    }

    struct Texts {
        static let regWasLabelTextFormat: String = "На ваш номер телефона уже начинали регистрацию компании\n%@\n\nВы можете продолжить регистрацию или начать сначала"
        static let continueButtonText: String = "ПРОДОЛЖИТЬ"
        static let restartButtonText: String = "НАЧАТЬ С НАЧАЛА"
        static let changePhoneButtonText: String = "ИЗМЕНИТЬ ТЕЛЕФОН"
    }
}

final class RegWasStartedViewController: BaseViewController {

    var presenter: RegWasStartedViewOutput!
    var companyName = "Индивидуальный Предприниматель Плейсхолдер Плейсхолдерыч Плейсхолдеров"

    // MARK: - view related:
    private var minTopYOffset: CGFloat = 20.0
    private var minBottomYOffset: CGFloat = 0.0

    // MARK: - views
    private lazy var imageViewContainer: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var logoImageView: UIImageView = {
        let logoImage = UIImage.whiteLogo.withRenderingMode(.alwaysOriginal)
        let logoView = UIImageView(image: logoImage)
        logoView.tintColor = Appearance.logoColor
        return logoView
    }()

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = Appearance.stackVerticalSpace
        return stackView
    }()

    private lazy var officeImageView: UIImageView = {
        let image = UIImage.office
        let imageView = UIImageView(image: image)
        return imageView
    }()

    private lazy var regWasLabel: UILabel = {
        let regLabel = UILabel()
        regLabel.font = Appearance.labelFont
        regLabel.textColor = Appearance.labelColor
        regLabel.text = String(format: Texts.regWasLabelTextFormat, self.companyName)
        regLabel.numberOfLines = 0
        regLabel.minimumScaleFactor = 0.5
        regLabel.textAlignment = .center
        return regLabel
    }()

    private lazy var continueButton: MBBlueUIButton = {
        let button = MBBlueUIButton()
        button.setTitleColor(Appearance.continueButtonTextColor, for: .normal)
        button.titleLabel?.font = Appearance.continueButtonFont
        button.setTitle(Texts.continueButtonText, for: .normal)
        button.addTarget(self, action: #selector(continueButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var restartButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(Appearance.restartButtonTextColor, for: .normal)
        button.titleLabel?.font = Appearance.restartButtonFont
        button.setTitle(Texts.restartButtonText, for: .normal)
        button.addTarget(self, action: #selector(restartButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var changePhoneButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Appearance.changePhoneButtonFont
        button.setTitleColor(Appearance.changePhoneButtonTextColor, for: .normal)
        button.setTitle(Texts.changePhoneButtonText, for: .normal)
        button.addTarget(self, action: #selector(changePhoneButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        addSubviews()
        presenter.viewDidLoad()
    }

    override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11, *) {
            super.viewSafeAreaInsetsDidChange()
            print("safeAreaInsets - \(self.view.safeAreaInsets)")
            minTopYOffset = self.view.safeAreaInsets.top
            minBottomYOffset = self.view.safeAreaInsets.bottom

            makeConstraints()

            self.view.layoutIfNeeded()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if #available(iOS 11, *) { } else {
            makeConstraints()
        }
    }

    func addSubviews() {
        self.view.addSubview(logoImageView)
        self.view.addSubview(verticalStackView)
        self.view.addSubview(changePhoneButton)
        self.verticalStackView.addArrangedSubview(imageViewContainer)
        self.verticalStackView.addSpace(Appearance.labelTopSpace)
        self.verticalStackView.addArrangedSubview(regWasLabel)
        self.verticalStackView.addSpace(Appearance.labelBottomSpace)
        self.verticalStackView.addArrangedSubview(continueButton)
        self.verticalStackView.addArrangedSubview(restartButton)
        imageViewContainer.addSubview(officeImageView)
    }

    func makeConstraints() {
        self.logoImageView.snp.makeConstraints { maker in
            maker.height.equalTo(Appearance.logoHeight)
            maker.width.equalTo(Appearance.logoWidth)
            maker.top.equalToSuperview().offset(Appearance.logoTop + minTopYOffset)
            maker.centerX.equalToSuperview()
        }

        self.verticalStackView.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(Appearance.stackHoriznontalMargin)
            maker.leading.equalToSuperview().inset(Appearance.stackHoriznontalMargin)
            maker.centerY.equalToSuperview()
            maker.top.greaterThanOrEqualToSuperview().inset(Appearance.stackVerticalMargin)
            maker.bottom.lessThanOrEqualToSuperview().inset(Appearance.stackVerticalMargin)
        }

        self.officeImageView.snp.makeConstraints { maker in
            maker.height.equalTo(Appearance.officeImageHeight).priority(ConstraintPriority(999))
            maker.width.equalTo(Appearance.officeImageWidth)
            maker.centerX.equalToSuperview()
            maker.top.bottom.equalToSuperview()
        }

        self.continueButton.snp.makeConstraints { maker in
            maker.height.equalTo(Appearance.middleButtonHeight)
        }

        self.restartButton.snp.makeConstraints { maker in
            maker.height.equalTo(Appearance.middleButtonHeight)
        }

        self.changePhoneButton.snp.makeConstraints { maker in
            maker.height.equalTo(Appearance.changePhoneButtonHeight)
            maker.width.equalTo(Appearance.changePhoneButtonWidth)
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().inset(Appearance.changePhoneButtonBottom + minBottomYOffset)
        }
    }

    // MARK: - BUTTON ACTIONS
    @objc func continueButtonTap() {
        presenter.continueRegistration()
    }
    @objc func restartButtonTap() {
        presenter.restartRegistration()
    }
    @objc func changePhoneButtonTap() {
        presenter.changePhone()
    }
}

private extension UIStackView {
    func addSpace(_ space: CGFloat, afterView: UIView? = nil) {
        guard abs(space - self.spacing) > 0.1 else { return }

        if #available(iOS 11.0, *) {
            if let afterV = afterView {
                self.setCustomSpacing(space, after: afterV)
            } else if let lastView = self.arrangedSubviews.last {
                self.setCustomSpacing(space, after: lastView)
            } // не обработан кейс когда у нас 0 вьюх и хотим space
        } else {
            let spacingView = UIView(frame: .zero)
            spacingView.backgroundColor = .clear
            spacingView.snp.makeConstraints { (make) in make.height.equalTo(space - self.spacing) }

            var index = arrangedSubviews.count
            if let afterV = afterView, let viewIndex = arrangedSubviews.firstIndex(of: afterV) {
                index = viewIndex
            }
            self.insertArrangedSubview(spacingView, at: index)
        }
    }
}

extension RegWasStartedViewController: RegWasStartedViewInput {
    func startAnimating() {
        self.showActivityIndicator()
    }

    func stopAnimating() {
        self.hideActivityIndicator()
    }
    func setCompanyName(_ name: String) {
        self.regWasLabel.text = String(format: Texts.regWasLabelTextFormat, name)
        self.regWasLabel.setNeedsLayout()
    }
}
