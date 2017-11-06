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

public class ManagerOneOrderController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private static let nibName = "ManagerOneOrderControllerView"
    public static func create(with order: DishOrder) -> ManagerOneOrderController {

        let vc = ManagerOneOrderController(nibName: nibName, bundle: Bundle.main)

        vc._orderId = order.ID
        vc._order = order

        return vc
    }

    //UI Elements
    @IBOutlet weak var CompleteDateLabel: UILabel!
    @IBOutlet weak var CreateAtLabel: UILabel!

    @IBOutlet weak var KeywordTitleLabel: UILabel!
    @IBOutlet weak var KeywordValueLabel: UILabel!

    @IBOutlet weak var PlaceNameTitleLabel: UILabel!
    @IBOutlet weak var PlaceNameValueLabel: UILabel!

    @IBOutlet weak var StatusTitleLabel: UILabel!
    @IBOutlet weak var StatusValueLabel: UILabel!

    @IBOutlet weak var TableView: UITableView!

    @IBOutlet weak var TotalTitleLabel: UILabel!
    @IBOutlet weak var TotalValueLabel: PriceLabel!

    // MARK: Data & services
    private let _tag = String.tag(ManagerOneOrderController.self)
    private var _orderId: Long!
    private var _order: DishOrder!
    private var _dateFormatter: DateFormatter {

        let result = DateFormatter()

        result.dateFormat = AppSummary.DataTimeFormat.dateWithTime
        result.timeZone = TimeZone(identifier: "UTC")

        return result
    }

    // MARK: Life circle
    override public func viewDidLoad() {
        super.viewDidLoad()

        ManagerOneOrderDishCell.register(for: TableView)

        setupStyles()
        setupDataToInterface()
    }
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showNavigationBar()
        navigationItem.title = "Заказ #\(_orderId)"

        loadOrder()
    }
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    // MARK: Methods
    private func loadOrder() {

        if (nil == _order) {

            fatalError("<\(self._tag)> Fuck, orderis  not setup.")
        }
    }
    private func setupDataToInterface() {

        CompleteDateLabel.text = "на \(_dateFormatter.string(from: _order!.Summary.CompleteDate))"
        CreateAtLabel.text = "добавлено \(_dateFormatter.string(from: _order!.Summary.CreateAt))"

        KeywordValueLabel.text = _order!.Summary.KeyWord
        PlaceNameValueLabel.text = _order!.Summary.PlaceName
        StatusValueLabel.text = prepare(status: _order!.Status)
        TotalValueLabel.setup(amount: _order!.TotalPrice, currency: _order!.Summary.Currency)
    }
    private func prepare(status: DishOrderStatus) -> String {

        switch(status) {

            case .Processing:
                return "В обработке"
            case .WaitingPayment:
                return "Ожидание оплаты"
            case .Making:
                return "Готовится"
            case .PaymentFail:
                return "Платеж отклонён"
            case .Completed:
                return "Завершен"
            case .CanceledByPlace:
                return "Отменён заведением"
            case .CanceledByUser:
                return "Отменён пользователем"
        }
    }
    private func setupStyles() {

        let boldFont = ThemeSettings.Fonts.bold(size: .head)
        let lightFont = ThemeSettings.Fonts.default(size: .head)

        self.view.backgroundColor = ThemeSettings.Colors.grey

        CompleteDateLabel.font = boldFont
        CreateAtLabel.font = ThemeSettings.Fonts.default(size: .subhead)

        KeywordTitleLabel.font = lightFont
        KeywordValueLabel.font = boldFont

        PlaceNameTitleLabel.font = lightFont
        PlaceNameValueLabel.font = boldFont

        StatusTitleLabel.font = lightFont
        StatusValueLabel.font = boldFont

        TotalTitleLabel.font = lightFont
        TotalValueLabel.font = boldFont

        if let constraint = (TableView.constraints.filter {$0.firstAttribute == .height}.first) {

            constraint.constant = ManagerOneOrderDishCell.height * CGFloat(_order!.Dishes.count)
        }
    }

    // MARK: UITableViewDelegate
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ManagerOneOrderDishCell.identifier, for: indexPath) as! ManagerOneOrderDishCell
        cell.setup(dish: _order!.Dishes[indexPath.row], currency: _order!.Summary.Currency)

        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: false)
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return ManagerOneOrderDishCell.height
    }

    // MARK: UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return _order?.Dishes.count ?? 0
    }
}
