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
    var messages: [ChatMessage] = []
    let defaults = UserDefaults.standard
    var timer: Timer?
    
    @IBOutlet var chatView: UIView!
    @IBOutlet var textInput: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        textInput.delegate = self
        
        reloadChat()
        updateStationDecor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.reloadChat), userInfo: nil, repeats: true);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
    
    func reloadChat() {
        print("Reloading chat...")
        jsrl.getChat().fetch { (err: Error?, messages: [ChatMessage]) in
            print("Chat result recieved.")
            self.messages.removeAll(keepingCapacity: true)
            self.messages.append(contentsOf: messages)
            self.tableView.reloadData()
//            self.scrollToBottom()
            print("Chat updated.")
        }
    }
    
    func scrollToBottom() {
        let indexPath = IndexPath(row: (messages.count - 1), section: 0)
        self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textInput {
            let message = ChatMessage()
            message.username = defaults.string(forKey: "chatUsername")!
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
    
    func keyboardWasShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.bottomConstraint.constant = keyboardFrame.size.height + 46
        self.scrollToBottom()
    }
    
    func keyboardWasHidden(notification: NSNotification) {
        self.bottomConstraint.constant = 46
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        messages = []
    }
    
    func updateStationDecor() {
        let station = Player.shared.activeStation
        chatView.backgroundColor = UIColor(hexString: station.color)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
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
        
        let template = "<span style='font-family:sans-serif;color:#fff;font-size:18px'>\(message.username): \(message.text)</span>"
        
        // This is all doing some nasty voodoo magic to convert the HTML string into attributed text
        let attrStr = try! NSAttributedString(
            data: template.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        
        cell.body.attributedText = attrStr
//        cell.backgroundColor = UIColor(hexString: Player.shared.activeStation.color)
        cell.backgroundColor = UIColor(hexString: "#222")
        
        cell.sizeToFit()
        
        return cell
    }
}


class ChatMessageViewCell: UITableViewCell {
    @IBOutlet weak var body: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
