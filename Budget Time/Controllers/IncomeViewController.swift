//
//  IncomeViewController.swift
//  Budget Time
//
//  Created by Kanoa Matton on 5/1/20.
//  Copyright © 2020 Kanoa Matton. All rights reserved.
//
//TO DO
//ADDITIONAL INCOME

import UIKit
import AudioToolbox
import GoogleMobileAds
import FSCalendar

class IncomeViewController: UIViewController, UNUserNotificationCenterDelegate, FSCalendarDelegate, FSCalendarDelegateAppearance {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var buttonDataView: Round_Button!
    @IBOutlet weak var currentDateButtonView: Round_Button!
    @IBOutlet weak var nextPaymentDueButtonView: Round_Button!
    @IBOutlet weak var currentDateView: UIView!
    @IBOutlet weak var nextPaymentView: UIView!
    
    //var income: Income
    @IBOutlet weak var totalIncomeAfterTaxLabel: UILabel!
    @IBOutlet weak var netIncomeAfterExpensesLabel: UILabel!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var gadBannerHome: GADBannerView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nextPaymentDueLabel: UILabel!
    @IBOutlet weak var nextPaymentDueAmount: UILabel!
    @IBOutlet weak var guidedView: UIView!
    @IBOutlet weak var guidedViewBackgroundImage: UIImageView!
    @IBOutlet weak var pressDownUpButton: UIButton!
    
    @IBOutlet weak var guidedViewTopConstraint: NSLayoutConstraint!
    
    var income: Income?
    var expenses: [Expense]?
    var dates: [String] = []
    var datesCanBeSelected: [String] = []
    let defaults = UserDefaults.standard
    var guidedViewDown = false
    var formatter = DateFormatter()
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        registerRemoteNotification()
        
        
        animateTotalIncomeShadow()
        customizeButton(buttonName: currentDateButtonView)
        customizeButton(buttonName: nextPaymentDueButtonView)
        
        updateDateLabel()
        updateWelcomeLabel()
        dataView.layer.cornerRadius = 15
        guidedViewBackgroundImage.layer.cornerRadius = 20
        
        
        //TO BLUR OUT THE EDGES
        //let gradientMaskLayer = CAGradientLayer()
        //gradientMaskLayer.frame = dataView.bounds
        //gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        //gradientMaskLayer.locations = [0, 0.01, 0.99, 1]
        //dataView.layer.mask = gradientMaskLayer
        //view.addSubview(dataView)
        
        
        gadBannerHome.adUnitID = "ca-app-pub-5510952973561945/6895116929"
        gadBannerHome.rootViewController = self
        gadBannerHome.load(GADRequest())
        
        
        
