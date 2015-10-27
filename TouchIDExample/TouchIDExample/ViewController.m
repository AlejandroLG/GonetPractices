//
//  ViewController.m
//  TouchIDExample
//
//  Created by Alejandro López on 8/25/15.
//  Copyright (c) 2015 GoNet. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_btnSignIn.layer setCornerRadius:_btnSignIn.frame.size.width/2];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInAction:(id)sender {
    // Creating local authentication context
    LAContext *context = [[LAContext alloc] init];
    
    NSError *error = nil;
    
    // Check if the local authentication context (LAContext) is able to authenticate a user
    // by the touch id functionality (it depends of device type).
    if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"It's neccessary an authentication to continue."
                          reply:^(BOOL success, NSError *error) {
                              
                              // Check if the user authentication is correct
                              if(success) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self showMessageWithTitle:@"Success"
                                                         message:@"Welcome, you're logged in successfully!!"
                                                  andButtonTitle:@"OK"];
                                      NSLog(@"Success - Welcome, you were logged in successfully !!!");
                                  });
                              }
                              else {
                                  switch (error.code) {
                                      case LAErrorAuthenticationFailed:
                                          [self showMessageWithTitle:@"Error"
                                                             message:@"The authentication has failed"
                                                      andButtonTitle:@"Continue"];
                                          break;
                                          
                                      case LAErrorUserCancel:
                                          NSLog(@"The user has cancelled the authentication process");
                                          break;
                                          
                                      case LAErrorUserFallback:
                                          NSLog(@"The user decides not to use the touch id functionality and decides to use his/her credentials");
                                          break;
                                          
                                      case LAErrorSystemCancel:
                                          NSLog(@"The authentication process has cancelled by the app.");
                                          break;
                                  }
                              }
                          }];
    }
    else {
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
                [self showMessageWithTitle:@"Error"
                                   message:@"You haven't set a your touch id authentication yet"
                            andButtonTitle:@"Continue"];
                break;
                
            case LAErrorPasscodeNotSet:
                [self showMessageWithTitle:@"Error"
                                   message:@"You haven't set a passcode yet"
                            andButtonTitle:@"Continue"];
                break;
                
            case LAErrorTouchIDNotAvailable:
                [self showMessageWithTitle:@"Error"
                                   message:@"This device doesn't support touch id functionality"
                            andButtonTitle:@"Continue"];
                break;
        }
    }
}

- (void)showMessageWithTitle:(NSString *)title
                     message:(NSString *)message
              andButtonTitle:(NSString *)buttonTitle {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:buttonTitle
                                          otherButtonTitles:nil, nil];
    [alert show];
}

@end
