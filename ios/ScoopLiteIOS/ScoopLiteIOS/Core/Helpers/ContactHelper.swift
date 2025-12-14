import Foundation
import PhoneNumberKit

/// Helper for phone number validation.
/// Matches the main YorNest app's ContactHelper.swift
final class ContactHelper {
    
    static let shared = ContactHelper()
    
    private let phoneNumberKit = PhoneNumberKit()
    
    func isPhoneNumberValid(_ phoneNumberString: String) -> Bool {
        do {
            let phoneNumber = try phoneNumberKit.parse(phoneNumberString, ignoreType: true)
            let formattedPhoneNumber = phoneNumberKit.format(phoneNumber, toType: .e164)
            print("Phone number is valid: \(formattedPhoneNumber)")
            return true
        } catch let error {
            print("Invalid phone number: \(error)")
            return false
        }
    }
}

