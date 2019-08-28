//
//  FileManager.swift
//  CollabARSample
//
//  Created by Satish Muttavarapu on 05/07/19.
//  Copyright © 2019 Wipro. All rights reserved.
//

import Foundation
import UIKit

class ImagesFileManager: NSObject{
    static var defaultManager = ImagesFileManager()
    fileprivate let fileManager = FileManager.default
    var images:[UIImage] = []
    private override init() {
        super.init()
        _ = self.configureDirectory()
    }
    
    fileprivate func configureDirectory() -> String {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("CollabARSampleImages")
        if !fileManager.fileExists(atPath: path) {
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
    }
    
   fileprivate func getDirectoryPath() -> String {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("CollabARSampleImages")
        return path
    }
    
    func saveImageDocumentDirectory(image: UIImage) -> Bool? {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("CollabARSampleImages")
        if !fileManager.fileExists(atPath: path) {
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        let url = NSURL(string: path)
        let imageName = "Img_" + generateCurrentTimeStamp()
        let imagePath = url!.appendingPathComponent(imageName)
        let urlString: String = imagePath!.absoluteString
        let imageData = image.jpegData(compressionQuality: 0.5)
        //let imageData = UIImagePNGRepresentation(image)
        if fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil){
            print("File Saved")
            return true
        }else{
            print("File not Saved")
            return false

        }
    }
    
    func getImageFromDocumentDirectory() -> [UIImage]? {
        do{
            images.removeAll()
            let imageDirectoryPath = self.getDirectoryPath()
            let url = URL(fileURLWithPath: imageDirectoryPath)
            let fileURLs = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            if fileURLs.count>0{
                for url in fileURLs{
                    if let data = NSData(contentsOfFile: url.path){
                        if let image = UIImage(data: data as Data){
                            images.append(image)
                        }
                    }
                }
            }else{
                images = []
            }
            
            return images
        }catch{
            print("Error")
        }
        return nil
    }
    
    func clearAllFilesFromDirectory(){
        do{
            let imageDirectoryPath = self.getDirectoryPath()
            let url = URL(fileURLWithPath: imageDirectoryPath)
            let fileURLs = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            for url in fileURLs{
                try fileManager.removeItem(atPath: url.path)
            }
            
        }catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    fileprivate func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh_mm_ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
    
}
