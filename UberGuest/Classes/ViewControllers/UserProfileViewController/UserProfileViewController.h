//
//  UserProfile.h
//  ÜberGuest
//
//  Created by Safyan Mughal on 12/16/13.
//  Copyright (c) 2013 Safyan Mughal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface UserProfileViewController : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong,nonatomic)IBOutlet UILabel *user_first_nam;
@property (strong,nonatomic)IBOutlet UILabel *user_last_nam;
@property (strong,nonatomic)IBOutlet UILabel *user_email;
@property (strong,nonatomic)IBOutlet UILabel *user_birthday;
@property (strong,nonatomic)IBOutlet UILabel *user_city;
@property (strong,nonatomic)IBOutlet UILabel *user_country;
@property (strong,nonatomic)IBOutlet UILabel *user_company;
@property (strong,nonatomic)IBOutlet UILabel *user_spouse;

@property (nonatomic, strong) IBOutlet UIImageView *profileImage;

@end
