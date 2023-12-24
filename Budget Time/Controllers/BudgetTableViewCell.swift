//
//  BudgetTableViewCell.swift
//  Budget Time
//
//  Created by Kanoa Matton on 4/22/20.
//  Copyright © 2020 Kanoa Matton. All rights reserved.
//

import UIKit

class BudgetTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonExpenseView: Round_Button!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func customizeButton(buttonName: UIButton) {
        if #available(iOS 13.0, *) {
            buttonName.layer.shadowColor = .init(srgbRed: 0, green: 250, blue: 0, alpha: 1)
        } else {
            // Fallback on earlier versions
        }
        buttonName.layer.shadowOpacity = 0.8
        buttonName.layer.shadowRadius = 4
        buttonName.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    func update(with expense: Expense) {
        let midnightToday = Calendar.current.startOfDay(for: Date())
        
        //let dateDifference = expense.dueDate.timeIntervalSince(midnightToday)
        let diff = expense.dueDate.interval(ofComponent: .day, fromDate: midnightToday)
        
        priceLabel.text = "$\(expense.price)"
        nameLabel.text = expense.name
        dueDateLabel.text = " Due in \(diff) days -  \(Expense.dueDateFormatter.string(from: expense.dueDate))"
        customizeButton(buttonName: buttonExpenseView)
    }
    
    

}

extension Date {

    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {

        let currentCalendar = Calendar.current

        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }
}
