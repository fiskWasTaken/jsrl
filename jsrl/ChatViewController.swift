//
//  ChatViewController.swift
//  jsrl
//
//  Created by Fisk on 15/11/2016.
//  Copyright © 2016 fisk. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    let jsrl = JSRL()
    @IBOutlet var chatView: UIView!
    var messages: [ChatMessage] = []
    
    @IBOutlet var textInput: UITextField!
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        textInput.delegate = self
        
        reloadChat()
        updateStationDecor()
    }
    
    func reloadChat() {
        jsrl.getChat().fetch { (err: Error?, messages: [ChatMessage]) in
            self.messages.removeAll(keepingCapacity: true)
            self.messages.append(contentsOf: messages)
            self.tableView.reloadData()
            let indexPath = IndexPath(row: (messages.count - 1), section: 0)
            
			self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textInput {
            let message = ChatMessage()
            message.username = "idot"
            message.text = textInput.text!
            
            jsrl.getChat().send(message, { (error, response) in
                // todo handle errors
                self.reloadChat()
            })
            
            textInput.text = ""
            return false
        }
        return true
    }
//    
//    func keyboardWasShown(notification: NSNotification) {
//        let info = notification.userInfo!
//        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        
//        UIView.animateWithDuration(0.1, animations: { () -> Void in
//            self.bottomConstraint.constant = keyboardFrame.size.height + 20
//        })
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        messages = []
    }
    
    func updateStationDecor() {
        let station = Player.shared.activeStation
        chatView.backgroundColor = UIColor(hexString: station.color)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cellIdentifier: String = "ChatMessageViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ChatMessageViewCell
        
        let template = "<span style='font-family:sans-serif;color:#fff;font-size:14px'>\(message.username): \(message.text)</span>"
        
        // This is all doing some nasty voodoo magic to convert the HTML string into attributed text
        let attrStr = try! NSAttributedString(
            data: template.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        
        cell.body.attributedText = attrStr
        cell.backgroundColor = UIColor(hexString: Player.shared.activeStation.color)
        
        cell.sizeToFit()
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
