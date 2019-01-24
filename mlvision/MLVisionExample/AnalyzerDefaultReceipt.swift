//
//  AnalyzerDefault.swift
//  MLVisionExample
//
//  Created by Wongsathorn Phaisarnrungpana on 25/1/2562 BE.
//  Copyright © 2562 Google Inc. All rights reserved.
//

import Foundation

class AnalyzerDefaultReceipt: AnalyzerBase {
    
    public var allString: String = ""
    
    override func isMatch(text: String) -> Bool {
        return true
    }
    
    override func analyze(lineText: String, currentLineIndex: Int) {
        super.analyze(lineText: lineText, currentLineIndex: currentLineIndex)
        allString += lineText + NEW_LINE
    }
    
    override func clearData() {
        super.clearData()
        allString = DEFAULT_TEXT
    }
    
    override func getConcatStringResult() -> String {
        return allString
    }
}
