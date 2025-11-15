//
//  InputValidator.swift
//  lotto-swift
//
//  Created by john on 11/10/25.
//

// InputValidator.swift

import Foundation

struct InputValidator {

    static func parsePurchaseAmount(_ input: String?) throws -> Int {
        let trimmed = input?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !trimmed.isEmpty else {
            throw InputParseError.empty
        }
        guard let value = Int(trimmed) else {
            throw InputParseError.notNumber
        }
        return value
    }

    static func parseWinningNumbers(_ text: String?) throws -> [Int] {
        let raw = text ?? ""
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw WinningLottoError.empty
        }
        if trimmed.contains(where: { $0.isWhitespace }) {
            throw WinningLottoError.whitespaceIncluded
        }
        let normalized = trimmed.replacingOccurrences(of: "，", with: ",")
        let pattern = #"^[0-9]+(,[0-9]+){5}$"#
        guard normalized.range(of: pattern, options: .regularExpression) != nil else {
            throw WinningLottoError.winningFormat
        }
        let parts = normalized.split(separator: ",")
        let nums = parts.compactMap { Int($0) }
        guard nums.count == 6 else {
            throw WinningLottoError.winningFormat
        }
        return nums
    }

    static func parseBonusNumber(_ text: String?) throws -> Int {
        let raw = text ?? ""
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw InputParseError.empty
        }
        if trimmed.contains(where: { $0.isWhitespace }) {
            throw InputParseError.whitespaceIncluded
        }
        let pattern = #"^[0-9]+$"#
        guard trimmed.range(of: pattern, options: .regularExpression) != nil,
              let n = Int(trimmed) else {
            throw WinningLottoError.singleNumberFormat
        }
        return n
    }
}
