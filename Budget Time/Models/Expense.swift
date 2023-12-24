//
//  Expense.swift
//  Budget Time
//
//  Created by Kanoa Matton on 4/22/20.
//  Copyright © 2020 Kanoa Matton. All rights reserved.
//

import Foundation



struct Expense: Codable {
    
    
    var name: String
    var dueDate: Date
    var price: Double
    var userNameEmail: String?
    var password: String?
    var methodOfPayment: String
    var recurring: Bool
    
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("expenses").appendingPathExtension("plist")
    
    
    static func loadToDo() -> [Expense]? {
        guard let codedToDos = try? Data(contentsOf: ArchiveURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Expense>.self, from: codedToDos)
    }
    
    static func saveToDos(_ expenses: [Expense]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(expenses)
        try? codedToDos?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    static func loadSampleToDos() -> [Expense] {
        let expense1 = Expense(name: "Expense 1", dueDate: Date(), price: 0, userNameEmail: nil, password: nil, methodOfPayment: "None", recurring: true)
        let expense2 = Expense(name: "Expense 2", dueDate: Date(), price: 0, userNameEmail: nil, password: nil, methodOfPayment: "None", recurring: true)
        
        return []
    }
    
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        //formatter.timeStyle = .short
        return formatter
        
    }()
    

}
