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
#import "VoiceRecorderViewController.h"
#import "UserProfileViewController.h"

#define kSavedImage @"savedImage.png"
#define kImagePath  @"imagePath"

@interface SignUpViewController () {
    AVAudioPlayer *audioPlayer;
}

@end

@implementation SignUpViewController

@synthesize imageView;

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
    [[self view] endEditing:YES];
}

#pragma mark - IBActions

-(IBAction)previous:(id)sender {
    if ([self.tf_first_name isFirstResponder]) {
        
    }else if([self.tf_lastname isFirstResponder]) {
        [self.tf_first_name becomeFirstResponder];
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
    }else if([self.tf_cellNumber isFirstResponder]) {
        [self.tf_company becomeFirstResponder];
    }else if([self.tv_title isFirstResponder]) {
        [self.tf_cellNumber becomeFirstResponder];
    }else if ([self.tv_like isFirstResponder]) {
        [self.tv_title becomeFirstResponder];
    }else if([self.tv_dislike isFirstResponder]) {
        [self.tv_like becomeFirstResponder];
    }else if ([self.tf_specialInterest isFirstResponder]) {
        [self.tv_dislike becomeFirstResponder];
    }
}

-(IBAction)next:(id)sender {
    if ([self.tf_first_name isFirstResponder]) {
        [self.tf_lastname becomeFirstResponder];
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
        [self.tf_cellNumber becomeFirstResponder];
    }else if ([self.tf_cellNumber isFirstResponder]) {
        [self.tv_title becomeFirstResponder];
    }else if ([self.tv_title isFirstResponder]) {
        [self.tv_like becomeFirstResponder];
    }else if ([self.tv_like isFirstResponder]) {
        [self.tv_dislike becomeFirstResponder];
    }else if ([self.tv_dislike isFirstResponder]) {
        [self.tf_specialInterest becomeFirstResponder];
    }
}

-(IBAction)done:(id)sender {
    [[self view] endEditing:YES];
    [self.scrollView setContentOffset:CGPointMake(0, -60) animated:YES];
}

- (IBAction)dismissKeyboard:(id)sender{
    [sender resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

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
    
    NSMutableDictionary *params = [self dictionaryWithParams];
    
    [self.activityIndicator startAnimating];
    GenericFetcher *fetcher = [[GenericFetcher alloc]init];
    
    //if there is a POST request send params in the fetcher method, if get request send nil to that
    // if there is a GET request send params in the urlbuilder method and nil to the fetcher method
    [self.submit setEnabled:NO];
    
    [fetcher fetchWithUrl:[URLBuilder urlForMethod:@"/register_guest?" withParameters:nil]
               withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict1) {
       NSLog(@"%@",dict1);
       int status = [[dict1 valueForKey:@"status"] integerValue];
       if (status == 1) {
           [[UserInfo instance] setApiKey:[dict1 valueForKey:kapi_key]];
           [[UserInfo instance] saveUserInfo];
           
           [self saveUserInfotoInstance];
           if (imageView.image) {
               [self uploadImage];
           }else {
               [[UserInfo instance] setProfileimageLink:KStaticImageURL];
               NSLog(@"Profile Image Link: %@", [[UserInfo instance] profileimageLink]);
               [self.activityIndicator stopAnimating];
               UserProfileViewController *userProfileVC = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
               [self.navigationController pushViewController:userProfileVC animated:YES];
           }
        }
        else {
            [self.activityIndicator stopAnimating];
           UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error in Registration" message:[dict1 valueForKey:@"error_message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alert show];
        }
                   
    }
   errorBlock:^(NSError *error) {
       [self.activityIndicator stopAnimating];
   }];
}

