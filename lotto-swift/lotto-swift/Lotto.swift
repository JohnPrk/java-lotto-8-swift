//
//  Lotto.swift
//  lotto-swift
//
//  Created by john on 11/12/25.
//

// Lotto.swift

import Foundation

struct Lotto {
    private static let lottoSize = 6
    private static let minNumber = 1
    private static let maxNumber = 45

    let numbers: [Int]

    init(numbers: [Int]) throws {
        try Lotto.validateCount(numbers)
        try Lotto.validateRange(numbers)
        try Lotto.validateDuplicate(numbers)
        self.numbers = numbers.sorted()
    }

    func getNumbers() -> [Int] {
        return numbers
    }

    private static func validateCount(_ numbers: [Int]) throws {
        if numbers.count != lottoSize {
            throw LottoError.invalidCount
        }
    }

    private static func validateRange(_ numbers: [Int]) throws {
        for number in numbers {
            if number < minNumber || number > maxNumber {
                throw LottoError.outOfRange
            }
        }
    }

    private static func validateDuplicate(_ numbers: [Int]) throws {
        let unique = Set(numbers)
        if unique.count != lottoSize {
            throw LottoError.duplicated
        }
    }
}
