//
//  ChangeProfileViewController.m
//  ÜberGuest
//
//  Created by Safyan Mughal on 12/24/13.
//  Copyright (c) 2013 Safyan Mughal. All rights reserved.
//

#import "ChangeProfileViewController.h"
#import "UserProfileViewController.h"
#import "VoiceRecorderViewController.h"

#import "UserInfo.h"
#import "GenericFetcher.h"
#import "URLBuilder.h"
#import "Utility.h"
#import "Constants.h"
#import "UIImageView+WebCache.h"

@interface ChangeProfileViewController ()

@end

@implementation ChangeProfileViewController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    //Do refreshing of userDefaults here, or table reloading
    
    [super viewWillAppear:YES];
    [self reloadInputViews];
    [self initilaizeChangeProView];
    
//    [self loadUserInformation];
    [self setTFTextSpace];
}

-(void) initialize {
    
    [self setTitle:@"Edit Profile"];
    isProfileImageChanged=NO;
    isAudioChanged=NO;
    
    // Camera + Voice Recorder Button
    UIBarButtonItem *actionBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(actionButton)];
    [self.navigationItem setRightBarButtonItem:actionBarButton];
    
    // hassan -  set the content size of scrollview
    CGFloat scrollViewHeight = 0.0f;
    scrollViewHeight = (14 * (30 + 10)) - 10;
    [self.scrollView setContentSize:CGSizeMake(320, scrollViewHeight)];
    
    [self setAccessoryView];
    [self loadUserInformation];
    [self reloadInputViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)changeProfileBackgroundTap:(id)sender
{
    [[self view] endEditing:YES];
}

-(void) loadUserInformation
{
   // UserInfo *info=[UserInfo instance];
    
    self.tf_email.text = [[UserInfo instance] emailAddress];
    self.tf_first_name.text = [[UserInfo instance] firstName];
    self.tf_last_name.text = [[UserInfo instance] lastName];
    self.tf_birthday.text = [[UserInfo instance] birthdays];
    self.tf_spouse.text = [[UserInfo instance] spouses];
    self.tf_city.text = [[UserInfo instance] citys];
    self.tf_country.text = [[UserInfo instance] countrys];
    self.tf_company.text = [[UserInfo instance] companys];
    self.tv_title.text= [[UserInfo instance] titles];
    self.tv_like.text = [[UserInfo instance] likes];
    self.tv_dislike.text = [[UserInfo instance] dislikes];
    self.tf_password.text = [[UserInfo instance] password];
    NSLog(@"Password = %@", [[UserInfo instance] password]);
    NSLog(@"Image1: %@", [[UserInfo instance] profileimageLink]);
    [imageView setImageWithURL:[NSURL URLWithString:[[UserInfo instance] profileimageLink]] placeholderImage:nil];
    self.tf_cellNumber.text = [[UserInfo instance] cellNumber];
    self.tf_specialInterest.text = [[UserInfo instance] specialInterest];
    
}

-(void)setTFTextSpace{
    self.tf_email.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_email.leftViewMode = UITextFieldViewModeAlways;
    self.tf_last_name.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_last_name.leftViewMode = UITextFieldViewModeAlways;
    self.tf_first_name.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_first_name.leftViewMode = UITextFieldViewModeAlways;
    self.tf_password.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_password.leftViewMode = UITextFieldViewModeAlways;
    self.tf_spouse.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_spouse.leftViewMode = UITextFieldViewModeAlways;
    self.tf_birthday.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_birthday.leftViewMode = UITextFieldViewModeAlways;
    self.tf_city.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_city.leftViewMode = UITextFieldViewModeAlways;
    self.tf_country.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_country.leftViewMode = UITextFieldViewModeAlways;
    self.tf_company.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_company.leftViewMode = UITextFieldViewModeAlways;
}

-(void)uploadImage {
    
    GenericFetcher *fetcher = [[GenericFetcher alloc]init];
    
    NSString *apiKey = [[UserInfo instance] apiKey];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    [param setValue:apiKey forKey:kapi_key];
    [param setValue:imageView.image forKey:kImage];
    
    //if there is a POST request send params in the fetcher method, if get request send nil to that
    // if there is a GET request send params in the urlbuilder method and nil to the fetcher method
    
    [fetcher PostImageToUrl:[URLBuilder urlForMethod:[NSString stringWithFormat:@"/upload_guest_image/%@", apiKey] withParameters:nil] withMethod:@"POST" withParams:param completionBlock:^(NSDictionary *dict) {
                   NSLog(@"%@",dict);
        
                   int status = [[dict valueForKey:@"status"] integerValue];
                    NSLog(@"Status of Image API: %d", status);
        
                   if (status == 1) {
                       [self.activityIndicator stopAnimating];
                       NSLog(@"Status = %d", status);
                       [[UserInfo instance] setProfileimageLink:[dict valueForKey:Kprofile_image]];
                       [[UserInfo instance] saveUserInfo];
                       NSLog(@"Image1: %@", [[UserInfo instance] profileimageLink]);
                       
                       [self.activityIndicator stopAnimating];
                       [self alertNotification:@"Congratulations!" message:@"Congratulations! Your profile is updated successfully!"];
                       [self.navigationController popViewControllerAnimated:YES];
                   }else {
                       [self.activityIndicator stopAnimating];
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Error" message:@"Unable to upload Image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                       [alert show];
                   }
               }
               errorBlock:^(NSError *error) {}];
}

