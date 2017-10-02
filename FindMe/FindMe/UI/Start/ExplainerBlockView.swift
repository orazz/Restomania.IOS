//
//  ExplainerBlockController.swift
//  FindMe
//
//  Created by Алексей on 02.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class ExplainerBlockView: UIView {

    private static let nibName = "ExplainerBlock"
    public static func build(image: UIImage?, text: String) -> ExplainerBlockView {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance =  nib.instantiate(withOwner: nil, options: nil).first! as! ExplainerBlockView

        instance.Image.image = image
        instance.Text.text = text

        return instance
    }

    @IBOutlet public weak var Image: UIImageView!
    @IBOutlet public weak var Text: UILabel!

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupStyles()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupStyles()
    }
    private func setupStyles() {

        Image?.layer.cornerRadius = 5.0
        Image?.clipsToBounds = true
    }
}
