//
//  ViewController.swift
//  Bloard
//
//  Created by Georges Kanaan on 10/30/14.
//  Copyright (c) 2014 Georges Kanaan. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {
    
    @IBOutlet var keyboardBackground: UIView!
    @IBOutlet var yKey: UIButton!
    @IBOutlet var tKey: UIButton!
    @IBOutlet var rKey: UIButton!
    @IBOutlet var eKey: UIButton!
    @IBOutlet var wKey: UIButton!
    @IBOutlet var qKey: UIButton!
    
    @IBOutlet var backgroundSlider: UISlider!
    @IBOutlet var keySlider: UISlider!
    
    
    //view controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //sliders set up
        //remove the tracks
        backgroundSlider.setMaximumTrackImage(UIImage.alloc(), forState: .Normal)
        backgroundSlider.setMinimumTrackImage(UIImage.alloc(), forState: .Normal)
        keySlider.setMaximumTrackImage(UIImage.alloc(), forState: .Normal)
        keySlider.setMinimumTrackImage(UIImage.alloc(), forState: .Normal)
        
        //set the sliders
        var sharedDefaults = NSUserDefaults(suiteName: "group.com.ge0rges.bloard")
        backgroundSlider.value = -sharedDefaults!.floatForKey("KBBackgroundColorShade")
        keySlider.value = -sharedDefaults!.floatForKey("KBKeysColorShade")
        
        //update preview
        keyboardBackground.backgroundColor = UIColor(white: CGFloat(-backgroundSlider.value), alpha: 1)

        yKey.backgroundColor = UIColor(white: CGFloat(-keySlider.value), alpha: 1)
        tKey.backgroundColor = UIColor(white: CGFloat(-keySlider.value), alpha: 1)
        rKey.backgroundColor = UIColor(white: CGFloat(-keySlider.value), alpha: 1)
        eKey.backgroundColor = UIColor(white: CGFloat(-keySlider.value), alpha: 1)
        wKey.backgroundColor = UIColor(white: CGFloat(-keySlider.value), alpha: 1)
        qKey.backgroundColor = UIColor(white: CGFloat(-keySlider.value), alpha: 1)
        
        //round out the buttons
        yKey.layer.cornerRadius = 5.0
        yKey.clipsToBounds = true
        
        tKey.layer.cornerRadius = 5.0
        tKey.clipsToBounds = true
        
        rKey.layer.cornerRadius = 5.0
        rKey.clipsToBounds = true
        
        eKey.layer.cornerRadius = 5.0
        eKey.clipsToBounds = true
        
        wKey.layer.cornerRadius = 5.0
        wKey.clipsToBounds = true
        
        qKey.layer.cornerRadius = 5.0
        qKey.clipsToBounds = true


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prefersStatusBarHidden() -> Bool {return true}


    //keyboard color
    @IBAction func setKeyboardBackgroundColor(sender: UISlider) {
        //set the value
        var sharedDefaults = NSUserDefaults(suiteName: "group.com.ge0rges.bloard")
        sharedDefaults!.setFloat(-sender.value, forKey: "KBBackgroundColorShade")
        
        //update the UI
        keyboardBackground.backgroundColor = UIColor(white: CGFloat(-sender.value), alpha: 1)
    }
    
    @IBAction func setKeysBackgroundColor(sender: UISlider) {
        //set the value
        var sharedDefaults = NSUserDefaults(suiteName: "group.com.ge0rges.bloard")
        sharedDefaults!.setFloat(-sender.value, forKey: "KBKeysColorShade")
        
        //update the UI
        yKey.backgroundColor = UIColor(white: CGFloat(-sender.value), alpha: 1)
        tKey.backgroundColor = UIColor(white: CGFloat(-sender.value), alpha: 1)
        rKey.backgroundColor = UIColor(white: CGFloat(-sender.value), alpha: 1)
        eKey.backgroundColor = UIColor(white: CGFloat(-sender.value), alpha: 1)
        wKey.backgroundColor = UIColor(white: CGFloat(-sender.value), alpha: 1)
        qKey.backgroundColor = UIColor(white: CGFloat(-sender.value), alpha: 1)

    }
    
    @IBAction func setDefaultColors(sender: UIButton) {
        //set the value
        var sharedDefaults = NSUserDefaults(suiteName: "group.com.ge0rges.bloard")
        sharedDefaults!.setFloat(0.43921569, forKey: "KBKeysColorShade")
        sharedDefaults!.setFloat(0.3372549, forKey: "KBBackgroundColorShade")
        
        //update the slider values
        backgroundSlider.value = -0.3372549
        keySlider.value = -0.43921569
        
        //update the UI
        setKeyboardBackgroundColor(backgroundSlider)
        setKeysBackgroundColor(keySlider)

    }
    
    //other actions
    @IBAction func share(sender: UIButton) {
        
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: ["Check out the official Bloard keyboard for iOS 8. Never see a white keyboard again. http://bit.ly/bloardapp"], applicationActivities: nil)
        activityViewController.excludedActivityTypes =  [
            UIActivityTypePrint,
            UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo
        ]
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }

}

