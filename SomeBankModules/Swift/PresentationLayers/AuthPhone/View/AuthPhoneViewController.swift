import UIKit
import SnapKit

extension AuthPhoneViewController {
    private struct Appearance {
        // margins for left/right trailing/leading
        static let horizontalMargin: CGFloat = 40.0
        // title
        static let titleColor: UIColor = UIColor.graphite1
        static let titleFont: UIFont = UIFont.bold20
        static let titleTopMargin: CGFloat = 76.0
        static let titleHeight: CGFloat = 24.0

        //phone text view
        static let phoneHorizontalMargin: CGFloat = 20.0
        static let phonePlaceholerColor = UIColor.graphite4
        static let phoneTextColor = UIColor.graphite1
        static let phoneTopMargin: CGFloat = 24.0
        static let phoneHeight: CGFloat = 60.0

        // hint under phone
        static let hintColor: UIColor = UIColor.graphite3
        static let hintFont: UIFont = UIFont.regular13
        static let hintTopMargin: CGFloat = 24.0
        static let hintHeight: CGFloat = 56.0

        // become client
        static let becomeClientButtonWidth: CGFloat = 200.0
        static let becomeClientButtonHeight: CGFloat = 32.0
        static let becomeClientTopMargin: CGFloat = 24.0
        static let becomeClientColor = UIColor.blue2
        static let becomeClientFont = UIFont.medium16

        // enter bank
        static let enterBankButtonHeight: CGFloat = 80.0
    }

    private struct Texts {
        static let title = "Добро пожаловать"
        static let placeholder = "Мобильный телефон"
        static let hint = "Введите свой номер телефона, чтобы войти или зарегистрироваться"
        static let becomeClientTitle = "СТАТЬ КЛИЕНТОМ"
        static let enterBank = "ВОЙТИ В БАНК"
        static let phoneErrorText = "Чтобы зарегистрироваться введите ваш номер телефона."
    }
}

final class AuthPhoneViewController: BaseViewController {

    var bottomButtonConstraint: Constraint!
    var bottomOffset: CGFloat = 0.0
    var bottomMinYOffset: CGFloat = 20.0
    var topMinYOffset: CGFloat = 0.0

    var presenter: AuthPhoneViewOutput!

    var enteredPhone: String = "" {
        didSet {
            let enable: Bool = enteredPhone.count == 10
            if enable {
                self.enterBankButtonView.enableButton()
            } else {
                self.enterBankButtonView.disableButton()
            }
        }
    }

    // MARK: - views

