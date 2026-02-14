//
//  EmojiTextField.swift
//  WhatsApp Web
//
//  Created by mac on 19/06/24.
//

import Foundation
import UIKit

// MARK: - Emoji Text Field

class EmojiTextField: UITextField {
    
    private var shouldShowCutCopy: Bool = false
    
    override var textInputContextIdentifier: String? { "" }
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
    
    override func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        if action == #selector(paste(_:)) {
            return nil
        }
        return super.target(forAction: action, withSender: sender)
    }
}
