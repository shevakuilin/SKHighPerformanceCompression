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
        animationManage.readyToStartCompressionGIFAnimation(imageView: self)

        return NSDragOperation.copy
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isDragIn = false
        // TODO: add GIF animation
        print("The file starts dragging away")
        animationManage.cancelCompressionGIFAnimation(imageView: self)
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        isDragIn = false
        
        return true
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if sender.draggingSource() != self as AnyObject as! _OptionalNilComparisonType {
//            let filePaths = sender.draggingPasteboard().propertyList(forType: NSPasteboard.PasteboardType("NSFilenamesPboardType"))
            
        }
        
        return true
    }
}
