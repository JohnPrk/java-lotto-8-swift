// ViewController.swift

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var purchaseAmountMessageLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = ""
    }

    @IBAction func didTapConfirmButton(_ sender: UIButton) {
        handlePurchaseAmount()
    }

    private func handlePurchaseAmount() {
        do {
            let amount = try InputValidator.parsePurchaseAmount(amountTextField.text)
            let money = try Money(amount: amount)
            let lottoCount = money.lottoCount
            resultLabel.text = "\(lottoCount)개를 구매했습니다."
            confirmButton.isEnabled = false
            confirmButton.alpha = 0.5
            amountTextField.isEnabled = false
            view.endEditing(true)
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

