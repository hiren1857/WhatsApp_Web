//
//  TextField.swift
//  WhatsApp Web
//
//  Created by mac on 24/06/24.
//

import Foundation
import UIKit

class NoPasteTextField: UITextField {
    
    override func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        if action == #selector(paste(_:)) {
            return nil
        }
        return super.target(forAction: action, withSender: sender)
    }
    
}
