//
//  LottoViewModel.swift
//  lotto-swift
//
//  Created by john on 11/18/25.
//

// LottoViewModel.swift

import Foundation

final class LottoViewModel {
    
    private let lottoGenerator: LottoGenerator
    private let inputParser: LottoInputParser
    private let resultFormatter: LottoResultFormatter
    
    private let stepDelay: TimeInterval = 0.6
    private var lottos: [Lotto] = []
    private var pendingWinningLotto: Lotto?
    private var winningLotto: WinningLotto?
    private var purchaseAmount: Int = 0
    
    var onUpdateResultLabel: ((String) -> Void)?
    var onUpdateLottoTickets: ((String) -> Void)?
    var onShowWinningNumbersInput: (() -> Void)?
    var onUpdateWinningNumbersOutput: ((String) -> Void)?
    var onShowBonusNumberInput: (() -> Void)?
    var onUpdateBonusNumberOutput: ((String) -> Void)?
    var onShowResults: ((String) -> Void)?
    
    var onDisablePurchaseUI: (() -> Void)?
    var onDisableWinningNumbersUI: (() -> Void)?
    var onDisableBonusNumberUI: (() -> Void)?
    
    var onShowAlert: ((String) -> Void)?
    var onResetPurchaseInput: (() -> Void)?
    var onResetWinningNumbersInput: (() -> Void)?
    var onResetBonusNumberInput: (() -> Void)?
    
    var onScrollToBottom: (() -> Void)?
    
    init(
        lottoGenerator: LottoGenerator = RandomLottoGenerator(),
        inputParser: LottoInputParser = LottoInputParser(),
        resultFormatter: LottoResultFormatter = LottoResultFormatter()
    ) {
        self.lottoGenerator = lottoGenerator
        self.inputParser = inputParser
        self.resultFormatter = resultFormatter
    }
    
    func purchaseAmount(amountText: String?) {
        do {
            let parsed = try inputParser.parsePurchaseAmount(amountText)
            self.purchaseAmount = parsed.amount
            onDisablePurchaseUI?()
            lottos = try lottoGenerator.generate(count: parsed.lottoCount)
            let ticketsText = resultFormatter.ticketsText(from: lottos)
            onUpdateResultLabel?("\(parsed.lottoCount)개를 구매했습니다.")
            DispatchQueue.main.asyncAfter(deadline: .now() + self.stepDelay) {
                self.onUpdateLottoTickets?(ticketsText)
                DispatchQueue.main.asyncAfter(deadline: .now() + self.stepDelay) {
                    self.onShowWinningNumbersInput?()
                    self.onScrollToBottom?()
                }
            }
        } catch let e as InputParseError {
            onShowAlert?(e.localizedDescription)
            onResetPurchaseInput?()
        } catch let e as MoneyError {
            onShowAlert?(e.localizedDescription)
            onResetPurchaseInput?()
        } catch {
            onShowAlert?("알 수 없는 오류가 발생했습니다.")
            onResetPurchaseInput?()
        }
    }
    
    func setWinningNumbers(numbersText: String?) {
        do {
            let lotto = try inputParser.parseWinningNumbers(numbersText)
            pendingWinningLotto = lotto
            
            DispatchQueue.main.asyncAfter(deadline: .now() + self.stepDelay) {
                let text = lotto.getNumbers()
                    .map(String.init)
                    .joined(separator: ", ")
                
                self.onUpdateWinningNumbersOutput?("[\(text)]")
                self.onScrollToBottom?()
                
                self.onDisableWinningNumbersUI?()
                self.onShowBonusNumberInput?()
                self.onScrollToBottom?()
            }
        } catch let e as WinningLottoError {
            onShowAlert?(e.localizedDescription)
            onResetWinningNumbersInput?()
        } catch let e as LottoError {
            onShowAlert?(e.localizedDescription)
            onResetWinningNumbersInput?()
        } catch {
            onShowAlert?("알 수 없는 입력 오류")
            onResetWinningNumbersInput?()
        }
    }
    
    func setBonusNumber(numberText: String?) {
        do {
            guard let winningLotto = pendingWinningLotto else {
                onShowAlert?("먼저 당첨 번호 6개를 입력해 주세요.")
                return
            }
            let parsed = try inputParser.parseBonusNumber(numberText, winningLotto: winningLotto)
            let bonus = parsed.bonus
            self.winningLotto = parsed.winning
            
            DispatchQueue.main.asyncAfter(deadline: .now() + self.stepDelay) {
                self.onUpdateBonusNumberOutput?("\(bonus.value)")
                self.onDisableBonusNumberUI?()
                self.onScrollToBottom?()
                
                self.showResults()
            }
        } catch let e as InputParseError {
            onShowAlert?(e.localizedDescription)
            onResetBonusNumberInput?()
        } catch let e as WinningLottoError {
            onShowAlert?(e.localizedDescription)
            onResetBonusNumberInput?()
        } catch let e as BonusError {
            onShowAlert?(e.localizedDescription)
            onResetBonusNumberInput?()
        } catch {
            onShowAlert?("알 수 없는 입력 오류")
            onResetBonusNumberInput?()
        }
    }
    
    private func showResults() {
        guard let winning = winningLotto else {
            onShowAlert?("당첨 번호와 보너스 번호가 존재하지 않습니다.")
            return
        }
        let results = LottoResults(lottos: self.lottos, winningNumbers: winning)
        let (summaryText, yieldText) = resultFormatter.summary(from: results, purchaseAmount: purchaseAmount)
        let resultOutputText = resultFormatter.finalResultText(summaryText: summaryText, yieldText: yieldText)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.stepDelay) {
            self.onShowResults?(resultOutputText)
            self.onScrollToBottom?()
        }
    }
}
