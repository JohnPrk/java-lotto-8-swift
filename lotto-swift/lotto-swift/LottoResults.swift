//
//  LottoResults.swift
//  lotto-swift
//
//  Created by john on 11/15/25.
//

// LottoResults.swift

import Foundation

struct LottoResults {

    private(set) var results: [LottoRank: Int] = [:]
    private(set) var totalPrize: Int = 0

    init(lottos: [Lotto], winningNumbers: WinningLotto) {
        for lotto in lottos {
            let rank = LottoResults.toRank(lotto: lotto, winningNumbers: winningNumbers)
            results[rank, default: 0] += 1
            totalPrize += rank.prize
        }
    }

    func count(of rank: LottoRank) -> Int {
        return results[rank] ?? 0
    }

    func calculateYield(purchaseAmount: Int) -> Double {
        guard purchaseAmount > 0 else { return 0 }
        return Double(totalPrize) / Double(purchaseAmount)
    }

    private static func toRank(lotto: Lotto, winningNumbers: WinningLotto) -> LottoRank {
        let matchCount = winningNumbers.countMatchingNumbers(lotto)
        let bonusMatched = winningNumbers.containsBonusNumber(lotto)
        return LottoRank.from(matchCount: matchCount, bonusMatched: bonusMatched)
    }
}
