//
//  OnePlaceMainContactsCell.swift
//  FindMe
//
//  Created by Алексей on 17.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class OnePlaceMainContactsCell: UITableViewCell {

    private static let nibName = "OnePlaceMainContactsCell"
    public static var instance: OnePlaceMainContactsCell {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first as! OnePlaceMainContactsCell

        instance._contacts = nil

        OnePlaceMainContactsCellOneLine.register(in: instance.ContactsTable)

        return instance
    }

    //MARK: UI elements
    @IBOutlet public weak var ContentView: UIView!
    @IBOutlet public weak var TitleLabel: UILabel!
    @IBOutlet public weak var ContactsTable: UITableView!


    //MARK: Data & Services
    private var _contacts: Contacts? {
        didSet {
            updateContacts()
        }
    }
    private var _lines:[ContactLine] = []

    private func updateContacts() {

        if (!needShow()) {
            return
        }

        let contacts = _contacts!
        _lines = []
        add(contacts.phone, for: "Телефон", to: _lines)
        add(contacts.secondPhone, for: "Телефон", to: _lines)
        add(contacts.vk, for: "Вконтакте", to: _lines)
        add(contacts.facebook, for: "Facebook", to: _lines)
        add(contacts.instagram, for: "Instagram", to: _lines)
        add(contacts.email, for: "Email", to: _lines)
        add(contacts.website, for: "Сайт", to: _lines)
        add(contacts.whatsapp, for: "Whatsapp", to: _lines)
        add(contacts.viber, for: "Viber", to: _lines)

        ContactsTable.reloadData()

        resize()
    }
    private func add(_ link: String?, for name: String, to range: [ContactLine])  {

        let line = ContactLine(name: name, link: link)
        if (line.isCorrect) {

            _lines.append(line)
        }
    }
    private func resize() {

        ContactsTable.layoutIfNeeded()
        let contactsTableHeight = ContactsTable.contentSize.height
        ContactsTable.setContraint(height: contactsTableHeight)

        var contentHeight = CGFloat(0)
        contentHeight = contentHeight + TitleLabel.getParentConstant(.top)! + TitleLabel.getConstant(.height)!
        contentHeight = contentHeight + ContactsTable.getParentConstant(.top)! + contactsTableHeight + CGFloat(5) //Offset bottom

        ContentView.setContraint(height: contentHeight)
    }

    public class ContactLine {

        public let name: String
        public let link: String
        public var displayValue: String

        public var isCorrect: Bool {
            return !String.isNullOrEmpty(link)
        }

        public init(name: String, link: String?) {

            self.name = name
            self.link = link ?? String.empty
            self.displayValue = self.link

            if (isCorrect) {
                self.displayValue = link!.components(separatedBy: "://").last!
                                          .components(separatedBy: "www.").last!
                                          .components(separatedBy: ".com/").last!
                                          .components(separatedBy: "/").first!
            }
        }
    }
}



//Table delegate and source
extension OnePlaceMainContactsCell: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: false)

        return nil
    }
}
extension OnePlaceMainContactsCell: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _lines.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: OnePlaceMainContactsCellOneLine.identifier, for: indexPath) as! OnePlaceMainContactsCellOneLine
        cell.setup(data: _lines[indexPath.row])

        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OnePlaceMainContactsCellOneLine.height
    }
}



//Cells
extension OnePlaceMainContactsCell: OnePlaceShowDividerDelegate {

    public func needShow() -> Bool {
        return nil != _contacts
    }
}
extension OnePlaceMainContactsCell: OnePlaceMainCellProtocol {

    public func update(by place: Place) {
        _contacts = place.contacts
    }
}
extension OnePlaceMainContactsCell: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        if (needShow()) {
            return Int(ContentView.getConstant(.height)!)
        }
        else {
            return 0
        }
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
