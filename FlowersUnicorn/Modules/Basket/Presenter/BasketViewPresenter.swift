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
    private var nameFieldModel: BasketFieldCellModel?
    private var phoneFieldModel: BasketFieldCellModel?
    
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

        let nameKey = "flowers.basket.name"
        let phoneKey = "flowers.basket.phone"
        let savedName = UserDefaults.standard.string(forKey: nameKey)
        let savedPhone = UserDefaults.standard.string(forKey: phoneKey)
        orderModel.name = savedName
        orderModel.phone = savedPhone
        let nameFieldModel = BasketFieldCellModel(placeholder: "Имя", text: savedName, fieldKeyboardType: .default, textDidChangeHandler: { [weak self] (textField) in
            self?.orderModel.name = textField.text
            UserDefaults.standard.set(textField.text, forKey: nameKey)
        })
        let phoneFieldModel = BasketFieldCellModel(placeholder: "Телефон", text: savedPhone, fieldKeyboardType: .phonePad, textDidChangeHandler: { [weak self] (textField) in
            let partialFormatter = PartialFormatter(defaultRegion: "RU")
            let formattedPhone = partialFormatter.formatPartial(textField.text ?? "")
            self?.orderModel.phone = formattedPhone
            textField.text = formattedPhone
            UserDefaults.standard.set(textField.text, forKey: phoneKey)
        })

        self.nameFieldModel = nameFieldModel
        cellModels.append(nameFieldModel)

        self.phoneFieldModel = phoneFieldModel
        cellModels.append(phoneFieldModel)
        
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
            
        let makeOrderCellModel = BasketOrderButtonCellModel.init(orderButtonHandler: { [weak self] in
            self?.makeOrder()
        }, commentChangeHandler: { [weak self] comment in
            self?.orderModel.comment = comment
        })

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
        let isNameEmpty = orderModel.name?.count == 0 || orderModel.name == nil
        let isPhoneEmpty = orderModel.phone?.count == 0 || orderModel.phone == nil
        if (isNameEmpty) {
            nameFieldModel?.setupErrorState?(true)
        }

        if (isPhoneEmpty) {
            phoneFieldModel?.setupErrorState?(true)
        }

        if (isNameEmpty || isPhoneEmpty) {
            let alert = UIAlertController.init(title: "Ошибка", message: "Пожалуйста, заполните поля Имя и Телефон", preferredStyle: .alert)
            let viewController = self.view as! UIViewController
            let okAction = UIAlertAction.init(title: "Хорошо", style: .cancel)
            alert.addAction(okAction)
            viewController.present(alert, animated: true)
            return
        }

        let viewController = view as! UIViewController

        guard let orderItems = self.orderItems else {
            print("order items is empty")
            return
        }

        orderService.makeOrder(order: orderModel, allItems: orderItems) { [weak self] (success, error) in
            DispatchQueue.main.async {

            guard success, error == nil else {
                self?.view?.showError()
                return
            }

            self?.basketService.clear()
            let successViewController = SuccessOrderViewController.init(nibName: "SuccessOrderViewController", bundle: nil)
            successViewController.doneHandler = {
                viewController.presentingViewController?.dismiss(animated: true)
            }
            successViewController.modalPresentationStyle = .custom
            viewController.modalPresentationStyle = .currentContext
            viewController.present(successViewController, animated: false)
            }
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
