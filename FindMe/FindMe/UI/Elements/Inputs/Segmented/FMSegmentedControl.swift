//
//  FMSegmentedControl.swift
//  FindMe
//
//  Created by Алексей on 19.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

@objc public protocol FMSegmentedControlDelegate {

    @objc optional func changeValue(_ segmentedControl: UISegmentedControl, index: Int, value: Any)
}
public class FMSegmentedControl: UIView {

    public static let height = CGFloat(45)
    private let nibName = "FMSegmentedControl"



    //MARK: UI elements
    @IBOutlet public weak var contentView: UIView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var segmentedControl: UISegmentedControl!



    //MARK: Callbacks
    public var delegate: FMSegmentedControlDelegate?
    public var onChangeEvent: ((_: UISegmentedControl, _: Int, _: Any ) -> Void)?



    //MARK: Properties
    public var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    public var values: [String: Any]! {
        didSet {
            updateSegments(range: values)
        }
    }
    public var value: Any {

        let index = segmentedControl.selectedSegmentIndex
        let title = segmentedControl.titleForSegment(at: index)!
        return values[title]!
    }



    public override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }
    private func setup() {

        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.setContraint(height: CGFloat(FMTextField.height))


        titleLabel.font = ThemeSettings.Fonts.default(size: .subhead)
        titleLabel.text = nil

        segmentedControl.addTarget(self, action: #selector(changeValue), for: .valueChanged)
    }
    private func updateSegments(range: [String: Any?]) {

        segmentedControl.removeAllSegments()

        for (key, _) in range {
            segmentedControl.insertSegment(withTitle: key, at: 0, animated: false)
        }

        if (range.count > 0) {
            segmentedControl.selectedSegmentIndex = 0
        }
    }



    //MARK: Actions
    public func select(_ newValue: Any) {

        var index = 0
        for (_, value) in values.reversed() {
            if ((value as AnyObject).isEqual(newValue)) {

                segmentedControl.selectedSegmentIndex = index
                return
            }
            index += 1
        }

        if (!values.isEmpty){
            segmentedControl.selectedSegmentIndex = 0
        }
    }
    public func select(_ index: Int) {

        segmentedControl.selectedSegmentIndex = index % values.count

        notify()
    }
    @objc private func changeValue() {
        notify()
    }
    private func notify() {

        let index = segmentedControl.selectedSegmentIndex
        delegate?.changeValue?(segmentedControl, index: index, value: value)
        onChangeEvent?(segmentedControl, index, value)
    }


}
