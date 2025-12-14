import Foundation
import UIKit

extension UILabel {
    
    /// Applies underline styling to a subtext within the label's text
    /// - Parameters:
    ///   - text: The full text of the label
    ///   - subtext: The portion of text to underline
    ///   - color: The color for the underlined text
    ///   - font: The font for the underlined text
    func setUnderline(
        with text: String,
        subtext: String,
        color: UIColor,
        font: UIFont
    ) {
        let descriptionAttributed = NSMutableAttributedString(string: text)
        let subtextRange = (text as NSString).range(of: subtext)
        descriptionAttributed.addAttributes([
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: color,
            .font: font,
        ], range: subtextRange)
        self.attributedText = descriptionAttributed
        self.textAlignment = .center
    }
}

