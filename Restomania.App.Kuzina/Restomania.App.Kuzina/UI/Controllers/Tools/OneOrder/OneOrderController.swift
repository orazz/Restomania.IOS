//
//  OneOrderController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public protocol OneOrderInterfacePart: InterfaceTableCellProtocol {
    func update(by: DishOrder)
}
public protocol OneOrderControllerDelegate {
    var orderId: Long { get }
    var order: DishOrder? { get }
}
public class OneOrderController: UIViewController {

    //UI Elements

    @IBOutlet weak var CreateAtLabel: UILabel!

    @IBOutlet weak var TableView: UITableView!

    @IBOutlet weak var TotalTitleLabel: UILabel!
    @IBOutlet weak var TotalValueLabel: PriceLabel!

    @IBOutlet weak var CancelButton: BlackBottomButton!
    @IBOutlet
    private weak var interfaceTable: UITableView!
    private var interfaceAdapter: InterfaceTable!
    private var interfaceParts: [OneOrderInterfacePart] = []

    //Services
    private let  _ordersApiService = ApiServices.Users.orders

    // MARK: Data & services
    private let _tag = String.tag(OneOrderController.self)
    private var orderId: Long!
    private var _order: DishOrder!
    private var _dateFormatter: DateFormatter {

        let result = DateFormatter()

        result.dateFormat = AppSummary.DataTimeFormat.dateWithTime
        result.timeZone = TimeZone(identifier: "UTC")

        return result
    }

    // MARK: Life circle
    public init(for orderId: Long) {
        super.init(nibName: "\(String.tag(OneOrderController.self))View", bundle: Bundle.main)

        self.orderId = orderId
    }
    public required convenience init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented init from coder for \(String.tag(OneOrderController.self))")
    }
    override public func viewDidLoad() {
        super.viewDidLoad()

        interfaceParts = loadParts()
        interfaceAdapter = InterfaceTable(source: interfaceTable, navigator: self.navigationController!, rows: interfaceParts)

        loadMarkup()
        loadData()
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showNavigationBar()
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    private func loadMarkup() {

        navigationItem.title = String(format: Keys.title.localized, orderId!)

        CancelButton.setTitle(Keys.cancelOrderButton.localized, for: .normal)

//        let boldFont = ThemeSettings.Fonts.bold(size: .head)
//        let lightFont = ThemeSettings.Fonts.default(size: .head)
//
//        self.view.backgroundColor = ThemeSettings.Colors.grey
//
//        CompleteDateLabel.font = boldFont
//        CreateAtLabel.font = ThemeSettings.Fonts.default(size: .subhead)
//
//        CodewordTitleLabel.font = lightFont
//        CodeworddValueLabel.font = boldFont
//
//        PlaceNameTitleLabel.font = lightFont
//        PlaceNameValueLabel.font = boldFont
//
//        StatusTitleLabel.font = lightFont
//        StatusValueLabel.font = boldFont
//
//        TotalTitleLabel.font = lightFont
//        TotalValueLabel.font = boldFont

    }
    private func loadParts() -> [OneOrderInterfacePart] {

        var result = [OneOrderInterfacePart]()

        result.append(OneOrderSpaceContainer.instance)
        result.append(OneOrderSummaryContainer.instance)

        result.append(OneOrderSpaceContainer.instance)

        result.append(OneOrderSpaceContainer.instance)

        result.append(OneOrderSpaceContainer.instance)

        result.append(OneOrderSpaceContainer.instance)

        return result
    }
    // MARK: Methods
    private func loadData() {

        if (nil == _order) {

            fatalError("<\(self._tag)> Fuck, orderis  not setup.")
        }
    }
    private func applyOrder() {

        if let order = _order {
//            CompleteDateLabel.text = "на \(_dateFormatter.string(from: order.summary.completeAt))"
            CreateAtLabel.text = "добавлено \(_dateFormatter.string(from: order.summary.CreateAt))"
//
//            CodeworddValueLabel.text = order.summary.codeword
//            CodewordTitleLabel.isHidden = true
//            CodeworddValueLabel.isHidden = true
//
//            PlaceNameValueLabel.text = order.summary.placeName
//            StatusValueLabel.text = prepare(status: order.status)
            TotalValueLabel.setup(amount: order.total.double, currency: order.currency)

            CancelButton.isHidden = order.isCompleted
        }
    }
//    private func prepare(status: DishOrderStatus) -> String {
//
////        switch(status) {
////
////            case .processing:
////                return "В обработке"
////            case .waitingPayment:
////                return "Ожидание оплаты"
////            case .Making:
////                return "Готовится"
////            case .Prepared:
////                return "Готов к выдаче"
////            case .PaymentFail:
////                return "Платеж отклонён"
////            case .Completed:
////                return "Завершен"
////            case .CanceledByPlace:
////                return "Отменён заведением"
////            case .CanceledByUser:
////                return "Отменён пользователем"
////        }
//        return String.empty
//    }

    //Actions
    @IBAction private func cancelOrder() {

//        StatusValueLabel.text = prepare(status: DishOrderStatus.CanceledByUser)
        CancelButton.isHidden = true

        let request = _ordersApiService.cancel(orderId)
        request.async(.background, completion: { response in

            DispatchQueue.main.async {
                if (response.isFail) {

//                    self.StatusValueLabel.text = self.prepare(status: self._order.status)
                    self.CancelButton.isHidden = false

                    let alert = UIAlertController()
                    alert.message = "Проблемы с отменой заказа, попробуйте позднее"
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }

//    // MARK: UITableViewDelegate
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: OneOrderDishCell.identifier, for: indexPath) as! OneOrderDishCell
//        cell.update(dish: _order!.dishes[indexPath.row], currency: _order!.currency)
//
//        return cell
//    }
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        tableView.deselectRow(at: indexPath, animated: false)
//    }
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return OneOrderDishCell.height
//    }
//
//    // MARK: UITableViewDataSource
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return _order?.dishes.count ?? 0
//    }
}
extension OneOrderController {
    public enum Keys: String, Localizable {
        public var tableName: String {
            return String.tag(OneOrderController.self)
        }

        case title = "Title"

        case cancelOrderButton = "Buttons.CancelOrder"

        case codewordTitleLabel = "Labels.Codeword"
        case placeNameTitleLabel = "Labels.PlaceName"
        case statusTitleLabel = "Labels.Status"

        case completeAtLabel = "Labels.CompleteAt"
        case createAtLabel = "Labels.CreateAt"

        case timeFormat = "Formats.Time"
        case dateFormat = "Formats.Date"

        case statusProcessing = "DishOrder.Status.Processing"
        case statusWaitingPayment = "DishOrder.Status.WaitingPayment"
        case statusMaking = "DishOrder.Status.Making"
        case statusPrepared = "DishOrder.Status.Prepared"
        case statusPaymentFail = "DishOrder.Status.PaymentFail"
        case statusCompleted = "DishOrder.Status.Completed"
        case statusCanceledByPlace = "DishOrder.Status.CanceledByPlace"
        case statusCanceledByUser = "DishOrder.Status.CanceledByUser"
    }
}
