//
//  OfficialLottoResult.swift
//  lotto-swift
//
//  Created by john on 11/23/25.
//

import Foundation

struct OfficialLottoResult {
    let round: Int
    let date: String
    let winningNumbers: [Int]
    let bonusNumber: Int
    let totalSalesAmount: Int64
    let firstPrizeAmount: Int64
    let firstPrizeWinners: Int
    
    let prizePerRank: [Int: Int64]
    let winnersPerRank: [Int: Int]
}
