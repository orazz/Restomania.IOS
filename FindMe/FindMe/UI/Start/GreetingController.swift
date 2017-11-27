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
    
     private static let nibName = "GreetingController"
    public static func build(parent: StartController) -> GreetingController {

        let instance = GreetingController(nibName: nibName, bundle: Bundle.main)


        return instance
    }


    @IBOutlet weak var CloseImage: UIImageView!
    @IBOutlet weak var StartUseButton: UIButton!

    @IBOutlet weak var SliderIndicator: SliderIndicator!
    @IBOutlet weak var Slider: SliderControl!

    private var _isLoadSlider: Bool = false

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupHandlers()

        let properties = ToolsServices.shared.properties
        properties.set(.isShowExplainer, value: true)
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadSildes()
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
        let image = ThemeSettings.Images.default
        slides.append(ExplainerBlockView.build(image: image, text: "Ищите лучшие заведения"))
        slides.append(ExplainerBlockView.build(image: image, text: "Находите тех, кто хочет познакомиться"))
        slides.append(ExplainerBlockView.build(image: image, text: "Общайтесь"))

        Slider.delegate = self
        Slider.setup(slides: slides)
        SliderIndicator.setup(size: slides.count)
    }
    private func setupHandlers() {

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closePage))
        CloseImage.addGestureRecognizer(tap)
        CloseImage.isUserInteractionEnabled = true
    }

    //MARK: SliderControlDelegate
    public func move(slider: SliderControl, focusOn: Int) {

        SliderIndicator?.focusTo(index: focusOn)
    }
    //MARK: UIActions
    @IBAction public func startUse() {

        closePage()
    }
    @objc private func closePage() {

        self.navigationController?.popViewController(animated: false)
    }
}
