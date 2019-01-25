//
//  AnalyzerSevenElevenReceipt.swift
//  MLVisionExample
//
//  Created by Wongsathorn Phaisarnrungpana on 24/1/2562 BE.
//  Copyright © 2562 Google Inc. All rights reserved.
//

import Foundation

class AnalyzerSevenElevenReceipt : AnalyzerBase{
    
    private let CPALL = "CP ALL"
    private let SEVEN_ELEVEN = "7-Eleven"
    
    var branchText = "?"
    var receiptIDText = "?"
    
    override init() {
        super.init()
        analyzerRulesList = [CPALL, SEVEN_ELEVEN, "CP", "Eleven", "Elever", "Elev"]
        stopAnalyzerProductRulesList = ["ยอด", "สุทธิ", "สด", "เงินสด", "ทอน", "เงินทอน"]
        startProductLineIndex = 4
    }
    
    override func isMatch(text: String) -> Bool {
        let isMatch = isContain(text: text, rules: analyzerRulesList)
        return isMatch
    }
    
    override func analyze(lineText: String, currentLineIndex: Int) {
        super.analyze(lineText: lineText, currentLineIndex: currentLineIndex)
        
        analyzeBranchText(lineText: lineText)
        analyzeReceiptIDText(lineText: lineText)
    }
    
    override func clearData() {
        super.clearData()
        branchText = DEFAULT_TEXT
        receiptIDText = DEFAULT_TEXT
    }
    
    override func getConcatStringResult() -> String {

        var result = CPALL + BLANK_SPACE + SEVEN_ELEVEN + NEW_LINE
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
    
    private func analyzeBranchText(lineText: String) -> Void{
        if self.branchText == DEFAULT_TEXT{
            let pattern = "\\([0-9]+\\)"
            let branchText = getMatchRegexRuleText(text: lineText, pattern: pattern)
            self.branchText = branchText ?? self.branchText
        }
    }
    
    private func analyzeReceiptIDText(lineText: String) -> Void{
        if self.receiptIDText == DEFAULT_TEXT{
            let pattern = "(R.[0-9]{10})|(R[0-9]{10})|(R[[:blank:]].[0-9]{10})"
            if let receiptIDText = getMatchRegexRuleText(text: lineText, pattern: pattern){
                self.receiptIDText = getValidateReceiptFormat(receiptIDText: receiptIDText)
            }
        }
    }
    
    private func getValidateReceiptFormat(receiptIDText: String) -> String{
        
        var receiptID = receiptIDText
        receiptID.removeAll(where: {$0 == " "})
        var chars = Array(receiptID)
        
        let index = 1
        let str = String(chars[index])
        let isNotInterger = Int(str) == nil
        
        if isNotInterger{
            chars[index] = SHARP
            receiptID = String(chars)
        }else{
            let stringIndex = receiptID.index(receiptID.startIndex, offsetBy: index)
            receiptID.insert(SHARP, at: stringIndex)
        }
        
        return receiptID
    }
}
