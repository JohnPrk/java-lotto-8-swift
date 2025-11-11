//
//  LottoGenerator.swift
//  lotto-swift
//
//  Created by john on 11/12/25.
//

import Foundation

protocol LottoGenerator {
    func generate(count: Int) throws -> [Lotto]
}

struct RandomLottoGenerator: LottoGenerator {

    func generate(count: Int) throws -> [Lotto] {
        guard count > 0 else {
            throw LottoGeneratorError.invalidCount
        }
        var lottos: [Lotto] = []

        for _ in 0..<count {
            let numbers = Self.randomNumbers()
            let lotto = try Lotto(numbers: numbers)
            lottos.append(lotto)
        }
        return lottos
    }

    private static func randomNumbers() -> [Int] {
        let allNumbers = Array(1...45)
        let picked = allNumbers.shuffled().prefix(6)
        return Array(picked).sorted()
    }
}
