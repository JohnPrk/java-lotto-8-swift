//
//  WinningLottoAndBonusNumber.swift
//  lotto-swift
//
//  Created by john on 11/14/25.

struct BonusNumber: Equatable {
    private static let minNumber = 1
    private static let maxNumber = 45

    let value: Int
    init(_ value: Int, notIn lotto: Lotto) throws {
        guard (BonusNumber.minNumber...BonusNumber.maxNumber).contains(value)
        else { throw BonusError.outOfRange }
        guard lotto.getNumbers().contains(value) == false
        else { throw BonusError.overlap }
        self.value = value
    }
}
