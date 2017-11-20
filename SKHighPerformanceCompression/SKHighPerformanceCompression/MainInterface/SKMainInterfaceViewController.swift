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
    @IBOutlet weak var animationImageView: SKDraftingImageView!
    @IBOutlet weak var maskView: NSView!
    
    private var animationManage = SKGIFAnimationManage.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        setMouseAction()
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
        
        // Setting default animation
        animationManage.startGIFAnimation(imageView: animationImageView, isDecompression: false)
    }
    
    // MARK: Setting mouse related events
    private func setMouseAction() {
        let area:NSTrackingArea = NSTrackingArea.init(rect: self.maskView.bounds, options: [.mouseEnteredAndExited, .activeInKeyWindow], owner: self, userInfo: nil)
        self.maskView.addTrackingArea(area)
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
