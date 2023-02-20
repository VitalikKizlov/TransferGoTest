//
//  ViewController.swift
//  TransferGoTest
//
//  Created by Vitalii Kizlov on 14.02.2023.
//

import UIKit
import Combine
import Transfer

class ViewController: UIViewController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addCurrencyExchangeVC()
    }

    // MARK: - Private

    func addCurrencyExchangeVC() {
        let viewModel = CurrencyExchangeViewModel()
        let vc = CurrencyExchangeViewController(viewModel)

        add(vc)
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}

