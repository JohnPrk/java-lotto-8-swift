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