- (IBAction)adjustView:(id)sender {
    
    if (sender == self.tf_password){
        [self.scrollView setContentOffset:CGPointMake(0, 40) animated:YES];
    }
    else if (sender == self.tf_birthday){
        [self.scrollView setContentOffset:CGPointMake(0, 80) animated:YES];
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
    else if (sender == self.tf_cellNumber){
        [self.scrollView setContentOffset:CGPointMake(0, 240) animated:YES];
    }
    else if (sender == self.tf_specialInterest){
        [self.scrollView setContentOffset:CGPointMake(0, 370) animated:YES];
    }
}

#pragma mark - initialize view

-(void)initilaizeView{
    
    self.isProfileImageChanged = NO;
    [self setTitle:@"Sign Up"];
    // hassan -  set the content size of scrollview
    CGFloat scrollViewHeight = 0.0f;
//    scrollViewHeight = (14 * (30 + 10)) + 60;
//    [self.scrollView setContentSize:CGSizeMake(320, 560)];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 800);
    
    // UIBarButton Item (Gallery/Take Photo/Voice Recorder)
    UIBarButtonItem *actionBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraButton)];
    [self.navigationItem setRightBarButtonItem:actionBarButton];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissViewcontroller)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];

    // Input AccesoryView
    [self setAccessoryView];

    // Set TextFields Left View
    [self setTextFieldsLeftView];
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
    [self initilaizeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(NSMutableDictionary *) dictionaryWithParams {
    
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
    [params setValue:self.tv_title.text forKey:ktitle];
    [params setValue:self.tv_like.text forKey:klikes];
    [params setValue:self.tv_dislike.text forKey:kdislikes];
    [params setValue:self.tf_cellNumber.text forKey:kCellNumber];
    [params setValue:self.tf_specialInterest.text forKey:kSpecialInterest];
    
    return params;
}

-(void) alertNotification:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

-(void) setTextFieldsLeftView {
    
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
    
    self.tf_cellNumber.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_cellNumber.leftViewMode = UITextFieldViewModeAlways;
    
    self.tf_specialInterest.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_specialInterest.leftViewMode = UITextFieldViewModeAlways;
}

-(void) setAccessoryView {
    
    [self.tf_first_name setInputAccessoryView:self.toolbar];
    [self.tf_lastname setInputAccessoryView:self.toolbar];
    [self.tf_email setInputAccessoryView:self.toolbar];
    [self.tf_city setInputAccessoryView:self.toolbar];
    [self.tf_company setInputAccessoryView:self.toolbar];
    [self.tf_country setInputAccessoryView:self.toolbar];
    [self.tf_birthday setInputAccessoryView:self.toolbar];
    [self.tf_password setInputAccessoryView:self.toolbar];
    [self.tf_spouse setInputAccessoryView:self.toolbar];
    [self.tv_like setInputAccessoryView:self.toolbar];
    [self.tv_dislike setInputAccessoryView:self.toolbar];
    [self.tv_title setInputAccessoryView:self.toolbar];
    [self.tf_cellNumber setInputAccessoryView:self.toolbar];
    [self.tf_specialInterest setInputAccessoryView:self.toolbar];
}

-(void) cameraButton {
    
//    [[self view] endEditing:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Picture From Gallery", @"Take Picture", nil];
    [actionSheet showInView:self.view];
}

-(void)uploadImage {
    
    GenericFetcher *fetcher = [[GenericFetcher alloc]init];
    
    NSString *apiKey = [[UserInfo instance] apiKey];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:imageView.image forKey:kImage];
    
    //if there is a POST request send params in the fetcher method, if get request send nil to that
    // if there is a GET request send params in the urlbuilder method and nil to the fetcher method
    
    [fetcher PostImageToUrl:[URLBuilder urlForMethod:[NSString stringWithFormat:@"/upload_guest_image/%@", apiKey] withParameters:nil] withMethod:@"POST" withParams:param completionBlock:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        
        int status = [[dict valueForKey:@"status"] integerValue];
        NSLog(@"Status of Image API: %d", status);
        if (status == 1) {
            [self.submit setEnabled:YES];
            
            [self.activityIndicator stopAnimating];
            NSLog(@"Status = %d", status);
            [[UserInfo instance] setProfileimageLink:[dict valueForKey:Kprofile_image]];
            NSLog(@"Profile Image Link: %@", [[UserInfo instance] profileimageLink]);
            [[UserInfo instance] saveUserInfo];
            
            [self.activityIndicator stopAnimating];
            [self alertNotification:@"Congratulations!" message:@"You have successfully registered, please check your email for details."];
            
            UserProfileViewController *userProfileVC = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
            [self.navigationController pushViewController:userProfileVC animated:YES];
        }else {
            [self.activityIndicator stopAnimating];
            [self alertNotification:@"Image Error" message:@"Sorry, You're unable to upload your image."];
        }
        }
                 errorBlock:^(NSError *error) {
                     [self.activityIndicator stopAnimating];
                 }];
}

