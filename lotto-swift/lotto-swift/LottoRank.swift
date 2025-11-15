//
//  LottoRank.swift
//  lotto-swift
//
//  Created by john on 11/12/25.
//

enum LottoRank: CaseIterable {
    case first
    case second
    case third
    case fourth
    case fifth
    case miss

    var prize: Int {
        switch self {
        case .first:  return 2_000_000_000
        case .second: return 30_000_000
        case .third:  return 1_500_000
        case .fourth: return 50_000
        case .fifth:  return 5_000
        case .miss:   return 0
        }
    }

    static func of(match: Int, bonusMatched: Bool) -> LottoRank {
        switch (match, bonusMatched) {
        case (6, _):          return .first
        case (5, true):       return .second
        case (5, false):      return .third
        case (4, _):          return .fourth
        case (3, _):          return .fifth
        default:              return .miss
        }
    }
}
