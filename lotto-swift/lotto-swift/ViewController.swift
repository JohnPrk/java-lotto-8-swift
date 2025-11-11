// ViewController.swift

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var purchaseAmountMessageLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var lottoLabel: UILabel!

    private let lottoGenerator: LottoGenerator = RandomLottoGenerator()
    private var lottos: [Lotto] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = ""
        lottoLabel.text = ""
        lottoLabel.numberOfLines = 0
        lottoLabel.lineBreakMode = .byWordWrapping
    }

    @IBAction func didTapConfirmButton(_ sender: UIButton) {
        handlePurchaseAmount()
    }

    private func handlePurchaseAmount() {
        do {
            let amount = try InputValidator.parsePurchaseAmount(amountTextField.text)
            let money = try Money(amount: amount)
            let lottoCount = money.lottoCount
            confirmButton.isEnabled = false
            confirmButton.alpha = 0.5
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
            lottoLabel.text = ticketsText
       } catch let error as InputError {
            showAlert(message: error.localizedDescription)
            resetInput()
        } catch let error as MoneyError {
            showAlert(message: error.localizedDescription)
            resetInput()
        } catch {
            showAlert(message: "알 수 없는 오류가 발생했습니다.")
            resetInput()
        }
    }

    private func resetInput() {
        amountTextField.text = ""
        amountTextField.becomeFirstResponder()
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
