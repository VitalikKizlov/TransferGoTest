//
//  ViewController.swift
//  TransferGoTest
//
//  Created by Vitalii Kizlov on 14.02.2023.
//

import UIKit
import Combine
import Transfer
import Utilities

class ViewController: UIViewController {

    private let viewModel: TransferViewModel

    @AutoLayoutable private var transferView = TransferView()

    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Init

    init(_ viewModel: TransferViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addTransferView()
        configureTransferView()
        setupBindings()
    }

    // MARK: - Private

    private func addTransferView() {
        view.addSubview(transferView)

        NSLayoutConstraint.activate([
            transferView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            transferView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            transferView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            transferView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    private func setupBindings() {
        transferView
            .viewActionPublisher
            .sink { [weak self] action in
                guard let self = self else { return }
                self.viewModel.viewInput.send(action)
            }
            .store(in: &subscriptions)
    }

    private func configureTransferView() {
        let senderCountryViewModel = CountryViewViewModel(image: UIImage(systemName: "scribble")!, title: "PLN")
        let senderExchangeViewModel = ExchangeDataViewViewModel(title: "Sending from", countryViewViewModel: senderCountryViewModel, amount: 300)

        let receiverCountryViewModel = CountryViewViewModel(image: UIImage(systemName: "scribble")!, title: "UAH")
        let receiverExchangeViewModel = ExchangeDataViewViewModel(title: "Receiver gets", countryViewViewModel: receiverCountryViewModel, amount: 600)

        let transferViewModel = TransferViewViewModel(senderViewViewModel: senderExchangeViewModel, receiverViewViewModel: receiverExchangeViewModel)

        transferView.configure(transferViewModel)
    }
}

