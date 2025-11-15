// ViewController.swift

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var purchaseAmountMessageLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var purchaseAmountButton: UIButton!
    @IBOutlet weak var lottoLabel: UILabel!
    @IBOutlet weak var winningNumbersMessageLabel: UILabel!
    @IBOutlet weak var winningNumbersField: UITextField!
    @IBOutlet weak var winningNumbersOutput: UILabel!
    @IBOutlet weak var winningNumbersButton: UIButton!
    @IBOutlet weak var bonusNumberMessageLabel: UILabel!
    @IBOutlet weak var bonusNumberField: UITextField!
    @IBOutlet weak var bonusNumberButton: UIButton!
    @IBOutlet weak var bonusNumberOutput: UILabel!

    private let lottoGenerator: LottoGenerator = RandomLottoGenerator()
    private let stepDelay: TimeInterval = 0.6
    private var lottos: [Lotto] = []
    private var pendingWinningLotto: Lotto?
    private var winningLotto: WinningLotto?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = ""
        lottoLabel.text = ""
        winningNumbersMessageLabel.text = ""
        winningNumbersField.isHidden = true
        winningNumbersButton.isHidden = true
        winningNumbersOutput.text = ""
        bonusNumberMessageLabel.text = ""
        bonusNumberField.text = ""
        bonusNumberField.isHidden = true
        bonusNumberButton.isHidden = true
        bonusNumberOutput.text = ""
        amountTextField.becomeFirstResponder()
    }

    @IBAction func didTapConfirmButton(_ sender: UIButton) {
        handlePurchaseAmount()
    }
    
    @IBAction func didTapWinningNumbersButton(_ sender: UIButton) {
        handleWinningNumbers()
    }
    
    @IBAction func didTapBonusNumberButton(_ sender: UIButton) {
        handleBonusNumber()
    }
    
    private func handlePurchaseAmount() {
        do {
            let amount = try InputValidator.parsePurchaseAmount(amountTextField.text)
            let money = try Money(amount: amount)
            let lottoCount = money.lottoCount
            purchaseAmountButton.isEnabled = false
            purchaseAmountButton.alpha = 0.5
            amountTextField.isEnabled = false
            view.endEditing(true)
            lottos = try lottoGenerator.generate(count: lottoCount)
            let ticketsText = lottos
                .map { lotto in
                    let nums = lotto.getNumbers()
                        .map { String($0) }
                        .joined(separator: ", ")
                    return "[\(nums)]"
                }
                .joined(separator: "\n")
            resultLabel.text = "\(lottoCount)개를 구매했습니다."
            DispatchQueue.main.asyncAfter(deadline: .now() + self.stepDelay) {
                self.lottoLabel.text = ticketsText
                DispatchQueue.main.asyncAfter(deadline: .now() + self.stepDelay) {
                    self.winningNumbersMessageLabel.text = "당첨 번호를 입력해 주세요"
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.stepDelay) {
                        self.winningNumbersField.isHidden = false
                        self.winningNumbersButton.isHidden = false
                        self.scrollToBottomIfNeeded()
                        self.winningNumbersField.becomeFirstResponder()
                    }
                }
            }
       } catch let e as InputParseError {
            showAlert(message: e.localizedDescription)
            resetPurchaseAmountInput()
       } catch let e as MoneyError {
            showAlert(message: e.localizedDescription)
            resetPurchaseAmountInput()
       } catch {
            showAlert(message: "알 수 없는 오류가 발생했습니다.")
            resetPurchaseAmountInput()
        }
    }
    
    private func handleWinningNumbers() {
        do {
            let nums = try InputValidator.parseWinningNumbers(winningNumbersField.text)
            let lotto = try Lotto(numbers: nums)
            pendingWinningLotto = lotto
            DispatchQueue.main.asyncAfter(deadline: .now() + self.stepDelay) {
                let text = lotto.getNumbers().map(String.init).joined(separator: ", ")
                self.winningNumbersOutput.text = "[\(text)]"
                self.scrollToBottomIfNeeded()
                self.winningNumbersField.isEnabled = false
                self.winningNumbersButton.isEnabled = false
                self.winningNumbersButton.alpha = 0.5
                self.bonusNumberMessageLabel.text = "보너스 번호를 입력해 주세요."
                self.bonusNumberField.isHidden = false
                self.bonusNumberButton.isHidden = false
                self.bonusNumberField.becomeFirstResponder()
                self.scrollToBottomIfNeeded()
            }
        } catch let e as WinningLottoError {
            showAlert(message: e.localizedDescription)
            resetWinningNumbers()
        } catch let e as LottoError {
            showAlert(message: e.localizedDescription)
            resetWinningNumbers()
        } catch {
            showAlert(message: "알 수 없는 입력 오류")
            resetWinningNumbers()
        }
    }
    
    private func handleBonusNumber() {
        do {
            guard let winningLotto = pendingWinningLotto else {
                showAlert(message: "먼저 당첨 번호 6개를 입력해 주세요.")
                return
            }
            let n = try InputValidator.parseBonusNumber(bonusNumberField.text)
            let bonus = try BonusNumber(n, notIn: winningLotto)
            self.winningLotto = WinningLotto(lotto: winningLotto, bonus: bonus)
            DispatchQueue.main.asyncAfter(deadline: .now() + self.stepDelay) {
                self.bonusNumberOutput.text = "\(bonus.value)"
                self.bonusNumberField.isEnabled = false
                self.bonusNumberButton.isEnabled = false
                self.bonusNumberButton.alpha = 0.5
                self.view.endEditing(true)
                self.view.layoutIfNeeded()
                self.scrollToBottomIfNeeded()
            }
        } catch let e as InputParseError {
            showAlert(message: e.localizedDescription)
            resetBonusNumber()
        } catch let e as WinningLottoError {
            showAlert(message: e.localizedDescription)
            resetBonusNumber()
        } catch let e as BonusError {
            showAlert(message: e.localizedDescription)
            resetBonusNumber()
        } catch {
            showAlert(message: "알 수 없는 입력 오류")
            resetBonusNumber()
        }
    }

    private func resetPurchaseAmountInput() {
        amountTextField.text = ""
        amountTextField.becomeFirstResponder()
    }

    private func resetWinningNumbers() {
        winningNumbersField.text = ""
        winningNumbersField.becomeFirstResponder()
    }
    
    private func resetBonusNumber() {
        bonusNumberField.text = ""
        bonusNumberField.becomeFirstResponder()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    private func setText(_ label: UILabel, _ text: String, animated: Bool = true) {
        guard animated else { label.text = text; return }
        UIView.transition(with: label, duration: 0.25, options: .transitionCrossDissolve, animations: {
            label.text = text
        }, completion: nil)
    }
    
    private func scrollToBottomIfNeeded() {
        self.view.layoutIfNeeded()
        let inset = scrollView.adjustedContentInset
        let visibleH = scrollView.bounds.height - inset.top - inset.bottom
        let contentH = scrollView.contentSize.height
        let y = max(0, contentH - visibleH)
        scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
    }
}