-(void) saveUserInfotoInstance {
    
    [[UserInfo instance] setFirstName:self.tf_first_name.text];
    [[UserInfo instance] setLastName:self.tf_last_name.text];
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
    
    [[UserInfo instance] saveUserInfo];
}

-(NSMutableDictionary *) getDictionaryWithUserInfo {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    [params setValue:self.tf_password.text forKey:kpassword];
    [params setValue:self.tf_first_name.text forKey:kfirst_name];
    [params setValue:self.tf_last_name.text forKey:klast_name];
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
    
    [params setValue:[[UserInfo instance] apiKey] forKey:kapi_key];
    
    return params;
}

-(IBAction) saveChanges:(id)sender
{
    if (self.tf_first_name.text.length==0 || self.tf_last_name.text.length == 0)
    {
        NSLog(@"Empty Fields");
        [self alertNotification:@"Missing Fields" message:@"Please input mandatory fields. (i.e) First Name & Last Name"];
        return;
    }
    
    [self.activityIndicator startAnimating];
    NSMutableDictionary *params = [self getDictionaryWithUserInfo];
    
    GenericFetcher *fetcher = [[GenericFetcher alloc]init];
    //if there is a POST request send params in the fetcher method, if get request send nil to that
    // if there is a GET request send params in the urlbuilder method and nil to the fetcher method
    
    NSLog(@"Camous url------> %@",[URLBuilder urlForMethod:@"/edit_guest?" withParameters:params]);
    [fetcher fetchWithUrl:[URLBuilder urlForMethod:@"/edit_guest?" withParameters:nil]
               withMethod:POST_REQUEST withParams:params completionBlock:^(NSDictionary *dict)
     {
        NSLog(@"%@",dict);
        int status = [[dict valueForKey:@"status"] integerValue];
        if (status == 1)
        {
            [self saveUserInfotoInstance];
            if (isProfileImageChanged) {
                [self uploadImage];
            }else {
                [self.activityIndicator stopAnimating];
                [self alertNotification:@"Congratulations!" message:@"Congratulations! Your profile is updated successfully!"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            [self alertNotification:@"Failure" message:@"Your profile could not updated successfully!"];
            [self.navigationController popViewControllerAnimated:YES];
        }
     }
               errorBlock:^(NSError *error){
                   [self alertNotification:@"No Internet" message:@"No Internet Connection Available."];
               }
     ];
}

- (IBAction)adjustView:(id)sender
{
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
        [self.scrollView setContentOffset:CGPointMake(0, 160) animated:YES];
    }
    else if (sender == self.tf_country){
        [self.scrollView setContentOffset:CGPointMake(0, 200) animated:YES];
    }
    else if (sender == self.tf_company){
        [self.scrollView setContentOffset:CGPointMake(0, 240) animated:YES];
    }
    else if (sender == self.tf_cellNumber){
        [self.scrollView setContentOffset:CGPointMake(0, 280) animated:YES];
    }
    else if (sender == self.tf_specialInterest){
        [self.scrollView setContentOffset:CGPointMake(0, 440) animated:YES];
    }
}

-(void)initilaizeChangeProView{
    //   [self.titleBarView setHidden:YES];
    self.tf_email.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_email.leftViewMode = UITextFieldViewModeAlways;
    self.tf_password.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_password.leftViewMode = UITextFieldViewModeAlways;
    self.tf_first_name.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_first_name.leftViewMode = UITextFieldViewModeAlways;
    self.tf_last_name.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.tf_last_name.leftViewMode = UITextFieldViewModeAlways;
    
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
}

#pragma mark - Helper Methods

-(void) dismissViewcontroller {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) setAccessoryView {
    [self.tf_first_name setInputAccessoryView:self.toolbar];
    [self.tf_last_name setInputAccessoryView:self.toolbar];
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
    [self.tv_title setInputAccessoryView:self.toolbar];
    [self.tf_cellNumber setInputAccessoryView:self.toolbar];
    [self.tf_specialInterest setInputAccessoryView:self.toolbar];
}

-(void) actionButton {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Picture From Gallery", @"Camera", nil];
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
        [imageView setImage:image];
        isProfileImageChanged=YES;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions

-(IBAction)previous:(id)sender {
   if([self.tf_last_name isFirstResponder]) {
        [self.tf_first_name becomeFirstResponder];
    }else if ([self.tf_email isFirstResponder]) {
        [self.tf_last_name becomeFirstResponder];
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
        [self.tf_last_name becomeFirstResponder];
    }else if ([self.tf_last_name isFirstResponder]) {
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
    [self.scrollView setContentOffset:CGPointMake(0, -60)];
}

#pragma mark - UITextField Delegate Methods

-(void) textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.tf_first_name) {
        [self.previous setEnabled:NO];
        [self.next setEnabled:YES];
    }else if (textField == self.tf_last_name) {
        [self.previous setEnabled:YES];
    }else if (textField == self.tf_specialInterest) {
        [self.next setEnabled:NO];
        [self.previous setEnabled:YES];
    }
}

#pragma mark - UITextView Delegate Methods

-(void) textViewDidBeginEditing:(UITextView *)textView {
    
    if (textView == self.tv_title) {
        [self.scrollView setContentOffset:CGPointMake(0, 320) animated:YES];
    }else if (textView == self.tv_like) {
        [self.scrollView setContentOffset:CGPointMake(0, 360) animated:YES];
    }else if (textView == self.tv_dislike) {
        [self.next setEnabled:YES];
        [self.scrollView setContentOffset:CGPointMake(0, 400) animated:YES];
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

#pragma mark - Helper Methods

-(void) alertNotification:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

@end
