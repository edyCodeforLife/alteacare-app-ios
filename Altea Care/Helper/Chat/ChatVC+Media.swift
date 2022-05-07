//
//  ChatVC+Media.swift
//  Altea Care
//
//  Created by Hedy on 23/04/21.
//

import UIKit
import SafariServices
import QuickLook
import Photos
import MobileCoreServices


extension ChatVC: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        if textView.text == "" {
            constraitHeightContainerChat.constant = 62
        } else if messageTV.frame.height > height {
            constraitHeightContainerChat.constant = constraitHeightContainerChat.constant - 21.5
        } else {
            constraitHeightContainerChat.constant = constraitHeightContainerChat.constant + 21.5
        }
        
        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension ChatVC: ImageCellDelegate {
    func reload(row: Int?) {
        if let r = row {
            tableView.reloadRows(at: [IndexPath(item: r, section: 0)], with: .none)
        }else {
            tableView.reloadData()
        }
    }
}

extension ChatVC : AttachmentPickerDelegate{
    func gallerySelected() {
        self.presentMediaPicker(fromController: self, sourceType: .photoLibrary)
    }
    
    func camSelected() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            self.presentMediaPicker(fromController: self, sourceType: .camera)
        } else {
            showBasicAlert(title: "Error", message: "Tidak ada kamera!", completion: nil)
        }
    }
    
    func docSelected() {
        self.presentFilePicker(fromController: self)
    }
}

extension ChatVC: MediaPickerPresenter, FilePickerPresenter {
    func didSelectFromFilePicker(withUrl fileUrl: URL) {
        do {
            let data = try Data(contentsOf: fileUrl)
            chatManager.sendMessagePDF(data, completion: { (result, _) in
                if result.isSuccessful() {

                } else {
                    
                }
            })
        } catch {
            
        }
    }
    
    func didSelectFromMediaPicker(withImage image: UIImage) {
        // ...
        // select item from image
        let imageData = image.jpegData(compressionQuality: 0.2)
        showToast(message: "Uploading sedang berjalan")
        do{
            chatManager.sendMessageFile(imageData!, completion: { (result, _) in
                    if result.isSuccessful() {
                        self.showToast(message: "File anda telah berhasil di kirim")
                    } else {
                        /// ...
                    }
                })
        } catch {
            
        }
    }
    
    func didSelectFromMediaPicker(withMediaUrl mediaUrl: NSURL) {
        // ...
        // select file such as pdf
        showToast(message: "Uploading sedang berjalan")
        do {
            let data = try Data(contentsOf: mediaUrl as URL)
            chatManager.sendMessageFile(data, completion: { (result, _) in
                if result.isSuccessful() {
                    self.showToast(message: "File anda telah berhasil di kirim")
                } else {
                    // ...
                }
            })
        } catch {
            print("unable to load data : \(error)")
        }
    }
}

extension ChatVC: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    }
}

extension ChatVC: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        return self.previewItem as QLPreviewItem
    }
}
