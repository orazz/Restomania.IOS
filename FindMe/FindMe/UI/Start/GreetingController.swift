//
//  Greeting.swift
//  FindMe
//
//  Created by Алексей on 25.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class GreetingController: UIViewController, SliderControlDelegate {
    
     private static let nibName = "GreetingView"
    public static func build(parent: StartController) -> GreetingController {

        var instance = GreetingController(nibName: nibName, bundle: Bundle.main)
        instance.source = parent

        return instance
    }


    @IBOutlet weak var CloseImage: UIImageView!
    @IBOutlet weak var StartUseButton: UIButton!

    @IBOutlet weak var SliderIndicator: SliderIndicator!
    @IBOutlet weak var Slider: SliderControl!

    public var source: StartController!
    private var _isLoadSlider: Bool = false

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupHandlers()

        let properties = ServicesFactory.shared.properties
        properties.set(.isShowExplainer, value: true)
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadSildes()

        self.navigationController?.isNavigationBarHidden = true
    }
    public override var prefersStatusBarHidden: Bool {
        return true
    }

    private func loadSildes() {

        if (_isLoadSlider){
            return
        }

        _isLoadSlider = true

        var slides = [ExplainerBlockView]()
        slides.append(ExplainerBlockView.build(image: nil, text: "Fuck"))
        slides.append(ExplainerBlockView.build(image: nil, text: "New"))
        slides.append(ExplainerBlockView.build(image: nil, text: "Fuck test"))
        slides.append(ExplainerBlockView.build(image: nil, text: "End"))

        Slider.delegate = self
        Slider.setup(slides: slides)
//        SliderIndicator.setup(size: slides.count)
    }
    private func setupHandlers() {

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closePage))
        CloseImage.addGestureRecognizer(tap)
        CloseImage.isUserInteractionEnabled = true
    }

    //MARK: SliderControlDelegate
    public func move(slider: SliderControl, focusOn: Int) {

//        SliderIndicator?.focusTo(index: focusOn)
    }
    //MARK: UIActions
    @IBAction public func startUse() {

        closePage()
    }
    @objc private func closePage() {

        self.navigationController?.popViewController(animated: false)
    }
}
