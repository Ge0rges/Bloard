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
    var shouldToggleCapsIfDeleted: Bool = false
    var isCaps: Bool = true
    var textEntered: Bool = false
    var loadedNibFromLayoutMethod: Bool = false
    
    var sharedDefaults: NSUserDefaults = NSUserDefaults(suiteName: "group.com.ge0rges.bloard")!
    
    var keyBackgroundColor: UIColor = UIColor(white: 0.43921569, alpha: 1)
    var keyboardBackgroundColor: UIColor = UIColor(white: 0.3372549, alpha: 1)
    
    var lexicon: UILexicon!
    
    var currentWord: String = ""
    var deleteTimer: NSTimer!
    var currentKeyboard: NSInteger!
    
    @IBOutlet var capsButton: UIButton!
    @IBOutlet var iPadCapsButton: UIButton!

    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        //Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Perform custom UI setup here
        //load the default keyboard
        var bundle = NSBundle.mainBundle() as NSBundle
        if(UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height){//check orientation
            if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {//check device
                bundle.loadNibNamed("DefaultKeyboardiPad", owner:self, options:nil)
            } else {
                bundle.loadNibNamed("DefaultKeyboard", owner:self, options:nil)
                
            }
        } else {
            if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {//check device
                bundle.loadNibNamed("DefaultKeyboardiPadLandscape", owner:self, options:nil)
            } else {
                bundle.loadNibNamed("DefaultKeyboardLandscape", owner:self, options:nil)
            }
        }
        
        //determine the keyboard color
        if (sharedDefaults.objectForKey("KBKeysColorShade") != nil) {
            self.keyBackgroundColor = UIColor(white: CGFloat(sharedDefaults.floatForKey("KBKeysColorShade")), alpha:1)
            self.keyboardBackgroundColor = UIColor(white: CGFloat(sharedDefaults.floatForKey("KBBackgroundColorShade")), alpha:1)
        }
        
        //update variables to keep track of where we are
        currentKeyboard = 1
        isCaps = true
        
        //round all buttons
        for view in self.inputView.subviews as [UIView] {
            view.layer.cornerRadius = 4.5
            view.clipsToBounds = true
        }
        
        
        //if we don't have a second caps button just assign it a UIButton instance
        if (self.iPadCapsButton == nil) {self.iPadCapsButton = UIButton.buttonWithType(UIButtonType.System) as UIButton}
        
        //get the lexicon
        let controller = UIInputViewController()
        controller.requestSupplementaryLexiconWithCompletion({lclLexicon in self.lexicon = lclLexicon})
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //on background thread
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { () -> Void in
            //set default capitalization
            var proxy = self.textDocumentProxy as UITextDocumentProxy
            if (proxy.autocapitalizationType! == .None) {
                self.isCaps = false;
            } else {
                self.isCaps = true;
            }
            
            //check if in container app to see if we should add a timer to refresh the color
            dispatch_after(1, dispatch_get_main_queue(), {
                //set the color
                self.updateKeyboardColor()
                
                if (self.sharedDefaults.boolForKey("inApp") == true) {
                    NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateKeyboardColor"), userInfo: nil, repeats: true)
                }

                //set caps button color
                if (self.isCaps) {
                    //set caps button color
                    //update UI
                    self.capsButton.backgroundColor = UIColor.whiteColor()
                    self.capsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
                    
                    self.iPadCapsButton.backgroundColor = UIColor.whiteColor()
                    self.iPadCapsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
                }
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (!loadedNibFromLayoutMethod) {
            if(UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height){//check orientation
                //update the bool
                loadedNibFromLayoutMethod = true
                
                //Keyboard is in Portrait load correct nib
                if (currentKeyboard == 1) {
                    //load the keyboard
                    var bundle = NSBundle.mainBundle() as NSBundle
                    if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {//check device
                        bundle.loadNibNamed("DefaultKeyboardiPad", owner:self, options:nil)
                    } else {
                        bundle.loadNibNamed("DefaultKeyboard", owner:self, options:nil)
                    }
                    
                    //update caps button
                    if (self.isCaps) {
                        //set caps button color
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            //update UI
                            self.capsButton.backgroundColor = UIColor.whiteColor()
                            self.capsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
                            
                            self.iPadCapsButton.backgroundColor = UIColor.whiteColor()
                            self.iPadCapsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
                        }
                    }
                    
                } else if (currentKeyboard == 2) {
                    //load the keyboard
                    var bundle = NSBundle.mainBundle() as NSBundle
                    if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {//check device
                        bundle.loadNibNamed("NumericalKeyboardiPad", owner:self, options:nil)
                    } else {
                        bundle.loadNibNamed("NumericalKeyboard", owner:self, options:nil)
                    }
                    
                } else if (currentKeyboard == 3) {
                    var bundle = NSBundle.mainBundle() as NSBundle
                    if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {//check device
                        bundle.loadNibNamed("SpecialCharactersKeyboardiPad", owner:self, options:nil)
                    } else {
                        bundle.loadNibNamed("SpecialCharactersKeyboard", owner:self, options:nil)
                    }
                }
                
            } else{
                //Keyboard is in Landscape load correct nib
                if (currentKeyboard == 1) {
                    //load the keyboard
                    var bundle = NSBundle.mainBundle() as NSBundle
                    if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {//check device
                        bundle.loadNibNamed("DefaultKeyboardiPadLandscape", owner:self, options:nil)
                    } else {
                        bundle.loadNibNamed("DefaultKeyboardLandscape", owner:self, options:nil)
                    }
                    
                    //update caps button
                    if (self.isCaps) {
                        //set caps button color
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            //update UI
                            self.capsButton.backgroundColor = UIColor.whiteColor()
                            self.capsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
                            
                            self.iPadCapsButton.backgroundColor = UIColor.whiteColor()
                            self.iPadCapsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
                        }
                    }
                    
                } else if (currentKeyboard == 2) {
                    var bundle = NSBundle.mainBundle() as NSBundle
                    if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {//check device
                        bundle.loadNibNamed("NumericalKeyboardiPadLandscape", owner:self, options:nil)
                    } else {
                        bundle.loadNibNamed("NumericalKeyboardLandscape", owner:self, options:nil)
                        
                    }
                } else if (currentKeyboard == 3) {
                    var bundle = NSBundle.mainBundle() as NSBundle
                    if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {//check device
                        bundle.loadNibNamed("SpecialCharactersKeyboardiPadLandscape", owner:self, options:nil)
                    } else {
                        bundle.loadNibNamed("SpecialCharactersKeyboardLandscape", owner:self, options:nil)
                    }
                }
            }
            
            for view in self.inputView.subviews as [UIView] {
                view.layer.cornerRadius = 4.5
                view.clipsToBounds = true
            }
            dispatch_after(2, dispatch_get_main_queue(), {
                self.loadedNibFromLayoutMethod = false
            })
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
        //update the colors
        if (sharedDefaults.objectForKey("KBKeysColorShade") != nil) {
            self.keyBackgroundColor = UIColor(white: CGFloat(sharedDefaults.floatForKey("KBKeysColorShade")), alpha:1)
            self.keyboardBackgroundColor = UIColor(white: CGFloat(sharedDefaults.floatForKey("KBBackgroundColorShade")), alpha:1)
        }

        //set the color of the keyboard
        //set the background color
        self.inputView.backgroundColor = self.keyboardBackgroundColor
        
        //set the key color
        for view in self.inputView.subviews as [UIView] {
            view.backgroundColor = self.keyBackgroundColor
        }
        
        //set caps color
        if (self.isCaps) {
            self.capsButton.backgroundColor = UIColor.whiteColor()
            self.capsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
            
            self.iPadCapsButton.backgroundColor = UIColor.whiteColor()
            self.iPadCapsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
            
        } else {
            self.capsButton.backgroundColor = self.keyBackgroundColor
            self.capsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
            self.iPadCapsButton.backgroundColor = self.keyBackgroundColor
            self.iPadCapsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
    }
    
    
    /*WRITING*/
    @IBAction func enterText(sender: UIButton) {//common method
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
            //play click sound on different thread
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in AudioServicesPlaySystemSound(1104)})
            
            //get button title and document proxy
            let title = sender.titleForState(.Normal)! as String
            var proxy = self.textDocumentProxy as UITextDocumentProxy
            
            //add text to thread
            self.currentWord += title

            //check if caps should be enabled
            if (proxy.autocapitalizationType! == .AllCharacters) {
                self.isCaps = true;
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    //update UI
                    self.capsButton.backgroundColor = UIColor.whiteColor()
                    self.capsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
                    
                    self.iPadCapsButton.backgroundColor = UIColor.whiteColor()
                    self.iPadCapsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
                    
                }
            } else if (proxy.autocapitalizationType! == .None) {
                self.isCaps = false;
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    //update UI
                    self.capsButton.backgroundColor = self.keyBackgroundColor
                    self.capsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    
                    self.iPadCapsButton.backgroundColor = self.keyBackgroundColor
                    self.iPadCapsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                }
            }
            
            
            //check if caps is enabled and insert the title
            if (!self.isCaps) {
                proxy.insertText(title.lowercaseString)
                self.shouldToggleCapsIfDeleted = false
                
            } else {
                proxy.insertText(title)
                
                self.shouldToggleCapsIfDeleted = true
                
                //check if we should keep caps or not
                if (proxy.autocapitalizationType! != .AllCharacters) {
                    self.toggleCaps()
                }
            }
            
            //check if end of sentence
            if ((title == "?" || title == "!" || title == ".") && proxy.autocapitalizationType! == .Sentences) {
                self.isCaps = true
                self.shouldToggleCapsIfDeleted = true
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    //update UI
                    self.capsButton.backgroundColor = UIColor.whiteColor()
                    self.capsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
                    
                    self.iPadCapsButton.backgroundColor = UIColor.whiteColor()
                    self.iPadCapsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
                }
            }
            
            //update variables
            self.textEntered = true
        }
    }
    
    @IBAction func toggleCaps() {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
            //play click sound on different thread
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in AudioServicesPlaySystemSound(1104)})
            
            //toggle caps
            self.isCaps = !self.isCaps
            
            //update UI
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if (self.isCaps) {
                    self.capsButton.backgroundColor = UIColor.whiteColor()
                    self.capsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
                    
                    self.iPadCapsButton.backgroundColor = UIColor.whiteColor()
                    self.iPadCapsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
                    
                } else {
                    self.capsButton.backgroundColor = self.keyBackgroundColor
                    self.capsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    
                    self.iPadCapsButton.backgroundColor = self.keyBackgroundColor
                    self.iPadCapsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                }
            })
        }
    }
    
    //deleting
    @IBAction func deleteTextStart(sender: UIButton) {
        //start a timer to call the delete action
        deleteTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "deleteText", userInfo: nil, repeats: true)
    }
    
    @IBAction func deleteText() {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
            //play click sound on different thread
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in AudioServicesPlaySystemSound(1104)})
            
            //delete the text
            var proxy = self.textDocumentProxy as UITextDocumentProxy
            
            //stop the timer if it isn't already stopped
            if (proxy.documentContextBeforeInput != nil) {
                if (countElements(proxy.documentContextBeforeInput) == 1 && self.deleteTimer != nil) {
                    self.deleteTimer.invalidate()
                    self.deleteTimer = nil;
                    
                    //last character will be deleted no more text
                    self.textEntered = false
                }
            }
            
            //determine if caps should be toggled
            if (self.shouldToggleCapsIfDeleted == true) {
                self.toggleCaps()
            }
            
            self.shouldToggleCapsIfDeleted = false
            
            //delete 1 back
            proxy.deleteBackward()
            
            //remove last chracter of current word
            self.currentWord.substringToIndex(self.currentWord.endIndex.predecessor())
        }
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
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
            //get document proxy
            var proxy = self.textDocumentProxy as UITextDocumentProxy
            
            //check if we should switch keyboards
            if (self.currentKeyboard > 1 && self.textEntered == true) {
                self.switchToDefault(sender)
            }
            
            //delete the space and isnert a point
            proxy.deleteBackward()
            proxy.insertText(".")
            
            //check if caps should be enabled
            if (proxy.autocapitalizationType! == .Sentences) {
                self.isCaps = true;
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.capsButton.backgroundColor = UIColor.whiteColor()
                    self.capsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
                    
                    self.iPadCapsButton.backgroundColor = UIColor.whiteColor()
                    self.iPadCapsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
                }
            }
        }
    }
    
    @IBAction func space(sender: UIButton) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
            //play click sound on different thread
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in AudioServicesPlaySystemSound(1104)})
            
            //get document proxy
            var proxy = self.textDocumentProxy as UITextDocumentProxy
            
            //check if we should switch keyboards
            if (self.currentKeyboard > 1 && self.textEntered == true) {
                self.switchToDefault(sender)
            }
            
            //insert space
            proxy.insertText(" ")
            
            //check if caps should be enabled
            if (proxy.autocapitalizationType! == .Words) {
                self.isCaps = true;
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    //update UI
                    self.capsButton.backgroundColor = UIColor.whiteColor()
                    self.capsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
                    
                    self.iPadCapsButton.backgroundColor = UIColor.whiteColor()
                    self.iPadCapsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
                }
            }
            
            //check the auto correct
            for lexiconEntry in self.lexicon.entries {
                lexiconEntry as UILexiconEntry
                if (lexiconEntry.userInput as NSString).lowercaseString == self.currentWord.lowercaseString {
                    for character in self.currentWord {
                        proxy.deleteBackward()
                    }
                    
                    proxy.insertText(lexiconEntry.documentText)
                    self.currentWord = ""
                }
            }
        }
    }
    
    @IBAction func changeKeyboard(sender: UIButton) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
            //play click sound
            AudioServicesPlaySystemSound(1104)
        }
        
        //change keyboard
        self.advanceToNextInputMode()
    }
    
    @IBAction func enter(sender: UIButton) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
            //play click sound
            AudioServicesPlaySystemSound(1104)
        }
        
        //enter
        var proxy = self.textDocumentProxy as UITextDocumentProxy
        proxy.insertText("\n")
    }
    
    @IBAction func dismissKeyboard(sender: UIButton) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
            //play click sound
            AudioServicesPlaySystemSound(1104)
        }
        
        //dismiss keyboard
        self.dismissKeyboard()
    }
    
    @IBAction func switchToNumerical(sender: UIButton) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
            //play click sound
            AudioServicesPlaySystemSound(1104)
        }
        
        //switch to numerical xib
        if(UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height){//check orientation
            var bundle = NSBundle.mainBundle() as NSBundle
            if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {//check device
                bundle.loadNibNamed("NumericalKeyboardiPad", owner:self, options:nil)
            } else {
                bundle.loadNibNamed("NumericalKeyboard", owner:self, options:nil)
            }
            
            
        } else{
            var bundle = NSBundle.mainBundle() as NSBundle
            if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {//check device
                bundle.loadNibNamed("NumericalKeyboardiPadLandscape", owner:self, options:nil)
            } else {
                bundle.loadNibNamed("NumericalKeyboardLandscape", owner:self, options:nil)
            }
        }
        
        //update variables to keep track of where we are
        currentKeyboard = 2
        textEntered = false
        
        //round all buttons
        for view in self.inputView.subviews as [UIView] {
            view.layer.cornerRadius = 4.5
            view.clipsToBounds = true
        }
        
        //update keyboard color
        dispatch_after(1, dispatch_get_main_queue(), {
            self.updateKeyboardColor()
        })
    }
    
    @IBAction func switchToDefault(sender: UIButton) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
            //play click sound
            AudioServicesPlaySystemSound(1104)
        }
        
        //switch to numerical xib
        if(UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height){//check orientation
            var bundle = NSBundle.mainBundle() as NSBundle
            if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {//check device
                bundle.loadNibNamed("DefaultKeyboardiPad", owner:self, options:nil)
            } else {
                bundle.loadNibNamed("DefaultKeyboard", owner:self, options:nil)
            }
            
            
        } else{
            var bundle = NSBundle.mainBundle() as NSBundle
            if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {//check device
                bundle.loadNibNamed("DefaultKeyboardiPadLandscape", owner:self, options:nil)
            } else {
                bundle.loadNibNamed("DefaultKeyboardLandscape", owner:self, options:nil)
            }
        }
        
        //update caps button
        if (self.isCaps) {
            //set caps button color
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                //update UI
                self.capsButton.backgroundColor = UIColor.whiteColor()
                self.capsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
                
                self.iPadCapsButton.backgroundColor = UIColor.whiteColor()
                self.iPadCapsButton.setTitleColor(self.keyBackgroundColor, forState: UIControlState.Normal)
            }
        }
        
        //update variables to keep track of where we are
        currentKeyboard = 1
        textEntered = false
        
        //round all buttons
        for view in self.inputView.subviews as [UIView] {
            view.layer.cornerRadius = 4.5
            view.clipsToBounds = true
        }
        
        //update keyboard color
        //update keyboard color
        dispatch_after(1, dispatch_get_main_queue(), {
            self.updateKeyboardColor()
        })
    }
    
    @IBAction func switchToSpecialCharacters(sender: UIButton) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) { () -> Void in
            //play click sound
            AudioServicesPlaySystemSound(1104)
        }
        
        //switch to numerical xib
        if(UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height){//check orientation
            var bundle = NSBundle.mainBundle() as NSBundle
            if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {//check device
                bundle.loadNibNamed("SpecialCharactersKeyboardiPad", owner:self, options:nil)
            } else {
                bundle.loadNibNamed("SpecialCharactersKeyboard", owner:self, options:nil)
            }
            
            
        } else{
            var bundle = NSBundle.mainBundle() as NSBundle
            if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {//check device
                bundle.loadNibNamed("SpecialCharactersKeyboardiPadLandscape", owner:self, options:nil)
            } else {
                bundle.loadNibNamed("SpecialCharactersKeyboardLandscape", owner:self, options:nil)
            }
        }
        
        //update variables to keep track of where we are
        currentKeyboard = 3
        textEntered = false
        
        //round all buttons
        for view in self.inputView.subviews as [UIView] {
            view.layer.cornerRadius = 4.5
            view.clipsToBounds = true
        }
        
        //update keyboard color
        dispatch_after(1, dispatch_get_main_queue(), {
            self.updateKeyboardColor()
        })
    }
}