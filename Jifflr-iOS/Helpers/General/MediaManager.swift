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
