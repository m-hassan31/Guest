//
//  ViewController.h
//  UberGuest
//
//  Created by Safyan Mughal on 12/16/13.
//  Copyright (c) 2013 Safyan Mughal. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserProfileViewController.h"
#import "SignUpViewController.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,UITableViewDelegate,UINavigationControllerDelegate>
{
    Boolean keyboardIsShowing;
    CGRect keyboardBounds;
    LoginViewController *login;
    int login_int;
}

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property(nonatomic, retain) IBOutlet UIButton *btn_login;
@property(strong, nonatomic) IBOutlet UITextField *tf_email;
@property(strong, nonatomic) IBOutlet UITextField *tf_password;

// Toolbar Button Properties
@property int login_int;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *previous;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *next;

-(void)resizeViewControllerToFitScreen;

-(IBAction)performLoginAction:(id)sender;
-(IBAction)backgroundTap:(id)sender;
-(IBAction)returnTextField:(id)sender;

// UIToolbar IBActions
-(IBAction)previous:(id)sender;
-(IBAction)next:(id)sender;
-(IBAction)done:(id)sender;

@end
