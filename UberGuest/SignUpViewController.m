//
//  SignUp.m
//  UberGuest
//
//  Created by Safyan Mughal on 12/16/13.
//  Copyright (c) 2013 Safyan Mughal. All rights reserved.
//

#import "SignUpViewController.h"
#import "GenericFetcher.h"
#import "URLBuilder.h"
#import "Utility.h"
#import "UserInfo.h"
#import "LoginViewController.h"

@interface SignUpViewController ()


@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)backgroundTap:(id)sender
{
    [self.tf_first_name resignFirstResponder];
    [self.tf_lastname resignFirstResponder];
    [self.tf_email resignFirstResponder];
    [self.tf_password resignFirstResponder];
    [self.tf_spouse resignFirstResponder];
    [self.tf_city resignFirstResponder];
    [self.tf_country resignFirstResponder];
    [self.tf_company resignFirstResponder];
    [self.tf_title resignFirstResponder];
    [self.tf_like resignFirstResponder];
    [self.tf_dislike resignFirstResponder];
}

- (IBAction)dismissKeyboard:(id)sender{
    [sender resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

///////......................................................

- (IBAction)performRegisterAction:(id)sender
{
    if (self.tf_email.text.length==0 || self.tf_password.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please input mandatory fields." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if (![Utility isValidEmail:self.tf_email.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please enter valid email format." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:self.tf_email.text forKey:kemail_id];
    [params setValue:self.tf_password.text forKey:kpassword];
    [params setValue:self.tf_first_name.text forKey:kfirst_name];
    [params setValue:self.tf_lastname.text forKey:klast_name];
        [params setValue:self.tf_birthday.text forKey:kbirthday];
        [params setValue:self.tf_spouse.text forKey:kspouse];
        [params setValue:self.tf_city.text forKey:kcity];
        [params setValue:self.tf_country.text forKey:kcountry];
        [params setValue:self.tf_company.text forKey:kcompany];
        [params setValue:self.tf_title.text forKey:ktitle];
        [params setValue:self.tf_like.text forKey:klikes];
        [params setValue:self.tf_dislike.text forKey:kdislikes];
    
    
    GenericFetcher *fetcher = [[GenericFetcher alloc]init];
    //if there is a POST request send params in the fetcher method, if get request send nil to that
    // if there is a GET request send params in the urlbuilder method and nil to the fetcher method
    [fetcher fetchWithUrl:[URLBuilder urlForMethod:@"/register_guest?" withParameters:nil]
               withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict) {
                   NSLog(@"%@",dict);
                   int status = [[dict valueForKey:@"status"] integerValue];
                   if (status == 1) {
                     
                       UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"You have successfully registered, please check your email for details." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                       [alert show];
                       
        //............................ changed view
                                             
                       
                       
                        UserInfo *userInfo = [UserInfo instance];
                        [userInfo setEmailAddress:self.tf_email.text];
                        [userInfo setApiKey:[dict valueForKey:@"api_key"]];
                        [userInfo setFirstName:self.tf_first_name.text];
                        [userInfo setLastName:self.tf_lastname.text];
                         [userInfo setPassword:self.tf_password.text];
                         [userInfo setBirthdays:self.tf_birthday.text];
                         [userInfo setSpouses:self.tf_spouse.text];
                         [userInfo setCitys:self.tf_city.text];
                         [userInfo setCountrys:self.tf_country.text];
                         [userInfo setCompanys:self.tf_company.text];
                         [userInfo setTitles:self.tf_title.text];
                         [userInfo setLikes:self.tf_like.text];
                         [userInfo setDislikes:self.tf_dislike.text];
                       [userInfo setIsLogin:YES];
                       
                       
                            //    [userInfo setProfileimageLink:[dict valueForKey:@"profile_pic_url"]];
                       // [userInfo setIsLogin:YES];
                        [userInfo saveUserInfo];
                            //                         if (image_edited) {
                            //                           NSString *api_key = [dict valueForKey:@"api_key"];
                            //                           [self uploadProfileImage:api_key andImage:profile_imageview.image];
                            //                       }
                       
                    
                       
                        [self.navigationController popToRootViewControllerAnimated:NO];
                       

                   }
                   else
                   {
                       UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error in Registration" message:[dict valueForKey:@"error_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                       [alert show];
                       
                   }
                   
               }
               errorBlock:^(NSError *error) {
        }];
    
    
    

    
}
//- (IBAction)goToLogin:(id)sender {
  //  [self.navigationController popViewControllerAnimated:YES];
//}

- (IBAction)adjustView:(id)sender {
    
    if (sender == self.tf_first_name) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (sender == self.tf_lastname){
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else if (sender == self.tf_email){
        [self.scrollView setContentOffset:CGPointMake(0, 30) animated:YES];
    }else if (sender == self.tf_password){
        [self.scrollView setContentOffset:CGPointMake(0, 45) animated:YES];
    }
    else if (sender == self.tf_birthday){
        [self.scrollView setContentOffset:CGPointMake(0, 85) animated:YES];
    }
    else if (sender == self.tf_spouse){
        [self.scrollView setContentOffset:CGPointMake(0, 120) animated:YES];
    }
    else if (sender == self.tf_city){
        [self.scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
    }
    else if (sender == self.tf_country){
        [self.scrollView setContentOffset:CGPointMake(0, 180) animated:YES];
    }
    else if (sender == self.tf_company){
        [self.scrollView setContentOffset:CGPointMake(0, 210) animated:YES];
    }
    else if (sender == self.tf_title){
        [self.scrollView setContentOffset:CGPointMake(0, 240) animated:YES];
    }
    else if (sender == self.tf_like){
        [self.scrollView setContentOffset:CGPointMake(0, 280) animated:YES];
    }
    else if (sender == self.tf_dislike){
        [self.scrollView setContentOffset:CGPointMake(0, 310) animated:YES];
    }
}


#pragma mark - initialize view
-(void)initilaizeView{
    
    // hassan -  set the content size of scrollview
    CGFloat scrollViewHeight = 0.0f;
    scrollViewHeight = (12 * (30 + 10)) - 10;
    [self.scrollView setContentSize:CGSizeMake(320, scrollViewHeight)];
    
    // UIBarButton Item (Gallery/Take Photo)
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto:)];
    [self.navigationItem setRightBarButtonItem:cameraButton];

    // Input AccesoryView
    [self setAccessoryView];
    
 //   [self.titleBarView setHidden:YES];
    self.tf_email.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_email.leftViewMode = UITextFieldViewModeAlways;
    self.tf_password.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_password.leftViewMode = UITextFieldViewModeAlways;
    self.tf_first_name.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_first_name.leftViewMode = UITextFieldViewModeAlways;
    self.tf_lastname.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_lastname.leftViewMode = UITextFieldViewModeAlways;
    
    self.tf_birthday.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_birthday.leftViewMode = UITextFieldViewModeAlways;

    self.tf_spouse.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_spouse.leftViewMode = UITextFieldViewModeAlways;
    
    self.tf_city.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_city.leftViewMode = UITextFieldViewModeAlways;
    
    self.tf_country.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_country.leftViewMode = UITextFieldViewModeAlways;
    
    self.tf_company.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_company.leftViewMode = UITextFieldViewModeAlways;
    
    self.tf_title.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_title.leftViewMode = UITextFieldViewModeAlways;
    
    self.tf_like.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_like.leftViewMode = UITextFieldViewModeAlways;
    
    self.tf_dislike.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_dislike.leftViewMode = UITextFieldViewModeAlways;

}

-(void) setAccessoryView {
    [self.tf_first_name setInputAccessoryView:self.toolbar];
    [self.tf_lastname setInputAccessoryView:self.toolbar];
    [self.tf_email setInputAccessoryView:self.toolbar];
    [self.tf_dislike setInputAccessoryView:self.toolbar];
    [self.tf_like setInputAccessoryView:self.toolbar];
    [self.tf_city setInputAccessoryView:self.toolbar];
    [self.tf_company setInputAccessoryView:self.toolbar];
    [self.tf_country setInputAccessoryView:self.toolbar];
    [self.tf_birthday setInputAccessoryView:self.toolbar];
    [self.tf_password setInputAccessoryView:self.toolbar];
    [self.tf_spouse setInputAccessoryView:self.toolbar];
    [self.tf_title setInputAccessoryView:self.toolbar];
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadLogView:) name:@"reloadLogView" object:nil];
    self.navigationController.navigationBarHidden=NO;
  //  spinner.hidden=YES;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"Sign Up";
    [self initilaizeView];
    
    
   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Selector Methods

