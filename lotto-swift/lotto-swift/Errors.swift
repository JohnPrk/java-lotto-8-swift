//
//  Errors.swift
//  lotto-swift
//
//  Created by john on 11/10/25.
//

// Errors.swift

import Foundation

enum InputError: LocalizedError {
    case blank
    case notNumber

    var errorDescription: String? {
        switch self {
        case .blank:
            return "[ERROR] 입력은 비어 있을 수 없습니다."
        case .notNumber:
            return "[ERROR] 구입 금액은 숫자여야 합니다."
        }
    }
}

enum MoneyError: LocalizedError {
    case notPositive
    case notUnit

    var errorDescription: String? {
        switch self {
        case .notPositive:
            return "[ERROR] 구입 금액은 0보다 커야 합니다."
        case .notUnit:
            return "[ERROR] 1,000원 단위로 입력해 주세요."
        }
    }
}
