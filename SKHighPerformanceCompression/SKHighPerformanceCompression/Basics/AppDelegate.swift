//
//  AppDelegate.swift
//  SKHighPerformanceCompression
//
//  Created by ShevaKuilin on 2017/11/17.
//  Copyright © 2017年 ShevaKuilin. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // Click the close button to minimize the application and open again, not to close it directly.
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        let window = sender.windows.first
        window?.makeKeyAndOrderFront(nil)
        
        return true
    }

}

