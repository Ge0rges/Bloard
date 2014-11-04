//
//  KeyboardViewController.swift
//  Bloard Keyboard
//
//  Created by Georges Kanaan on 10/30/14.
//  Copyright (c) 2014 Georges Kanaan. All rights reserved.
//

import UIKit
import AVFoundation


class KeyboardViewController: UIInputViewController {
    
    //declare outlets and varibales
    var isCaps: Bool = true
    var textEntered: Bool = false
    
    var deleteTimer: NSTimer!
    var currentKeyboard: NSInteger!
    
    @IBOutlet var capsButton: UIButton!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        //Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Perform custom UI setup here
        //fix a bug
        self.inputView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

        //load the keyboard
        var bundle = NSBundle.mainBundle() as NSBundle
        bundle.loadNibNamed("DefaultKeyboard", owner:self, options:nil)
        
        //set the color
        updateKeyboardColor()
        
        //check if in ap pto see if we should add a timer to refresh the color
        var sharedDefaults = NSUserDefaults(suiteName: "group.com.ge0rges.bloard")
        if (sharedDefaults!.boolForKey("inApp") == true) {
            NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateKeyboardColor"), userInfo: nil, repeats: true)
        }
        
        //update variables to keep track of where we are
        currentKeyboard = 1
        
        //set caps button color
        capsButton.backgroundColor = UIColor.whiteColor()
        capsButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        isCaps = true
        
