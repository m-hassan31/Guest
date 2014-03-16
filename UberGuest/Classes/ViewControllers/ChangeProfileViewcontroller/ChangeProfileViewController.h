//
//  ChangeProfileViewController.h
//  ÜberGuest
//
//  Created by Safyan Mughal on 12/24/13.
//  Copyright (c) 2013 Safyan Mughal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceRecorderViewController.h"
@interface ChangeProfileViewController : UIViewController<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITextFieldDelegate, UITextViewDelegate,UITextFieldDelegate, VoiceRecorderViewControllerDelegate>
{
    IBOutlet UIImageView *imageView;
    BOOL isProfileImageChanged;
    BOOL isAudioChanged;
   
    
}
- (IBAction)editUserVoice:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *tf_first_name;
@property (strong, nonatomic) IBOutlet UITextField *tf_last_name;

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

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *previous;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *next;

@property (strong, nonatomic) IBOutlet UIButton *saveChangesButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) NSData *imageData;


-(IBAction)adjustView:(id)sender;
-(IBAction)changeProfileBackgroundTap:(id)sender;

// Toolbar IBActions
-(IBAction)previous:(id)sender;
-(IBAction)next:(id)sender;
-(IBAction)done:(id)sender;

-(IBAction)saveChanges:(id)sender;

@end
