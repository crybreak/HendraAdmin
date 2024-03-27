//
//  AttachmentUSDZ + Helper.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 17/03/2024.
//

import Foundation
import SceneKit.ModelIO
import CoreData

extension AttahcmentUSDZ {
    static let maxThumbnailPixelSize: CGSize = CGSize(width: 600, height: 600)
    
    var creationDate: Date {
        get { self.creationDate_ ?? Date() }
    }
    
    
    var send: Bool {
        get {self.send_ ?? false}
        set (newValue){ self.send_ = newValue}
    }
    
    convenience init(url: URL, usdz: Data?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.data_ = usdz
        self.url = url
    }
    
    
    public override func awakeFromInsert() {
        self.creationDate_ = Date() + TimeInterval()
        self.send_ = false
    }
    
    static func delete(_ attachment: AttahcmentUSDZ?) {
        guard let attachment,
                let context = attachment.managedObjectContext else {return}
        context.delete(attachment)
    }
    static func createThumbnailThroughtARQL(from url: URL , thumbmailPixelSize: CGSize, time: TimeInterval = 10) -> UIImage? {
        let device = MTLCreateSystemDefaultDevice()!

        let renderer = SCNRenderer(device: device, options: [:])
                renderer.autoenablesDefaultLighting = true

                if (url.pathExtension == "usdz") {
                    let scene = try? SCNScene(url: url, options: nil)
                    renderer.scene = scene
                } else {
                    let asset = MDLAsset(url: url)
                    let scene = SCNScene(mdlAsset: asset)
                    renderer.scene = scene
                }

                let image = renderer.snapshot(atTime: time, with: thumbmailPixelSize, antialiasingMode: .multisampling4X)
                return image
    }
    
    func getThumbnail() async -> UIImage? {
        
        guard self.thumbnailImageData_ == nil else {
            return UIImage(data: thumbnailImageData_!)
        }
        guard let data_ = self.data_ else {
            return nil
        }

        guard let url = self.url else {
            return nil
        }
       

        let imageThumbnail = await Task (priority: .medium) {
            AttahcmentUSDZ.createThumbnailThroughtARQL(from: url,
                                                    thumbmailPixelSize:  AttahcmentUSDZ.maxThumbnailPixelSize)
        }.value
        
        Task (priority: .low){
            self.thumbnailImageData_ = imageThumbnail?.pngData()
        }
        return imageThumbnail
    }
}


extension AttahcmentUSDZ: Comparable {
    public static func < (lhs: AttahcmentUSDZ, rhs: AttahcmentUSDZ) -> Bool {
        lhs.creationDate < rhs.creationDate
    }
}
