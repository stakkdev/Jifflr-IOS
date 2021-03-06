//
//  FileManager.swift
//  Jifflr-iOS
//
//  Created by James Shaw on 29/03/2018.
//  Copyright © 2018 The Distance. All rights reserved.
//

import UIKit
import Foundation

class MediaManager: NSObject {
    static let shared = MediaManager()
    
    func get(id: String?, fileExtension: String) -> URL? {
        var mediaId = id ?? "createAd"
        mediaId.append(".\(fileExtension)")
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDir = paths[0]
        let assetsPath = documentsDir.appending(Constants.UrlPaths.media.path)
        let assetPath = assetsPath.appending("/\(mediaId)")
        
        if FileManager.default.fileExists(atPath: assetPath) {
            let url = URL(fileURLWithPath: assetPath)
            return url
        }
        
        return nil
    }
    
    func deleteCreateAdMedia() {
        var mediaId = "createAd.jpg"
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDir = paths[0]
        let assetsPath = documentsDir.appending(Constants.UrlPaths.media.path)
        var assetPath = assetsPath.appending("/\(mediaId)")
        
        if FileManager.default.fileExists(atPath: assetPath) {
            do {
                try FileManager.default.removeItem(atPath: assetPath)
                print("CreateAd.jpg deleted successfully.")
            } catch {
                print("Error Deleting CreateAd.jpg media.")
            }
        } else {
            mediaId = "createAd.mp4"
            assetPath = assetsPath.appending("/\(mediaId)")
            
            if FileManager.default.fileExists(atPath: assetPath) {
                do {
                    try FileManager.default.removeItem(atPath: assetPath)
                    print("CreateAd.mp4 deleted successfully.")
                } catch {
                    print("Error Deleting CreateAd.mp4 media.")
                }
            }
        }
    }
    
    func save(data: Data, id: String?, fileExtension: String) -> Bool {
        var mediaId = id ?? "createAd"
        mediaId.append(".\(fileExtension)")
        
        do {
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentsDir = paths[0]
            let assetsPath = documentsDir.appending(Constants.UrlPaths.media.path)
            
            if !FileManager.default.fileExists(atPath: assetsPath) {
                try FileManager.default.createDirectory(atPath: assetsPath, withIntermediateDirectories: false, attributes: nil)
            }
            
            let assetPath = assetsPath.appending("/\(mediaId)")
            
            if FileManager.default.fileExists(atPath: assetPath) {
                try FileManager.default.removeItem(atPath: assetPath)
            }
            
            if mediaId.contains("createAd") {
                var deletePath = assetsPath.appending("/createAd.jpg")
                if FileManager.default.fileExists(atPath: deletePath) {
                    try FileManager.default.removeItem(atPath: deletePath)
                }
                
                deletePath = assetsPath.appending("/createAd.mp4")
                if FileManager.default.fileExists(atPath: deletePath) {
                    try FileManager.default.removeItem(atPath: deletePath)
                }
            }
            
            let success = FileManager.default.createFile(atPath: assetPath, contents: data, attributes: nil)
            return success
        } catch {
            return false
        }
    }
    
    func clear() {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDir = paths[0]
        do {
            let filePaths = try FileManager.default.contentsOfDirectory(atPath: documentsDir)
            for filePath in filePaths {
                try FileManager.default.removeItem(atPath: documentsDir + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
}
