//
//  ImagesController.swift
//  FindMe
//
//  Created by Алексей on 06.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

@objc public protocol ImagesControllerDelegate {
    @objc optional func move(vc: ImagesController, to slide: Int)
    @objc optional func close(vc: ImagesController)
}
public class ImagesController: UIViewController {

    private static let nibName = "ImagesControllerView"
    public static func instance(images: [ImageContainer]) -> ImagesController {

        let instance = ImagesController(nibName: nibName, bundle: Bundle.main)
        instance.setup(images: images)
        instance.focusOn(slide: 0)

        return instance
    }

    //UI elements
    @IBOutlet private weak var sliderView: SliderControl!
    @IBOutlet private weak var navigationTitle: UINavigationItem!
//    @IBOutlet private weak var sliderIndicator: SliderIndicator!

    //Data & services
    private let _tag = String.tag(ImagesController.self)
    private var _images: [ImageContainer] = []
    private var _slides: [ImageControllerSlide] = []
    private var _isSetup: Bool = false
    private var _current: Int = 0

    //MARK: View life circle
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setup()
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Log.debug(_tag, "Open modal for \(_images.count) images.")
    }
    private func setup() {
        if (_isSetup){
            return
        }
        _isSetup = true

        setup(images: _images)
        focusOn(slide: _current)
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //MARK: Methods
    public var delegate: ImagesControllerDelegate?
    public var currentSlide: Int {
        return sliderView.current
    }
    public func focusOn(slide: Int) {

        _current = slide
        sliderView?.focusOn(slide: slide)
    }
    public func setup(images: [ImageContainer]) {

        _images = images
        _slides = images.map({ ImageControllerSlide.instance(image: $0) })
        sliderView?.setup(slides: _slides)
        sliderView?.delegate = self
        updateTitle()
    }

    //MARK: Actions
    @IBAction private func swipeTop() {

        delegate?.close?(vc: self)

        self.dismiss(animated: false, completion: {
            Log.debug(self._tag, "Close modal.")
        } )
    }
    private func updateTitle() {
        navigationTitle?.title = "\(_current + 1) из \(_images.count)"
    }

    public class ImageContainer {

        public let link: String
        public let description: String

        public convenience init(link: String) {
            self.init(link: link, description: String.empty)
        }
        public init(link: String, description: String) {

            self.link = link
            self.description = description
        }
    }
}

extension ImagesController: SliderControlDelegate {
    public func move(slider: SliderControl, focusOn: Int) {

        _current = focusOn
        updateTitle()

        delegate?.move?(vc: self, to: focusOn)
    }
}
