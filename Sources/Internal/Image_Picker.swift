//
//  File.swift
//  
//
//  Created by Omar Hariri on 06/11/1442 AH.
//

import Foundation
import UIKit
public protocol ImagePickerDelegate: AnyObject {
    func ImagePickerDidSelectQrCodeImage(UserPin: String)
}

open class ImagePicker: NSObject, UINavigationControllerDelegate {
    
    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        self.presentationController = presentationController
        self.delegate = delegate
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.mediaTypes = ["public.image"]
        self.pickerController.sourceType = .photoLibrary
        
    }
    
    
    public func present(from sourceView: UIView) {
        self.presentationController?.present(self.pickerController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: String) {
        controller.dismiss(animated: true, completion: {
            self.delegate?.ImagePickerDidSelectQrCodeImage(UserPin: image)
            
        })
        
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: "No")
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let userPin = detectQRCode(pickedImage)
            self.pickerController(picker, didSelect: userPin)
        }
        
    }
    
    func detectQRCode(_ image: UIImage?) -> String {
        if let selectedImage = image {
            let coder = RCCoder()
            do {
                return try coder.decode(selectedImage)
            } catch {
                return ""
            }
        }
        return ""
    }
}
