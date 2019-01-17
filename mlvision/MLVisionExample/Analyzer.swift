//
//  Analysis.swift
//  MLVisionExample
//
//  Created by Wongsathorn Phaisarnrungpana on 16/1/2562 BE.
//  Copyright © 2562 Google Inc. All rights reserved.
//

import Foundation

class Analyzer{
    
    private let PRODUCT_NAME = "ดีเสิร์ตโตะ"
    private let GRAPE_FAVOR = "องุ่นเคียวโฮ"
    private let BERRY_FAVOR = "มิกซ์เบอร์รีโลลิป็อป"
    private let STRAWBERRY_FAVOR = "สตรอว์เบอรร์รี บิงซู"
    private let SHARP = Character("#")
    
    var cpallText: String = String.init()
    var sevenelevenText: String = String.init()
    var branchText: String = String.init()
    var productList = Array<Product>()
    var receiptIDText: String = String.init()
    
    public func analyze(text: String) -> Void{
        analyzeCPALLText(text: text)
        analyzeSevenElevenText(text: text)
        analyzeBranchText(text: text)
        analyzeProduct(text: text)
        analyzeReceiptID(text: text)

        printResult()
        print("======================================")
    }
    
    public func clearData() -> Void{
        cpallText = String.init()
        sevenelevenText = String.init()
        branchText = String.init()
        productList.removeAll()
        receiptIDText = String.init()
    }
    
    private func analyzeCPALLText(text: String) -> Void{
        if cpallText == ""{
            let CPALL = "CP ALL"
            let isContain = text.contains(CPALL)
            cpallText = isContain ? CPALL : cpallText
        }
    }
    
    private func analyzeSevenElevenText(text: String) -> Void{
        if sevenelevenText == ""{
            let SEVEN_ELEVEN = "7-Eleven"
            let isContain = text.contains(SEVEN_ELEVEN)
            sevenelevenText = isContain ? SEVEN_ELEVEN : sevenelevenText
        }
    }
    
    private func analyzeBranchText(text: String) -> Void{
        if self.branchText == ""{
            let pattern = "\\([0-9]+\\)"
            let branchText = getMatchRegexRuleText(text: text, pattern: pattern)
            self.branchText = branchText ?? self.branchText
        }
    }
    
    private func analyzeProduct(text: String) -> Void{
        let words = text.split(separator: " ")
        guard words.count > 1 else {
            return
        }
        
        let productText = String(words[1])
        let RULES = [PRODUCT_NAME, "เสิร์ดโดะ", "เสิร์ดโตะ", "เสิร์ดโคะ", "เสิร์คโดะ", "เสิร์คโตะ", "เสิร์คโคะ", "เสิร์ตโดะ", "เสิร์ตโตะ", "เสิร์ตโคะ", "เสิร์ทโดะ", "เสิร์ทโตะ", "เสิร์ทโคะ", "เสร็ตโตะ"]
        
        if isContain(text: productText, rules: RULES){
            let name = PRODUCT_NAME
            let favor = getFavorName(text: text)
            let amount = String(words[0])
            let product = Product(name: name,favor: favor,amount: amount)
            productList.append(product)
        }
    }
    
    private func analyzeReceiptID(text: String) -> Void{
        if self.receiptIDText == ""{
            let pattern = "(R\\W[0-9]{10})|(R[0-9]{10})|(R \\W[0-9]{10})"
            if let receiptIDText = getMatchRegexRuleText(text: text, pattern: pattern){
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
    
    private func getValidateSHARPFormat(receiptIDText: String) -> String{
        var receiptID = receiptIDText
        let isHaveShap = receiptID.contains(SHARP)
        if !isHaveShap{
            let index: String.Index = receiptID.firstIndex(of: Character("R"))!
            receiptID.insert(SHARP, at: index)
        }
        return receiptID
    }
    
    private func getFavorName(text: String) -> String{
        if isGrapeFavor(text: text) { return GRAPE_FAVOR }
        if isMixBerryFavor(text: text) { return BERRY_FAVOR }
        return STRAWBERRY_FAVOR
    }
    
    private func isGrapeFavor(text: String) -> Bool{
        let RULES = [GRAPE_FAVOR, "องุ่น", "อรุ่น"]
        return isContain(text: text, rules: RULES)
    }
    
    private func isMixBerryFavor(text: String) -> Bool{
        let RULES = [BERRY_FAVOR, "มิกซ์", "มิก", "มี", "มีกซ์", "มีก"]
        return isContain(text: text, rules: RULES)
    }
    
    private func isContain(text: String, rules: [String]) -> Bool{
        var isContain = false
        for rule in rules{
            isContain = text.contains(rule)
            if isContain { break }
        }
        return isContain
    }
    
    private func getMatchRegexRuleText(text:String, pattern: String) -> String?{
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: text.utf16.count)
        let result = regex.firstMatch(in: text, options: [], range: range)
            .map{String(text[Range($0.range,in: text)!])}
        return result
    }
    
    private func printResult() -> Void{
        print("Haru CPALL : " + cpallText)
        print("Haru 7-Eleven : " + sevenelevenText)
        print("Haru Branch : " + branchText)
        
        productList.forEach{
            print("Haru Product Name : " + $0.name)
            print("Haru Product Favor : " + $0.favor)
            print("Haru Product Amount : " + $0.amount)
        }
        
        print("Haru ReceiptID : " + receiptIDText)
    }
}
