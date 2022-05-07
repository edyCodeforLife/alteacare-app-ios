//
//  ChatVC+Tableview.swift
//  Altea Care
//
//  Created by Hedy on 23/04/21.
//

import UIKit
import AVKit
import SafariServices
import QuickLook

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = content[indexPath.row]
        switch data {
        case .inText(let message):
            guard let cell = tableView.dequeueCell(with: LeftTextCell.self) else {
                return UITableViewCell()
            }
            cell.messageL.text = message
            return cell
        case .outText(let message):
            guard let cell = tableView.dequeueCell(with: RightTextCell.self) else {
                return UITableViewCell()
            }
            cell.messageL.text = message
            return cell
        case .outImage(let message):
            guard let cell = tableView.dequeueCell(with: RightImageCell.self) else {
                return UITableViewCell()
            }
//            if message.urlIsImage() == true{
            message.getMediaContentTemporaryUrl{ (result, documentUrl) in
                self.configImageCell(with: cell, url: documentUrl ?? "")
            }
            
//            }else{
//                configVideoCell(with: cell, url: message)
//            }
            cell.currentRow = indexPath.item
            cell.delegate = self
            return cell
        case .inImage(let message):
            guard let cell = tableView.dequeueCell(with: LeftImageCell.self) else {
                return UITableViewCell()
            }
//            if message.urlIsImage() == true{
//                print("urls image :\(message.urlIsImage())")
            message.getMediaContentTemporaryUrl{ (result, documentUrl) in
                self.configImageCell(with: cell, url: documentUrl ?? "")
            }//            }else{
//                print("urls image else : \(message.urlIsImage())")
//                configVideoCell(with: cell, url: message)
//            }
            cell.currentRow = indexPath.item
            cell.delegate = self
            return cell
        case .outDocument(let message):
            guard let cell = tableView.dequeueCell(with: RightFileCell.self) else {
                return UITableViewCell()
            }
            configFileCell(with: cell, url: message)
            return cell
        case .inDocument(let message):
            guard let cell = tableView.dequeueCell(with: LeftFileCell.self) else {
                return UITableViewCell()}
            configFileCell(with: cell, url: message)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let data = content[indexPath.row]
//        
//        switch data {
//        case .outImage(let message):
////            print("outImage : \(message)")
////            if message.urlIsImage() == true{
//                showImage(urlString: message)
////            }else {
////                if let url = URL(string: message){
////                    playVideo(url: url)
////                }
////            }
//        case .inImage(let message):
//            print("in image: \(message)")
////            if message.urlIsImage() == true{
//                showImage(urlString: message)
////            }else {
////                if let url = URL(string: message){
////                    playVideo(url: url)
////                }
////            }
//        case .outDocument(let message):
//            openUrlForRead(urlString: message)
//        case .inDocument(let message):
//            openUrlForRead(urlString: message)
//        default:
//            break
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ChatVC {
    func openFile(url: URL) {
        //url is file path
        self.previewItem = url as NSURL
        
        DispatchQueue.main.async {
            let previewController = QLPreviewController()
            previewController.dataSource = self
            self.present(previewController, animated: true, completion: nil)
        }
    }
    
    // Helpers - Media Players
    private func showImage(urlString: String){
        let url = URL(string: urlString)
        let img = UIImageView()
        img.kf.setImage(with: url)
        
        guard let image  = img.image else{
            showBasicAlert(title: "Error", message: "Gagal memuat gambar", completion: nil)
            return }
        let vc = ImageDetailVC(image: image)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        
        let vc = AVPlayerViewController()
        vc.player = player
        
        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    private func openUrlForRead(urlString: String) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let url = NSURL(string: urlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!)
        let svc = SFSafariViewController(url: url! as URL,  configuration: config)
        self.present(svc, animated: true, completion: nil)
    }
    
    private func configImageCell(with cell: LeftImageCell, url: String) {
        cell.playIndicatorIV.isHidden = true
        let url = URL(string: url)
        cell.messageIV.kf.setImage(with: url)
    }
    
    private func configVideoCell(with cell: LeftImageCell, url: String) {
        cell.playIndicatorIV.isHidden = false
        if let url = URL(string: url) {
            AVAsset(url: url).generateThumbnail { (image) in
                DispatchQueue.main.async {
                    guard let image = image else { return }
                    cell.messageIV.image = image
                }
            }
        }
    }
    
    private func configImageCell(with cell: RightImageCell, url: String) {
        cell.playIndicatorIV.isHidden = true
        let url = URL(string: url)
        cell.messageIV.kf.setImage(with: url)
        guard cell.messageIV.image != nil else{return}
    }
    
    private func configVideoCell(with cell: RightImageCell, url: String) {
        cell.playIndicatorIV.isHidden = false
        if let url = URL(string: url) {
            AVAsset(url: url).generateThumbnail { (image) in
                DispatchQueue.main.async {
                    guard let image = image else { return }
                    cell.messageIV.image = image
                }
            }
        }
    }
    
    private func configFileCell(with cell: LeftFileCell, url: String) {
        cell.fileNameL.text = url.fileNameFromUrl()
    }
    
    private func configFileCell(with cell: RightFileCell, url: String) {
        cell.fileNameL.text = url.fileNameFromUrl()
    }
}
