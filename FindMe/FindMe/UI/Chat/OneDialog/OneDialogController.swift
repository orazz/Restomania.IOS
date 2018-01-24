//
//  OneDialogController.swift
//  FindMe
//
//  Created by Алексей on 25.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary
import AsyncTask

public class OneDialogController: UIViewController {

    //UI
    @IBOutlet private weak var messagesTable: UITableView!
    @IBOutlet private weak var inputField: FMTextField!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var controlsPanel: UIView!
    private var keyboardOffsetConstraint: NSLayoutConstraint!
    private var interfaceLoader: InterfaceLoader!
    private var refreshControl: UIRefreshControl!

    //Services
    private let dialogsService = CacheServices.chatDialogs
    private let messagesService = CacheServices.chatMessages
    private let messagesContainer: PartsLoadTypedContainer<[ChatMessage]>
    private let loadAdapter: PartsLoader

    //Data
    private let _tag = String.tag(OneDialogController.self)
    private let guid = Guid.new
    private let loadQueue: AsyncQueue
    private let dialog: ChatDialog
    private var messages: [ChatMessage] = []

    //Lifecirlce
    public init(for dialog: ChatDialog) {
        self.dialog = dialog

        messagesContainer = PartsLoadTypedContainer<[ChatMessage]>()
        loadAdapter = PartsLoader([messagesContainer])

        loadQueue = AsyncQueue.createForControllerLoad(for: String.tag(OneDialogController.self))

        super.init(nibName: "\(String.tag(OneDialogController.self))View", bundle: Bundle.main)

        messagesContainer.updateHandler = { update in
            DispatchQueue.main.async {
                self.messages = update.sorted(by: { $0.CreateAt > $1.CreateAt })
                self.applyData()
            }
        }
        messagesContainer.completeLoadHandler = {
            DispatchQueue.main.async {
                self.completeLoad()
            }
        }
        messagesService.subscribe(guid: guid, handler: self, tag: tag)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        loadMarkup()
        loadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.edgesForExtendedLayout = []

        subscribeOnOpenKeyboard()
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        unsubscribeOnOpenKeyboard()
    }

    private func loadMarkup() {

        for constraint in controlsPanel.superview?.constraints ?? [] {
            if (constraint.identifier == "KeyboardOffset") {
                keyboardOffsetConstraint = constraint
                break
            }
        }

        updateTableContentInset()
    }
    private func loadData() {

        let cached = displayCached()
        if (cached.isEmpty) {
            interfaceLoader.show()
        }

        requestData()
    }
    private func requestData() {

        messagesContainer.startRequest()
        let request = messagesService.all(from: dialog.ID, with: SelectParameters())
        request.async(loadQueue, completion: self.messagesContainer.completeLoad)
    }
    private func completeLoad() {

        if (loadAdapter.isLoad) {

            interfaceLoader.hide()
            refreshControl.endRefreshing()
        }
    }
    private func displayCached() -> [ChatMessage] {

        let cached = messagesService.cache.where({ $0.dialogId == self.dialog.ID })
        messagesContainer.update(cached)

        return cached
    }
    private func applyData() {

        messagesTable.reloadData()
    }
}
//Table
extension OneDialogController: UITableViewDelegate {
    private func setupTable() {

        messagesTable.delegate = self
        messagesTable.dataSource = self

        let numRows = tableView(messagesTable, numberOfRowsInSection: 0)
        var contentInsetTop = messagesTable.bounds.size.height
        for i in 0..<numRows {
            contentInsetTop -= tableView(messagesTable, heightForRowAt: IndexPath(item: i, section: 0))
            if contentInsetTop <= 0 {
                contentInsetTop = 0
            }
        }
        messagesTable.contentInset = UIEdgeInsetsMake(contentInsetTop, 0, 0, 0)
    }

}
extension OneDialogController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
//Messages
extension OneDialogController: ChatMessagesCacheServiceDelegate {
    public func messagesService(_ service: ChatMessagesCacheService, new message: ChatMessage) {
        if (message.dialogId == dialog.ID) {
            _ = displayCached()
        }
    }
    public func messagesService(_ service: ChatMessagesCacheService, updates messages: [ChatMessage]) {
        _ = displayCached()
    }
}
//Keysboard
extension OneDialogController {
    public func subscribeOnOpenKeyboard() {

        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keysboardOpen), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keysboardClose), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    public func unsubscribeOnOpenKeyboard() {

        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc private func keysboardOpen(notification: NSNotification) {

        DispatchQueue.main.async {
            self.keyboardOffsetConstraint?.constant = super.realKeyboardHeight(for: notification)
        }
    }
    @objc private func keysboardClose(notification: NSNotification) {
        DispatchQueue.main.async {
            self.keyboardOffsetConstraint?.constant = 0.0
        }
    }
}

