//
//  ProfileTableViewController.swift
//  SwipeMe
//
//  Created by Brian Ramirez on 8/29/16.
//  Copyright © 2016 Brian Ramirez. All rights reserved.
//

import UIKit
import FirebaseAuth
import JSSAlertView
import FirebaseInvites
import GoogleSignIn
import MessageUI


class ProfileTableViewController: UITableViewController,FIRInviteDelegate,GIDSignInUIDelegate,MFMailComposeViewControllerDelegate  {
    
    var sectionsArray = [3,4,1,1]

    @IBOutlet weak var notificationSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBAction func switchPressed(sender: AnyObject) {
        if(notificationSwitch.enabled == true ){
            UIApplication.sharedApplication().registerForRemoteNotifications()
        } else if(notificationSwitch.enabled == false){
            UIApplication.sharedApplication().unregisterForRemoteNotifications()
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Section : \(indexPath.section)")
        print("Index \(indexPath.row)")
        
        if(indexPath.section == 0){
            
            if(indexPath.row == 1){
                print("Invite Friend tapped")
                if let invite = FIRInvites.inviteDialog() {
                    invite.setInviteDelegate(self)
                    
                    
                    invite.setMessage("Check this app out! It's called Swpr")
                    invite.setTitle("Swpr invite! ")
                    invite.setDeepLink("https://cq83n.app.goo.gl/qbvQ")
                    invite.setCallToActionText("Install!")
                    invite.setCustomImage("https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png")
                    invite.open()
                }
                
            }
        }
        
        if(indexPath.section == 1){
            
            if(indexPath.row == 0){
                print("Privacy Policy Tapped")
            }
            
            if(indexPath.row == 1){
                print("Terms of service Tapped")
            }
            
            if(indexPath.row == 2){
                print("Open Source Library")
            }
            
            if(indexPath.row == 3){
                print("About Us Tapped")
            }
        }
        
        if(indexPath.section == 2){
            
            if(indexPath.row == 0){
                print("Report a Bug Tapped")
                
                let mailComposeViewController = configuredMailComposeViewController()
                if MFMailComposeViewController.canSendMail() {
                    self.presentViewController(mailComposeViewController, animated: true, completion: nil)
                } else {
                    displayAlert("Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
                }
            }
        }
        
        if(indexPath.section == 3){
            if(indexPath.row == 0){
                print("Log Out Tapped")
                try! FIRAuth.auth()!.signOut()
                
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogInScreen") as UIViewController
                
                self.presentViewController(viewController, animated: true, completion: nil)
            }
        }
    }
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["info.swipeme@gmail.com"])
        mailComposerVC.setSubject("Swpr Report A Bug ")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func displayAlert(title:String, message: String){
        let alertView = JSSAlertView().show(
            self,
            title: title,
            text: message,
            buttonText: "Okay",
            color: UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0),
            iconImage: UIImage(named: "idea"))
        alertView.setTextTheme(.Light)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func displayNoInternetAlert(){
        let alertView = JSSAlertView().show(
            self,
            title: "Oh 💩...",
            text: "Looks like there is no internet. Connect to a network and relauch the app.",
            buttonText: "FML😫 Okay",
            color: UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0),
            iconImage: UIImage(named: "noInternet"))
        alertView.setTextTheme(.Light)
    }
    
    func inviteFinishedWithInvitations(invitationIds: [AnyObject], error: NSError?) {
        if let error = error {
            print("Failed: " + error.localizedDescription)
        } else {
            print("Invitations sent")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionsArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionsArray[section]
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

         Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
