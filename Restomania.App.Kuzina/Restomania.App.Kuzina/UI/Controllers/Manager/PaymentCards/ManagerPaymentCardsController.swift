//
//  PaymentCardsController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 11.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public protocol IPaymentCardsDelegate {

    func removeCard(id: Long)
}
public class PaymentCardsController: UIViewController,
                                      IPaymentCardsDelegate,
                                      UITableViewDelegate,
                                      UITableViewDataSource {

    private static let nibName = "ManagerPaymentCardsControllerView"
    public static func create() -> PaymentCardsController {

        let vc = PaymentCardsController(nibName: nibName, bundle: Bundle.main)

        vc._addCardService = AddPaymentCardService()
        vc._apiService = UserCardsApiService(storage: ServicesManager.shared.keysStorage)

        return vc
    }

    //UI elements
    @IBOutlet weak var TableView: UITableView!

    // MARK: Data & service
    private let _tag = String.tag(PaymentCardsController.self)
    private var _loader: InterfaceLoader!
    private var _addCardService: AddPaymentCardService!
    private var _apiService: UserCardsApiService!
    private var _cards = [PaymentCard]()

    // MARK: Life circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: PaymentCardCell.nibName, bundle: nil)
        TableView.register(nib, forCellReuseIdentifier: PaymentCardCell.identifier)

        _loader = InterfaceLoader(for: view)
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showNavigationBar()
        navigationItem.title = "Карты оплаты"

        loadCards()
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        hideNavigationBar()
    }

    private func loadCards() {

        _loader.show()

        let request = _apiService.alll()
        request.async(.background, completion: { response in

            DispatchQueue.main.async {

                if (!response.isSuccess) {

                    Log.Warning(self._tag, "problem with getting payment cards.")
                } else {

                    self._cards = response.data!
                    self.TableView.reloadData()
                }

                self._loader.hide()
            }

        })

    }

    // MARK: IPaymentCardsDelegate
    public func removeCard(id: Long) {

        Log.Debug(_tag, "Try remove #\(id) payment card.")

        let card = _cards.find({ id == $0.ID })
        let index = _cards.index(where: { id == $0.ID })
        if (nil == card) {
            return
        }

        //Update interface 
        _cards.remove(at: index!)
        TableView.reloadData()

        let request = _apiService.remove(cardID: id)
        request.async(.background, completion: { response in

            if (!response.isSuccess) {

                self._cards.insert(card!, at: index!)
                self.TableView.reloadData()

                let alert = UIAlertController()
                alert.message = "Проблемы с удалением карты, попробуйте позднее."
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                self.show(alert, sender: self)
            }
        })
    }
    @IBAction public func addCard() {

        Log.Debug(_tag, "Try add new payment card.")
        let currency = CurrencyType.RUB

        _addCardService.addCard(for: currency, on: self, complete: { success, _ in

            Log.Debug(self._tag, "Adding new card is \(success)")

            if (success) {

                DispatchQueue.main.async {

                    self.loadCards()
                }
            }
        })
    }

    // MARK: UITableViewDelegate
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let card = _cards[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentCardCell.identifier, for: indexPath) as! PaymentCardCell
        cell.setup(card: card, delegate: self)

        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath) as? PaymentCardCell
        cell?.Remove()
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return PaymentCardCell.height
    }

    // MARK: UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return _cards.count
    }
}
