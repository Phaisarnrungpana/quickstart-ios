//
//  AnalyzerBase.swift
//  MLVisionExample
//
//  Created by Wongsathorn Phaisarnrungpana on 24/1/2562 BE.
//  Copyright © 2562 Google Inc. All rights reserved.
//

import Foundation

class AnalyzerBase{
    
    //MARK: - Public Const
    let DEFAULT_TEXT = "?"
    let NEW_LINE = "\n"
    let BLANK_SPACE = " "
    let SHARP = Character.init("#")
    
    //MARK: - Public Variable
    //MARK: - Assing at constructor
    var analyzerRulesList = Array<String>()
    var stopAnalyzerProductRulesList = Array<String>()
    var startProductLineIndex: Int = 0
    
    var targetProductList = Array<String>()
    var otherProductList = Array<String>()
    
    //MARK: - Private Variable
    private var targetProductRulesList = Array<String>()
    private var isAnalyzingProuductLine = true
    
    //MARK: - Constructor
    init() {
        targetProductRulesList = [];
    }
    
    //MARK: - Override Method
    func isMatch(text: String) -> Bool {
        fatalError("Subclasses need to implement the `isMatch()` method.")
    }
    
    func analyze(lineText: String, currentLineIndex: Int) -> Void{
        analyzeProductLineText(lineText: lineText, currentLineIndex: currentLineIndex)
    }
    
    func clearData() -> Void {
        targetProductList.removeAll()
    }
    
    func getConcatStringResult() -> String{
        fatalError("Subclasses need to implement the `isMatch()` method.")
    }
    
    //MARK: - Public Method
    func isContain(text: String, rules: [String]) -> Bool{
        var isContain = false
        for rule in rules{
            isContain = text.contains(rule)
            if isContain { break }
        }
        return isContain
    }
    
    func getMatchRegexRuleText(text:String, pattern: String) -> String? {
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: text.utf16.count)
        let result = regex.firstMatch(in: text, options: [], range: range)
            .map{String(text[Range($0.range,in: text)!])}
        return result
    }
    
    //MARK: - Private Method
    private func analyzeProductLineText(lineText: String, currentLineIndex: Int) -> Void{
        
        let isCanAnalyze = currentLineIndex >= startProductLineIndex && isAnalyzingProuductLine
        
        if isCanAnalyze{
            isAnalyzingProuductLine = !isContain(text: lineText, rules: stopAnalyzerProductRulesList)
            
            if isAnalyzingProuductLine{
                
                let isTargetProduct = isContain(text: lineText, rules: targetProductRulesList)
                var targetList = isTargetProduct ? targetProductList : otherProductList
                targetList.append(lineText)
            }
        }
    }
}
