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
    
    private var hightlightText: String = ""
    private var normalText: String = ""
    
    override init() {
        super.init()
        
        targetProductList.append("7-Eleven")
        targetProductList.append("แม็คโคร")
        targetProductList.append("TESCO")
        targetProductList.append("LOTUS")
    }
    
    override func isMatch(text: String) -> Bool {
        return true
    }
    
    override func analyze(lineText: String, currentLineIndex: Int) {
        allString += lineText + NEW_LINE
        
        let isProduct = isContain(text: lineText, rules: targetProductRulesList)
        if isProduct {
            hightlightText += lineText + NEW_LINE
        }else{
            normalText += lineText + NEW_LINE
        }
    }
    
    override func clearData() {
        super.clearData()
        allString = DEFAULT_TEXT
        hightlightText = ""
        normalText = ""
    }
    
    override func getConcatStringResult() -> NSMutableAttributedString {
        return ConvertToAttributeString(hightlightText: hightlightText, normalText: normalText)
    }
}
