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

public class OnePlaceController: UIViewController {

    private static let nibName = "OnePlaceView"
    public static func build(placeId: Long) -> OnePlaceController {

        let instance = OnePlaceController(nibName: nibName, bundle: Bundle.main)

        instance._placeId = placeId
        instance._apiService = PlacesMainApiService(ServicesFactory.shared.configs)

        return instance
    }


    //MARK: UIElements
    @IBOutlet weak var ContentView: BuildedView!
    private var _loader: InterfaceLoader!

    //MARK: Data
    private var _placeId: Long!
    private var _apiService: PlacesMainApiService!
    private var _source: Place? = nil


    //View controller circle
    public override func viewDidLoad() {
        super.viewDidLoad()

        _loader = InterfaceLoader(for: self.view)

        loadData()
    }
    private func loadData() {

        _loader.show()

        let task = _apiService.Find(placeId: _placeId)
        task.async(.background, completion: { response in
            DispatchQueue.main.async {

                if (response.isFail) {

                    self.navigationController?.popViewController(animated: true)

                    let alert = UIAlertController(title: "Ошибка", message: "Проблемы с получение данных заведения. Проверьте подключение к интернету и попробуйте позже.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.navigationController?.present(alert, animated: true, completion: nil)

                    return
                }

                let place = response.data!
                self._source = place
                self.buildPage(for: place)

                self._loader.hide()
            }
        })
    }
    private func buildPage(for place: Place) {

        ContentView.addSubview(OnePlaceViewHeader.build(place: place))
//        ContentView.addPart(OnePlaceViewAddress.build(place: place))
    }


    //MARK: Actions
    @IBAction public func goBack() {

        self.navigationController?.popViewController(animated: true)
    }


    public class BuildedView: UIScrollView {

        private var _offsetTop: CGFloat = CGFloat(0)

        public func addPart(_ view: UIView) {

            let frame = view.frame
            let source = self.frame
            view.frame = CGRect(x: 0, y: _offsetTop, width: source.width, height: frame.height)
            addSubview(view)

            _offsetTop = _offsetTop + frame.height
        }
    }
}
