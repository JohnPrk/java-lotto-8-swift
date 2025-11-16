//
//  WinningLotto.swift
//  lotto-swift
//
//  Created by john on 11/15/25.
//

struct WinningLotto {
    
    let lotto: Lotto
    let bonus: BonusNumber
    
    init(lotto: Lotto, bonusNumber: BonusNumber) throws {
            self.lotto = lotto
            self.bonus = bonusNumber
        }

        func countMatchingNumbers(_ lotto: Lotto) -> Int {
            return self.lotto.countMatchingNumbers(with: lotto)
        }

        func containsBonusNumber(_ lotto: Lotto) -> Bool {
            return lotto.containsNumber(bonus.value)
        }
}
