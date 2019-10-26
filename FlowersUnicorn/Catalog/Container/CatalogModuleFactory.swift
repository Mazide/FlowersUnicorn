//
//  CatalogFactory.swift
//  FlowersUnicorn
//
//  Created by Home on 26/10/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit

struct CatalogModule {
    let view: CatalogViewInput
    let presenter: CatalogViewOutput
}

class CatalogModuleFactory: NSObject {
    func createModule() -> CatalogModule {
        let view = CatalogView(nibName: "CatalogView", bundle: nil)
        let presenter = CatalogPresenter(view: view)
        view.output = presenter
        let module = CatalogModule(view: view, presenter: presenter)
        return module
    }
}
