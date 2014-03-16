

#import "UserInfo.h"



static UserInfo *singletonInstance;
@implementation UserInfo

-(void) copyObject :(UserInfo *) objToCopy{
	//Main
    singletonInstance.firstName = objToCopy.firstName;
    singletonInstance.lastName  = objToCopy.lastName;
    singletonInstance.password = objToCopy.password;
    singletonInstance.emailAddress = objToCopy.emailAddress;
    singletonInstance.apiKey = objToCopy.apiKey;
    singletonInstance.isLogin = objToCopy.isLogin;
    singletonInstance.gender=objToCopy.gender;
    singletonInstance.campusID = objToCopy.campusID;
    singletonInstance.imageUrl = objToCopy.imageUrl;
    singletonInstance.schoolName = objToCopy.schoolName;
    singletonInstance.campusName = objToCopy.campusName;
    
    //
    singletonInstance.birthdays = objToCopy.birthdays;
    singletonInstance.spouses = objToCopy.spouses;
    singletonInstance.citys = objToCopy.citys;
    singletonInstance.countrys = objToCopy.countrys;
    singletonInstance.companys = objToCopy.companys;
    singletonInstance.titles = objToCopy.titles;
    singletonInstance.likes = objToCopy.likes;
    singletonInstance.dislikes = objToCopy.dislikes;
    singletonInstance.cellNumber = objToCopy.cellNumber;
    singletonInstance.specialInterest = objToCopy.specialInterest;
    singletonInstance.profileimageLink = objToCopy.profileimageLink;
    singletonInstance.profileimageLink1 = objToCopy.profileimageLink1;
    singletonInstance.userVoiceLink = objToCopy.userVoiceLink;
    singletonInstance.longitude = objToCopy.longitude;
    singletonInstance.latitude = objToCopy.latitude;
    singletonInstance.superUser = objToCopy.superUser;
    singletonInstance.propertyId = objToCopy.propertyId;
}



#pragma mark - Custom Methods

-(void) loadUserInfo{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey:kUserInfo];
	[defaults synchronize];
    UserInfo *obj = (UserInfo *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
	if (obj) {
		[self copyObject:obj];
	}
}

-(void)saveUserInfo{
	NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:singletonInstance];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myEncodedObject forKey:kUserInfo];
    [defaults synchronize];
}

-(NSString*) nullCheck :(NSString *)str{if (str) {return str;}return @"";}


#pragma mark - Encode Decoder
- (void)encodeWithCoder:(NSCoder *)encoder{
	//Main
    [encoder encodeObject:[self firstName] forKey:kfirst_name];
    [encoder encodeObject:[self lastName] forKey:klast_name];
    [encoder encodeObject:[self password] forKey:kpassword];
    [encoder encodeObject:[self emailAddress] forKey:kemail_id];
    [encoder encodeObject:[self apiKey] forKey:kapi_key];
    [encoder encodeBool:[self isLogin] forKey:kislogin];

    
    //...........
    [encoder encodeObject:[self birthdays] forKey:kbirthday];
    [encoder encodeObject:[self spouses] forKey:kspouse];
    [encoder encodeObject:[self citys] forKey:kcity];
    [encoder encodeObject:[self countrys] forKey:kcountry];
    [encoder encodeObject:[self companys] forKey:kcompany];
    [encoder encodeObject:[self titles] forKey:ktitle];
    [encoder encodeObject:[self likes] forKey:klikes];
    [encoder encodeObject:[self dislikes] forKey:kdislikes];
    [encoder encodeObject:[self cellNumber] forKey:kCellNumber];
    [encoder encodeObject:[self specialInterest] forKey:kSpecialInterest];
    [encoder encodeObject:[self profileimageLink] forKey:Kprofile_image];
    [encoder encodeObject:[self profileimageLink1] forKey:Kprofile_image1];
    [encoder encodeObject:[self userVoiceLink] forKey:kvoice];
    
    [encoder encodeDouble:[self longitude] forKey:kLongitude];
    [encoder encodeDouble:[self latitude] forKey:kLatitude];
    [encoder encodeInt:[self propertyId] forKey:kPropertyId];
    [encoder encodeInt:[self superUser] forKey:kSuperUSer];
}

