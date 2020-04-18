//
//  BasketViewPresenter.swift
//  FlowersUnicorn
//
//  Created by Home on 04/11/2019.
//  Copyright © 2019 Nikita Demidov. All rights reserved.
//

import UIKit
import PhoneNumberKit

struct BasketOrderModel {
    var itemCounts: [String : Int]
    var name: String?
    var phone: String?
    var date: Date?
    var comment: String?
    var delivery: DeliverSpot?
    var totalPrice: String?
    
    init() {
        self.itemCounts = [String : Int]()
    }
}

class BasketViewPresenter: NSObject {
    weak var view: BasketViewInput?
    weak var moduleOutput: BasketModuleOutput?
    
    private var basketService = BasketService.shared
    private var catalogService = CatalogService()
    private var deliverAreasService = DeliveryService()
    private var orderModel = BasketOrderModel()
    private let orderService = OrderService()
    
    private var priceCellModel: BasketPriceCellModel?
    private var orderItems: [CatalogItem]?
    private var basketDateCellModel: BasketDateCellModel?
    private var makeOrderCellModel: BasketOrderButtonCellModel?
    
    init(view: BasketViewInput, moduleOutput: BasketModuleOutput) {
        self.view = view
        self.moduleOutput = moduleOutput
    }
}

extension BasketViewPresenter: BasketViewOutput {
    func viewDidLoad() {
        update()
    }
    
    func viewWillAppear() {
        update()
    }
    
    func didSelectItem(with id: String) {
        moduleOutput?.didSelectItem(with: id)
    }
    
    private func update() {
        catalogService.obtainCatalogItems { [weak self] (catalogItems) in
            self?.deliverAreasService.obtainDeliveriesSpots(completion: { [weak self] (deliverAreas) in
                self?.show(catalogItems: catalogItems, deliverAreas: deliverAreas)
            })
        }
    }
    
    private func show(catalogItems: [CatalogItem], deliverAreas: [DeliverSpot]) {
        let basketItems = catalogItems.filter { self.basketService.isContain(id: $0.id) }
        self.orderItems = basketItems
        var cellModels: [CellModel] = basketItems.map { [weak self] (item) -> BasketItemOrderCellModel in
            let price = String(Int(item.price)) + " ₽"
            self?.orderModel.itemCounts[item.id] = 1
            return BasketItemOrderCellModel(modelId: item.id,
                                            cellId: "BasketItemOrderCell",
                                            tapHandler: nil,
                                            size: CGSize.init(width: 320, height: 82),
                                            title: item.title,
                                            iconPath: item.imagePath,
                    price: price,
                    changeCountHandler: { (countChange) in
                        let itemCount = self?.orderModel.itemCounts[item.id] ?? 0
                        var newCount = itemCount + countChange
                        newCount = newCount > 0 ? newCount : 0
                        self?.orderModel.itemCounts[item.id] = newCount
                        self?.updatePrice()
                        self?.updateOrderPrice()
                        return newCount
            })
        }
        
        let basketPriceCellModel = BasketPriceCellModel()
        self.priceCellModel = basketPriceCellModel
        cellModels.append(basketPriceCellModel)
        
        
        let nameField = BasketFieldCellModel(placeholder: "Имя", fieldKeyboardType: .default, textDidChangeHandler: { [weak self] (textField) in
            self?.orderModel.name = textField.text
        })
        let phoneField = BasketFieldCellModel(placeholder: "Телефон", fieldKeyboardType: .phonePad, textDidChangeHandler: { [weak self] (textField) in
            let partialFormatter = PartialFormatter(defaultRegion: "RU")
            let formattedPhone = partialFormatter.formatPartial(textField.text ?? "")
            self?.orderModel.phone = formattedPhone
            textField.text = formattedPhone
        })
        cellModels.append(nameField)
        cellModels.append(phoneField)
        
        self.basketDateCellModel = BasketDateCellModel()
        self.basketDateCellModel?.tapHandler = { [weak self] cellModel in
            self?.view?.endEditing()
            self?.showDatePicker()
        }
        
        if let basketDateCellModel = self.basketDateCellModel {
            cellModels.append(basketDateCellModel)
        }

        let deliveryTitleCellModel = DestinationTitleCellModel()
        cellModels.append(deliveryTitleCellModel)
        let deliveryDestinationCellModel = deliverAreas.map { (area) -> BasketDestinationCellModel in
            let basketDestinationCellModel = BasketDestinationCellModel(title: area.title, price: String(area.price), selected: false)
            basketDestinationCellModel.deliverySpot = area
            return basketDestinationCellModel
        }
        orderModel.delivery = deliverAreas.first

        deliveryDestinationCellModel.first?.selected = true
        
        for destinationCellModel in deliveryDestinationCellModel {
            destinationCellModel.tapHandler = { [weak self] cellModel in
                for model in deliveryDestinationCellModel {
                    model.stateChangedHandler?(false)
                    model.selected = false
                }
                destinationCellModel.stateChangedHandler?(true)
                destinationCellModel.selected = true
                self?.orderModel.delivery = destinationCellModel.deliverySpot
                self?.updateOrderPrice()
            }
        }
        
        cellModels.append(contentsOf: deliveryDestinationCellModel)
            
        let makeOrderCellModel = BasketOrderButtonCellModel { [weak self] in
            self?.makeOrder()
        }

        self.makeOrderCellModel = makeOrderCellModel
        cellModels.append(makeOrderCellModel)

    
        view?.setup(cellModels: cellModels)
        DispatchQueue.main.async {
            self.updatePrice()
            self.updateOrderPrice()
            deliveryDestinationCellModel.first?.stateChangedHandler?(true)
        }
    }

    private func updateOrderPrice() {
        let priceString = String(getCurrentPrice()) + " ₽"
        let deliveryPrice = String(Int(orderModel.delivery?.price ?? 0)) + " ₽"
        let fullPrice = getCurrentPrice() + Int(orderModel.delivery?.price ?? 0)
        let fullPriceString = String(fullPrice) + " ₽"
        let deliveryTitle = (orderModel.delivery?.title ?? "") + ":"
        makeOrderCellModel?.updateLabelsHandler?(priceString, deliveryPrice, deliveryTitle, fullPriceString)
    }

    private func updatePrice() {
        orderModel.totalPrice = String(getCurrentPrice()) + " ₽"
        priceCellModel?.priceDidChange?(orderModel.totalPrice ?? "")
    }

    private func getCurrentPrice() -> Int {
        var fullPrice: Float = 0
        guard let items = orderItems else {
            return 0
        }

        for item in items {
            let count = self.orderModel.itemCounts[item.id] ?? 1
            let price = item.price * Float(count)
            fullPrice += price
        }

        return Int(fullPrice)
    }
    
    private func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        if let date = orderModel.date {
            let dateString = dateFormatter.string(from: date)
            basketDateCellModel?.dateChanged?(dateString)
        }
    }
    
    private func makeOrder() {
        orderService.makeOrder(order: orderModel) { (success, error) in
            
        }
    }
    
    private func showDatePicker() {
        let viewController = self.view as! UIViewController
        let datePickerViewController = BasketDatePicker(nibName: "BasketDatePicker", bundle: nil)
        datePickerViewController.doneHandler = { [weak datePickerViewController, weak self] date in
            self?.orderModel.date = date
            datePickerViewController?.dismiss(animated: true, completion: nil)
            self?.updateDate()
        }
        viewController.present(datePickerViewController, animated: true, completion: nil)
    }
}
