//
//  SignUp.h
//  UberGuest
//
//  Created by Safyan Mughal on 12/16/13.
//  Copyright (c) 2013 Safyan Mughal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "LoginViewController.h"
#import "VoiceRecorderViewController.h"

@interface SignUpViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UITextViewDelegate, UITextViewDelegate, UITextFieldDelegate, VoiceRecorderViewControllerDelegate> {
    IBOutlet UIImageView *imageView;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *tf_first_name;
@property (strong, nonatomic) IBOutlet UITextField *tf_lastname;

@property (strong, nonatomic) IBOutlet UITextField *tf_email;
@property (strong, nonatomic) IBOutlet UITextField *tf_password;
@property (strong, nonatomic) IBOutlet UITextField *tf_birthday;
@property (strong, nonatomic) IBOutlet UITextField *tf_spouse;
@property (strong, nonatomic) IBOutlet UITextField *tf_city;
@property (strong, nonatomic) IBOutlet UITextField *tf_country;
@property (strong, nonatomic) IBOutlet UITextField *tf_company;
@property (strong, nonatomic) IBOutlet UITextField *tf_cellNumber;
@property (strong, nonatomic) IBOutlet UITextField *tf_specialInterest;

@property (strong, nonatomic) IBOutlet UITextView *tv_title;
@property (strong, nonatomic) IBOutlet UITextView *tv_like;
@property (strong, nonatomic) IBOutlet UITextView *tv_dislike;

@property (strong,nonatomic)IBOutlet UIButton *submit;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

// Toolbar Button Properties
@property (strong, nonatomic) IBOutlet UIBarButtonItem *previous;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *next;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *done;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) NSData *imageData;
@property (nonatomic, assign) BOOL isProfileImageChanged;

- (IBAction)performRegisterAction:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)adjustView:(id)sender;

-(IBAction)previous:(id)sender;
-(IBAction)next:(id)sender;
-(IBAction)done:(id)sender;

- (IBAction)editUserVoice:(id)sender;

@end
