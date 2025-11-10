//
//  InputValidator.swift
//  lotto-swift
//
//  Created by john on 11/10/25.
//

import Foundation

struct InputValidator {

    static func parsePurchaseAmount(_ input: String?) throws -> Int {
        guard let input = input, !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw InputError.blank
        }
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let value = Int(trimmed) else {
            throw InputError.notNumber
        }
        return value
    }
}
