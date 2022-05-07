//
//  ImagePickerHandler.swift
//  Altea Care
//
//  Created by Hedy on 21/03/21.
//

import UIKit
import MobileCoreServices

class ImagePickerHandler: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: MediaPickerPresenter?
    let sourceType: UIImagePickerController.SourceType
    var picker = UIImagePickerController()
    
    init(sourceType: UIImagePickerController.SourceType) {
        self.sourceType = sourceType
        self.picker.sourceType = sourceType
        super.init()
        self.picker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let mediaType = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaType.rawValue)] as? String {
            switch mediaType {
            case String(kUTTypeImage):
                if let selectedImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
                    self.delegate?.didSelectFromMediaPicker(withImage: selectedImage)
                }
            case String(kUTTypeImage), String(kUTTypeMovie), String(kUTTypeVideo):
                if let selectedMediaURL = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaURL.rawValue)] as? NSURL {
                    self.delegate?.didSelectFromMediaPicker(withMediaUrl: selectedMediaURL)
                }
            default:
                break
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

protocol MediaPickerPresenter {
    var imagePickerHandler: ImagePickerHandler { get set }
    func presentMediaPicker(fromController controller: UIViewController, sourceType: UIImagePickerController.SourceType)
    func didSelectFromMediaPicker(withImage image: UIImage)
    func didSelectFromMediaPicker(withMediaUrl mediaUrl: NSURL)
}

extension MediaPickerPresenter {
    func presentMediaPicker(fromController controller: UIViewController, sourceType:UIImagePickerController.SourceType) {
        imagePickerHandler.delegate = self
        imagePickerHandler.picker.sourceType = sourceType
        controller.present(imagePickerHandler.picker, animated: true, completion: nil)
    }
    
}
