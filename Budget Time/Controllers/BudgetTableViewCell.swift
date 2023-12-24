//
//  BudgetTableViewCell.swift
//  Budget Time
//
//  Created by Kanoa Matton on 4/22/20.
//  Copyright © 2020 Kanoa Matton. All rights reserved.
//

import UIKit

class BudgetTableViewCell: UITableViewCell {

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
    
    func update(with expense: Expense) {        
        priceLabel.text = "$\(expense.price)"
        nameLabel.text = expense.name
        dueDateLabel.text = " Due:  \(Expense.dueDateFormatter.string(from: expense.dueDate))"
    }
    
    

}