    /// Label сверху
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.title
        label.textColor = Appearance.titleColor
        label.font = Appearance.titleFont
        label.sizeToFit()
        return label
    }()

    private lazy var formatter: AuthPhoneFieldFormatter = {
        let formatter = AuthPhoneFieldFormatter()
        formatter.maskString = AuthPhoneFieldFormatter.phoneMask()
        return formatter
    }()

    /// текст телефона - Text + placeholder
    private lazy var phoneTextField: TippedTextFieldWithBottomLine = {
        var phoneTextField = TippedTextFieldWithBottomLine(with: Texts.placeholder)
        phoneTextField.backgroundColor = .white
        phoneTextField.setKeyboard(.numberPad)
//        phoneTextField.textField.clearButtonMode = UITextField.ViewMode.whileEditing
//        phoneTextField.setError("Укажите 10 цифр номера мобильного телефона")
        phoneTextField.formatter = self.formatter
        phoneTextField.delegate = self

        return phoneTextField
    }()

    /// подсказка
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.hint
        label.textColor = Appearance.hintColor
        label.font = Appearance.hintFont
        label.numberOfLines = 2
        label.sizeToFit()
        return label
    }()

    //??? разве нет свифтового компонента "синяя кнопка"?
    /// кнопка в середине ?? кнопка с текстом ?
    private lazy var becomeClientButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Texts.becomeClientTitle, for: .normal)
        button.titleLabel?.font = Appearance.becomeClientFont
        button.setTitleColor(Appearance.becomeClientColor, for: .normal)
        button.addTarget(self, action: #selector(becomeClientButtonTapAction(_:)), for: .touchUpInside)
        return button
    }()

    /// кнопка снизу - ВОЙТИ В БАНК
    private lazy var enterBankButtonView: MBBlueButtonView = {
        let buttonView = MBBlueButtonView(gradient: .white)
        buttonView.button.setTitle(Texts.enterBank, for: .normal)
        buttonView.button.addTarget(self, action: #selector(enterBankButtonTapAction(_:)), for: .touchUpInside)
        return buttonView
    }()

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView.init()
        return scroll
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AuthPhoneViewController.tapAction))
        self.view.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.navigationController?.setNavigationBarHidden(true, animated: false)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        if #available(iOS 11.0, *) {} else {
            makeConstraints()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        if let phone = MBUserDefaultsManager.userPhone(), let text = self.phoneTextField.textField.text {
            let range = NSRange(text.startIndex..., in: text)
            formatter.applyFormatting(to: self.phoneTextField.textField, with: phone, in: range) { [weak self] formattedString in
                self?.phoneTextField.setText(formattedString)
                self?.enteredPhone = phone
            }
        } else {
            self.phoneTextField.setText("+7 ")
            self.enteredPhone = ""
        }
        self.phoneTextField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11, *) {
            super.viewSafeAreaInsetsDidChange()
            print("safeAreaInsets - \(self.view.safeAreaInsets)")

            topMinYOffset = self.view.safeAreaInsets.top
            bottomMinYOffset = self.view.safeAreaInsets.bottom
            bottomOffset = self.view.safeAreaInsets.bottom

            makeConstraints()

            bottomButtonConstraint.update(inset: bottomOffset)
            self.view.layoutIfNeeded()
        }
    }

    func addSubviews() {

        view.addSubview(scrollView)
        scrollView.addSubview(self.titleLabel)
        scrollView.addSubview(self.phoneTextField)
        scrollView.addSubview(self.hintLabel)
        scrollView.addSubview(self.becomeClientButton)
        view.addSubview(self.enterBankButtonView)
        enterBankButtonView.disableButton()
    }

    func makeConstraints() {
        self.titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(Appearance.horizontalMargin)
            make.height.equalTo(Appearance.titleHeight)
            make.top.equalToSuperview().offset(Appearance.titleTopMargin + topMinYOffset)
        }
        self.phoneTextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(Appearance.phoneHorizontalMargin)
            make.height.equalTo(Appearance.phoneHeight)
            make.top.equalTo(titleLabel.snp.bottom).offset(Appearance.phoneTopMargin)
        }
        self.hintLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(Appearance.horizontalMargin)
            make.height.equalTo(Appearance.phoneHeight)
            make.top.equalTo(phoneTextField.snp.bottom)
        }
        self.becomeClientButton.snp.makeConstraints { (make) in
            make.width.equalTo(Appearance.becomeClientButtonWidth)
            make.height.equalTo(Appearance.becomeClientButtonHeight)
            make.centerX.equalTo(self.view)
            make.top.equalTo(hintLabel.snp.bottom).offset(Appearance.becomeClientTopMargin)
            make.bottom.equalToSuperview()
        }
        self.enterBankButtonView.snp.makeConstraints { (make) -> Void in
            self.bottomButtonConstraint = make.bottom.equalTo(self.view.snp.bottomMargin).inset(self.bottomOffset).constraint
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Appearance.enterBankButtonHeight)
            make.width.equalTo(self.view)
        }

        scrollView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(enterBankButtonView.snp.top)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    // MARK: - Buttons methods
    @objc private func becomeClientButtonTapAction(_ sender: UIButton) {
        phoneTextField.resignFirstResponder()

        //done: показ крутилки и дёргание presenter с Phone -> дёрганье Interctor с Phones
        self.presenter.becomeClient(enteredPhone)
    }

    @objc private func enterBankButtonTapAction(_ sender: UIButton) {
        phoneTextField.resignFirstResponder()
        self.presenter.enterBank(enteredPhone)
    }

    @objc func tapAction() {
        view.endEditing(true)
    }

    // MARK: - Keyboard related methods
    private enum KeyboardMoveType {
        case show
        case hide
        case changeFrame
    }

    @objc private func keyboardWillShow(_ notification: Notification?) {
        print("Keyboard Notification - keyboardWillShow \n\(String(describing: notification))")
        updateOffset(notification, moveType: .show)
    }

    @objc private func keyboardWillHide(_ notification: Notification?) {
        print("Keyboard Notification - keyboardWillHide \n\(String(describing: notification))")
        updateOffset(notification, moveType: .hide)
    }

    @objc private func keyboardWillChangeFrame(_ notification: Notification?) {
        print("Keyboard Notification - keyboardWillChangeFrame \n\(String(describing: notification))")
        updateOffset(notification, moveType: .changeFrame)
    }

    private func updateOffset(_ notification: Notification?, moveType: KeyboardMoveType) { //made function for updating offset from Notification
        if let userInfo = notification?.userInfo {
            if let rectEndVal = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
                let animationDurationVal = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber {
                var heightEnd: CGFloat = bottomMinYOffset
                if moveType != KeyboardMoveType.hide {
                    heightEnd = rectEndVal.cgRectValue.size.height - bottomMinYOffset
                }
                print("Keyboard Notification - from - \(bottomOffset) to - \(heightEnd), duration = \(animationDurationVal)\n\n\n")
                if abs(bottomOffset - heightEnd) > 0.1 && animationDurationVal.doubleValue > 0.05 { //removed unneeded animation - (currentOffset - needed) - no update(offset;
                    UIView.animate(withDuration: animationDurationVal.doubleValue) {
                        self.bottomButtonConstraint.update(inset: heightEnd)
                        self.view.layoutIfNeeded()
                    }
                } else if abs(bottomOffset - heightEnd) > 0.1 { //if animationDurationVal < 0.05 - just updating offset
                    self.bottomButtonConstraint.update(inset: heightEnd)
                }
                bottomOffset = heightEnd
            }
        }
    }
}

extension AuthPhoneViewController: TippedTextFieldWithBottomLineDelegateProtocol {
    func willReturnButtonTapped(_ control: TippedTextFieldWithBottomLine) {

    }
    func textValueChanged(_ control: TippedTextFieldWithBottomLine, on value: String) {
        var phone = value.components(separatedBy: CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "+")).inverted).joined()
        if phone.hasPrefix("+7") { phone.removeFirst(2) }
        print("entered phone - \(phone)")
        self.enteredPhone = phone
    }
    func shouldBeginEditing(_ control: TippedTextFieldWithBottomLine) -> Bool {
        return true
    }

}

extension AuthPhoneViewController: AuthPhoneViewInput {
    func showActivity() {
        self.showActivityIndicator()
    }

    func hideActivity() {
        self.hideActivityIndicator()
    }
}
