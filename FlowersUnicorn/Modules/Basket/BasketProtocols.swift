//
//  BasketProtocols.swift
//  FlowersUnicorn
//
//  Created by Home on 04/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import Foundation

protocol BasketViewInput: ListViewInput {
    func endEditing()
    func showError()
}

protocol BasketViewOutput: ListViewOutput {
    func didSelectItem(with id: String)
}

protocol BasketModuleOutput: class {
    func didSelectItem(with id: String)
}
