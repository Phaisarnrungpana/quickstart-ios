//
//  AnalyzerFactory.swift
//  MLVisionExample
//
//  Created by Wongsathorn Phaisarnrungpana on 24/1/2562 BE.
//  Copyright © 2562 Google Inc. All rights reserved.
//

import Foundation

class AnalyzerFactory{
    
    static let analyzerList = [
        AnalyzeLotusReceipt.init(),
        AnalyzerMakroReceipt.init(),
        AnalyzerSevenElevenReceipt.init(),
        AnalyzerDefaultReceipt.init()
    ]
    
    static func getAnalyzer(text: String) -> AnalyzerBase{
        let analyzer = analyzerList.first { (analyzer) -> Bool in
            analyzer.isMatch(text: text)
        }
        return analyzer!
    }
}
