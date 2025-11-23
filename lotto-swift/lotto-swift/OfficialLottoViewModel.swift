//
//  OfficialLottoViewModel.swift
//  lotto-swift
//
//  Created by john on 11/23/25.
//

import Foundation

final class OfficialLottoViewModel {
    
    private let crawler = LottoCrawler()
    private let generator = RandomLottoGenerator()
    
    private var purchasedLottos: [Lotto] = []
    private var purchaseAmount: Int = 0
    
    var onUpdateResultLabel: ((String) -> Void)?
    var onUpdateLottoTickets: ((String) -> Void)?
    var onShowRoundInput: (() -> Void)?
    var onShowFinalResult: ((String) -> Void)?
    var onShowAlert: ((String) -> Void)?
    
    func purchaseAmount(amountText: String?) {
        guard let text = amountText,
              let amount = Int(text),
              amount >= 1000,
              amount.isMultiple(of: 1000) else {
            onShowAlert?("1000원 단위로 입력해 주세요.")
            return
        }
        self.purchaseAmount = amount
        let count = amount / 1000
        do {
            purchasedLottos = try generator.generate(count: count)
            let ticketsText = purchasedLottos
                .map { "[\($0.numbers.map(String.init).joined(separator: ", "))]" }
                .joined(separator: "\n")
            onUpdateResultLabel?("\(count)개를 구매했습니다.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.onUpdateLottoTickets?(ticketsText)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    self.onShowRoundInput?()
                }
            }
        } catch {
            onShowAlert?("로또 생성 실패")
        }
    }
    
    func fetchOfficialResult(roundText: String?) {
        guard let roundStr = roundText?.trimmingCharacters(in: .whitespaces),
              let round = Int(roundStr),
              (1...1200).contains(round) else {
            onShowAlert?("1~1200 사이의 회차를 입력해 주세요.")
            return
        }
        
        Task { @MainActor in
            do {
                let official = try await self.crawler.fetchResult(for: round)
                let mainLotto = try Lotto(numbers: official.winningNumbers.sorted())
                let winningLotto = try WinningLotto(
                    lotto: mainLotto,
                    bonusNumber: try BonusNumber(official.bonusNumber, notIn: mainLotto)
                )
                let results = LottoResults(lottos: self.purchasedLottos, winningNumbers: winningLotto)
                let myTotalPrize = results.totalPrize
                let yield = results.calculateYield(purchaseAmount: self.purchaseAmount)
                let winningNumsStr = official.winningNumbers.sorted().map(String.init).joined(separator: ", ")
                let totalWinners = official.winnersPerRank.values.reduce(0, +)
                let averagePrize = totalWinners > 0 ? Double(official.totalSalesAmount) / Double(totalWinners) : 0
                var totalPrizeMoney: Int64 = 0
                for rank in 1...5 {
                    let w = Int64(official.winnersPerRank[rank] ?? 0)
                    let p = official.prizePerRank[rank] ?? 0
                    totalPrizeMoney += w * p
                }
                let totalYield = official.totalSalesAmount > 0 ? (Double(totalPrizeMoney) / Double(official.totalSalesAmount)) * 100.0 : 0.0
                let finalText = """
                🎰 \(official.round)회차 결과 (\(official.date))
                ──────────────────────────────────
                ★ 당첨 번호 ★
                \(winningNumsStr) + 보너스 [\(official.bonusNumber)]
                ──────────────────────────────────

                [ 🙋‍♂️ 나의 결과 ]
                \(self.formatMyResults(results))

                💰 총 당첨금: \(myTotalPrize.formattedWithComma())원
                📈 수익률: \(String(format: "%.1f", yield))%
                🍀 운지수: \(self.luckIndex(myPrize: myTotalPrize, average: averagePrize))

                ──────────────────────────────────
                [ 📊 전체 당첨 현황 ]
                \(self.formatOfficialStats(official))
                
                👥 전체 평균 당첨금: \(Int64(averagePrize).formattedWithComma())원
                📉 전체 평균 수익률: \(String(format: "%.1f", totalYield))% (당첨금/판매액)
                ──────────────────────────────────
                """

                self.onShowFinalResult?(finalText)
            } catch {
                self.onShowAlert?("회차 정보를 가져오지 못했습니다.")
            }
        }
    }

    private func formatMyResults(_ results: LottoResults) -> String {
        var lines: [String] = []
        if results.count(of: .first) > 0 { lines.append("🥇 1등: \(results.count(of: .first))개") }
        if results.count(of: .second) > 0 { lines.append("🥈 2등: \(results.count(of: .second))개") }
        if results.count(of: .third) > 0 { lines.append("🥉 3등: \(results.count(of: .third))개") }
        if results.count(of: .fourth) > 0 { lines.append("4등: \(results.count(of: .fourth))개") }
        if results.count(of: .fifth) > 0 { lines.append("5등: \(results.count(of: .fifth))개") }
        if lines.isEmpty { lines.append("꽝입니다... 😢 다음 기회에!") }
        return lines.joined(separator: "\n")
    }

    private func formatOfficialStats(_ official: OfficialLottoResult) -> String {
        var lines: [String] = []
        let w1 = 15
        let header = " 순위 " + "| " + "   당첨자   " + "| " + centerString("1인당 금액", width: w1)
        lines.append(header)
        let separator = String(repeating: "-", count: 4) + "-+-" + String(repeating: "-", count: 9) + "-+-" + String(repeating: "-", count: w1)
        lines.append(separator)
        for rank in 1...5 {
            let winners = official.winnersPerRank[rank] ?? 0
            let prizePerPerson = official.prizePerRank[rank] ?? 0
            let rankName = "\(rank)등"
            let winnerText = "\(winners.formattedWithComma())명"
            let prizeText = "\(prizePerPerson.formattedWithComma())원"
            let col1 = "\u{200A} " + rankName + " "
            let col2 = centerString(winnerText, width: 9)
            let col3 = rightPadString(prizeText, width: w1)
            lines.append(col1 + "| " + col2 + " | " + col3)
        }
        return lines.joined(separator: "\n")
    }
    
    private func visualLength(_ text: String) -> Int {
        return text.reduce(0) { count, char in
            return count + (char.isASCII ? 1 : 2)
        }
    }
    
    private func centerString(_ text: String, width: Int) -> String {
        let currentLength = visualLength(text)
        let padding = max(0, width - currentLength)
        let leftPadCount = padding / 2
        let rightPadCount = padding - leftPadCount
        return String(repeating: " ", count: leftPadCount) + text + String(repeating: " ", count: rightPadCount)
    }
    
    private func rightPadString(_ text: String, width: Int) -> String {
        let currentLength = visualLength(text)
        let padding = max(0, width - currentLength)
        return String(repeating: " ", count: padding) + text
    }
    
    private func luckIndex(myPrize: Int64, average: Double) -> String {
        guard average > 0 else { return "당첨자 없음" }
        let ratio = Double(myPrize) / average
        switch ratio {
        case ..<0.1: return "운이 없었네요 😭"
        case 0.1..<1: return "평균보다 아쉬워요 😢"
        case 1..<3: return "평균 수준이에요 😊"
        case 3..<10: return "평균의 \(Int(ratio))배! 좋았어요! 🎉"
        default: return "대박! 평균의 \(Int(ratio))배 당첨!!! 🔥🔥🔥"
        }
    }
}

extension Int {
    func formattedWithComma() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
extension Int64 {
    func formattedWithComma() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
