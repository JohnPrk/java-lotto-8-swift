//
//  LottoInputParser.swift
//  lotto-swift
//
//  Created by john on 11/18/25.
//

// LottoInputParser.swift

import Foundation

struct LottoInputParser {
    
    func parsePurchaseAmount(_ text: String?) throws -> (amount: Int, money: Money, lottoCount: Int) {
        let amount = try InputValidator.parsePurchaseAmount(text)
        let money = try Money(amount: amount)
        let lottoCount = money.lottoCount
        return (amount, money, lottoCount)
    }
    
    func parseWinningNumbers(_ text: String?) throws -> Lotto {
        let nums = try InputValidator.parseWinningNumbers(text)
        return try Lotto(numbers: nums)
    }
    
    func parseBonusNumber(_ text: String?, winningLotto: Lotto) throws -> (bonus: BonusNumber, winning: WinningLotto) {
        let n = try InputValidator.parseBonusNumber(text)
        let bonus = try BonusNumber(n, notIn: winningLotto)
        let winning = try WinningLotto(lotto: winningLotto, bonusNumber: bonus)
        return (bonus, winning)
    }
}
