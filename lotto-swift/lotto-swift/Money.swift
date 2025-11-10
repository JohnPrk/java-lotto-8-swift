//
//  Money.swift
//  lotto-swift
//
//  Created by john on 11/10/25.
//

struct Money {
    private static let unitMoneyForBuyLotto = 1000
    let amount: Int

    init(amount: Int) throws {
        try Money.validatePositive(amount)
        try Money.validateUnit(amount)
        self.amount = amount
    }

    private static func validatePositive(_ amount: Int) throws {
        if amount <= 0 {
            throw MoneyError.notPositive
        }
    }

    private static func validateUnit(_ amount: Int) throws {
        if amount % unitMoneyForBuyLotto != 0 {
            throw MoneyError.notUnit
        }
    }

    var lottoCount: Int {
        return amount / Money.unitMoneyForBuyLotto
    }
}
