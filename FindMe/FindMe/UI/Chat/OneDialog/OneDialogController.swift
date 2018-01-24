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

public class OneDialogController: UIViewController {

    //UI
    @IBOutlet private weak var messagesTable: UITableView!
    @IBOutlet private weak var inputField: FMTextField!
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var controlsPanel: UIView!

    //Services
    private let dialogsService = CacheServices.chatDialogs
    private let messagesService = CacheServices.chatMessages

    //Data
    private let _tag = String.tag(OneDialogController.self)
    private let guid = Guid.new
    private let dialog: ChatDialog

    //Lifecirlce
    public init(for dialog: ChatDialog) {
        self.dialog = dialog

        super.init(nibName: "\(String.tag(OneDialogController.self))View", bundle: Bundle.main)
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
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    private func loadMarkup() {}
    private func loadData() {}
}
