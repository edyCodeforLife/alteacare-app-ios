//
//  DownloadManager.swift
//  Altea Care
//
//  Created by Ridwan Abdurrasyid on 17/02/22.
//

import Foundation

class DownloadManager {
    static func loadFileSync(url: URL, completion: @escaping (URL?, Error?) -> Void) {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationUrl.path) {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl, nil)
        }
        else if let dataFromURL = NSData(contentsOf: url) {
            if dataFromURL.write(to: destinationUrl, atomically: true) {
                print("file saved [\(destinationUrl.path)]")
                completion(destinationUrl, nil)
            }
            else {
                print("error saving file")
                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                completion(destinationUrl, error)
            }
        }
        else {
            let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
            completion(destinationUrl, error)
        }
    }
    
    
    // Large File
    static func loadFileAsync(url: URL, completion: @escaping (URL?, Error?) -> Void) {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationUrl.path) {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl, nil)
        }
        else {
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil else {
                    completion(destinationUrl, error)
                    return
                }
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        if let data = data {
                            if let _ = try? data.write(to: destinationUrl, options: .atomic) {
                                completion(destinationUrl, error)
                            }
                            else {
                                completion(destinationUrl, error)
                            }
                        }
                        else {
                            completion(destinationUrl, error)
                        }
                    }
                }
            })
            task.resume()
        }
    }
}
