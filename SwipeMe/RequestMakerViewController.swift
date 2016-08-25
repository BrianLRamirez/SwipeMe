//
//  RequestMakerViewController.swift
//  SwipeMe
//
//  Created by Brian Ramirez  on 8/22/16.
//  Copyright © 2016 Brian Ramirez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import XLActionController

class RequestMakerViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var chooseDcBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var placeHolderLbl: UILabel!
    @IBOutlet var textViewGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var characterCounterLbl: UILabel!
    
    var requestLocation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        
        characterCounterLbl.text = "0/40"
        
        textViewGestureRecognizer.addTarget(self, action: #selector(hidePlaceHolder))
        textView.addGestureRecognizer(textViewGestureRecognizer)
        
        //Make user image
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2
        self.userImage.clipsToBounds = true

        //Check if user is logged in. (Migth remove )
        if let user = FIRAuth.auth()?.currentUser {
            
            //fetch for user image,name,email, and uid
            let name = user.displayName
            let photoUrl = user.photoURL
            
            //Get first name only
            let fullNameArr = name!.characters.split{$0 == " "}.map(String.init)
            let firstName: String = fullNameArr[0]
            
            //Display User info
            nameLbl.text = "\(firstName) needs a swipe at"
            userImage.image = UIImage(data: ( NSData(contentsOfURL: photoUrl!))! )
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        characterCounterLbl.text = "\(numberOfChars)/40"
        return numberOfChars < 40;
    }
    
    func hidePlaceHolder(){
        textView.removeGestureRecognizer(textViewGestureRecognizer)
        textView.becomeFirstResponder()
        placeHolderLbl.hidden = true
    }

    
    
    //Even though the request model has a requestID it is generated by the datbase and we do not upload it
    func createRequest(location :String, comment:String){
        //Check if user is logged in. (Migth remove )
        if let user = FIRAuth.auth()?.currentUser {
            let request : [String : AnyObject] = ["displayName":user.displayName!,
                                                  "UID":user.uid,
                                                  "createdAt":currentDate(),
                                                  "location":location,
                                                  "comment":comment,
                                                  "userPhotoURL": String(user.photoURL!)]
            
            let databaseRef = FIRDatabase.database().reference()
            
            databaseRef.child("Requests").childByAutoId().setValue(request)
            
        }
    }
    
    
    func currentDate() -> String{
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return dateformatter.stringFromDate(NSDate())
    }
    
    @IBAction func submitBtnPressed(sender: UIButton) {
        
        if(requestLocation.characters.count != 0 && textView.text.characters.count != 0){
            createRequest(requestLocation, comment: textView.text!)
            UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, forEvent:nil)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func cancelBrnPressed(sender: UIButton) {
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, forEvent:nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func chooseDcPressed(sender: UIButton) {
                let actionController = PeriscopeActionController()
                actionController.headerData = "Where do you want a meal swipe?"
                actionController.addSection(PeriscopeSection())
        
                actionController.addAction(Action("Worcester Commons", style: .Cancel, handler: { action in
                    self.chooseDcBtn.setTitle("Worceser Commons", forState: UIControlState.Normal)
                    self.requestLocation = "Worcester"
                }))
        
                actionController.addAction(Action("Hampshire Commons", style: .Cancel, handler: { action in
                    self.chooseDcBtn.setTitle("Hampshire Commons", forState: UIControlState.Normal)
                    self.requestLocation = "Hampshire"
                }))
                actionController.addAction(Action("Franklin Commons", style: .Cancel, handler: { action in
                    self.chooseDcBtn.setTitle("Franklin Commons", forState: UIControlState.Normal)
                    self.requestLocation = "Franklin"
                }))
                actionController.addAction(Action("Berkshire Commons", style: .Cancel, handler: { action in
                    self.chooseDcBtn.setTitle("Berkshire Commons", forState: UIControlState.Normal)
                    self.requestLocation = "Berkshire"
                }))
                actionController.addAction(Action("Blue Wall", style: .Cancel, handler: { action in
                    self.chooseDcBtn.setTitle("Blue Wall", forState: UIControlState.Normal)
                    self.requestLocation = "Blue Wall"
                }))
                actionController.addAction(Action("Cancel", style: .Destructive, handler: { action in
                }))
                presentViewController(actionController, animated: true, completion: nil)
    }


}