-(void) takePhoto:(id) sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Picture Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Select Picture", @"Take Picture", @"Record Audio", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate Methods

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            [self useCameraRoll];
            break;
        case 1:
            [self useCamera];
            break;
        case 2:
            break;
        default:
            break;
    }
}

-(void) useCameraRoll {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
//        imagePicker.mediaTypes = (NSString *) kUTTypeImage;
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
//        _newMedia = NO;
    }
}

-(void) useCamera {
    
    NSLog(@"Take Picture");
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
//        imagePicker.mediaTypes = (NSString *) kUTTypeImage;
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];
//        _newMedia = NO;
    }
}

-(void) recordAudio {
    NSLog(@"Record Audio");
}

#pragma mark - IBActions

-(IBAction)previous:(id)sender {
    if ([self.tf_first_name isFirstResponder]) {
        
    }else if([self.tf_lastname isFirstResponder]) {
        [self.tf_first_name becomeFirstResponder];
        self.previous.enabled = NO;
    }else if ([self.tf_email isFirstResponder]) {
        [self.tf_lastname becomeFirstResponder];
    }else if ([self.tf_password isFirstResponder]) {
        [self.tf_email becomeFirstResponder];
    }else if ([self.tf_birthday isFirstResponder]) {
        [self.tf_password becomeFirstResponder];
    }else if ([self.tf_spouse isFirstResponder]) {
        [self.tf_birthday becomeFirstResponder];
    }else if ([self.tf_city isFirstResponder]) {
        [self.tf_spouse becomeFirstResponder];
    }else if ([self.tf_country isFirstResponder]) {
        [self.tf_city becomeFirstResponder];
    }else if ([self.tf_company isFirstResponder]) {
        [self.tf_country becomeFirstResponder];
    }else if([self.tf_title isFirstResponder]) {
        [self.tf_company becomeFirstResponder];
    }else if ([self.tf_like isFirstResponder]) {
        [self.tf_title becomeFirstResponder];
    }else if([self.tf_dislike isFirstResponder]) {
        [self.tf_like becomeFirstResponder];
        self.next.enabled = YES;
    }
    
}

