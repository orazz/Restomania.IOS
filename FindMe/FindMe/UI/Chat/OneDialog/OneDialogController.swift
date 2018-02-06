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
import Gloss

public class OneDialogController: UIViewController {

    //UI
    @IBOutlet private weak var messagesTable: UITableView!
    @IBOutlet private weak var inputField: UITextField!
    @IBOutlet private weak var selectAttachmentButton: UIButton!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var controlsPanel: UIView!
    private var keyboardOffsetConstraint: NSLayoutConstraint!
    private var interfaceLoader: InterfaceLoader!
    private var refreshControl: UIRefreshControl!
    private var messagesCache: [OneDialogMessage] = []
    private var imagePicker: UIImagePickerController!

    //Services
    private let dialogsService = CacheServices.chatDialogs
    private let messagesService = CacheServices.chatMessages
    private let messagesContainer: PartsLoadTypedContainer<[ChatMessage]>
    private let loadAdapter: PartsLoader

    //Data
    private let _tag = String.tag(OneDialogController.self)
    private let guid = Guid.new
    private let loadQueue: AsyncQueue
    private let apiQueue: AsyncQueue
    private let dialog: ChatDialog
    private var messages: [DialogMessageModelProtocol] = []

    //Lifecirlce
    public init(for dialog: ChatDialog) {
        self.dialog = dialog

        messagesContainer = PartsLoadTypedContainer<[ChatMessage]>()
        loadAdapter = PartsLoader([messagesContainer])

        loadQueue = AsyncQueue.createForControllerLoad(for: String.tag(OneDialogController.self))
        apiQueue = AsyncQueue.createForApi(for: String.tag(OneDialogController.self))

        super.init(nibName: "\(String.tag(OneDialogController.self))View", bundle: Bundle.main)

        self.title = dialog.name
        messagesContainer.updateHandler = { update in
            DispatchQueue.main.async {

                let sorted = update.sorted(by: { $0.CreateAt > $1.CreateAt })
                let needReload = sorted.any({ e in nil == self.messages.find({ e.ID == $0.id }) })
                self.messages = sorted.map({ SimpleDialogMessageModel(for: $0) })
                if (needReload) {
                    self.applyData()
                }
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
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        messagesCache.each({ $0.viewWillDisappear() })
        messagesCache.removeAll()
        unsubscribeOnOpenKeyboard()
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

        controlsPanel.backgroundColor = UIColor(red: 245, green: 245, blue: 245)
        controlsPanel.layer.shadowColor = ThemeSettings.Colors.divider.cgColor

        inputField.placeholder = "Введите сообщение"
        inputField.font = ThemeSettings.Fonts.default(size: .subhead)
        inputField.textColor = ThemeSettings.Colors.blackText
        //inputField.text = "😀"

        setupTable()

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
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

        messagesTable.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        messagesTable.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width - 10)
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
        return createMessageWrapper(for: indexPath).height
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

        let row = indexPath.row
        if  (row < messagesCache.count) {
            let cell = messagesCache[row]
            cell.apply(message)

            return cell
        }
        else {
            var cell: OneDialogMessage? = nil
            if (message.isOutgoing) {
                cell = OneDialogSendingMessage.create(for: message)
            }
            else {
                cell = OneDialogReceivedMessage.create(for: message)
            }
            messagesCache.append(cell!)
            
            return cell!
        }
    }
}
//Write message
extension OneDialogController {
    @IBAction private func selectAttachment() {

        let alert = UIAlertController(title: "Отправить фото", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: { _ in self.openImagePicker(type: .camera) }))
        alert.addAction(UIAlertAction(title: "Взять из галлереи", style: .default, handler: { _ in self.openImagePicker(type: .photoLibrary) }))
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel))

        self.present(alert, animated: true, completion: nil)
    }
    private func openImagePicker(type: UIImagePickerControllerSourceType) {

        imagePicker.sourceType = type

        self.present(imagePicker, animated: true, completion: nil)
    }
    private func sendAttachment(_ image: UIImage) {

        guard let normalized = image.normalizeOrientation(),
                let dataUrl = DataUrl.convert(normalized) else {
            return
        }
        inputField.text = String.empty

        Log.info(_tag, "Send message with attachment.")

        let text = inputField.text ?? String.empty
//        let message = SendingMessage(toDialog: dialog.ID, content: text, attachments: [dataUrl] )
//        send(message, model: ChatMessageModel(source: message.createStub(), loadImages: [image]))
    }
    @IBAction private func sendMessage() {

        guard let text = inputField.text,
                    !String.isNullOrEmpty(text) else {
                return
        }
        inputField.text = String.empty

        Log.info(_tag, "Send simple message.")
        let message = SendingMessage(toDialog: dialog.ID, content: text)
        send(message, model: SendingDialogMessageModel(for: message, id: Long(-messages.count - 1)))
    }
    private func send(_ message: SendingMessage, model: DialogMessageModelProtocol) {

        let cell = OneDialogSendingMessage.create(for: model)
        messages.insert(model, at: 0)
        messagesCache.insert(cell, at: 0)
        applyData()

        _ = dialogsService.updateLastMessage(for: message.dialogId, by: model.buildMessage())

        let request = self.messagesService.send(message)
        request.async(apiQueue, completion: { response in
            DispatchQueue.main.async {

                if (response.isFail) {
                    self.inputField.text = message.content
                    self.view.makeToast("Проблемы с отправкой сообщения. Проверьте подключение к интернету.", position: .top)
                    return
                }


                if let index = self.messages.index(where: { $0.id == model.id }),
                    let message = self.messagesService.cache.find({ $0.ID == response.data!.ID }) {

                    _ = self.dialogsService.updateLastMessage(for: message.dialogId, by: message)

                    let update = SimpleDialogMessageModel(for: message)
                    self.messages[index] = update
                    cell.apply(update)
                    self.applyData()
                }
            }
        })
    }
}
//Pick image
extension OneDialogController: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            sendAttachment(pickedImage)
        }

        picker.dismiss(animated: true, completion: nil)
    }
}
extension OneDialogController: UINavigationControllerDelegate {}

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

//Models
extension OneDialogController {
    fileprivate class ChatMessageModel: ChatMessage {

        public var loadImages: [UIImage] = []

        public init(source: ChatMessage, loadImages: [UIImage]) {
            super.init(source: source)

            self.loadImages = loadImages
        }

        public required init(source: ChatMessage) {
            super.init(source: source)
        }
        public required init(json: JSON) {
            super.init(json: json)
        }
    }
}

