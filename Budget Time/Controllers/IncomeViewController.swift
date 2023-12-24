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

class IncomeViewController: UIViewController {

    //var income: Income
    @IBOutlet weak var totalIncomeAfterTaxLabel: UILabel!
    @IBOutlet weak var netIncomeAfterExpensesLabel: UILabel!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var gadBannerHome: GADBannerView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var income: Income?
    var expenses: [Expense]?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWelcomeLabel()
        dataView.layer.cornerRadius = 15
        
        //TO BLUR OUT THE EDGES
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = dataView.bounds
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientMaskLayer.locations = [0, 0.01, 0.99, 1]
        dataView.layer.mask = gradientMaskLayer
        view.addSubview(dataView)
        
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
        updateNetIncomeAndLabel()
        // Do any additional setup after loading the view.
        
    }
    //TO UPDATE HOME PAGE WHEN U COME FROM EXPENSE PAGE
    override func viewWillAppear(_ animated: Bool) {
        if let savedExpenses = Expense.loadToDo() {
            expenses = savedExpenses
        } else {
            expenses = Expense.loadSampleToDos()
        }
        updateNetIncomeAndLabel()
        updateWelcomeLabel()
    }
    
    func updateWelcomeLabel() {
        let defaultsName = defaults.string(forKey: "Name")
        if defaultsName != nil {
            welcomeLabel.text = "Welcome, \(defaultsName!)"
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
        netIncomeAfterExpensesLabel.text = "$\(totalNetIncome)"
        if totalNetIncome < 0 {
            noticeLabel.text = "Oh no! Your're losing this much monthly. Your net income is less than 0!"
        } else if totalNetIncome == 0{
            noticeLabel.text = "You're saving $0 monthly. Try lowering any unnecessary expenses to save more money!"
        } else {
            noticeLabel.text = "You're saving this much monthly! It's above $0 so good job!"
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
