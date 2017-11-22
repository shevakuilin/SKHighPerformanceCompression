//
//  SKGlobalFormattingTool.swift
//  SKHighPerformanceCompression
//
//  [SK:] Responsible for global formatting
//
//  Created by ShevaKuilin on 2017/11/21.
//  Copyright © 2017年 ShevaKuilin. All rights reserved.
//

import Foundation

/** Format print output
 *
 *  @param message  Custom display content [e.g. "array.first"]
 *  @param file     The path contains the symbol
 *  @param method   Method name contains the symbol
 *  @param line     The line in which the symbol is located
 */
public func printLog<T>(_ message: T,
                        file: String = #file,
                        method: String = #function,
                        line: Int = #line) {
    #if DEBUG
        print("File location => [\((file as NSString).lastPathComponent) \(method):] - [Line \(line)], Output content => 「 \(message) 」")
    #endif
}
