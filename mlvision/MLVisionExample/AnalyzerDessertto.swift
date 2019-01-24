//
//  AnalyzerDessertto.swift
//  MLVisionExample
//
//  Created by Wongsathorn Phaisarnrungpana on 16/1/2562 BE.
//  Copyright © 2562 Google Inc. All rights reserved.
//

import Foundation

class AnalyzerDessertto{
    
    private let DEFAULT_TEXT = "?"
    private let PRODUCT_NAME = "ดีเสิร์ตโตะ"
    private let GRAPE_FAVOR = "องุ่นเคียวโฮ"
    private let BERRY_FAVOR = "มิกซ์เบอร์รีโลลิป็อป"
    private let STRAWBERRY_FAVOR = "สตรอว์เบอรร์รี บิงซู"
    private let CPALL = "CP ALL"
    private let SEVEN_ELEVEN = "7-Eleven"
    private let SHARP = Character("#")
    
    var cpallText: String = "?"
    var sevenelevenText: String = "?"
    var branchText: String = "?"
    var productList = Array<Product>()
    var receiptIDText: String = "?"
    
    public func analyze(text: String) -> Void{
        print("Haru RawData : " + text)
        
        analyzeCPALLText(text: text)
        analyzeSevenElevenText(text: text)
        analyzeBranchText(text: text)
        analyzeProduct(text: text)
        analyzeReceiptID(text: text)

        printResult()
        print("======================================")
    }
    
    public func clearData() -> Void{
        cpallText = DEFAULT_TEXT
        sevenelevenText = DEFAULT_TEXT
        branchText = DEFAULT_TEXT
        productList.removeAll()
        receiptIDText = DEFAULT_TEXT
    }
    
    public func getConcatAnalyzedString() -> String{
        
        let newline = "\n"
        let blankSpace = " "
        
        var analyzedString = "CPALL : " + cpallText + newline
        analyzedString += "7-Eleven : " + sevenelevenText + newline
        analyzedString += "Branch : " + branchText + newline
        
        productList.forEach({product in
            analyzedString += "Product : "
            analyzedString += product.name
            analyzedString += blankSpace
            analyzedString += product.favor
            analyzedString += blankSpace
            analyzedString += ",จำนวน : " + product.amount
            analyzedString += newline
        })
        
        analyzedString += newline
        analyzedString += "ReceiptID : " + receiptIDText + newline
        
        return analyzedString
    }
    
    private func analyzeCPALLText(text: String) -> Void{
        if cpallText == DEFAULT_TEXT{
            let RULES = [CPALL, "CP", "ALL"]
            if isContain(text: text, rules: RULES){
                cpallText = CPALL
            }
        }
    }
    
    private func analyzeSevenElevenText(text: String) -> Void{
        if sevenelevenText == DEFAULT_TEXT{
            let RULES = [SEVEN_ELEVEN, "7-", "Eleven", "Elever", "Elev"]
            if isContain(text: text, rules: RULES){
                sevenelevenText = SEVEN_ELEVEN
            }
        }
    }
    
    private func analyzeBranchText(text: String) -> Void{
        if self.branchText == DEFAULT_TEXT{
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
        let RULES = [PRODUCT_NAME, "เสิร์ดโดะ", "เสิร์ดโตะ", "เสิร์ดโคะ", "เสิร์คโดะ", "เสิร์คโตะ", "เสิร์คโคะ", "เสิร์ตโดะ", "เสิร์ตโตะ", "เสิร์ตโคะ", "เสิร์ทโดะ", "เสิร์ทโตะ", "เสิร์ทโคะ", "เสร็ตโตะ", "เช็คโอะ"]
        
        if isContain(text: productText, rules: RULES){
            let name = PRODUCT_NAME
            
            let favorText = String(words[2])
            let favor = getFavorName(text: favorText)
            
            let amountText = String(words[0])
            let isNumerical = Int(amountText) != nil
            let amount = isNumerical ? amountText : DEFAULT_TEXT
            
            let product = Product(name: name,favor: favor,amount: amount)
            productList.append(product)
        }
    }
    
    private func analyzeReceiptID(text: String) -> Void{
        if self.receiptIDText == DEFAULT_TEXT{
            let pattern = "(R.[0-9]{10})|(R[0-9]{10})|(R[[:blank:]].[0-9]{10})"
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
    
    private func getFavorName(text: String) -> String{
        if isGrapeFavor(text: text) { return GRAPE_FAVOR }
        if isMixBerryFavor(text: text) { return BERRY_FAVOR }
        if isStawberryFavor(text: text){ return STRAWBERRY_FAVOR }
        return DEFAULT_TEXT
    }
    
    private func isGrapeFavor(text: String) -> Bool{
        let RULES = [GRAPE_FAVOR, "องุ่น", "อรุ่น"]
        return isContain(text: text, rules: RULES)
    }
    
    private func isMixBerryFavor(text: String) -> Bool{
        let RULES = [BERRY_FAVOR, "มิกซ์", "มิก", "มี", "มีกซ์", "มีก"]
        return isContain(text: text, rules: RULES)
    }
    
    private func isStawberryFavor(text: String) -> Bool{
        let RULES = [STRAWBERRY_FAVOR, "สตรอ","สตรอว" , "สตรอว์"]
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
    
    private func isSimilarity(text: String, rules: [String]) -> Bool{
        var similarityPercentageList = [Int]()
        for rule in rules{
            let similarityPercentage = getSimilarityPercentage(mainText: text, checkedText: rule)
            similarityPercentageList.append(similarityPercentage)
        }
        
        let CRITERIA = 50
        let maxPercentage = similarityPercentageList.max()
        let isSimilarity = maxPercentage! > CRITERIA
        return isSimilarity
    }
    
    private func getMatchRegexRuleText(text:String, pattern: String) -> String?{
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: text.utf16.count)
        let result = regex.firstMatch(in: text, options: [], range: range)
            .map{String(text[Range($0.range,in: text)!])}
        return result
    }
    
    private func getSimilarityPercentage(mainText: String, checkedText: String) -> Int{
        let levenshteinResult = Levenshtein.levenshtein(aStr: mainText, bStr: checkedText)
        let differentPercentage = (levenshteinResult * 100 / mainText.count)
        let similarityPercentage = 100 - differentPercentage
        
        return similarityPercentage
    }
    
    private func getAveragePercentage(percentageList: [Int]) -> Int{
        let sumPercentage = percentageList.reduce(0,+)
        let averagePercentage = sumPercentage / percentageList.count
        return averagePercentage
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
