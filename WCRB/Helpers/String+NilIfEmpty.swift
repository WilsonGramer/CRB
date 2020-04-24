//  String+NilIfEmpty.swift - WCRB

import Foundation

extension String {
    var nilIfEmpty: String? {
        self.isEmpty ? nil : self
    }
}
