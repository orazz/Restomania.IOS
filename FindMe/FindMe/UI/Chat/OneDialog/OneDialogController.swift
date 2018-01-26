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
import Toast_Swift

public class OneDialogController: UIViewController {

    //UI
    @IBOutlet private weak var messagesTable: UITableView!
    @IBOutlet private weak var inputField: FMTextField!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var controlsPanel: UIView!
    private var keyboardOffsetConstraint: NSLayoutConstraint!
    private var interfaceLoader: InterfaceLoader!
    private var refreshControl: UIRefreshControl!
    private var messagesCache: [Long: OneDialogMessage] = [:]

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

        self.title = dialog.name
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
        _ = messagesCache.values.map({ $0.viewWillDisappear() })
        messagesCache.removeAll()
    }

    private func loadMarkup() {

        interfaceLoader = InterfaceLoader(for: self.view)
        refreshControl = messagesTable.addRefreshControl(target: self, selector: #selector(needReload))
        refreshControl.attributedTitle = nil

        for constraint in controlsPanel.superview?.constraints ?? [] {
            if (constraint.identifier == "KeyboardOffset") {
                keyboardOffsetConstraint = constraint
                break
            }
        }

        controlsPanel.backgroundColor = ThemeSettings.Colors.background
        controlsPanel.layer.shadowColor = ThemeSettings.Colors.divider.cgColor

        setupTable()
    }
    @objc private func needReload() {
        loadAdapter.startRequest()
        requestData()
    }
    private func loadData() {

        let cached = displayCached()
        if (cached.isEmpty) {
            interfaceLoader.show()
        }

        requestData()
    }
    private func requestData() {

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

        messagesTable.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi));
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
        return createMessageWrapper(for: indexPath).countHeight()
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createMessageWrapper(for: indexPath)
    }
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? OneDialogMessage {
            cell.willDisplay()
        }
    }
    private func createMessageWrapper(for indexPath: IndexPath) -> OneDialogMessage {

        let message = messages[indexPath.row]

        if let cell = messagesCache[message.ID] {
            cell.update(by: message)
        }
        else {
            if (message.isSended) {
                messagesCache[message.ID] = OneDialogSendingMessage.create(for: message)
            }
            else {
                messagesCache[message.ID] = OneDialogReceivedMessage.create(for: message)
            }
        }

        return messagesCache[message.ID]!
    }
}
//Write message
extension OneDialogController {
    @IBAction private func sendMessage() {

        let message = inputField.text
        if (String.isNullOrEmpty(message)) {
            return
        }

        inputField.text = String.empty

        let container = SendingMessage(toDialog: dialog.ID, content: message!, and: [])
        let stub = container.createStub()
        messages.append(stub)
        applyData()
        _ = dialogsService.updateLastMessage(for: stub.dialogId, by: stub)

        let request = self.messagesService.send(container)
        request.async(self.loadQueue, completion: { response in

            DispatchQueue.main.async {
                if (response.isFail) {
                    self.inputField.text = message
                    self.view.makeToast("Проблемы с отправкой сообщения. Проверьте подключение к интернету.", position: .top)
                }
                else {
                    if let index = self.messages.index(where: { $0 === stub }),
                        let message = self.messagesService.cache.find({ $0.ID == response.data!.ID }) {
                            self.messages[index] = message
                            self.applyData()
                            _ = self.dialogsService.updateLastMessage(for: message.dialogId, by: message)
                    }
                }
            }
        })
    }
}
//Get messages
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
    @IBAction private func tryCloseKeyboard() {
        self.view.endEditing(true)
    }
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

