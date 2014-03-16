//
//  ViewController.m
//  UberGuest
//
//  Created by Safyan Mughal on 12/16/13.
//  Copyright (c) 2013 Safyan Mughal. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "UserProfileViewController.h"

#import "Utility.h"
#import "URLBuilder.h"
#import "GenericFetcher.h"
#import "UserInfo.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize tf_email,tf_password,login_int;

#pragma mark - Initialization

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"Email ID: %@", [[UserInfo instance] emailAddress]);
    [self.tf_email setText:[[UserInfo instance] emailAddress]];
    if ([[UserInfo instance] isLogin])
    {
        UserProfileViewController *user_profile_instance=[[UserProfileViewController alloc]initWithNibName:@"UserProfileViewController" bundle:nil];
        [self.navigationController pushViewController:user_profile_instance animated:NO];
    }
}

-(void) initializeView {
    
    [self setTitle:@"Login"];
    [self.tf_email setText:[[UserInfo instance] emailAddress]];
    
    // Sign up Button
    UIBarButtonItem *signupButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign up" style:UIBarButtonItemStylePlain target:self action:@selector(signupViewController)];
    [self.navigationItem setRightBarButtonItem:signupButton];
    
    // Set InputView of TextFields
    [self setInputView];
}

-(void) signupViewController {
    SignUpViewController *signupVC = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    [self.navigationController pushViewController:signupVC animated:YES];
}

-(void) setInputView {
    [self.tf_email setInputAccessoryView:self.toolbar];
    [self.tf_password setInputAccessoryView:self.toolbar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(void) dismissViewcontroller {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBAction

-(IBAction)performLoginAction:(id)sender

{
    [self.view endEditing:YES];
    if (self.tf_email.text.length==0 || self.tf_password.text.length == 0) {
        [self alertNotification:@"Fields Missing" message:@"Please input mandatory fields."];
        return;
    }
    if (![Utility isValidEmail:self.tf_email.text]) {
        [self alertNotification:@"Wrong Email Format" message:@"Please enter valid email format."];
        return;
    }
    
    [self.activity setColor:[UIColor blackColor]];
    [self.activity startAnimating];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.tf_email.text forKey:@"email_id"];
    [params setValue:self.tf_password.text forKey:@"password"];
    
    GenericFetcher *fetcher = [[GenericFetcher alloc]init];
    //if there is a POST request send params in the fetcher method, if get request send nil to that
    // if there is a GET request send params in the urlbuilder method and nil to the fetcher method
    
    [fetcher fetchWithUrl:[URLBuilder urlForMethod:@"/guest_login/" withParameters:nil]
               withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
                   NSLog(@"%@",dict);
                   int status = [[dict valueForKey:@"status"] integerValue];
                   if (status == 1) {
                       // 
                       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLocation"];
                       [[NSUserDefaults standardUserDefaults] synchronize];
                       
                       NSLog(@"%@",dict);
                       
                       // Save user info in the Instance Method of UserInfo
                       NSDictionary *userDict = [dict valueForKey:@"user"];
                       [self setUserInfoInstance:userDict];
                       
                       [tf_password setText:@""];
                       [self.activity stopAnimating];
                       
                       // After successfull login, push to user's profile view controller
                       UserProfileViewController *userProfileVC = [[UserProfileViewController alloc]initWithNibName:@"UserProfileViewController" bundle:NULL];
                       [self.navigationController pushViewController:userProfileVC animated:YES];
                   }
                   else
                   {
                       [self.activity stopAnimating];
                       [self alertNotification:@"Failure" message:@"No such user exist in Uber Guest."];
                       return ;
                   }
               }
     
               errorBlock:^(NSError *error) {
                   [self.activity stopAnimating];
                   [self alertNotification:@"No Internet" message:@"No Internet Connection Available."];
                                      NSLog(@"%@",error);
               }];
    // send login call to the api
    // set user info
    // move to the state and campus selection page
}

-(IBAction)previous:(id)sender {
    if ([self.tf_password isFirstResponder]) {
        [self.tf_email becomeFirstResponder];
    }
}

-(IBAction)next:(id)sender {
    if ([self.tf_email isFirstResponder]) {
        [self.tf_password becomeFirstResponder];
    }
}

-(IBAction)done:(id)sender {
    [[self view] endEditing:YES];
}

-(IBAction)backgroundTap:(id)sender {
    [[self view] endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    if([[UIScreen mainScreen]bounds].size.height==480)
    {
        [self.view setFrame:CGRectMake(0, -30, 320, 480)];
    }
}

#pragma mark - UITextField Delegate Methods

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.tf_email) {
        [self.previous setEnabled:NO];
        [self.next setEnabled:YES];
    }else if (textField == self.tf_password) {
        [self.next setEnabled:NO];
        [self.previous setEnabled:YES];
    }
}

#pragma mark - Helper Methods

-(void) setUserInfoInstance:(NSDictionary *)userDict {
    
    UserInfo *userInfo = [UserInfo instance];
    
    [userInfo setEmailAddress:self.tf_email.text];
    [userInfo setPassword:self.tf_password.text];
    
    [userInfo setApiKey:[userDict valueForKey:kapi_key]];
    userInfo.isLogin=YES;
    userInfo.firstName = [userDict valueForKey:kfirst_name];
    userInfo.lastName = [userDict valueForKey:klast_name];
    userInfo.birthdays = [userDict valueForKey:kbirthday];
    userInfo.spouses = [userDict valueForKey:kspouse];
    userInfo.citys = [userDict valueForKey:kcity];
    userInfo.countrys = [userDict valueForKey:kcountry];
    userInfo.companys = [userDict valueForKey:kcompany];
    userInfo.titles = [userDict valueForKey:ktitle];
    userInfo.likes = [userDict valueForKey:klikes];
    userInfo.dislikes = [userDict valueForKey:kdislikes];
    userInfo.apiKey = [userDict valueForKey:kapi_key];
    
    userInfo.propertyId = [[userDict valueForKey:kPropertyId] intValue];
    userInfo.superUser = [[userDict valueForKey:kSuperUSer] intValue];
    
    userInfo.profileimageLink = [userDict valueForKey:Kprofile_image];
    userInfo.profileimageLink1 = [userDict valueForKey:Kprofile_image1];
    userInfo.userVoiceLink = [userDict valueForKey:kvoice];
    
    [userInfo saveUserInfo];
}

-(void) alertNotification:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

@end
