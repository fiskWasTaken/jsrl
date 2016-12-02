//
//  ChatTableViewController.swift
//  jsrl
//

import UIKit

class ChatViewController: UIViewController, UITextFieldDelegate {
    /**
     The chat view is done in a really inefficient way and I'm sorry.
     I wish we had chat deltas to make updates easier but we have to
     download the last 100 messages each time because that's how the
     JSRL chat works.
     */
    
    /** Seconds between chat updates */
    let chatUpdateInterval = 3.0
    let jsrl = JSRL()
    var messages: [ChatMessage] = []
    let defaults = UserDefaults.standard
    var timer: Timer?
    
    @IBOutlet var chatText: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var chatView: UIView!
    @IBOutlet var textInput: UITextField!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textInput.delegate = self
        
        reloadChat()
        updateStationDecor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: chatUpdateInterval, target: self, selector: #selector(self.reloadChat), userInfo: nil, repeats: true);
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
            if err != nil {
                return
            }
            
            print("Chat result recieved.")
            self.messages.removeAll(keepingCapacity: true)
            self.messages.append(contentsOf: messages)
            self.updateView()
            
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateScrollPosition), userInfo: nil, repeats: false)
        }
    }
    
    func updateView() {
        let result = self.messages.map { message -> String in
            let template = "<p style='line-height:1;margin-bottom:4px'><span style='font-family:sans-serif;color:#fff;font-size:14pt'>\(message.username): \(message.text)</span></p>"
            return template
        }.joined()
        
        // This is all doing some nasty voodoo magic to convert the HTML string into attributed text
        let attrStr = try! NSAttributedString(
            data: result.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        
        chatText.attributedText = attrStr
    }
    
    /**
     Update the scroll position.
     */
    func updateScrollPosition() {
        scrollView.contentSize.height = chatText.frame.height
        
        let autoScrollPosition = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.bounds.size.height
        
        // Chat will only autoscroll if the contentOffset is basically at the top
        // or an entire screen's height before the furthest possible scroll position
        if (scrollView.contentOffset.y < 0.1 || scrollView.contentOffset.y > autoScrollPosition - scrollView.bounds.size.height) {
            var offset = scrollView.contentOffset
            offset.y = autoScrollPosition
            scrollView.setContentOffset(offset, animated: true)
        }
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
        self.updateScrollPosition()
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
}