- (id)initWithCoder:(NSCoder *)decoder{
	if((self = [super init])) {
        self.firstName = [decoder decodeObjectForKey:kfirst_name];
        self.lastName = [decoder decodeObjectForKey:klast_name];
        self.password = [decoder decodeObjectForKey:kpassword];
        self.emailAddress = [decoder decodeObjectForKey:kemail_id];
        self.apiKey = [decoder decodeObjectForKey:kapi_key];
        self.profileimageLink = [decoder decodeObjectForKey:Kprofile_image];
        self.profileimageLink1 = [decoder decodeObjectForKey:Kprofile_image1];
        self.isLogin =[decoder decodeBoolForKey:kislogin];
    
        //...........
        self.birthdays = [decoder decodeObjectForKey:kbirthday];
        self.spouses = [decoder decodeObjectForKey:kspouse];
        self.citys = [decoder decodeObjectForKey:kcity];
        self.countrys = [decoder decodeObjectForKey:kcountry];
        self.companys = [decoder decodeObjectForKey:kcompany];
        self.titles = [decoder decodeObjectForKey:ktitle];
        self.likes = [decoder decodeObjectForKey:klikes];
        self.dislikes = [decoder decodeObjectForKey:kdislikes];
        self.cellNumber = [decoder decodeObjectForKey:kCellNumber];
        self.specialInterest = [decoder decodeObjectForKey:kSpecialInterest];
        self.userVoiceLink = [decoder decodeObjectForKey:kvoice];
        
        self.longitude = [decoder decodeDoubleForKey:kLongitude];
        self.latitude = [decoder decodeDoubleForKey:kLatitude];
        
        self.superUser = [decoder decodeIntForKey:kSuperUSer];
        self.propertyId = [decoder decodeIntForKey:kPropertyId];
    }
	return self;
}

-(void) setUserWithInfo:(NSDictionary *)userDict{
    self.firstName = [userDict valueForKey:kfirst_name];
    self.lastName = [userDict valueForKey:klast_name];
    self.emailAddress = [userDict valueForKey:kemail_id];
    self.password = [userDict valueForKey:kpassword];
    self.birthdays = [userDict valueForKey:kbirthday];
    self.spouses = [userDict valueForKey:kspouse];
    self.citys = [userDict valueForKey:kcity];
    self.countrys = [userDict valueForKey:kcountry];
    self.companys = [userDict valueForKey:kcompany];
    self.titles = [userDict valueForKey:ktitle];
    self.likes = [userDict valueForKey:klikes];
    self.dislikes = [userDict valueForKey:kdislikes];
    self.cellNumber = [userDict valueForKey:kCellNumber];
    self.specialInterest = [userDict valueForKey:kSpecialInterest];
    self.isLogin = [[userDict valueForKey:kislogin] boolValue];
    
    self.apiKey = [userDict valueForKey:kapi_key];
    self.profileimageLink = [userDict valueForKey:Kprofile_image];
    self.profileimageLink1 = [userDict valueForKey:Kprofile_image1];
    self.userVoiceLink = [userDict valueForKey:kvoice];
    
    self.longitude = [[userDict valueForKey:kLongitude] doubleValue];
    self.latitude = [[userDict valueForKey:kLatitude] doubleValue];
    
    self.superUser = [[userDict valueForKey:kSuperUSer] intValue];
    self.propertyId = [[userDict valueForKey:kPropertyId] intValue];
    
    self.isLogin = YES;
//    self.male
}


-(void) removeUserInfo{
    self.firstName=nil;
    self.lastName=nil;
  //  self.emailAddress = nil;
    self.password = nil;
    self.birthdays =nil;
    self.spouses =nil;
    self.citys = nil;
    self.countrys = nil;
    self.companys = nil;
    self.titles = nil;
    self.likes = nil;
    self.dislikes = nil;
    self.cellNumber = nil;
    self.specialInterest = nil;
   
    self.apiKey = nil;
    self.isLogin = NO;
    self.profileimageLink = nil;
    self.profileimageLink1 = nil;
    self.userVoiceLink=nil;
    self.longitude = 0.0;
    self.latitude = 0.0;
    self.superUser = 0;
    self.propertyId = 0;
}

#pragma mark - init
- (id) init {
    if (self = [super init]) {
	}
    self.isLogin= NO;
    return self;
}

#pragma mark - Shared Instance

+ (UserInfo*)instance{
    if(!singletonInstance)
	{
		singletonInstance=[[UserInfo alloc]init];
		[singletonInstance loadUserInfo];
	}
    return singletonInstance;
}
@end
