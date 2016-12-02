//
//  SettingsViewController.swift
//  jsrl
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    let defaults = UserDefaults.standard

    @IBOutlet var chatUsername: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatUsername.text = defaults.string(forKey: "chatUsername")
        chatUsername.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func debugPopulateLibrary(_ sender: AnyObject) {
        Library.shared.populateFrom(jsrl: JSRL(), onComplete: {
            print("Reloading library")
            _ = Library.shared.loadFromCoreData()
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == chatUsername {
            defaults.set(textField.text!, forKey: "chatUsername")
            return false
        }
        return true
    }
}
