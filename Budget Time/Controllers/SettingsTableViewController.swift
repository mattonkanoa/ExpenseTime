//
//  SettingsTableViewController.swift
//  Budget Time
//
//  Created by Kanoa Matton on 4/29/20.
//  Copyright © 2020 Kanoa Matton. All rights reserved.
//

import UIKit
import MessageUI

class SettingsTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    let defaults = UserDefaults.standard
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            print("Message sent")
        case .cancelled:
            print("Message cancelled")
        case .failed:
            print("Message failed")
        case .saved:
            print("Message saved")
        default:
            break
        }
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet weak var showTotalNumberOfExpensesSwitch: UISwitch!
    @IBOutlet weak var alwaysRequirePasswordSwitch: UISwitch!
    @IBOutlet weak var currentName: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCurrentName()
        
        let defaultsAlwaysShowExpenses = defaults.bool(forKey: "AlwaysShowTotalExpenses")
        let defaultsAlwaysRequirePassword = defaults.string(forKey: "AlwaysRequirePassword")
        
        if defaultsAlwaysShowExpenses == true {
            showTotalNumberOfExpensesSwitch.setOn(true, animated: false)
        }
        else if defaultsAlwaysShowExpenses == false{
            showTotalNumberOfExpensesSwitch.setOn(false, animated: false)
        }
        
        
        if defaultsAlwaysRequirePassword == "true" {
            alwaysRequirePasswordSwitch.setOn(true, animated: false)
        }
        else if defaultsAlwaysRequirePassword == "false" {
            alwaysRequirePasswordSwitch.setOn(false, animated: false)
        }
        
       
    }
    func updateCurrentName() {
        let defaultsName = defaults.string(forKey: "Name")
        if defaultsName != nil {
            currentName.text = defaultsName
        } else {
            currentName.text = "None"
        }
    }
    
    @IBAction func sendEmailButtonPressed(_ sender: UIButton) {
        if !MFMailComposeViewController.canSendMail() {
            print("Cannot send mail")
            return
        }
        guard MFMailComposeViewController.canSendMail() else {return}
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        
        mailComposer.setToRecipients(["kmdeveloping@gmail.com"])
        mailComposer.setSubject("Expense Time")
        mailComposer.setMessageBody("", isHTML: false)
        
        present(mailComposer, animated: true, completion: nil)
        
        
    }
    
/*
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
 */
    @IBAction func alwaysRequirePasswordSwitchChanged(_ sender: UISwitch) {
        if alwaysRequirePasswordSwitch.isOn {
            defaults.set("true", forKey: "AlwaysRequirePassword")
        }
        else {
            defaults.set("false", forKey: "AlwaysRequirePassword")
        }
    }
    
    @IBAction func showTotalExpensesSwitchChanged(_ sender: UISwitch) {
        if showTotalNumberOfExpensesSwitch.isOn {
            defaults.set(true, forKey: "AlwaysShowTotalExpenses")
        }
        else {
            defaults.set(false, forKey: "AlwaysShowTotalExpenses")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func unwindToSettingsTableView(segue: UIStoryboardSegue) {
        
        updateCurrentName()
        
        
    }

}
