//
//  FilePickerHandler.swift
//  Altea Care
//
//  Created by Hedy on 27/03/21.
//

import Foundation
import MobileCoreServices
import UIKit

class FilePickerHandler: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var delegate: FilePickerPresenter?
    let picker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
    
    override init() {
        super.init()
        self.picker.delegate = self
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            self.delegate?.didSelectFromFilePicker(withUrl: url)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

protocol FilePickerPresenter {
    var filePickerHandler: FilePickerHandler { get set }
    func presentFilePicker(fromController controller: UIViewController)
    func didSelectFromFilePicker(withUrl fileUrl: URL)
}

extension FilePickerPresenter {
    func presentFilePicker(fromController controller: UIViewController) {
        filePickerHandler.delegate = self
        controller.present(filePickerHandler.picker, animated: true, completion: nil)
    }
    
}
