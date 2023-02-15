//
//  ViewModel.swift
//  TransferGoTest
//
//  Created by Vitalii Kizlov on 14.02.2023.
//

import Foundation

final class TransferViewModel {

}

extension TransferViewModel {
    enum LoadingState: Equatable {
        case idle
        case loading
        case loaded
        case failed(Error)

        static func == (lhs: TransferViewModel.LoadingState, rhs: TransferViewModel.LoadingState) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle):
                return true
            case (.loading, .loading):
                return true
            case (.loaded, .loaded):
                return true
            case (.failed, .failed):
                return true
            default:
                return false
            }
        }
    }
}

extension TransferViewModel {
    enum ViewInputEvent {
        case textDidChange(String)
        case cancelButtonClicked
    }
}
