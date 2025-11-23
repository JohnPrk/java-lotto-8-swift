//
//  LottoCrawler.swift
//  lotto-swift
//
//  Created by john on 11/23/25.
//

import Foundation

extension String.Encoding {
    static let eucKR = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(0x0422))
}

class LottoCrawler {
    private let baseURL = "https://www.dhlottery.co.kr/gameResult.do"
    
    func fetchResult(for round: Int) async throws -> OfficialLottoResult {
        guard (1...1200).contains(round) else {
            throw NSError(domain: "LottoCrawler", code: -1, userInfo: [NSLocalizedDescriptionKey: "유효하지 않은 회차입니다."])
        }
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "method", value: "byWin"),
            URLQueryItem(name: "drwNo", value: "\(round)"),
            URLQueryItem(name: "dwrNoList", value: "\(round)")
        ]
        guard let url = components?.url else {
            throw NSError(domain: "LottoCrawler", code: -3, userInfo: [NSLocalizedDescriptionKey: "URL 생성 실패"])
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let (data, _) = try await URLSession.shared.data(for: request)
        guard let html = String(data: data, encoding: .utf8) ?? String(data: data, encoding: .eucKR) else {
            throw NSError(domain: "LottoCrawler", code: -2, userInfo: [NSLocalizedDescriptionKey: "인코딩 실패"])
        }
        return try parseHTML(html, round: round)
    }
    
    private func parseHTML(_ html: String, round: Int) throws -> OfficialLottoResult {
            let range = NSRange(html.startIndex..., in: html)
            let ballRegex = try NSRegularExpression(pattern: "<span class=\"ball_645[^\"]*\">([0-9]+)</span>")
            let ballMatches = ballRegex.matches(in: html, range: range)
            guard ballMatches.count >= 7 else {
                throw NSError(domain: "Parse", code: -1, userInfo: [NSLocalizedDescriptionKey: "당첨 번호를 찾을 수 없습니다."])
            }
            let numbers = (0..<6).compactMap { index -> Int? in
                let valStr = html[Range(ballMatches[index].range(at: 1), in: html)!]
                return Int(valStr)
            }
            let bonusStr = html[Range(ballMatches[6].range(at: 1), in: html)!]
            let bonus = Int(bonusStr) ?? 0
            let salesRegex = try NSRegularExpression(pattern: "총판매금액.*?<strong>([0-9,]+)원</strong>")
            let salesMatch = salesRegex.firstMatch(in: html, range: range)
            let salesStr = salesMatch.map { String(html[Range($0.range(at: 1), in: html)!]) } ?? "0"
            let totalSales = Int64(salesStr.replacingOccurrences(of: ",", with: "")) ?? 0
            let rankRegex = try NSRegularExpression(
                pattern: "<td>(\\d)등</td>\\s*<td class=\"tar\">.*?</td>\\s*<td>([0-9,]+)</td>\\s*<td class=\"tar\">([0-9,]+)원</td>",
                options: .dotMatchesLineSeparators
            )
            let rankMatches = rankRegex.matches(in: html, range: range)
            var prizePerRank: [Int: Int64] = [:]
            var winnersPerRank: [Int: Int] = [:]
            for match in rankMatches {
                guard let rankRange = Range(match.range(at: 1), in: html),
                      let rank = Int(html[rankRange]) else { continue }
                if let winnersRange = Range(match.range(at: 2), in: html) {
                    let wStr = String(html[winnersRange]).replacingOccurrences(of: ",", with: "")
                    winnersPerRank[rank] = Int(wStr) ?? 0
                }
                if let amountRange = Range(match.range(at: 3), in: html) {
                    let aStr = String(html[amountRange]).replacingOccurrences(of: ",", with: "")
                    prizePerRank[rank] = Int64(aStr) ?? 0
                }
            }
            let firstAmount = prizePerRank[1] ?? 0
            let firstWinners = winnersPerRank[1] ?? 0
            let dateRegex = try NSRegularExpression(pattern: "\\((\\d{4}년 \\d{1,2}월 \\d{1,2}일) 추첨\\)")
            let dateMatch = dateRegex.firstMatch(in: html, range: range)
            let date = dateMatch.map { String(html[Range($0.range(at: 1), in: html)!]) } ?? ""
            return OfficialLottoResult(
                round: round,
                date: date,
                winningNumbers: numbers,
                bonusNumber: bonus,
                totalSalesAmount: totalSales,
                firstPrizeAmount: firstAmount,
                firstPrizeWinners: firstWinners,
                prizePerRank: prizePerRank,
                winnersPerRank: winnersPerRank
            )
        }
}

fileprivate extension NSTextCheckingResult {
    func captured(_ index: Int, in string: String) -> String {
        guard index < numberOfRanges else { return "" }
        guard let r = Range(range(at: index), in: string) else { return "" }
        return String(string[r])
    }
}
