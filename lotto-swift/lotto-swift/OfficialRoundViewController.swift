// OfficialRoundViewController.swift
import UIKit

class OfficialRoundViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var purchaseAmountMessageLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var purchaseAmountButton: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var lottoLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var roundTextField: UITextField!
    @IBOutlet weak var roundButton: UIButton!
    @IBOutlet weak var resultOutput: UILabel!
    
    private let viewModel = OfficialLottoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "실제 회차 조회"
        setupInitialUI()
        bindViewModel()
        resultOutput.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
    }
    
    private func setupInitialUI() {
        roundLabel.text = ""
        resultLabel.text = ""
        lottoLabel.text = ""
        resultOutput.text = ""
        roundTextField.isHidden = true
        roundButton.isHidden = true
        amountTextField.becomeFirstResponder()
    }
    

    
    @IBAction func didTapPurchase(_ sender: UIButton) {
        viewModel.purchaseAmount(amountText: amountTextField.text)
        amountTextField.isEnabled = false;
        purchaseAmountButton.alpha = 0.5
        purchaseAmountButton.isEnabled = false
    }
    
    @IBAction func didTapFetchRound(_ sender: UIButton) {
        viewModel.fetchOfficialResult(roundText: roundTextField.text)
        roundTextField.isEnabled = false
        roundButton.alpha = 0.5
        roundButton.isEnabled = false
    }
    
    private func bindViewModel() {
        viewModel.onUpdateResultLabel = { [weak self] text in
            self?.resultLabel.text = text
            self?.scrollToBottomIfNeeded()
        }
        
        viewModel.onUpdateLottoTickets = { [weak self] text in
            self?.lottoLabel.text = text
            self?.scrollToBottomIfNeeded()
        }
        
        viewModel.onShowRoundInput = { [weak self] in
            self?.roundLabel.text = "회차를 입력해주세요."
            self?.roundTextField.isHidden = false
            self?.roundButton.isHidden = false
            self?.roundTextField.becomeFirstResponder()
            self?.scrollToBottomIfNeeded()
        }
        
        viewModel.onShowFinalResult = { [weak self] text in
            self?.resultOutput.text = text
            self?.resultOutput.becomeFirstResponder()
            self?.scrollToBottomIfNeeded()
        }
        
        viewModel.onShowAlert = { [weak self] message in
            self?.showAlert(message: message)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
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
