//
//  AddEditTableViewController.swift
//  Budget Time
//
//  Created by Kanoa Matton on 4/22/20.
//  Copyright © 2020 Kanoa Matton. All rights reserved.
//
// ----- TO-DO -----
// Customer Service number


import UIKit

class AddEditTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var recurringPaymentSwitch: UISwitch!
    
    
    @IBOutlet weak var usernameOrEmailTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    
    @IBOutlet weak var methodPaymentSegment: UISegmentedControl!
    
    var expense: Expense?
    
    
    let dueDateIndex = IndexPath(row: 0, section: 2)
    let dueDatePickerIndex = IndexPath(row: 1, section: 2)
    let methodOfPaymentIndex = IndexPath(row: 0, section: 3)
    
    var methodOfPayment: String = ""
    var recurring: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
    
        //SET THE MINIMUM DATE TO SET A DUEDATE BE TODAY
        let midnightToday = Calendar.current.startOfDay(for: Date())
        dueDatePickerView.minimumDate = midnightToday
        
        if let expense = expense {
            priceTextField.text = "\(expense.price)"
            nameTextField.text = expense.name
            dueDatePickerView.date = expense.dueDate
            recurringPaymentSwitch.isOn = expense.recurring
            if let userNameOrEmail = expense.userNameEmail {
                usernameOrEmailTextField?.text = userNameOrEmail
            }
            if let password = expense.password {
                passwordTextField?.text = password
            }
            switch expense.methodOfPayment {
            case "None":
                methodPaymentSegment.selectedSegmentIndex = 0
            case "Credit Card":
                methodPaymentSegment.selectedSegmentIndex = 1
            case "Debit Card":
                methodPaymentSegment.selectedSegmentIndex = 2
            case "Other":
                methodPaymentSegment.selectedSegmentIndex = 3
            default:
                break
            }
            
        } else {
            dueDatePickerView.date = Date().addingTimeInterval(24*60*60)
        }
        updateDueDateLabel(date: dueDatePickerView.date)
        updateSaveButtonState()
        if recurringPaymentSwitch.isOn {
            recurring = true
        } else {
            recurring = false
        }
        
        //I do this switch statement to fix a bug to where the segment keeps going back to the 0 case. this fixes it.
        switch methodPaymentSegment.selectedSegmentIndex {
        case 0:
            methodOfPayment = "None"
        case 1:
            methodOfPayment = "Credit Card"
        case 2:
            methodOfPayment = "Debit Card"
        case 3:
            methodOfPayment = "Other"
        default:
            break
        }
        
        
        
    }
    
    
    //TOOLBAR FOR KEYBOARDS TO REMOVE THEM (DONE BUTTON)
    func setupTextFields() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        doneBtn.tintColor = .black
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        priceTextField.inputAccessoryView = toolbar
        nameTextField.inputAccessoryView = toolbar
        usernameOrEmailTextField?.inputAccessoryView = toolbar
        passwordTextField?.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    @IBAction func recurringPaymentChanged(_ sender: UISwitch) {
        if recurringPaymentSwitch.isOn {
            recurring = true
        } else {
            recurring = false
        }
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch methodPaymentSegment.selectedSegmentIndex{
        case 0:
            methodOfPayment = "None"
        case 1:
            methodOfPayment = "Credit Card"
        case 2:
            methodOfPayment = "Debit Card"
        case 3:
            methodOfPayment = "Other"
        default:
            break
        }
    }
    
    
    func updateSaveButtonState() {
        let priceText = priceTextField.text ?? ""
        let nameText = nameTextField.text ?? ""
        saveButton.isEnabled = !priceText.isEmpty && !nameText.isEmpty
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = Expense.dueDateFormatter.string(from: date)
    }
    @IBAction func dueDatePickerViewChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: dueDatePickerView.date)
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == dueDateIndex {
            dueDatePickerView.datePickerMode = .date
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == methodOfPaymentIndex {
            return 45
        } else if indexPath == dueDatePickerIndex{
            return 175
        } else {
            return 45
        }
    }
    
    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
 */

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
        
        let price = priceTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let dueDate = dueDatePickerView.date
        let userNameEmail = usernameOrEmailTextField?.text
        let password = passwordTextField?.text
        let methodOfPay = methodOfPayment
        let isRecurring = recurring
        
        expense = Expense(name: name, dueDate: dueDate, price: (price as NSString).doubleValue, userNameEmail: userNameEmail, password: password, methodOfPayment: methodOfPay, recurring: recurring)
        
        
    }
    

}