-(IBAction)next:(id)sender {
    if ([self.tf_first_name isFirstResponder]) {
        [self.tf_lastname becomeFirstResponder];
        self.previous.enabled = YES;
    }else if ([self.tf_lastname isFirstResponder]) {
        [self.tf_email becomeFirstResponder];
    }else if ([self.tf_email isFirstResponder]) {
        [self.tf_password becomeFirstResponder];
    }else if ([self.tf_password isFirstResponder]) {
        [self.tf_birthday becomeFirstResponder];
    }else if ([self.tf_birthday isFirstResponder]) {
        [self.tf_spouse becomeFirstResponder];
    }else if ([self.tf_spouse isFirstResponder]) {
        [self.tf_city becomeFirstResponder];
    }else if ([self.tf_city isFirstResponder]) {
        [self.tf_country becomeFirstResponder];
    }else if ([self.tf_country isFirstResponder]) {
        [self.tf_company becomeFirstResponder];
    }else if ([self.tf_company isFirstResponder]) {
        [self.tf_title becomeFirstResponder];
    }else if ([self.tf_title isFirstResponder]) {
        [self.tf_like becomeFirstResponder];
    }else if ([self.tf_like isFirstResponder]) {
        [self.tf_dislike becomeFirstResponder];
        self.next.enabled = NO;
    }
}
-(BOOL) textFieldShouldReturn: (UITextField *) textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(IBAction)done:(id)sender {
    [[self view] endEditing:YES];
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];

}

@end
