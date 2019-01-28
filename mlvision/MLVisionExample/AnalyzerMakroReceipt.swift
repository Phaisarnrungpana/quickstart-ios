//
//  AnalyzerMakroReceipt.swift
//  MLVisionExample
//
//  Created by Wongsathorn Phaisarnrungpana on 24/1/2562 BE.
//  Copyright © 2562 Google Inc. All rights reserved.
//

import Foundation

class AnalyzerMakroReceipt: AnalyzerBase{
    
    private let MAKRO = "บมจ.สยามแม็คโคร"
    private let BRANCH_LINE_INDEX = 0
    
    var branchText = "?"
    var posIDText = "?"
    
    override init() {
        super.init()
        analyzerRulesList = [MAKRO, "สยามแม็กโคร", "แม็ค", "โคร"]
        stopAnalyzerProductRulesList = ["TOTAL", "TOT", "OTAL", "T0TAL", "0TAL"]
        startProductLineIndex = 6
    }
    
    override func isMatch(text: String) -> Bool {
        let isMatch = isContain(text: text, rules: analyzerRulesList)
        return isMatch
    }
    
    override func analyze(lineText: String, currentLineIndex: Int) {
        super.analyze(lineText: lineText, currentLineIndex: currentLineIndex)
        analyzeBranchText(lineText: lineText, lineIndex: currentLineIndex)
        analyzePosIDText(lineText: lineText)
    }
    
    override func clearData() {
        super.clearData()
        
        branchText = DEFAULT_TEXT
        posIDText = DEFAULT_TEXT
    }
    
    override func getConcatStringResult() -> NSMutableAttributedString {
        
        var hightlightText = MAKRO + NEW_LINE
        hightlightText += "Branch : " + branchText + NEW_LINE
        hightlightText += "POS ID : " + posIDText + NEW_LINE
        
        hightlightText += "Target Product : " + NEW_LINE
        targetProductList.forEach { (product) in
            hightlightText += product + NEW_LINE
        }
        
        var normalText = "Other Product : " + NEW_LINE
        otherProductList.forEach { (product) in
            normalText += product + NEW_LINE
        }
        
        return ConvertToAttributeString(hightlightText: hightlightText, normalText: normalText)
    }
    
    private func analyzeBranchText(lineText: String, lineIndex: Int) -> Void{
        
        var branch = lineText
        branch.removeAll(where: {$0 == "."})
        branch.removeAll(where: {$0 == ","})
        
        let words = branch.split(separator: " ")
        let isNeverAssignBranch = self.branchText == DEFAULT_TEXT
        let isTargetLineIndex = lineIndex == BRANCH_LINE_INDEX
        let isFoundBranch = words.count >= 2
        
        if isNeverAssignBranch && isTargetLineIndex && isFoundBranch{
            branchText = ""
            for i in 1..<words.count{
                branchText += words[i]
            }
        }
    }
    
    private func analyzePosIDText(lineText: String) -> Void{
        if self.posIDText == DEFAULT_TEXT {
            let pattern = "P.S ... \\w{15}"
            if let posIDText = getMatchRegexRuleText(text: lineText, pattern: pattern){
                self.posIDText = getValidatePosIDFormat(posIDText: posIDText)
            }
        }
    }
    
    private func getValidatePosIDFormat(posIDText: String) -> String{
        
        var posID = posIDText
        posID.removeAll(where: {$0 == " "})
        var chars = Array(posID)
        chars[1] = Character.init("O")
        chars[3] = Character.init("I")
        chars[4] = Character.init("D")
        chars[5] = SHARP
        
        posID = String(chars)
        let index2ToInsert = posID.index(posID.startIndex, offsetBy: 2)
        posID.insert(" ", at: index2ToInsert)
        
        let index6ToInsert = posID.index(posID.startIndex, offsetBy: 6)
        posID.insert(" ", at: index6ToInsert)
        
        return posID
    }
}
