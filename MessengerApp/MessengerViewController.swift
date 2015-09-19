//
//  MessengerViewController.swift
//  MessengerApp
//
//  Created by Mario Youssef on 2015-09-16.
//  Copyright (c) 2015 Mario Youssef. All rights reserved.
//

import UIKit
import Parse


class MessengerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var messageTableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    
    @IBOutlet weak var dockViewHeightConstraint: NSLayoutConstraint!
    
    
    var messagesArray: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.messageTableView.delegate = self
        self.messageTableView.dataSource = self
        
        self.messageTextField.delegate = self
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tableViewTapped")
        self.messageTableView.addGestureRecognizer(tapGesture)
        
        self.retrieveMessages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonTapped(sender: UIButton) {
        self.messageTextField.endEditing(true)
        
        self.sendButton?.enabled = false
        self.messageTextField?.enabled = false
        
        //Sending message to parse
        var newMessageObject = PFObject(className: "Message")
        newMessageObject["Text"] = self.messageTextField.text!
        newMessageObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                self.retrieveMessages()
                NSLog("Message Sent")
            } else {
                NSLog(error!.description)
        
            }
            //self.sendButton?.enabled = true
            self.messageTextField?.enabled = true
            self.messageTextField?.text = ""
        }
    }
    
    func retrieveMessages() {
        var query = PFQuery(className: "Message")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            self.messagesArray = [String]()
            
            for messageObject in objects! {
                
                let messageText: String? = (messageObject as PFObject)["Text"] as? String
                if messageText != nil{
                    self.messagesArray.append(messageText!)
                }
            }
            self.messageTableView.reloadData()
        }
    }
    
    
    func tableViewTapped() {
        self.messageTextField.endEditing(true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0, animations: {
            
            self.dockViewHeightConstraint.constant = 310
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0, animations: {
            
            self.dockViewHeightConstraint.constant = 60
            self.view.layoutIfNeeded()
            
            }, completion: nil)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.messageTableView.dequeueReusableCellWithIdentifier("messageViewCell") as UITableViewCell!
       
        cell.textLabel?.text = self.messagesArray[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messagesArray.count
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
