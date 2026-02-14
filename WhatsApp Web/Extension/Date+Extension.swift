//
//  Date+Extension.swift
//  WhatsApp Web
//
//  Created by mac on 13/06/24.
//

import Foundation

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
