//
//  ProfileControllerChangeAvatar.swift
//  FindMe
//
//  Created by Алексей on 06.02.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class ProfileControllerChangeAvatar: UITableViewCell {

    public static func create(for delegate: ProfileControllerDelegate) -> ProfileControllerChangeAvatar {

        let cell: ProfileControllerChangeAvatar = UINib.instantiate(from: "\(String.tag(ProfileControllerChangeAvatar.self))View", bundle: Bundle.main)
        cell.delegate = delegate

        return cell
    }

    //UI
    @IBOutlet private weak var avatarImage: AvatarImage!
    private var imagePicker: UIImagePickerController!

    //Data
    private var delegate: ProfileControllerDelegate!

    public override func awakeFromNib() {
        super.awakeFromNib()

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }

    //Actions
    public func update(avatar: String) {
        avatarImage.setup(url: avatar)
    }
    @IBAction private func tryChangeAvatar() {

        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary

        let vc = delegate.takeController()
        vc.present(imagePicker, animated: true, completion: nil)
    }
}

//Image picker
extension ProfileControllerChangeAvatar: UIImagePickerControllerDelegate {


    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarImage.contentMode = .scaleAspectFill
            avatarImage.image = pickedImage

            delegate.changeAvatar(on: pickedImage)
        }

        picker.dismiss(animated: true, completion: nil)
    }
}
extension ProfileControllerChangeAvatar: UINavigationControllerDelegate {}
extension ProfileControllerChangeAvatar: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 140
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
