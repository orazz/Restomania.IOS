//
//  OnePlaceController.swift
//  FindMe
//
//  Created by Алексей on 06.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

internal protocol OnePlaceMainCellProtocol: InterfaceTableCellProtocol {

    func update(by: DisplayPlaceInfo)
}
public class OnePlaceMainController: UIViewController {

    private static let nibName = "OnePlaceMainView"
    public static func build(placeId: Long) -> OnePlaceMainController {

        let vc = OnePlaceMainController(nibName: nibName, bundle: Bundle.main)

        vc.placeId = placeId
        vc.cache = CacheServices.places
        vc.likes = ServicesFactory.shared.likes

        return vc
    }


    //MARK: UIElements
    @IBOutlet weak var contentTable: UITableView!
    private var contentAdapter: InterfaceTable!
    @IBOutlet weak var likeButton: UIBarButtonItem!
    private var loader: InterfaceLoader!
    private var refreshControl: UIRefreshControl!

    //MARK: Data
    private var placeId: Long!
    private var place: DisplayPlaceInfo? = nil
    private var cache: PlacesCacheService!
    private var likes: LikesService!


    //View controller circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        loader = InterfaceLoader(for: self.view)

        refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = ThemeSettings.Colors.background
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        contentTable.addSubview(refreshControl)

        setupLikeButton()

        let rows = buildRows()
        contentAdapter = InterfaceTable(source: contentTable, navigator: self.navigationController!, rows: rows)

        loadData(manual: false)
    }
    private func setupLikeButton() {

        var image = ThemeSettings.Images.heartInactive
        if (likes.isLiked(place: placeId)){

            image = ThemeSettings.Images.heartActive
        }

        likeButton.image = image.withRenderingMode(.alwaysOriginal)
    }
    private func buildRows() -> [OnePlaceMainCellProtocol] {

        var result = [OnePlaceMainCellProtocol]()

        result.append(OnePlaceMainTitleCell.instance)
        result.append(OnePlaceMainSliderCell.instance)
        result.append(OnePlaceMainAddressCell.instance)
        result.append(OnePlaceMainStatisticCell.create(with: self.navigationController!))

        let description = OnePlaceMainDescriptionCell.instance
        result.append(description)
        result.append(OnePlaceMainDividerCell.instance(for: description))

//        let actions = OnePlaceMainContactsCell.instance
//        result(actions)
//        result.add(OnePlaceMainDividerCell.instance(for: actions))

        let contacts = OnePlaceMainContactsCell.instance
        result.append(contacts)
        result.append(OnePlaceMainDividerCell.instance(for: contacts))

        result.append(OnePlaceMainLocationCell.instance)
        result.append(OnePlaceMainSpaceCell.instance)

        return result
    }

    @objc private func refreshData() {
        loadData(manual: true)
    }
    private func loadData(manual: Bool) {

        if  !manual, let place = cache.findLocal(id: placeId) {

            completeLoad(place)
            return
        }

        if (isNeedLoad) {
            loader.show()
        }

        let task = cache.findRemote(id: placeId)
        task.async(.background, completion: { response in
            DispatchQueue.main.async {

                if let place = response {
                    self.completeLoad(place)
                }
                else if (!manual) {
                    self.goBack()

                    let alert = UIAlertController(title: "Ошибка", message: "Проблемы с получение данных заведения. Проверьте подключение к интернету и попробуйте позже.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.navigationController?.present(alert, animated: true, completion: nil)

                    return
                }

            }
        })
    }
    private func completeLoad(_ place: DisplayPlaceInfo) {

        self.place = place

        for it in contentAdapter.rows {
            if let cell = it as? OnePlaceMainCellProtocol {
                cell.update(by: place)
            }
        }

        contentAdapter.reload()

        if (refreshControl.isEnabled) {
            refreshControl.endRefreshing()
        }

        if (!isNeedLoad) {
            loader.hide()
        }
    }
    private var isNeedLoad: Bool {
        return nil == place
    }


    //MARK: Actions
    @IBAction public func goBack() {

        self.navigationController?.popViewController(animated: true)
    }
    @IBAction public func likePlace() {

        if (likes.isLiked(place: placeId)){
            likes.unlike(place: placeId)
        }
        else {
            likes.like(place: placeId)
        }

        setupLikeButton()
    }
}
public class OnePlaceMainSubheadLabel: FMSubheadLabel {

    public override func initialize() {
        super.initialize()

        textColor = ThemeSettings.Colors.main
        font = ThemeSettings.Fonts.bold(size: .subhead)
    }
}