-(void) saveUserInfotoInstance {
    
    [[UserInfo instance] setFirstName:self.tf_first_name.text];
    [[UserInfo instance] setLastName:self.tf_lastname.text];
    [[UserInfo instance] setEmailAddress:self.tf_email.text];
    [[UserInfo instance] setPassword:self.tf_password.text];
    [[UserInfo instance] setBirthdays:self.tf_birthday.text];
    [[UserInfo instance] setSpouses:self.tf_spouse.text];
    [[UserInfo instance] setCitys:self.tf_city.text];
    [[UserInfo instance] setCountrys:self.tf_country.text];
    [[UserInfo instance] setCompanys:self.tf_company.text];
    [[UserInfo instance] setTitles:self.tv_title.text];
    [[UserInfo instance] setLikes:self.tv_like.text];
    [[UserInfo instance] setDislikes:self.tv_dislike.text];
    [[UserInfo instance] setCellNumber:self.tf_cellNumber.text];
    [[UserInfo instance] setSpecialInterest:self.tf_specialInterest.text];
    [[UserInfo instance] setIsLogin:YES];
    
    [[UserInfo instance] saveUserInfo];
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
        default:
            break;
    }
}

-(void) useCameraRoll {
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
    NSLog(@"take image from gallery");
}

-(void) useCamera {
    
    NSLog(@"Take Picture");
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES) {
        NSLog(@"Camera");
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    picker.delegate = self;
    UIImage  *image =  [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (image) {
        self.isProfileImageChanged = YES;
        [imageView setImage:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void) dismissViewcontroller {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextField Delegate Methods

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.tf_first_name) {
        [self.previous setEnabled:NO];
        [self.next setEnabled:YES];
    }else if (textField == self.tf_lastname) {
        [self.previous setEnabled:YES];
    }else if (textField == self.tf_specialInterest) {
        [self.next setEnabled:NO];
        [self.previous setEnabled:YES];
    }
}

#pragma mark - UITextView Delegate Methods

-(void) textViewDidBeginEditing:(UITextView *)textView {
    
    if (textView == self.tv_title) {
        [self.scrollView setContentOffset:CGPointMake(0, 280) animated:YES];
    }else if (textView == self.tv_like) {
        [self.scrollView setContentOffset:CGPointMake(0, 310) animated:YES];
    }else if (textView == self.tv_dislike) {
        [self.next setEnabled:YES];
        [self.scrollView setContentOffset:CGPointMake(0, 340) animated:YES];
    }

}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    static const NSUInteger MAX_NUMBER_OF_LINES_ALLOWED = 3;
    
    NSMutableString *t = [NSMutableString stringWithString:
                          textView.text];
    [t replaceCharactersInRange: range withString: text];
    
    NSUInteger numberOfLines = 0;
    for (NSUInteger i = 0; i < t.length; i++) {
        if ([[NSCharacterSet newlineCharacterSet]
             characterIsMember: [t characterAtIndex: i]]) {
            numberOfLines++;
        }
    }
    
    return (numberOfLines < MAX_NUMBER_OF_LINES_ALLOWED);
}

- (IBAction)editUserVoice:(id)sender {
    VoiceRecorderViewController *voiceRVC = [[VoiceRecorderViewController alloc] initWithNibName:@"VoiceRecorderViewController" bundle:nil];
    voiceRVC.delegate=self;
    [self.navigationController pushViewController:voiceRVC animated:YES];
}

@end
