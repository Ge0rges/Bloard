//
//  SetupViewController.m
//  Bloard
//
//  Created by Georges Kanaan on 11/14/14.
//  Copyright (c) 2014 Georges Kanaan. All rights reserved.
//

#import "SetupViewController.h"

@interface SetupViewController ()

@end

@implementation SetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkKeyboard:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (BOOL)isCustomKeyboardEnabled {
    NSString *bundleID = @"com.ge0rges.Bloard.Bloard-Keyboard";
    NSArray *keyboards = [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] objectForKey:@"AppleKeyboards"]; // Array of all active keyboards
    for (NSString *keyboard in keyboards) {
        if ([keyboard isEqualToString:bundleID])
            return YES;
    }
    
    return NO;
}

-(void)checkKeyboard:(NSTimer *)timer {
    if ([[self class] isCustomKeyboardEnabled]) {
        //stop the timer
        [timer invalidate];
        timer = nil;
        
        //go back to main view controller
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
