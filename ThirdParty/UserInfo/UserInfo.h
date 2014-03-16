
#import "AbstractObject.h"

#define KStaticImageURL     @"http://www.uberguest.com/uberguest_dev/upload_image/no-image.jpg"

#define kUserInfo           @"userinfo"
#define kfirst_name         @"first_name"
#define klast_name          @"last_name"
#define kemail_id           @"email_id"

#define kpassword           @"password"
#define kbirthday           @"birthday"
#define kspouse             @"spouse"
#define kcity               @"city"
#define kcountry            @"country"
#define kcompany            @"company"
#define ktitle              @"title"
#define klikes              @"likes"
#define kdislikes           @"dislikes"
#define kCellNumber         @"cell_number"
#define kSpecialInterest    @"special_instructions"

#define kapi_key            @"api_key"
#define Kprofile_image      @"profile_image"
#define Kprofile_image1     @"picture"
#define kislogin            @"islogin"
#define kImageUrl           @"imageUrl"
#define kImage              @"image"
#define kvoice              @"voice"

#define kLatitude           @"latitude"
#define kLongitude          @"longitude"
#define kSuperUSer          @"super_user"
#define kPropertyId         @"property_id"

@interface UserInfo : AbstractObject
@property (nonatomic,retain) NSString *firstName;
@property (nonatomic,retain) NSString *lastName;
@property (nonatomic,retain) NSString *emailAddress;
@property (nonatomic,retain) NSString *password;


@property (nonatomic,retain)  NSString *apiKey;
@property (nonatomic, retain) NSString *campusID;
@property (nonatomic,retain)  NSString *schoolName;
@property (nonatomic,retain)  NSString *campusName;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *gender;

@property (nonatomic, retain) NSString *birthdays;
@property (nonatomic, retain) NSString *spouses;
@property (nonatomic, retain) NSString *citys;
@property (nonatomic, retain) NSString *countrys;
@property (nonatomic, retain) NSString *companys;
@property (nonatomic, retain) NSString *titles;
@property (nonatomic, retain) NSString *likes;
@property (nonatomic, retain) NSString *dislikes;

@property (nonatomic, retain) NSString *cellNumber;
@property (nonatomic, retain) NSString *specialInterest;

@property (nonatomic,retain) NSString *profileimageLink;
@property (nonatomic,retain) NSString *profileimageLink1;
@property (nonatomic,retain) NSString *userVoiceLink;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property (nonatomic, assign) int propertyId;
@property (nonatomic, assign) int superUser;

//@property (nonatomic, strong) NSString *latitude;
//@property (nonatomic, strong) NSString *longitude;
//
//@property (nonatomic, strong) NSString *propertyId;
//@property (nonatomic, strong) NSString *superUser;

@property BOOL isLogin;
+ (UserInfo*)instance;

-(void) loadUserInfo;
-(void) saveUserInfo;
-(void) removeUserInfo;

@end
