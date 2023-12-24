//
//  BudgetTableViewController.swift
//  Budget Time
//
//  Created by Kanoa Matton on 4/22/20.
//  Copyright © 2020 Kanoa Matton. All rights reserved.
//
//APP ID: ca-app-pub-5510952973561945~6110440872
//ADD UNIT: ca-app-pub-5510952973561945/4366114367
//TEST UNIT: ca-app-pub-3940256099942544/2934735716

import UIKit
import UserNotifications
import GoogleMobileAds

class BudgetTableViewController: UITableViewController {


    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var noCurrentExpenseLabel: UILabel!
    
    var expenses = [Expense]()
    
    var test = "String"
    var total: Double = 0
    let totalString = "Total Due"
    
    var dates = [Date]()
    let defaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //CHECK TO SEE IF THE SETTING IS SET TO ALWAYS SHOW TOTAL EXPENSES. IF IT IS TRUE, THEN IT BEING HIDDEN IS FALSE AND VICE VERSA
        let defaultsAlwaysShowExpenses = defaults.bool(forKey: "AlwaysShowTotalExpenses")
        if defaultsAlwaysShowExpenses == true {
            totalLabel.isHidden = false
        } else if defaultsAlwaysShowExpenses == false {
            totalLabel.isHidden = true
        }
        
        //HOW TO ADD CUSTOM UIVIEW TO TABLEVIEW (THIS IS AN AD)
        let gadBanner = GADBannerView(frame: CGRect(x: self.view.frame.width/2 - 160, y: self.view.frame.height-140, width: 320, height: 50))
        self.navigationController?.view.addSubview(gadBanner)
        gadBanner.adUnitID = "ca-app-pub-5510952973561945/4366114367"
        gadBanner.rootViewController = self
        gadBanner.load(GADRequest())
        
        
        //CHECK TO SEE IF THERE ARE EXPENSES STORED ALREADY
        if let savedExpenses = Expense.loadToDo() {
            expenses = savedExpenses
        }
        updateDatesInExpenses()
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        
        for expense in expenses {
            total += expense.price
            dates.append(expense.dueDate)
        }
        //THIS SORTS
        sortExpenses()
        totalLabel.text = "$\(total)"
        updateNoExpensesLabel()
        registerLocal()
        scheduleLocal()
        
             
    }
    
    //VIEW WILL APPEAR TO UPDATE WHEN THE EXPENSES VIEW REAPPEARS TO UPDATE ANY SETTINGS MADE
    
    override func viewDidAppear(_ animated: Bool) {
        //CHECK TO SEE IF THE SETTING IS SET TO ALWAYS SHOW TOTAL EXPENSES. IF IT IS TRUE, THEN IT BEING HIDDEN IS FALSE AND VICE VERSA
        let defaultsAlwaysShowExpenses = defaults.bool(forKey: "AlwaysShowTotalExpenses")
        if defaultsAlwaysShowExpenses == true {
            totalLabel.isHidden = false
        } else if defaultsAlwaysShowExpenses == false {
            totalLabel.isHidden = true
        }
    }
    
    //UPDATE THE NO CURRENT EXPENSES LABEL
    func updateNoExpensesLabel() {
        if expenses.count < 1 {
            noCurrentExpenseLabel.isHidden = false
        } else {
            noCurrentExpenseLabel.isHidden = true
        }
    }
    //UPDATE DATES FOR RECURRING ONES
    func updateDatesInExpenses() {
        let midnightToday = Calendar.current.startOfDay(for: Date())
        var dateComponent = DateComponents()
        dateComponent.month = 1

        var i = 0
        for expense in expenses {
            if (expense.dueDate < midnightToday) && (expense.recurring == true) {
                let newDate = Calendar.current.date(byAdding: dateComponent, to: expense.dueDate)
                expenses.append(Expense(name: expense.name, dueDate: newDate!, price: expense.price, userNameEmail: expense.userNameEmail, password: expense.password, methodOfPayment: expense.methodOfPayment, recurring: expense.recurring))
                expenses.remove(at: i)
            }
            i += 1
        }
        sortExpenses()
        tableView.reloadData()
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) {
            granted, error in
            if granted {
                print("GRANTED")
            } else {
                print("NOT GRANTED")
            }
        }
    }
    
    @objc func scheduleLocal() {
        let midnightToday = Calendar.current.startOfDay(for: Date())
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        
        for expense in expenses {
            if expense.dueDate > midnightToday {
                
                
                let content = UNMutableNotificationContent()
                content.title = "Expense Due Soon!"
                content.body = "You have an expense due soon. Come see what expense it is!"
                content.categoryIdentifier = "expense"
                content.userInfo = ["customData": "fizz"]
                content.sound = .default
                
                //var dateComponents = DateComponents()
                //dateComponents.minute = 30
                let calendar = Calendar.current
                let components = calendar.dateComponents([.day, .month, .year], from: expense.dueDate)
                
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
                
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    center.add(request)
                
                
                break
            }
        }
        
        
        
        
    }
    
    
    
    func sortExpenses(){
        expenses = expenses.sorted(by: {$0.dueDate.compare($1.dueDate) == .orderedAscending})
    }
    
    //UPDATE EXPENSES TO SHOW RED IF ITS PAST DUE DATE
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return expenses.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let midnightToday = Calendar.current.startOfDay(for: Date())

        let cell = tableView.dequeueReusableCell(withIdentifier: "expenseCell", for: indexPath) as! BudgetTableViewCell
        
        
        // Configure the cell...
        let expense = expenses[indexPath.row]
        
        
        //IF CELL
        if expense.dueDate < midnightToday {
            cell.nameLabel.textColor = .red
            cell.priceLabel.textColor = .red
            cell.dueDateLabel.textColor = .red
            
        } else {
            cell.nameLabel.textColor = .black
            cell.priceLabel.textColor = .black
            cell.dueDateLabel.textColor = .black
        }
        cell.update(with: expense)
        cell.showsReorderControl = true

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let expense = expenses[indexPath.row]
            expenses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Expense.saveToDos(expenses)
            total -= expense.price
            totalLabel.text = "$\(total)"
            updateNoExpensesLabel()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if segue.identifier == "EditExpense" {
            let indexPath = tableView.indexPathForSelectedRow!
            let expense = expenses[indexPath.row]
            let navController = segue.destination as! UINavigationController
            let addEditExpenseTableViewController = navController.topViewController as! AddEditTableViewController
            
            addEditExpenseTableViewController.expense = expense
        }
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func unwindToBudgetTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind", let sourceViewController = segue.source as? AddEditTableViewController else {return}
        guard segue.identifier == "saveUnwind", let expense = sourceViewController.expense else {return}
        

        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            total = 0
            expenses[selectedIndexPath.row] = expense
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
            for expense in expenses {
                total += expense.price
            }
            totalLabel.text = "$\(total)"
            sortExpenses()
            self.tableView.reloadData()
            
        } else {
            
            let newIndexPath = IndexPath(row: expenses.count, section: 0)
            expenses.append(expense)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            //save total
            total += expense.price
            totalLabel.text = "$\(total)"
            sortExpenses()
            self.tableView.reloadData()
            
        }
        
        Expense.saveToDos(expenses)
        updateNoExpensesLabel()
        updateDatesInExpenses()
        tableView.reloadData()
        
        
    }
    
    
    

}
