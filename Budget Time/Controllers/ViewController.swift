//
//  ViewController.swift
//  Budget Time
//
//  Created by Kanoa Matton on 4/28/20.
//  Copyright © 2020 Kanoa Matton. All rights reserved.
//



import UIKit
import AudioToolbox

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var enterPasswordLabel: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var expenseTimeTitle: UILabel!
    
    let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        //HOW TO SET A VALUE IN A DEFAULT FOR A KEY
        //defaults.set("Hello", forKey: "Kanoa")
        updateNameTextField()
        setupTextFields()
        enterButton.layer.cornerRadius = 15
        let alwaysRequirePassword = defaults.string(forKey: "AlwaysRequirePassword")
        if (alwaysRequirePassword == "false") {
            performSegue(withIdentifier: "toExpenses", sender: self)
        }
        
        let defaultsPassword = defaults.string(forKey: "Password")
        if defaultsPassword != nil {
            enterPasswordLabel.text = "Please Enter Your Password"
            passwordTextfield.isSecureTextEntry = true
        }
        nameTextField.layer.cornerRadius = 15
        nameTextField.layer.borderWidth = 0
        passwordTextfield.layer.cornerRadius = 15
        passwordTextfield.layer.borderWidth = 0
        
        nameTextField.clipsToBounds = true
        passwordTextfield.clipsToBounds = true
        
        
        
        
        updateEnterButtonState()
       
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //HOW TO MOVE VIEW UP WHEN PRESS KEYBOARD. INCLUDES THE INIT AS WELL AS OBSERVERS IN VIEWDIDLOAD
    @objc func keyBoardWillChange(notification: Notification) {
        
        print("Keyboard will show: \(notification.name.rawValue)")
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height + (view.frame.height - enterButton.frame.origin.y) - enterButton.frame.height - 5
        } else {
            view.frame.origin.y = 0
        }
        
    }
    
    func updateEnterButtonState() {
        let password = passwordTextfield.text ?? ""
        let name = nameTextField.text ?? ""
        let defaultsName = defaults.string(forKey: "Name")
        if defaultsName != nil {
            enterButton.isEnabled = !password.isEmpty
        } else {
            enterButton.isEnabled = !password.isEmpty && !name.isEmpty
        }
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        updateEnterButtonState()
    }
    //UPDATE NAME TEXT FIELD TO SHOW UP IF NO NAME WAS NEVER ENTERED
    func updateNameTextField() {
        let defaultsName = defaults.string(forKey: "Name")
        
        if defaultsName == nil {
            nameTextField.isHidden = false
        } else {
            nameTextField.isHidden = true
        }
    }
    
    func setupTextFields() {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        doneBtn.tintColor = .black
        
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        passwordTextfield.inputAccessoryView = toolbar
        nameTextField.inputAccessoryView = toolbar
        
    }
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    @IBAction func enterButtonPressed(_ sender: UIButton) {
        /* HOW TO GET A VALUE FOR A KEY
        let tester = defaults.string(forKey: "Kanoa")
         */
        
        //set variable to password
        let defaultsPassword = defaults.string(forKey: "Password")
        let defaultsName = defaults.string(forKey: "Name")
        
        //check if password is nil or not. if it is nil that means no password was set so create a new one
        
        if defaultsPassword == nil {
            defaults.set(passwordTextfield.text, forKey: "Password")
            defaults.set(nameTextField.text, forKey: "Name")
            performSegue(withIdentifier: "toExpenses", sender: self)
        }
        //else, check to see if defaults password equals text field, if so then proceed. if not, stay here
        else {
            
            if passwordTextfield.text == defaultsPassword {
                if defaultsName == nil {
                    defaults.set(nameTextField.text, forKey: "Name")
                }
                
                performSegue(withIdentifier:"toExpenses",sender: self)

                
                
            }
            else {
                
                UIButton.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.curveEaseOut], animations: {
                    self.enterButton.frame.origin.x += 10
                    
                }, completion: nil)
                UIButton.animate(withDuration: 0.1, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.curveEaseOut], animations: {
                    self.enterButton.frame.origin.x -= 20
                    
                }, completion: nil)
                UIButton.animate(withDuration: 0.1, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [.curveEaseOut], animations: {
                    self.enterButton.frame.origin.x += 10
                    
                }, completion: nil)
                
                
                
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                //THIS CODE MAKES SMALL VIBRATIONS
                //let generator = UIImpactFeedbackGenerator(style: .heavy)
                //generator.impactOccurred()
            }
        }
        
        
        
        
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
