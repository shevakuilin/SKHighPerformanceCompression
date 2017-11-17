//
//  SKMainInterfaceViewController.swift
//  SKHighPerformanceCompression
//
//  [SK:] Responsible for the main interface of compression interaction
//
//  Created by ShevaKuilin on 2017/11/17.
//  Copyright © 2017年 ShevaKuilin. All rights reserved.
//

import Cocoa
import QuartzCore

class SKMainInterfaceViewController: NSViewController {

    @IBOutlet weak var settingButton: NSButton!
    @IBOutlet weak var reminderInfoLabel: NSTextField!
    @IBOutlet weak var applicationTitleLabel: NSTextField!
    @IBOutlet weak var animationImageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        setBasicsInteractionAction()
    }
    
}

extension SKMainInterfaceViewController {
    
    // MARK: Set background (e.g., view's backgroundColor, defaultTitle's textColor..)
    private func setBackground() {
        self.view.wantsLayer = true // Open the layer draw
        self.view.layer?.backgroundColor = NSColor(red: 52/255.0, green: 52/255.0, blue: 52/255.0, alpha: 1.0).cgColor
        
        // Read animation pictures
        var pictureFrames:Array<NSImage> = []
        let picturePrefix = "Hover+compress+gift+relax_"
        for i in 44..<172 {
            let pictureSuffix = i < 100 ? "000" + "\(i)" : "00" + "\(i)"
            let pictureFull = picturePrefix + pictureSuffix
            let image = NSImage.init(named: NSImage.Name(rawValue: pictureFull))
            pictureFrames.append(image!)
        }
        
        // TODO: Testing GIF animation
        makeGIFAnimation(images: pictureFrames)
    }
    
    // Making GIF animation effects
    private func makeGIFAnimation(images:Array<NSImage>) {
        weak var weakSelf = self
        guard let wSelf = weakSelf else {
            return
        }
        var index:Int = 0
        let period:TimeInterval = 0.1
        let queue = DispatchQueue.global(qos: .default)
        let _timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        _timer.schedule(deadline: .now() + period, repeating: period)
        _timer.setEventHandler {
            if images.count == 0 {
                _timer.cancel()
                return
            }
            let image:NSImage = images[index]
            DispatchQueue.main.async {
                wSelf.animationImageView.image = image
            }
            
            index += 1
            if index == images.count - 1 {
                index = 0
            }
        }
        _timer.resume()
    }
}

extension SKMainInterfaceViewController {
    
    // MARK: Set basics interaction action (e.g., drag and drop gesture)
    private func setBasicsInteractionAction() {
        // Get & set view's window
        let basicsWindows = self.view.window
        basicsWindows?.isMovableByWindowBackground = true // Allows the mouse to drag & drop the background movement
    }
    
}
