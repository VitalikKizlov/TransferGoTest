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
import Models

class ViewController: UIViewController {

    private let viewModel: CurrencyExchangeViewModel

    @AutoLayoutable private var transferView = TransferView()

    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Init

    init(_ viewModel: CurrencyExchangeViewModel) {
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
        viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }

                switch state {
                case .idle(let data):
                    self.updateTransferView(from: data)
                case .failed(let error):
                    print(error)
                case .loading:
                    print("loading")
                case .loaded(let data):
                    self.updateTransferView(from: data)
                }
            }
            .store(in: &subscriptions)

        transferView
            .viewActionPublisher
            .sink { [weak self] action in
                guard let self = self else { return }
                self.viewModel.viewInput.send(action)
            }
            .store(in: &subscriptions)
    }

    private func updateTransferView(from data: ExchangeData) {
        let senderCountryViewModel = CountryViewViewModel(image: data.sender.country.image, title: data.sender.country.currency.rawValue)
        let senderExchangeViewModel = ExchangeDataViewViewModel(title: "Sending from", countryViewViewModel: senderCountryViewModel, amount: data.sender.amount)

        let receiverCountryViewModel = CountryViewViewModel(image: data.receiver.country.image, title: data.receiver.country.currency.rawValue)
        let receiverExchangeViewModel = ExchangeDataViewViewModel(title: "Receiver gets", countryViewViewModel: receiverCountryViewModel, amount: data.receiver.amount)

        let transferViewModel = TransferViewViewModel(senderViewViewModel: senderExchangeViewModel, receiverViewViewModel: receiverExchangeViewModel)

        transferView.configure(transferViewModel)
    }
}

