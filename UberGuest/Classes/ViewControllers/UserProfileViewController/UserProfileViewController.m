//
//  UserProfile.m
//  ÜberGuest
//
//  Created by Safyan Mughal on 12/16/13.
//  Copyright (c) 2013 Safyan Mughal. All rights reserved.
//

#import "UserProfileViewController.h"
#import "LoginViewController.h"
#import "ChangeProfileViewController.h"
#import "AbstractFetcher.h"
#import "VoiceRecorderViewController.h"

#import "AppDelegate.h"

#import "UserInfo.h"
#import "Utility.h"
#import "URLBuilder.h"
#import "GenericFetcher.h"
#import "UIImageView+WebCache.h"

#define kSavedImage @"savedImage.png"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) initialize {
    
    // Load User Info
    [self loadUserInfo];
    
    // Logout UIBarButtonItem
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(confirmationAlert)];
    [self.navigationItem setLeftBarButtonItem:logoutButton];
    
    // Edit UIBarButtonItem
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editProfile)];
    [self.navigationItem setRightBarButtonItem:editButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLocation"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLocation"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.mapView setDelegate:self];
        [appDelegate locationUpdate];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadUserInfo];
}

#pragma mark - Helper Methods

-(void) loadUserInfo {
    
    [self setTitle:@"User Profile"];
    NSLog(@"Image1: %@", [[UserInfo instance] profileimageLink]);
    NSLog(@"Image2: %@", [[UserInfo instance] profileimageLink1]);
    if ([[UserInfo instance] profileimageLink]) {
        [self.profileImage setImageWithURL:[NSURL URLWithString:[[UserInfo instance] profileimageLink]] placeholderImage:nil];
    }else if ([[UserInfo instance] profileimageLink1]) {
        [self.profileImage setImageWithURL:[NSURL URLWithString:[[UserInfo instance] profileimageLink1]] placeholderImage:nil];
    }else {
        [self.profileImage setImageWithURL:[NSURL URLWithString:KStaticImageURL]];
    }
    self.user_email.text = [[UserInfo instance] emailAddress];
    self.user_first_nam.text = [[UserInfo instance] firstName];
    self.user_last_nam.text = [[UserInfo instance] lastName];
    self.user_birthday.text = [[UserInfo instance] birthdays];
    self.user_city.text = [[UserInfo instance] citys];
    self.user_company.text = [[UserInfo instance] companys];
    self.user_country.text = [[UserInfo instance] countrys];
    self.user_spouse.text = [[UserInfo instance] spouses];
}

-(void)logoutProfile
{
    UserInfo *userInfo = [UserInfo instance];
    [userInfo removeUserInfo];
    [userInfo saveUserInfo];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) confirmationAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alertView show];
}

-(void)editProfile
{
    ChangeProfileViewController *editVC = [[ChangeProfileViewController alloc]initWithNibName:@"ChangeProfileViewController" bundle:NULL];
    [self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark - UIAlertView Delegate

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //u need to change 0 to other value(,1,2,3) if u have more buttons.then u can check which button was pressed.
    
    if (buttonIndex == 1) {
        [self logoutProfile];
    }
}

@end
