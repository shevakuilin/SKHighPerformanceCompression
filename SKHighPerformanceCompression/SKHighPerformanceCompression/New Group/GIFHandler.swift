//
//  GIFHandler.swift
//  GIF
//
//  Created by Christian Lundtofte on 14/03/2017.
//  Copyright © 2017 Christian Lundtofte. All rights reserved.
//

import Foundation
import AVFoundation
import Cocoa

// Replaces the old '(frames: [GIFFrame], loops:Int, secondsPrFrame: Float)' with a type
// Describes the data necessary to show a gif. Frames, loops, and duration
class GIFRepresentation {
    var frames:[GIFFrame] = [GIFFrame.emptyFrame]
    var loops:Int = GIFHandler.defaultLoops
    
    init(frames: [GIFFrame], loops:Int) {
        self.frames = frames
        self.loops = loops
    }
    
    init() {}
}

// Creates and loads gifs
class GIFHandler {

    // MARK: Constants
    static let errorNotificationName = NSNotification.Name(rawValue: "GIFError")
    static let defaultLoops:Int = 0
    static let defaultFrameDuration:Double = 0.2
    static let minFrameDuration:Double = 0.06
    
    // MARK: Loading gifs
    static func loadGIF(with image: NSImage, onFinish: ((GIFRepresentation) -> ())) {
        
        // Attempt to fetch the number of frames, frame duration, and loop count from the .gif
        guard let bitmapRep = image.representations[0] as? NSBitmapImageRep,
            let frameCount = (bitmapRep.value(forProperty: .frameCount) as? NSNumber)?.intValue,
            let loopCount = (bitmapRep.value(forProperty: .loopCount) as? NSNumber)?.intValue else {
                
            NotificationCenter.default.post(name: errorNotificationName, object: self, userInfo: ["Error":"Could not load gif. The file does not contain the metadata required for a gif."])
            onFinish(GIFRepresentation())
            return
        }

        
        var retFrames:[GIFFrame] = []
        
        // Iterate the frames, set the current frame on the bitmapRep and add this to 'retImages'
        for n in 0 ..< frameCount {
            bitmapRep.setProperty(.currentFrame, withValue: NSNumber(value: n))
            
            if let data = bitmapRep.representation(using: .gif, properties: [:]),
               let img = NSImage(data: data) {
                let frame = GIFFrame(image: img)
                
                if let frameDuration = (bitmapRep.value(forProperty: .currentFrameDuration) as? NSNumber)?.doubleValue {
                    frame.duration = frameDuration
                }
                
                retFrames.append(frame)
            }
        }
        
        onFinish(GIFRepresentation(frames: retFrames, loops: loopCount))
    }
    
    
    // MARK: Making gifs from frames
    // Creates and saves a gif
    static func createAndSaveGIF(with frames: [GIFFrame], savePath: URL, loops: Int = GIFHandler.defaultLoops) {
        // Get and save data at 'savePath'
        let data = GIFHandler.createGIFData(with: frames, loops: loops)
        
        do {
            try data.write(to: savePath)
        }
        catch {
            NotificationCenter.default.post(name: errorNotificationName, object: self, userInfo: ["Error":"Could not save file: "+error.localizedDescription])
            print("Error: \(error)")
        }
    }
    
    // Creates and returns an NSImage from given images
    static func createGIF(with frames: [GIFFrame], loops: Int = GIFHandler.defaultLoops) -> NSImage? {
        // Get data and convert to image
        let data = GIFHandler.createGIFData(with: frames, loops: loops)
        let img = NSImage(data: data)
        return img
    }
    
    // Creates NSData from given images
    static func createGIFData(with frames: [GIFFrame], loops: Int = GIFHandler.defaultLoops) -> Data {
        // Loop count
        let loopCountDic = NSDictionary(dictionary: [kCGImagePropertyGIFDictionary:NSDictionary(dictionary: [kCGImagePropertyGIFLoopCount: loops])])
        
        // Number of frames
        let imageCount = frames.filter { (frame) -> Bool in
            return frame.image != nil
        }.count
        
        // Destination (Data object)
        guard let dataObj = CFDataCreateMutable(nil, 0),
            let dst = CGImageDestinationCreateWithData(dataObj, kUTTypeGIF, imageCount, nil) else { fatalError("Can't create gif") }
        CGImageDestinationSetProperties(dst, loopCountDic as CFDictionary) // Set loop count on object
        
        // Add images to destination
        frames.forEach { (frame) in
            guard let image = frame.image else { return }
            if let imageRef = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                // Frame duration
                let frameDurationDic = NSDictionary(dictionary: [kCGImagePropertyGIFDictionary:NSDictionary(dictionary: [kCGImagePropertyGIFDelayTime: frame.duration])])
                
                // Add image
                CGImageDestinationAddImage(dst, imageRef, frameDurationDic as CFDictionary)
            }
        }
        

        // Close, cast as data and return
        let _ = CGImageDestinationFinalize(dst)
        let retData = dataObj as Data
        return retData
    }
    
    
    // MARK: Helper functions for gifs
    // Naive method for determining whether something is an animated gif
    static func isAnimatedGIF(_ image: NSImage) -> Bool {
        // Attempt to fetch the number of frames, frame duration, and loop count from the .gif
        guard let bitmapRep = image.representations[0] as? NSBitmapImageRep,
            let frameCount = (bitmapRep.value(forProperty: .frameCount) as? NSNumber)?.intValue,
            let _ = (bitmapRep.value(forProperty: .loopCount) as? NSNumber)?.intValue,
            let _ = (bitmapRep.value(forProperty: .currentFrameDuration) as? NSNumber)?.floatValue else {
            return false
        }

        return frameCount > 1 // We have loops, duration and everything, and there's more than 1 frame, it's probably a gif
    }
    
}
