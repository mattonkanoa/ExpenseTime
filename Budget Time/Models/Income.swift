//
//  Income.swift
//  Budget Time
//
//  Created by Kanoa Matton on 5/1/20.
//  Copyright © 2020 Kanoa Matton. All rights reserved.
//

import Foundation

struct Income: Codable {
    
    var income: Double
    var state: String
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("income").appendingPathExtension("plist")
    
    
    static func loadToDo() -> Income? {
        guard let codedToDos = try? Data(contentsOf: ArchiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Income.self, from: codedToDos)
    }
    
    static func saveToDos(_ income: Income) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(income)
        try? codedToDos?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadSampleToDos() -> Income {
        
           let totalIncome = Income(income: 0, state: "California")
           
           return totalIncome
       }
    
}
