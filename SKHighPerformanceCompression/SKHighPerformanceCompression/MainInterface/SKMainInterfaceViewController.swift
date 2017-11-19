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
    
    private var animationManage = SKGIFAnimationManage.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        setBasicsInteractionAction()
    }
    
    override func mouseDown(with event: NSEvent) {
        animationManage.stopGIFAnimation()
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

}

extension SKMainInterfaceViewController {
    
    // MARK: Set basics interaction action (e.g., drag and drop gesture)
    private func setBasicsInteractionAction() {
        // Get & set view's window
        let basicsWindows = self.view.window
        basicsWindows?.isMovableByWindowBackground = true // Allows the mouse to drag & drop the background movement
    }
    
}