        //round all buttons
        for view in self.inputView.subviews as [UIView] {
            view.layer.cornerRadius = 5.0
            view.clipsToBounds = true
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(textInput: UITextInput) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(textInput: UITextInput) {
        // The app has just changed the document's contents, the document context has been updated.
        
    }
    
    
    func updateKeyboardColor() {
        //set the color of the keyboard
        //get the settings
        var sharedDefaults = NSUserDefaults(suiteName: "group.com.ge0rges.bloard")
        
        //set the background color
        self.inputView.backgroundColor = UIColor(white: CGFloat(sharedDefaults!.floatForKey("KBBackgroundColorShade")), alpha: 1)
        
        //set the key color
        for view in self.inputView.subviews as [UIView] {
            view.backgroundColor = UIColor(white: CGFloat(sharedDefaults!.floatForKey("KBKeysColorShade")), alpha: 1)
        }
        
        //set caps color
        if (isCaps == true) {
            //set caps button color
            capsButton.backgroundColor = UIColor.whiteColor()
            capsButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        }
    }
    
    
    /*WRITING*/
    @IBAction func enterText(sender: UIButton) {//common method
        //play click sound
        AudioServicesPlaySystemSound(1104)
        
        //get button title and document proxy
        let button = sender as UIButton
        let title = button.titleForState(.Normal)
        var proxy = textDocumentProxy as UITextDocumentProxy
        
        //check if caps should be enabled
        if (proxy.autocapitalizationType! == .AllCharacters) {
            isCaps = true;
            
            capsButton.backgroundColor = UIColor.whiteColor()
            capsButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        }
        
        
        //check if caps is enabled and insert the title
        if (!isCaps) {
            proxy.insertText(title!.lowercaseString)
        } else {
            proxy.insertText(title!)
            
            //check if we should keep caps or not
            if (proxy.autocapitalizationType! != .AllCharacters) {
                capsButton.backgroundColor = UIColor.darkGrayColor()
                capsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                
                isCaps = !isCaps
            }
        }
        
        //check if end of sentence
        if ((title == "?" || title == "!" || title == ".") && proxy.autocapitalizationType! == .Sentences) {
            isCaps = true;
            
            capsButton.backgroundColor = UIColor.whiteColor()
            capsButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        }
        
        //update variables
        textEntered = true
    }
    
    @IBAction func toggleCaps(sender: UIButton) {
        //play click sound
        AudioServicesPlaySystemSound(1104)
        
        //update UI
        isCaps = !isCaps
        
        if (isCaps) {
            sender.backgroundColor = UIColor.whiteColor()
            sender.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
            
        } else {
            sender.backgroundColor = UIColor.darkGrayColor()
            sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
    }
    
    //deleting
    @IBAction func deleteTextStart(sender: UIButton) {
        //start a timer to call the delete action
        deleteTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "deleteText", userInfo: nil, repeats: true)
    }
    
    @IBAction func deleteText() {
        //play click sound
        AudioServicesPlaySystemSound(1104)
        
        //delete the text
        var proxy = textDocumentProxy as UITextDocumentProxy
        
        //stop the timer if it isn't already stopped
        if (proxy.documentContextBeforeInput != nil) {
            if (countElements(proxy.documentContextBeforeInput) == 1 && deleteTimer != nil) {
                deleteTimer.invalidate()
                deleteTimer = nil;
                
                //last character will be deleted no more text
                textEntered = false
            }
        }
        
        //delete 1 back
        proxy.deleteBackward()
    }
    
    @IBAction func deleteTextStop(sender: UIButton) {
        //stop the timer if it isn't already stopped
        if (deleteTimer != nil) {
            deleteTimer.invalidate()
            deleteTimer = nil;
        }
    }
    
    /*SPECIAL KEYS*/
    @IBAction func spaceTapMultipleTimes(sender: UIButton) {//common method
        //get document proxy
        var proxy = textDocumentProxy as UITextDocumentProxy
        
        //check if we should switch keyboards
        if (currentKeyboard > 1 && textEntered == true) {
            switchToDefault(sender)
        }
        
        //delete the space and isnert a point
        proxy.deleteBackward()
        proxy.insertText(".")
        
        //check if caps should be enabled
        if (proxy.autocapitalizationType! == .Sentences) {
            isCaps = true;
            
            capsButton.backgroundColor = UIColor.whiteColor()
            capsButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func space(sender: UIButton) {
        //play click sound
        AudioServicesPlaySystemSound(1104)
        
        //get document proxy
        var proxy = textDocumentProxy as UITextDocumentProxy
        
        //check if we should switch keyboards
        if (currentKeyboard > 1 && textEntered == true) {
            switchToDefault(sender)
        }
        
        
        //insert space
        proxy.insertText(" ")
        
        //check if caps should be enabled
        if (proxy.autocapitalizationType! == .Words) {
            isCaps = true;
            
            capsButton.backgroundColor = UIColor.whiteColor()
            capsButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func changeKeyboard(sender: UIButton) {
        //play click sound
        AudioServicesPlaySystemSound(1104)
        
        //change keyboard
        self.advanceToNextInputMode()
    }
    
    @IBAction func enter(sender: UIButton) {
        //play click sound
        AudioServicesPlaySystemSound(1104)
        
        //dismiss keyboard
        self.dismissKeyboard()
    }
    
    @IBAction func switchToNumerical(sender: UIButton) {
        //play click sound
        AudioServicesPlaySystemSound(1104)
        
        //switch to numerical xib
        var bundle = NSBundle.mainBundle() as NSBundle
        bundle.loadNibNamed("NumericalKeyboard", owner:self, options:nil)
        
        //update variables to keep track of where we are
        currentKeyboard = 2
        textEntered = false
        
        //round all buttons
        for view in self.inputView.subviews as [UIView] {
            view.layer.cornerRadius = 5.0
            view.clipsToBounds = true
        }
        
        //update keyboard color
        updateKeyboardColor()
    }
    
    @IBAction func switchToDefault(sender: UIButton) {
        //play click sound
        AudioServicesPlaySystemSound(1104)
        
        //switch to numerical xib
        var bundle = NSBundle.mainBundle() as NSBundle
        bundle.loadNibNamed("DefaultKeyboard", owner:self, options:nil)
        
        //update variables to keep track of where we are
        currentKeyboard = 1
        textEntered = false
        
        //round all buttons
        for view in self.inputView.subviews as [UIView] {
            view.layer.cornerRadius = 5.0
            view.clipsToBounds = true
        }
        
        //update keyboard color
        updateKeyboardColor()
        
        if (isCaps == true) {
            //set caps button color
            capsButton.backgroundColor = UIColor.whiteColor()
            capsButton.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func switchToSpecialCharacters(sender: UIButton) {
        //play click sound
        AudioServicesPlaySystemSound(1104)
        
        //switch to numerical xib
        var bundle = NSBundle.mainBundle() as NSBundle
        bundle.loadNibNamed("SpecialCharactersKeyboard", owner:self, options:nil)
        
        //update variables to keep track of where we are
        currentKeyboard = 3
        textEntered = false
        
        //round all buttons
        for view in self.inputView.subviews as [UIView] {
            view.layer.cornerRadius = 5.0
            view.clipsToBounds = true
        }
        
        //update keyboard color
        updateKeyboardColor()
    }
}
