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
    private let decompressionGIFPrefix = "Hover+compress+gift+relax_"
    private let defaultGIFPrefix = "animationIn+hover+relax_"
    private var isCancle:Bool = false
    
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
        if isCancle {
            isCancle = false
        }
        // Read animation pictures
        var pictureFrames:Array<NSImage> = []
        var picturePrefix = ""
        if isDecompression {
            picturePrefix = decompressionGIFPrefix
            for i in 44..<172 {
                let pictureSuffix = i < 100 ? "000" + "\(i)" : "00" + "\(i)"
                let pictureFull = picturePrefix + pictureSuffix
                let image = NSImage.init(named: NSImage.Name(rawValue: pictureFull))
                pictureFrames.append(image!)
            }
        } else {
            picturePrefix = defaultGIFPrefix
            for i in 15..<53 {
                let pictureSuffix = "000" + "\(i)"
                let pictureFull = picturePrefix + pictureSuffix
                let image = NSImage.init(named: NSImage.Name(rawValue: pictureFull))
                pictureFrames.append(image!)
            }
        }
        if _timer != nil {
            _timer?.cancel()
        }
        makeGIFAnimation(images: pictureFrames, imageView: imageView, isDecompression:isDecompression)
    }
    
    // Ready to start compression
    public func readyToStartCompressionGIFAnimation(imageView:NSImageView) {
        if isCancle {
            isCancle = false
        }
        var pictureFrames:Array<NSImage> = []
        let picturePrefix = defaultGIFPrefix
        for i in 50..<82 {
            let pictureSuffix = "000" + "\(i)"
            let pictureFull = picturePrefix + pictureSuffix
            let image = NSImage.init(named: NSImage.Name(rawValue: pictureFull))
            pictureFrames.append(image!)
        }
        if _timer != nil {
            _timer?.cancel()
        }
        makeGIFAnimation(images: pictureFrames, imageView: imageView, isDecompression:true)
    }
    
    // Cancel compression
    public func cancelCompressionGIFAnimation(imageView:NSImageView) {
        isCancle = true
        var pictureFrames:Array<NSImage> = []
        let picturePrefix = defaultGIFPrefix
        for i in (50..<61).reversed() {
            let pictureSuffix = "000" + "\(i)"
            let pictureFull = picturePrefix + pictureSuffix
            let image = NSImage.init(named: NSImage.Name(rawValue: pictureFull))
            pictureFrames.append(image!)
        }
        if _timer != nil {
            _timer?.cancel()
        }
        makeGIFAnimation(images: pictureFrames, imageView: imageView, isDecompression:false)
    }
    
    // Making GIF animation effects
    private func makeGIFAnimation(images:Array<NSImage>, imageView:NSImageView, isDecompression:Bool) {
        weak var weakSelf = self
        guard let wSelf = weakSelf else {
            return
        }

        var index:Int = 0
        let period:TimeInterval = 0.1
        let queue = DispatchQueue.global(qos: .default)
        _timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        if let _timer = _timer {
            _timer.schedule(deadline: .now() + period, repeating: isCancle ? 0.077 : 0.04)
            _timer.setEventHandler {
                if images.count == 0 {
                    _timer.cancel()
                    return
                }
                let image:NSImage = images[index]
                DispatchQueue.main.async {
                    imageView.image = image
                    if isDecompression == false {
                        if index == 0 {
                            wSelf.stopGIFAnimation()
                            print("The last default frame diagram is:" + "\(image.name()!.rawValue)")
                        }

                    } else {
                        if index == 0 {
                            wSelf.stopGIFAnimation()
                            print("The last bit of the compressed frame graph is:" + "\(image.name()!.rawValue)")
                        }
                    }
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
