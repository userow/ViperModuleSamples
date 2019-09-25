//
//  AuthPhoneTextFieldFormatter.swift
//
//
//  Created by Paul Vasilenko on 21/08/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import InputMask

class AuthPhoneFieldFormatter: NSObject, StepTextFieldFormatProviderProtocol {

    var maxLength: Int = 0
    var maskString: String? = nil {
        didSet {
            guard let maskValue = self.maskString else {
                return
            }
            self.mask = try? Mask.getOrCreate(withFormat: maskValue)
        }
    }
    private(set) var mask: Mask?

    @discardableResult func applyFormatting(to textField: UITextField,
                                            with replacementString: String,
                                            in range: NSRange,
                                            completion: (String) -> Void) -> Bool {
        guard let text = textField.text, let textRange = Range(range, in: text) else {
            return true
        }
        var formattedText = text.replacingCharacters(in: textRange, with: replacementString)
        if let mask = self.mask {
            var offset = textField.cursorPosition
            let caretString = CaretString(string: formattedText)
            let result = mask.apply(toText: caretString)
            formattedText = result.formattedText.string
            textField.text = formattedText
            let deltaLengths = formattedText.count - text.count
            offset += deltaLengths
            if let newPosition = textField.position(from: textField.beginningOfDocument, offset: offset) {
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
            completion(formattedText)
            return false
        }
        completion(formattedText)
        return true
    }

}

extension AuthPhoneFieldFormatter {
    static func phoneMask() -> String {
        return "+7 ([000]) [000] [00] [00]"
    }
}
