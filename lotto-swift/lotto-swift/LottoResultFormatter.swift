//
//  LottoResultFormatter.swift
//  lotto-swift
//
//  Created by john on 11/18/25.
//

// LottoResultFormatter.swift

import Foundation

struct LottoResultFormatter {
    
    func ticketsText(from lottos: [Lotto]) -> String {
        return lottos
            .map { lotto in
                let nums = lotto.getNumbers()
                    .map { String($0) }
                    .joined(separator: ", ")
                return "[\(nums)]"
            }
            .joined(separator: "\n")
    }
    
    func summary(from results: LottoResults, purchaseAmount: Int) -> (summaryText: String, yieldText: String) {
        let fifth  = results.count(of: .fifth)
        let fourth = results.count(of: .fourth)
        let third  = results.count(of: .third)
        let second = results.count(of: .second)
        let first  = results.count(of: .first)
        
        let lines: [String] = [
            "3개 일치 (5,000원) - \(fifth)개",
            "4개 일치 (50,000원) - \(fourth)개",
            "5개 일치 (1,500,000원) - \(third)개",
            "5개 일치, 보너스 볼 일치 (30,000,000원) - \(second)개",
            "6개 일치 (2,000,000,000원) - \(first)개"
        ]
        
        let summaryText = lines.joined(separator: "\n")
        let yieldValue = results.calculateYield(purchaseAmount: purchaseAmount)
        let yieldText = String(format: "%.1f", yieldValue)
        
        return (summaryText, yieldText)
    }
    
    func finalResultText(summaryText: String, yieldText: String) -> String {
        return """
        당첨 통계
        ---
        \(summaryText)
        총 수익률은 \(yieldText)% 입니다.
        """
    }
}