        if let savedIncome = Income.loadToDo() {
            income = savedIncome
            totalIncomeAfterTaxLabel.text = "$\(income!.income)"
        } else {
            income = Income.loadSampleToDos()
        }
        if let savedExpenses = Expense.loadToDo() {
            expenses = savedExpenses
        } else {
            expenses = Expense.loadSampleToDos()
        }
        updateDatesInExpenses()
        sortExpenses()
        updateNextPaymentDueLabel()
        updateNetIncomeAndLabel()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Reset dates values to avoid any bugs of then not clearing
        dates = []
        calendar.reloadData()
    }
    
    
    // MARK: CALENDAR STUFF
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        
        formatter.dateFormat = "MM-dd-yyyy"
        //Get the due date
        var dueDate = Date()
        var calendarDate = DateComponents()
        var excludedDate:Date
        
        if expenses!.count == 0 {
            return nil
        }
        
        for expense in expenses! {
            
            dueDate = expense.dueDate
            calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: dueDate)
            dates.append("\(calendarDate.month!)-\(calendarDate.day!)-\(calendarDate.year!)")
            
        }
        
        for i in 0...dates.count-1 {
            
            excludedDate = formatter.date(from: dates[i])!
            
            if date.compare(excludedDate) == .orderedSame {
                return .green
            }
        }
      
        return nil
        
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        formatter.dateFormat = "MM-dd-yyyy"
        //Get the due date
        var dueDate = Date()
        var calendarDate = DateComponents()
        var excludedDate:Date
        
        if expenses!.count == 0 {
            return false
        }
        
        for expense in expenses! {
            
            dueDate = expense.dueDate
            calendarDate = Calendar.current.dateComponents([.day, .year, .month], from: dueDate)
            datesCanBeSelected.append("\(calendarDate.month!)-\(calendarDate.day!)-\(calendarDate.year!)")
            
        }
        
        for i in 0...datesCanBeSelected.count-1 {
            
            excludedDate = formatter.date(from: datesCanBeSelected[i])!
            
            if date.compare(excludedDate) == .orderedSame {
                return true
            }
        }
      
        return false
    }
    
    
    func registerRemoteNotification() {
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
        }
    
        
    }
    
    //TO UPDATE HOME PAGE WHEN U COME FROM EXPENSE PAGE
    override func viewWillAppear(_ animated: Bool) {
        if let savedExpenses = Expense.loadToDo() {
            expenses = savedExpenses
        } else {
            expenses = Expense.loadSampleToDos()
        }
        updateDatesInExpenses()
        sortExpenses()
        updateNextPaymentDueLabel()
        updateNetIncomeAndLabel()
        updateWelcomeLabel()
        updateDateLabel()
    }
    
   
    
    func sortExpenses(){
        if (expenses != nil) && (expenses!.count > 0) {
            expenses = expenses!.sorted(by: {$0.dueDate.compare($1.dueDate) == .orderedAscending})
        }
    }
    
    func updateDatesInExpenses() {
        let midnightToday = Calendar.current.startOfDay(for: Date())
        var dateComponent = DateComponents()
        dateComponent.month = 1

        if (expenses != nil) && (expenses!.count > 0) {
            var i = 0
            for expense in expenses! {
                //REMOVE THE EXPENSE AND RE APPEND IT TO THE BOTTOM IF IT RECURRS
                if (expense.dueDate < midnightToday) && (expense.recurring == true) {
                    let newDate = Calendar.current.date(byAdding: dateComponent, to: expense.dueDate)
                    expenses!.append(Expense(name: expense.name, dueDate: newDate!, price: expense.price, userNameEmail: expense.userNameEmail, password: expense.password, methodOfPayment: expense.methodOfPayment, recurring: expense.recurring))
                    expenses!.remove(at: i)
                    
                }
                else if (expense.dueDate < midnightToday) && (expense.recurring == false){
                    //REMOVE THE EXPENSE AND REPEND IT BUT DONT ADD ONTO THE DATE
                    //expenses!.append(Expense(name: expense.name, dueDate: expense.dueDate, price: expense.price, userNameEmail: expense.userNameEmail, password: expense.password, methodOfPayment: expense.methodOfPayment, recurring: expense.recurring))
                    expenses!.remove(at: i)
                }
                
                i += 1
            }
            Expense.saveToDos(expenses!)
        }
        
        sortExpenses()
    }
    
    
    
    func updateDateLabel() {
        
        guidedView.layer.cornerRadius = 20
        guidedView.layer.borderWidth = 0
        guidedView.layer.shadowOpacity = 0.6
        guidedView.layer.shadowRadius = 15
        guidedView.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        var monthAsString = ""
        let midnightToday = Calendar.current.startOfDay(for: Date())
        let calenderDate = Calendar.current.dateComponents([.day, .year, .month], from: midnightToday)
        
        switch calenderDate.month {
        case 1:
            monthAsString = "January"
        case 2:
            monthAsString = "February"
        case 3:
            monthAsString = "March"
        case 4:
            monthAsString = "April"
        case 5:
            monthAsString = "May"
        case 6:
            monthAsString = "June"
        case 7:
            monthAsString = "July"
        case 8:
            monthAsString = "August"
        case 9:
            monthAsString = "September"
        case 10:
            monthAsString = "October"
        case 11:
            monthAsString = "November"
        case 12:
            monthAsString = "December"
        default:
            break
        }
        
        
        //dateLabel.text = Expense.dueDateFormatter.string(from: midnightToday)
        dateLabel.text = "\(monthAsString) \(calenderDate.day!), \(calenderDate.year!)"
    }
    
    func animateTotalIncomeShadow() {
        
        Round_Button.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            if #available(iOS 13.0, *) {
                self.buttonDataView.layer.shadowColor = .init(srgbRed: 0, green: 250, blue: 0, alpha: 1)
            } else {
                // Fallback on earlier versions
            }
            
            self.buttonDataView.layer.shadowOpacity = 1
            self.buttonDataView.layer.shadowRadius = 4
            self.buttonDataView.layer.shadowOffset = CGSize(width: 1, height: 1)
        }, completion: nil)
        
    }
    
    func updateNextPaymentDueLabel() {
        let midnightToday = Calendar.current.startOfDay(for: Date())
        
        if (expenses != nil) && (expenses!.count > 0) {
            let currentExpense = expenses![0]
            
            nextPaymentDueAmount.text = "$\(currentExpense.price)"
            
            //let diff = expense.dueDate.interval(ofComponent: .day, fromDate: midnightToday)
            let diff = currentExpense.dueDate.interval(ofComponent: .day, fromDate: midnightToday)
            if diff == 1 {
                nextPaymentDueLabel.text = "\(diff) day, \(currentExpense.name)"
            }
            else if diff == 0{
                nextPaymentDueLabel.text = "Today, \(currentExpense.name)"
            }
            else {
                nextPaymentDueLabel.text = "\(diff) days, \(currentExpense.name)"
            }
            
            
        } else {
            nextPaymentDueLabel.text = "No Upcoming Payments"
            nextPaymentDueAmount.text = ""
        }
        
        
    }
    
    func customizeButton(buttonName: UIButton) {
        /*
        if #available(iOS 13.0, *) {
            buttonName.layer.shadowColor = .init(srgbRed: 0, green: 250, blue: 0, alpha: 1)
        } else {
            // Fallback on earlier versions
        }*/
        buttonName.layer.shadowOpacity = 0.3
        buttonName.layer.shadowRadius = 4
        buttonName.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    func updateWelcomeLabel() {
        let defaultsName = defaults.string(forKey: "Name")
        if defaultsName != nil {
            welcomeLabel.text = "Welcome, \(defaultsName!)!"
        } else {
            welcomeLabel.text = "Welcome"
        }
    }
    
    func updateNetIncomeAndLabel() {
        if let savedIncome = Income.loadToDo() {
            income = savedIncome
        } else {
            income = Income.loadSampleToDos()
        }
        var total: Double = 0
        for expense in expenses! {
            total += expense.price
        }
        let totalNetIncome = income!.income - total
        let totalNetIncomeRounded = Double(round(100*totalNetIncome)/100)
        netIncomeAfterExpensesLabel.text = "$\(totalNetIncomeRounded)"
        if totalNetIncome < 0 {
            noticeLabel.text = "Oh no! Your're losing $\(totalNetIncomeRounded) monthly. Your net income is less than 0!"
        } else if totalNetIncome == 0{
            noticeLabel.text = "You're saving $0 monthly. Try lowering any unnecessary expenses to save more money!"
        } else {
            noticeLabel.text = "You're saving this much monthly!"
        }
    }
    
   
    @IBAction func pressDownPressed(_ sender: UIButton) {
        
        guidedViewDown = !guidedViewDown
        
        if guidedViewDown {
            guidedViewTopConstraint.constant = -100
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                
                self.currentDateView.alpha = 0
                self.nextPaymentView.alpha = 0
                self.dataView.alpha = 1
                self.pressDownUpButton.setTitle("Close Income Tab", for: .normal)
                self.calendar.alpha = 0
            })
        } else {
            guidedViewTopConstraint.constant = -340
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                
                self.currentDateView.alpha = 1
                self.nextPaymentView.alpha = 1
                self.dataView.alpha = 0
                self.pressDownUpButton.setTitle("View/Input Total Income", for: .normal)
                self.calendar.alpha = 1
            })
        }
        
    }
    
    
    @IBAction func viewTapGesture(_ sender: UITapGestureRecognizer) {
        //for a small vibration
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        //performSegue(withIdentifier: "toIncomeInfo", sender: self)
    }
    
    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "EditIncome" {
            let navController = segue.destination as! UINavigationController
            let incomeTableViewController = navController.topViewController as! IncomeTableViewController
            
            incomeTableViewController.income = income
           
            
        }
    }*/
    
    @IBAction func unWindToIncomeViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind", let sourceViewController = segue.source as? IncomeTableViewController else {return}
        guard segue.identifier == "saveUnwind", var income = sourceViewController.income else {return}
        
        
        
        income.income.round()

        totalIncomeAfterTaxLabel.text = "$\(income.income)"
        
        Income.saveToDos(income)
        updateNetIncomeAndLabel()
        
        
        
        
    }

}
/*
extension Date {

    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {

        let currentCalendar = Calendar.current

        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }
}*/

