//
//  SKGIFAnimationManage.swift
//  SKHighPerformanceCompression
//
//  Created by ShevaKuilin on 2017/11/19.
//  Copyright © 2017年 ShevaKuilin. All rights reserved.
//

import Cocoa

private let manage = SKGIFAnimationManage()

class SKGIFAnimationManage: NSObject {
    private var _timer:DispatchSourceTimer?
    private let defaultGIFPrefix = "Hover+compress+gift+relax_"
    private let decompressionGIFPrefix = "animationIn+hover+relax_"
    
    // Create a single instance
    class func sharedInstance() -> SKGIFAnimationManage {
        return manage
    }
    
    // Stop animation
    public func stopGIFAnimation() {
        if let _timer = _timer {
            _timer.cancel()
        }
    }
    
    // Display animation according to status
    public func startGIFAnimation(imageView:NSImageView, isDecompression:Bool) {
        
        // Read animation pictures
        var pictureFrames:Array<NSImage> = []
        var picturePrefix = ""
        if isDecompression {
            picturePrefix = defaultGIFPrefix
            for i in 44..<172 {
                let pictureSuffix = i < 100 ? "000" + "\(i)" : "00" + "\(i)"
                let pictureFull = picturePrefix + pictureSuffix
                let image = NSImage.init(named: NSImage.Name(rawValue: pictureFull))
                pictureFrames.append(image!)
            }
        } else {
            picturePrefix = decompressionGIFPrefix
            for i in 15..<94 {
                let pictureSuffix = "000" + "\(i)"
                let pictureFull = picturePrefix + pictureSuffix
                let image = NSImage.init(named: NSImage.Name(rawValue: pictureFull))
                pictureFrames.append(image!)
            }
        }
        makeGIFAnimation(images: pictureFrames, imageView: imageView)
    }
    
    // Making GIF animation effects
    private func makeGIFAnimation(images:Array<NSImage>, imageView:NSImageView) {
        var index:Int = 0
        let period:TimeInterval = 0.1
        let queue = DispatchQueue.global(qos: .default)
        _timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        if let _timer = _timer {
            _timer.schedule(deadline: .now() + period, repeating: 0.05)
            _timer.setEventHandler {
                if images.count == 0 {
                    _timer.cancel()
                    return
                }
                let image:NSImage = images[index]
                DispatchQueue.main.async {
                    imageView.image = image
                }
                
                index += 1
                if index == images.count - 1 {
                    index = 0
                }
            }
            _timer.resume()
        }
        
    }
}
