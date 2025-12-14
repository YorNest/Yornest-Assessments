import Foundation
import UIKit
import DialCountries

// MARK: - State

enum EnterPhoneState: BaseState {
    case setupCountry(String, String)  // flag emoji, dial code
    case updateNextButton(Bool)
}

// MARK: - Event

enum EnterPhoneEvent: BaseEvent {
    case updateColorForDialLabel(Bool)
    case updateAgreement(Bool)
    case showConfirmPhoneNumber(String?, String?)
    case showTermsPolicy(Bool)
    case showCountries
    case error
    case internetError
    case errorManyRequest(Closure<Bool>?)
    case showHelpAndFeedback
    case errorPleaseContact
}

// MARK: - Presenter

/// Handles phone number entry and authentication request.
/// Matches main YorNest app's EnterPhoneViewPresenter.
final class EnterPhoneViewPresenter: BasePresenter<EnterPhoneState, EnterPhoneEvent> {

    // MARK: Properties

    private var authService: AuthServiceProtocol
    private var dialCode: String?
    private var checkEnable = false
    private var nextButtonEnable = false

    private var signInTask: Task<Void, Never>?

    // MARK: Init

    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }

    // MARK: Methods

    override func loaded() {

    }

    func signIn(_ number: String) {
        UserManager.shared.session = nil
        let formattedNumber = format(phone: number, maskNeeded: false)
        guard let fullNumber = dialCode?.appending(formattedNumber) else { return }
        signInTask?.cancel()
        signInTask = Task { [weak self] in
            guard let strongSelf = self else { return }
            do {
                let model = AuthenticateUserRequestModel(mobileNumber: fullNumber)
                let result = try await strongSelf.authService.authenticateUser(model: model)

                guard Task.isCancelled == false else { return }

                UserManager.shared.userId = result.userId ?? ""
                await strongSelf.emitMainActorEvent(.showConfirmPhoneNumber(result.session, fullNumber))
            } catch {
                switch error.localizedDescription {
                case RequestAPIError.authorizationError.localizedDescription:
                    break
                case RequestAPIError.notApproved.localizedDescription, RequestAPIError.incorrectRestrictError.localizedDescription:
                    let closeCompletion: Closure<Bool>? = { [weak strongSelf] success in
                        guard success else { return }
                        strongSelf?.emitEvent(.showHelpAndFeedback)
                    }
                    await strongSelf.emitMainActorEvent(.errorManyRequest(closeCompletion))
                case RequestAPIError.internetError.localizedDescription:
                    await strongSelf.emitMainActorEvent(.internetError)
                default:
                    await strongSelf.emitMainActorEvent(.error)
                }
            }
        }
    }

    func updateCountry(_ flag: String, _ dialCode: String) {
        self.dialCode = dialCode
        updateState(.setupCountry(flag, dialCode))
    }

    func shouldChange(_ textField: UITextField, _ range: NSRange, _ string: String) -> Bool {
        guard let text = textField.text, let textRange = Range(range, in: text) else {
            return false
        }
        if string.count > 2 {
            let updatedString = string.replacingOccurrences(of: dialCode ?? "", with: "")
            textField.text = format(phone: updatedString, maskNeeded: true)
            let newText = dialCode?.appending(updatedString)
            if ContactHelper.shared.isPhoneNumberValid(newText ?? "") {
                nextButtonEnable = true
            } else {
                nextButtonEnable = false
            }
            checkEnabled()
            updateColorForDialLabel(newText?.isEmpty ?? true)
            return false
        }
        let newString = text.replacingCharacters(in: textRange, with: string)
        textField.text = format(phone: newString, maskNeeded: true)
        let newText = dialCode?.appending(textField.text ?? "")
        if ContactHelper.shared.isPhoneNumberValid(newText ?? "") {
            nextButtonEnable = true
        } else {
            nextButtonEnable = false
        }
        checkEnabled()
        updateColorForDialLabel(textField.text?.isEmpty ?? true)
        return false
    }

    func setupCurrentCountry() {
        let flag = Country.getCurrentCountry()?.flag
        let dialCode = Country.getCurrentCountry()?.dialCode
        self.dialCode = dialCode
        updateState(.setupCountry(flag ?? "", dialCode ?? ""))
    }

    func updateAgreement() {
        checkEnable.toggle()
        checkEnabled()
        emitEvent(.updateAgreement(checkEnable))
    }

    func checkEnabled() {
        if checkEnable && nextButtonEnable {
            updateState(.updateNextButton(true))
        } else {
            updateState(.updateNextButton(false))
        }
    }

    func showCountries() {
        emitEvent(.showCountries)
    }

    func showTermsPolicy(isPrivacy: Bool) {
        emitEvent(.showTermsPolicy(isPrivacy))
    }

    private func format(phone: String, maskNeeded: Bool) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""

        result += " "

        if maskNeeded {
            for (index, char) in numbers.enumerated() {
                if index == 6 {
                    result += "-"
                } else if index > 0 && index == 3 && index < numbers.count {
                    result += " "
                }
                result.append(char)
            }
            return result
        } else {
            return numbers
        }
    }

    private func updateColorForDialLabel(_ isEmpty: Bool) {
        emitEvent(.updateColorForDialLabel(isEmpty))
    }
}

