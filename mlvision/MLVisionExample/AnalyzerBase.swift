//
//  AnalyzerBase.swift
//  MLVisionExample
//
//  Created by Wongsathorn Phaisarnrungpana on 24/1/2562 BE.
//  Copyright © 2562 Google Inc. All rights reserved.
//

import Foundation
import UIKit

class AnalyzerBase{
    
    //MARK: - Public Const
    let DEFAULT_TEXT = "?"
    let NEW_LINE = "\n"
    let BLANK_SPACE = " "
    let SHARP = Character.init("#")
    let COLOR = UIColor.blue
    
    //MARK: - Public Variable
    //MARK: - Assing at constructor
    var analyzerRulesList = Array<String>()
    var stopAnalyzerProductRulesList = Array<String>()
    var startProductLineIndex: Int = 0
    
    var targetProductList = Array<String>()
    var otherProductList = Array<String>()
    
    //MARK: - Private Variable
    var targetProductRulesList = Array<String>()
    private var isAnalyzingProuductLine = true
    
    //MARK: - Constructor
    init() {
        targetProductRulesList = ["CP", "cp", "bkp", "BKP","ตราห้าาดาว" ,"ห้าดาว", "ท้าดาว", "ไส้กรอก", "ไสกรอก", "ไส้กรอ", "ไสกรอ", "ไส่กรอก", "ไสกรอ", "คูโร", "คุโร", "คโร", "บุตะ", "บูตะ", "บตะ", "โบตะ", "โรโบตะ", "โบดะ", "โรโบดะ" , "น้ำตาว", "kurobuta", "kurobuda", "Kurobuta", "KUROBUTA", "kuro", "Kuro", "KURO", "โบโล", "โบโลน่า", "ชิกเก่นแฟรงค์", "ชิกเก่นแฟรง", "ชิกเกนแฟรง", "ชิกเก่น", "ชิกเกน", "ชิกเก", "แฟรงค์", "แฟร", "แฟรง", ];
    }
    
    //MARK: - Override Method
    func isMatch(text: String) -> Bool {
        fatalError("Subclasses need to implement the `isMatch()` method.")
    }
    
    func analyze(lineText: String, currentLineIndex: Int) -> Void{
        print("Haru currentLineIndex : " + String(currentLineIndex))
        print("Haru lineText : " + lineText)
        analyzeProductLineText(lineText: lineText, currentLineIndex: currentLineIndex)
    }
    
    func clearData() -> Void {
        isAnalyzingProuductLine = true
        targetProductList.removeAll()
        otherProductList.removeAll()
    }
    
    func getConcatStringResult() -> NSMutableAttributedString{
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
    
    func ConvertToAttributeString(hightlightText: String, normalText: String) -> NSMutableAttributedString {
        
        let attribute = [NSAttributedStringKey.foregroundColor : COLOR]
        let highlightAttributeString = NSMutableAttributedString(string: hightlightText, attributes: attribute)
        
        let normalAttributeString = NSMutableAttributedString(string: normalText)
        
        let attributeString = NSMutableAttributedString()
        attributeString.append(highlightAttributeString)
        attributeString.append(normalAttributeString)
        
        return attributeString
    }
    
    //MARK: - Private Method
    private func analyzeProductLineText(lineText: String, currentLineIndex: Int) -> Void{
        
        let isCanAnalyze = currentLineIndex >= startProductLineIndex && isAnalyzingProuductLine
        
        if isCanAnalyze{
            isAnalyzingProuductLine = !isContain(text: lineText, rules: stopAnalyzerProductRulesList)
            
            if isAnalyzingProuductLine{
                let isTargetProduct = isContain(text: lineText, rules: targetProductRulesList)
                
                if isTargetProduct{
                    targetProductList.append(lineText)
                }else{
                    otherProductList.append(lineText)
                }
            }
        }
    }
}
