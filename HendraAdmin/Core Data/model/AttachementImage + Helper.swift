//
//  AttachementIMG.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 11/03/2024.
//

import Foundation
import UIKit
import CoreData


extension AttahcmentImage {
    
    var uuid: UUID  {
#if DEBUG
        uuid_!
#else
        self.uuid_ ?? UUID()
#endif
    }
    
    static let maxThumbnailPixelSize: Int = 600
    
    var creationDate: Date {
        get { self.creationDate_ ?? Date() }
    }
    
    
    var send: Bool {
        get {self.send_ }
        set (newValue){ self.send_ = newValue}
    }
    
    convenience init(image: Data?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.fullImageData_ = image
        self.send_ = false
    }
    
    public override func awakeFromInsert() {
        self.creationDate_ = Date() + TimeInterval()
        self.uuid_ = UUID()
    }
    static func createThumbnailThroughtImage(from imageData: Data, thumbmailPixelSize: Int) -> UIImage? {
        
        let options = [kCGImageSourceCreateThumbnailWithTransform: true,
                     kCGImageSourceCreateThumbnailFromImageAlways: true,
                              kCGImageSourceThumbnailMaxPixelSize: thumbmailPixelSize] as [CFString : Any]  as CFDictionary
        
        guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil), let imageReference = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options) else {return nil}
        return UIImage(cgImage: imageReference)
    }
    
    
    func getThumbnail() async -> UIImage? {
        
        guard self.thumbnailData_ == nil else {
            return UIImage(data: thumbnailData_!)
        }
        guard let fullImageData = self.fullImageData_ else {
            return nil
        }
        let imageThumbnail = await Task (priority: .medium) {
           AttahcmentImage.createThumbnailThroughtImage(from: fullImageData,
                                                    thumbmailPixelSize: AttahcmentImage.maxThumbnailPixelSize)
        }.value
        
        
        
        
        Task (priority: .low){

        self.thumbnailData_ = imageThumbnail?.pngData()

        }
        self.send_ = false
        return imageThumbnail
    }
    
   
    
    static func delete(_ attachment: AttahcmentImage?) {
        guard let attachment,
                let context = attachment.managedObjectContext else {return}
        context.delete(attachment)
    }
    
    static func createiImage(from imageData: Data) async -> UIImage? {
       let image = await Task(priority: .background) {
            UIImage(data: imageData)
       }.value
        
        return image
    }
    
    func createFullImage() async -> UIImage? {
        
        guard let data = self.fullImageData_ else {return nil}
        let image = await AttahcmentImage.createiImage(from: data)
        return image
    }
    
    func updateImageSize(to newSize: CGSize?) {
        if let newHeight = newSize?.height,
           self.height != Float(newHeight) {
            self.height = Float(newHeight)
        }
        
        if let newWidth = newSize?.width,
        self.width != Float(newWidth) {
            self.width = Float(newWidth)
        }
    }
    
    func imageWidth() -> CGFloat {
        if self.width > 0 {
            return CGFloat(self.width)
        } else {
            return CGFloat(AttahcmentImage.maxThumbnailPixelSize)
        }
    }
    
    func imageHeight() -> CGFloat {
        if self.height > 0 {
            return CGFloat(self.height)
        } else {
            return CGFloat(AttahcmentImage.maxThumbnailPixelSize)
        }
    }
}

extension AttahcmentImage: Comparable {
    public static func < (lhs: AttahcmentImage, rhs: AttahcmentImage) -> Bool {
        lhs.creationDate < rhs.creationDate
    }
}
