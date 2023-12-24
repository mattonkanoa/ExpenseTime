//
//  IncomeTableViewController.swift
//  Budget Time
//
//  Created by Kanoa Matton on 5/1/20.
//  Copyright © 2020 Kanoa Matton. All rights reserved.
//

import UIKit
import GoogleMobileAds

class IncomeTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var totalIncomeTextField: UITextField!
    @IBOutlet weak var statePickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    
    var income: Income?
    let statePicked: String = "Alaska"

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row]
    }
    
    
    
    let stateIncomePercent: [String:Double] = ["Alabama": 78.77,"Alaska": 77.84,"Arizona": 78.68,"Arkansas": 78.57,"California": 72.88,"Colorado": 74.86,"Connecticut": 73.36,"Delaware": 75.06,"Florida": 81.95,"Georgia": 76.11,"Hawaii": 70.73,"Idaho": 77.15,"Illinois": 75.04,"Indiana": 76.41,"Iowa": 75.67,"Kansas": 76.42,"Kentucky": 78.48,"Louisiana": 79.40,"Maine": 76.25,"Maryland": 70.76,"Massachusetts": 73.34,"Michigan": 76.30,"Minnesota": 73.21,"Mississippi": 79.51,"Missouri": 78.28,"Montana": 76.80,"Nebraska": 75.73,"Nevada": 81,"New Hampshire": 78.63,"New Jersey": 73.79,"New Mexico": 78.89,"New York": 74.49,"North Carolina": 77.45,"North Dakota": 78.66,"Ohio": 76.28,"Oklahoma": 78.22,"Oregon": 73.64,"Pennsylvania": 75.58,"Rhode Island": 75.17,"South Carolina": 76.18,"South Dakota": 81.25,"Tennessee": 82.47,"Texas": 80.69,"Utah": 74.43,"Vermont": 76.18,"Virginia": 73.81,"Washington": 79.27,"West Virginia": 78.78,"Wisconsin": 75.08,"Wyoming": 80.03]
    
    
    
    var states: [String] = ["Alaska",
    "Alabama",
    "Arkansas",
    "Arizona",
    "California",
    "Colorado",
    "Connecticut",
    "Delaware",
    "Florida",
    "Georgia",
    "Hawaii",
    "Iowa",
    "Idaho",
    "Illinois",
    "Indiana",
    "Kansas",
    "Kentucky",
    "Louisiana",
    "Massachusetts",
    "Maryland",
    "Maine",
    "Michigan",
    "Minnesota",
    "Missouri",
    "Mississippi",
    "Montana",
    "North Carolina",
    "North Dakota",
    "Nebraska",
    "New Hampshire",
    "New Jersey",
    "New Mexico",
    "Nevada",
    "New York",
    "Ohio",
    "Oklahoma",
    "Oregon",
    "Pennsylvania",
    "Rhode Island",
    "South Carolina",
    "South Dakota",
    "Tennessee",
    "Texas",
    "Utah",
    "Virginia",
    "Vermont",
    "Washington",
    "Wisconsin",
    "West Virginia",
    "Wyoming"]

    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-5510952973561945/3233142856")
        let request = GADRequest()
        interstitial.load(request)
        
        setupTextFields()
        self.statePickerView.delegate = self
        self.statePickerView.dataSource = self
        
        //var i = 0
        
        if let income = income {
            totalIncomeTextField.text = "\(income.income)"
            //statePickerView.value(forKey: income.state)
        }
        updateSaveButtonState()
        
        if (interstitial.isReady) {
            interstitial.present(fromRootViewController: self)
            print("TESTER")
        }

        
        
    }
    
    func setupTextFields() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        doneBtn.tintColor = .black
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        totalIncomeTextField.inputAccessoryView = toolbar
        
    }
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    func updateSaveButtonState() {
        let totalText = totalIncomeTextField.text ?? ""
        saveButton.isEnabled = !totalText.isEmpty
    }
    @IBAction func keyboardDidChange(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else {return}
        
        let totalIncome = totalIncomeTextField.text ?? ""
        let stateResidingIn = states[statePickerView.selectedRow(inComponent: 0)]
        let incomeAfterTaxes = (((totalIncome as NSString).doubleValue) * stateIncomePercent[stateResidingIn]!) / 100
        
        income = Income(income: incomeAfterTaxes , state: stateResidingIn)
        
    }
    

}
