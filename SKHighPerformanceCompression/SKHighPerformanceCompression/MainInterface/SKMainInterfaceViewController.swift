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

class SKMainInterfaceViewController: NSViewController {

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
        self.view.layer?.backgroundColor = NSColor(red: 37/255.0, green: 37/255.0, blue: 37/255.0, alpha: 1.0).cgColor
    }
    
}

extension SKMainInterfaceViewController {
    
    // MARK: Set basics interaction action (e.g., drag and drop gesture)
    private func setBasicsInteractionAction() {
        // Get view's window
        let basicsWindows = self.view.window
        basicsWindows?.isMovableByWindowBackground = true // Allows the mouse to drag and drop the background movement
    }
    
}
