//
//  AnalyzerLotusReceipt.swift
//  MLVisionExample
//
//  Created by Wongsathorn Phaisarnrungpana on 24/1/2562 BE.
//  Copyright © 2562 Google Inc. All rights reserved.
//

import Foundation

class AnalyzeLotusReceipt: AnalyzerBase {
    
    private let TESTCO_LOTUS = "TESCO LOTUS"
    private let BRANCH_LINE_INDEX = 0
    
    var branchText = "?"
    var receiptIDText = "?"
    
    override init() {
        super.init()
        analyzerRulesList = [TESTCO_LOTUS, "TESCO", "LOTUS", "TESC", "LOTU"]
        stopAnalyzerProductRulesList = ["เงิน", "สด", "ทอน"]
        startProductLineIndex = 3
    }
    
    override func isMatch(text: String) -> Bool {
        let isMatch = isContain(text: text, rules: analyzerRulesList)
        return isMatch
    }
    
    override func analyze(lineText: String, currentLineIndex: Int) {
        super.analyze(lineText: lineText, currentLineIndex: currentLineIndex)
        
        analyzeBranchText(lineText: lineText,lineIndex: currentLineIndex)
        analyzeReceiptIDText(lineText: lineText)
    }
    
    override func clearData() {
        super.clearData()
        branchText = DEFAULT_TEXT
        receiptIDText = DEFAULT_TEXT
    }
    
    override func getConcatStringResult() -> String {
        
        var result = TESTCO_LOTUS + NEW_LINE
        result += "Branch : " + branchText + NEW_LINE
        result += "ReceiptID : " + receiptIDText + NEW_LINE
        
        result += "Target Product : " + NEW_LINE
        targetProductList.forEach { (product) in
            result += product + NEW_LINE
        }
        
        result += "Other Product : " + NEW_LINE
        otherProductList.forEach { (product) in
            result += product + NEW_LINE
        }
        
        return result
    }
    
    private func analyzeBranchText(lineText: String, lineIndex: Int) -> Void{
        
        let words = lineText.split(separator: " ")
        let isNeverAssignBrach = self.branchText == DEFAULT_TEXT
        let isTargetLineIndex = lineIndex == BRANCH_LINE_INDEX
        let isFoundBrachText = words.count >= 2
        
        if isNeverAssignBrach && isTargetLineIndex && isFoundBrachText{
            branchText = ""
            for i in 2..<words.count{
                branchText += words[i];
            }
        }
    }
    
    private func analyzeReceiptIDText(lineText: String) -> Void{
        if self.receiptIDText == DEFAULT_TEXT{
            let pattern = "R... \\w{15}"
            if let receiptIDText = getMatchRegexRuleText(text: lineText, pattern: pattern){
                self.receiptIDText = getValidateReceiptFormat(receiptIDText: receiptIDText)
            }
        }
    }
    
    private func getValidateReceiptFormat(receiptIDText: String) -> String{
        
        var receiptID = receiptIDText
        receiptID.removeAll(where: {$0 == " "})
        receiptID.removeAll(where: {$0 == "."})
        receiptID.removeAll(where: {$0 == ","})
        
        var chars = Array(receiptID)
        chars[1] = Character.init("I")
        chars[2] = Character.init("D")
        
        receiptID = String(chars)
        let indexToInsert = receiptID.index(receiptID.startIndex, offsetBy: 3)
        receiptID.insert(".", at: indexToInsert)
        
        return receiptID
    }
}
