//
//  Date.swift
//  LibraryApp
//
//  Created by Edbert Chandradinata on 30/12/24.
//

import SwiftUI

class DateHelper {
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"  // Default format for API
        return formatter.string(from: date)
    }
}
