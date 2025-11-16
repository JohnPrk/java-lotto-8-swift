//
//  LottoRank.swift
//  lotto-swift
//
//  Created by john on 11/12/25.
//

// LottoRank.swift

import Foundation 

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

    static func from(matchCount: Int, bonusMatched: Bool) -> LottoRank {
        switch matchCount {
        case 6:
            return .first
        case 5:
            return bonusMatched ? .second : .third
        case 4:
            return .fourth
        case 3:
            return .fifth
        default:
            return .miss
        }
    }
}
