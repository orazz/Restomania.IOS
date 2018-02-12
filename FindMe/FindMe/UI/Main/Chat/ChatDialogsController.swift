//
//  ChatDialogsController.swift
//  FindMe
//
//  Created by Алексей on 24.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class ChatDialogsController: UIViewController {


    //UI
    @IBOutlet private weak var dialogsTable: UITableView!
    private var refreshControl: UIRefreshControl!
    private var interfaceLoader: InterfaceLoader!

    //Services
    private let dialogsService = CacheServices.chatDialogs
    private let messagesService = CacheServices.chatMessages
    private var dialogsContainer: PartsLoadTypedContainer<[ChatDialog]>!
    private var loadAdapter: PartsLoader!

    //Data
    private let _tag = String.tag(ChatDialogsController.self)
    private let guid = Guid.new
    private var dialogs: [ChatDialog] = []
    private var loadQueue: AsyncQueue!

    //Life circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = dialogsTable.addRefreshControl(target: self, selector: #selector(needReload))
        interfaceLoader = InterfaceLoader(for: self.view)

        dialogsService.subscribe(guid: guid, handler: self, tag: tag)
        dialogsContainer = PartsLoadTypedContainer<[ChatDialog]>()
        dialogsContainer.updateHandler = { update in

            self.dialogs = update.sorted(by: { $0.lastActivity > $1.lastActivity })
            DispatchQueue.main.async {
                self.applyData()
            }
        }
        dialogsContainer.completeLoadHandler = {
            DispatchQueue.main.async {
                self.completeLoad()
            }
        }
        loadAdapter = PartsLoader([dialogsContainer])

        loadQueue = AsyncQueue.createForControllerLoad(for: _tag)

        loadMarkup()
        loadData()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        _ = messagesService.new(with: SelectParameters())
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }





    private func loadMarkup() {

        self.view.backgroundColor = ThemeSettings.Colors.background

        ChatDialogsDialogRow.register(in: dialogsTable)
        self.dialogsTable.delegate = self
        self.dialogsTable.dataSource = self
        self.dialogsTable.backgroundColor = ThemeSettings.Colors.background
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

        let request = dialogsService.all(with: SelectParameters())
        request.async(loadQueue, completion: dialogsContainer.completeLoad)
    }
    private func completeLoad() {

        if (loadAdapter.isLoad) {

            refreshControl.endRefreshing()
            interfaceLoader.hide()
        }
    }
    private func displayCached() -> [ChatDialog] {

        let cached = dialogsService.cache.all
        dialogsContainer.update(cached)

        return cached
    }
    private func applyData() {
        dialogsTable.reloadData()
    }
}
extension ChatDialogsController {
    public func dialog(with userId: Long) -> ChatDialog? {
        return dialogsService.cache.find({ !$0.isGroup && $0.recipientId == userId })
    }
    public func start(with userId: Long) -> RequestResult<ChatDialog> {
        return dialogsService.add(for: userId)
    }
    public func controllerFor(dialogId: Long) -> OneDialogController? {

        guard let dialog = dialogsService.cache.find(dialogId) else {
            return nil
        }

        return OneDialogController(for: dialog)
    }
    public func open(_ dialogId: Long) {

        if let vc = controllerFor(dialogId: dialogId) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension ChatDialogsController: ChatDialogsCacheServiceDelegate {
    public func dialogsService(_ service: ChatDialogsCacheService, new dialog: ChatDialog) {
        _ = displayCached()
    }
    public func dialogsService(_ service: ChatDialogsCacheService, update dialog: ChatDialog) {
        _ = displayCached()
    }
}
extension ChatDialogsController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let dialog = dialogs[indexPath.row]
        Log.debug(_tag, "Select dialog #\(dialog.ID)")
        open(dialog.ID)
    }
}
extension ChatDialogsController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogs.count
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ChatDialogsDialogRow.height
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let row = tableView.dequeueReusableCell(withIdentifier: ChatDialogsDialogRow.identifier, for: indexPath) as! ChatDialogsDialogRow
        row.update(by: dialogs[indexPath.row])

        return row
    }
}
