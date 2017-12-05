//
//  SKDraftingImageView.swift
//  SKHighPerformanceCompression
//
//  [SK:] This is a custom control that inherits from NSImageView to respond to mouse drag and drop files
//
//  Created by ShevaKuilin on 2017/11/20.
//  Copyright © 2017年 ShevaKuilin. All rights reserved.
//

import Cocoa

class SKDraftingImageView: NSImageView {

    private var isDragIn:Bool = false
    private var animationManage = SKGIFAnimationManage.sharedInstance()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.registerForDraggedTypes([NSPasteboard.PasteboardType("NSFilenamesPboardType")]) // Types of registered drag and drop
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.registerForDraggedTypes([NSPasteboard.PasteboardType("NSFilenamesPboardType")])
    }
    
}

extension SKDraftingImageView {
    
    // MARK: Destination Operations
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        isDragIn = true
        // TODO: add GIF animation
        printLog("The file begins dragging in")
        animationManage.stopGIFAnimation()
        animationManage.readyToStartCompressionGIFAnimation(imageView: self, completion: {() in
            
        })

        return NSDragOperation.copy
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isDragIn = false
        // TODO: add GIF animation
        print("The file starts dragging away")
        animationManage.stopGIFAnimation()
        animationManage.cancelCompressionGIFAnimation(imageView: self, completion: {() in
            
        })
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        isDragIn = false
        printLog("Dragging end!!")
        
        
        return true
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pBoard = sender.draggingPasteboard()
        if let types = pBoard.types {
            if types.contains(NSPasteboard.PasteboardType("NSFilenamesPboardType")) {
                weak var weakSelf = self
                guard let wSelf = weakSelf else {
                    return false
                }
                animationManage.stopGIFAnimation()
                animationManage.startGIFAnimation(imageView: self, isDecompression: true, completion: {() in
                    printLog("compress is completion !!")
                    let path = (pBoard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: "NSFilenamesPboardType")) as? NSArray)?.firstObject
                    if let thePath = path {
                        if let image:NSImage = NSImage.init(contentsOfFile: thePath as! String) {
                            let pathStr = thePath as! String
                            let pathArr:Array<String> = pathStr.components(separatedBy: "/")
                            let suffix:String = pathArr.last ?? ""
                            wSelf.creatImagesFileFolder(images: [image], imageNames: [suffix])
                        }
                    }
                })
                printLog("Start to compress...")
            }
        }
        
        return true
    }
    
    // MARK: Create a folder for storing compressed pictures
    private func creatImagesFileFolder(images:[NSImage], imageNames:[String]) {
        let documentsDirectory = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        let currentDate = dateFormatter.string(from: nowDate)
        let dataPath = documentsDirectory.appendingPathComponent("SKimages " + currentDate)
        do {
            try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
            self.creatCompressedImageFile(prefix: "SKimages " + currentDate, image: images.first!, imageName: imageNames.first!)
        } catch let error as NSError {
            printLog(error.description)
        }
    }
    
    // MARK: Create a compressed picture
    private func creatCompressedImageFile(prefix:String, image:NSImage, imageName:String) {
        let documentsDirectory = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let dataPath = documentsDirectory.appendingPathComponent(prefix + "/" + imageName)
        if var imageData = image.tiffRepresentation {
            let imageRep = NSBitmapImageRep.imageReps(with: imageData)
            imageData = NSBitmapImageRep.representationOfImageReps(in: imageRep, using: NSBitmapImageRep.FileType.jpeg, properties: [NSBitmapImageRep.PropertyKey.compressionFactor : 0.1])!
            try? imageData.write(to: dataPath)
        }
    }
}

extension NSBitmapImageRep {
    var png: Data? {
        return representation(using: .png, properties: [:])
    }
}
extension Data {
    var bitmap: NSBitmapImageRep? {
        return NSBitmapImageRep(data: self)
    }
}
extension NSImage {
    var png: Data? {
        return tiffRepresentation?.bitmap?.png
    }
    func savePNG(to url: URL) -> Bool {
        do {
            try png?.write(to: url)
            return true
        } catch {
            print(error)
            return false
        }
        
    }
}
