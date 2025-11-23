//
//  MainViewController.swift
//  lotto-swift
//
//  Created by john on 11/20/25.
//

// MainViewController.swift

import UIKit


class MainViewController: UIViewController {
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let manualButton = UIButton(type: .system)
    private let officialButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    @objc private func didTapManual() {
        let vc = ManualInputViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapOfficial() {
        let vc = OfficialRoundViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
