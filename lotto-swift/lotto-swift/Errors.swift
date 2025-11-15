//
//  Errors.swift
//  lotto-swift
//
//  Created by john on 11/10/25.
//

// Errors.swift

import Foundation

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

enum LottoError: LocalizedError {
    case invalidCount
    case outOfRange
    case duplicated

    var errorDescription: String? {
        switch self {
        case .invalidCount:
            return "[ERROR] 로또 번호는 6개여야 합니다."
        case .outOfRange:
            return "[ERROR] 로또 번호는 1부터 45 사이여야 합니다."
        case .duplicated:
            return "[ERROR] 로또 번호는 중복될 수 없습니다."
        }
    }
}

enum LottoGeneratorError: LocalizedError {
    case invalidCount

    var errorDescription: String? {
        switch self {
        case .invalidCount:
            return "[ERROR] 로또 생성 개수는 1개 이상이어야 합니다."
        }
    }
}

enum InputParseError: LocalizedError {
    case empty
    case notNumber
    case whitespaceIncluded

    var errorDescription: String? {
        switch self {
        case .empty: return "[ERROR] 입력은 비어 있을 수 없습니다."
        case .notNumber: return "[ERROR] 숫자만 입력해 주세요."
        case .whitespaceIncluded: return "[ERROR] 공백 없이 입력해 주세요. 예) 7"
        }
    }
}

enum WinningLottoError: LocalizedError {
    case empty
    case whitespaceIncluded
    case winningFormat
    case singleNumberFormat

    var errorDescription: String? {
        switch self {
        case .empty:
            return "[ERROR] 입력은 비어 있을 수 없습니다."
        case .whitespaceIncluded:
            return "[ERROR] 공백 없이 입력해 주세요. 예) 1,2,3,4,5,6"
        case .winningFormat:
            return "[ERROR] 형식이 올바르지 않습니다. 예) 1,2,3,4,5,6 처럼 숫자 6개를 콤마로 구분해 주세요."
        case .singleNumberFormat:
            return "[ERROR] 보너스 번호는 숫자 하나만 입력해 주세요. 예) 7"
        }
    }
}

enum BonusError: LocalizedError {
    case overlap
    case outOfRange
    var errorDescription: String? {
        switch self {
        case .overlap: return "[ERROR] 보너스 번호는 당첨 번호와 중복될 수 없습니다."
        case .outOfRange: return "[ERROR] 보너스 번호는 1부터 45 사이여야 합니다."
        }
    }
}
