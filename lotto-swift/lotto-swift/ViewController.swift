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
    @IBOutlet weak var resultOutput: UILabel!
    
    private let viewModel = LottoViewModel()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupInitialUI()
            bindViewModel()
        }
        
        @IBAction func didTapConfirmButton(_ sender: UIButton) {
            viewModel.purchaseAmount(amountText: amountTextField.text)
        }
        
        @IBAction func didTapWinningNumbersButton(_ sender: UIButton) {
            viewModel.setWinningNumbers(numbersText: winningNumbersField.text)
        }
        
        @IBAction func didTapBonusNumberButton(_ sender: UIButton) {
            viewModel.setBonusNumber(numberText: bonusNumberField.text)
        }
        
        private func setupInitialUI() {
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
            resultOutput.text = ""
            amountTextField.becomeFirstResponder()
        }
        
        private func bindViewModel() {
            viewModel.onUpdateResultLabel = { [weak self] text in
                self?.resultLabel.text = text
        }

        viewModel.onUpdateLottoTickets = { [weak self] text in
            self?.lottoLabel.text = text
        }

        viewModel.onShowWinningNumbersInput = { [weak self] in
            guard let self = self else { return }
            self.winningNumbersMessageLabel.text = "당첨 번호를 입력해 주세요"
            self.winningNumbersField.isHidden = false
            self.winningNumbersButton.isHidden = false
            self.scrollToBottomIfNeeded()
            self.winningNumbersField.becomeFirstResponder()
        }

        viewModel.onUpdateWinningNumbersOutput = { [weak self] text in
            self?.winningNumbersOutput.text = text
        }

        viewModel.onShowBonusNumberInput = { [weak self] in
            guard let self = self else { return }
            self.bonusNumberMessageLabel.text = "보너스 번호를 입력해 주세요."
            self.bonusNumberField.isHidden = false
            self.bonusNumberButton.isHidden = false
            self.bonusNumberField.becomeFirstResponder()
            self.scrollToBottomIfNeeded()
        }

        viewModel.onUpdateBonusNumberOutput = { [weak self] text in
            self?.bonusNumberOutput.text = text
        }

        viewModel.onShowResults = { [weak self] text in
            self?.resultOutput.text = text
            self?.scrollToBottomIfNeeded()
        }

        viewModel.onDisablePurchaseUI = { [weak self] in
            guard let self = self else { return }
            self.purchaseAmountButton.isEnabled = false
            self.purchaseAmountButton.alpha = 0.5
            self.amountTextField.isEnabled = false
            self.view.endEditing(true)
        }

        viewModel.onDisableWinningNumbersUI = { [weak self] in
            guard let self = self else { return }
            self.winningNumbersField.isEnabled = false
            self.winningNumbersButton.isEnabled = false
            self.winningNumbersButton.alpha = 0.5
        }

        viewModel.onDisableBonusNumberUI = { [weak self] in
            guard let self = self else { return }
            self.bonusNumberField.isEnabled = false
            self.bonusNumberButton.isEnabled = false
            self.bonusNumberButton.alpha = 0.5
            self.view.endEditing(true)
            self.view.layoutIfNeeded()
        }

        viewModel.onShowAlert = { [weak self] message in
            self?.showAlert(message: message)
        }

        viewModel.onResetPurchaseInput = { [weak self] in
            self?.resetPurchaseAmountInput()
        }

        viewModel.onResetWinningNumbersInput = { [weak self] in
            self?.resetWinningNumbers()
        }

        viewModel.onResetBonusNumberInput = { [weak self] in
            self?.resetBonusNumber()
        }

        viewModel.onScrollToBottom = { [weak self] in
            self?.scrollToBottomIfNeeded()
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
        
        private func scrollToBottomIfNeeded() {
            view.layoutIfNeeded()
            let inset = scrollView.adjustedContentInset
            let visibleH = scrollView.bounds.height - inset.top - inset.bottom
            let contentH = scrollView.contentSize.height
            let y = max(0, contentH - visibleH)
            scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: true)
        }
}
