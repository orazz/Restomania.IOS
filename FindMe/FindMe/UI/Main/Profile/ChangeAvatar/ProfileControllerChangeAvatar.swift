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
    private var avatar: String? = nil

    public override func awakeFromNib() {
        super.awakeFromNib()

        avatarImage.contentMode = .scaleAspectFill
        avatarImage.clear()

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }

    //Actions
    public func update(avatar: String) {
        avatarImage.setup(url: avatar)

        self.avatar = avatar
    }
    @IBAction private func tryChangeAvatar() {

        let alert = UIAlertController(title: "Изменить аватар", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Сделать фото", style: .default, handler: { _ in self.openImagePicker(type: .camera) }))
        alert.addAction(UIAlertAction(title: "Взять из галлереи", style: .default, handler: { _ in self.openImagePicker(type: .photoLibrary) }))

        if (!String.isNullOrEmpty(avatar)) {
            alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in self.removeAvatar() }))
        }

        let vc = delegate.takeController()
        vc.present(alert, animated: true, completion: nil)
    }
    private func openImagePicker(type: UIImagePickerControllerSourceType) {

        imagePicker.sourceType = type

        let vc = delegate.takeController()
        vc.present(imagePicker, animated: true, completion: nil)
    }
    private func removeAvatar() {

        avatar = nil
        avatarImage.clear()
        delegate.changeAvatar(on: nil)
    }
}

//Image picker
extension ProfileControllerChangeAvatar: UIImagePickerControllerDelegate {


    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarImage.image = pickedImage
            delegate.changeAvatar(on: pickedImage)
        }

        picker.dismiss(animated: true, completion: nil)
    }
}
extension ProfileControllerChangeAvatar: UINavigationControllerDelegate {}
extension ProfileControllerChangeAvatar: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 120
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
