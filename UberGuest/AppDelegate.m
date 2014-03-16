
//
//  AppDelegate.m
//  ÜberGuest
//
//  Created by Safyan Mughal on 12/16/13.
//  Copyright (c) 2013 Safyan Mughal. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

#import "UserInfo.h"
#import "Constants.h"
#import "URLBuilder.h"
#import "GenericFetcher.h"
#import "UserProfileViewController.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#define kLastLocationUpdateTimestamp @"locationUpdateTimeStamp"

@implementation AppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // For the time being use this longitude and latitude, later it will be got from the server
//    self.hotelLatitude = 31.513195;
//    self.hotelLongitude = 74.350652;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:loginVC];
    
    // Location Update
    [self.mapView setDelegate:self];
    [self locationUpdate];
    
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self.locationManager startMonitoringSignificantLocationChanges];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.locationManager stopMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Helper Methods

-(void) locationUpdate {
    
    self.locationManager = [[CLLocationManager alloc] init];
    CLLocation *newLocation = [self.locations lastObject];
    
    self.locationManager.delegate = self;
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager startUpdatingLocation];
    
    NSDate *newLocationTimestamp = newLocation.timestamp;
    NSDate *lastLocationUpdateTiemstamp;
    
    int locationUpdateInterval = 10000;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (userDefaults) {
        
        lastLocationUpdateTiemstamp = [userDefaults objectForKey:kLastLocationUpdateTimestamp];
        
        if (!([newLocationTimestamp timeIntervalSinceDate:lastLocationUpdateTiemstamp] < locationUpdateInterval)) {
            //NSLog(@"New Location: %@", newLocation);
            //            [(AppDelegate*)[UIApplication sharedApplication].delegate didUpdateToLocation:newLocation];
            [userDefaults setObject:newLocationTimestamp forKey:kLastLocationUpdateTimestamp];
        }
    }
}

-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationMaskPortrait);
    
    // Use this to allow upside down as well
    //return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    BOOL isInBackground = NO;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground)
    {
        isInBackground = YES;
    }
    
    // Handle location updates as normal, code omitted for brevity.
    // The omitted code should determine whether to reject the location update for being too
    // old, too close to the previous one, too inaccurate and so forth according to your own
    // application design.
    
    if (isInBackground)
    {
        [self sendBackgroundLocationToServer:newLocation];
    }
    else
    {
        // ...
    }
    
    CLLocationCoordinate2D currentCoordinates = newLocation.coordinate;
    
    NSLog(@"Location Has been found");
    
    NSLog(@"Entered new Location with the coordinates Latitude: %f Longitude: %f", currentCoordinates.latitude, currentCoordinates.longitude);
}

-(void) sendBackgroundLocationToServer:(CLLocation *)location
{
    // REMEMBER. We are running in the background if this is being executed.
    // We can't assume normal network access.
    // bgTask is defined as an instance variable of type UIBackgroundTaskIdentifier
    
    // Note that the expiration handler block simply ends the task. It is important that we always
    // end tasks that we have started.
    
    self.bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:
                   ^{
                       [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
                   }];
    
    // ANY CODE WE PUT HERE IS OUR BACKGROUND TASK
    
    // For example, I can do a series of SYNCHRONOUS network methods (we're in the background, there is
    // no UI to block so synchronous is the correct approach here).
    
//    float latitudeMe = location.coordinate.latitude;
//    float longitudeMe = location.coordinate.longitude;
    
    // ...
    
    // AFTER ALL THE UPDATES, close the task
    
    if (self.bgTask != UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
        self.bgTask = UIBackgroundTaskInvalid;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Unable to start location manager. Error:%@", [error description]);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if ([[UserInfo instance] isLogin]) {
        
        [self setPropertyAndSuperKey];
        CLLocation *guestLastLocation = [locations lastObject];
        
        // Temp Lat/Long of guest
        CLLocation *tempLoc = [[CLLocation alloc] initWithLatitude:31.515 longitude:74.35];
        
        // Lat/Lon
        float latitudeMe = guestLastLocation.coordinate.latitude;
        float longitudeMe = guestLastLocation.coordinate.longitude;
        
        CLLocation *hotelLocation = [[CLLocation alloc] initWithLatitude:self.hotelLatitude longitude:self.hotelLongitude];
        CLLocationDistance distance = [hotelLocation distanceFromLocation:guestLastLocation];
        
        NSLog(@"Entered new Location with the coordinates Latitude: %f Longitude: %f", latitudeMe, longitudeMe);
        NSLog(@"Distance between hotle and guest: %f", distance);
        
        NSLog(@"Calculated Miles %@", [NSString stringWithFormat:@"%.1fmi",(distance/UNITMETER)]);
        // Condition on the basis of to call the update location method
        float newDistance = (float)distance/UNITMETER;
        //    NSLog(@"New Distance = %f", newDistance);
        if (self.superKey == 1) {
            // if guest is super user then apply these conditions
            if (newDistance > 16093.0) {
                // if guest location distance > 10 Miles then update guest's location after each 15 min
                [self setTimerToStopOrStartUpadating:900];
            }
            else if (newDistance > 24140.0) {
                // if guest location distance > 5 Miles then update guest's location after each 1 min
                [self setTimerToStopOrStartUpadating:60];
            }
            else if (newDistance < 2414.0) {
                // if guest location distance < 5 Miles then update guest's location after each 30 sec
                [self setTimerToStopOrStartUpadating:30];
            }
            else if (newDistance < 1609.0) {
                // if guest location distance < 1 Miles then update guest's location after each 10 sec
                [self setTimerToStopOrStartUpadating:10];
            }
            else {
                [self setTimerToStopOrStartUpadating:1800];
            }
        }else {
            // if guest is regular user then apply these conditions
            if (newDistance > 16093.0) {
                // if guest location distance > 10 Miles then update guest's location after each 15 min
                [self setTimerToStopOrStartUpadating:900];
            }
            else if (newDistance > 24140.0) {
                // if guest location distance > 5 Miles then update guest's location after each 1 min
                [self setTimerToStopOrStartUpadating:60];
            }
            else if (newDistance < 4828.0) {
                // if guest location distance < 3 Miles then update guest's location after each 30 sec
                [self setTimerToStopOrStartUpadating:30];
            }
            else if (newDistance < 1609.0) {
                // if guest location distance < 1 Miles then update guest's location after each 10 sec
                [self setTimerToStopOrStartUpadating:15];
            }
            else {
                [self setTimerToStopOrStartUpadating:1800];
            }
        }
        
        // Send Location to server
        [self sendLocationToServer:latitudeMe longitude:longitudeMe];
    }else {
        [self.locationManager stopMonitoringSignificantLocationChanges];
        [self.locationManager stopUpdatingLocation];
    }
}

-(void) sendLocationToServer:(double) latitude longitude:(double)longitude {

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[[UserInfo instance] apiKey] forKey:kapi_key];
    [params setValue:[NSNumber numberWithDouble:longitude] forKey:kLongitude];
    [params setValue:[NSNumber numberWithDouble:latitude] forKey:kLatitude];
    
    GenericFetcher *fetcher = [GenericFetcher new];
    [fetcher fetchWithUrl:[URLBuilder urlForMethod:@"/guest_update_location?" withParameters:params] withMethod:GET_REQUEST withParams:nil completionBlock:^(NSDictionary *dict1) {
        int status = [[dict1 valueForKey:@"status"] integerValue];
        NSLog(@"Status = %d", status);
        //        if (status == 1) {
        //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"You have successfully uploaded location." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //            [alert show];
        //        }
    } errorBlock:^(NSError *error) {
        NSLog(@"Error");
    }];
}

#pragma mark - Helper Methods

-(void) setTimerToStopOrStartUpadating:(NSTimeInterval) timeInterval {
    
    [self.locationManager stopUpdatingLocation];
    [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self.locationManager selector:@selector(startUpdatingLocation) userInfo:nil repeats:YES];
}

-(void) setPropertyAndSuperKey {
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSLog(@"Property Id = %d", [[UserInfo instance] propertyId]);
    [param setValue:[NSNumber numberWithInt:[[UserInfo instance] propertyId]] forKey:kPropertyId];
    
    GenericFetcher *fetcher = [[GenericFetcher alloc] init];
    [fetcher fetchWithUrl:[URLBuilder urlForMethod:@"/property_lat_long?" withParameters:param] withMethod:GET_REQUEST withParams:nil completionBlock:^(NSDictionary *dict) {
        int status = [[dict valueForKey:@"status"] integerValue];
        NSLog(@"Status = %d", status);
        if (status == 1) {
            NSDictionary *userDict = [dict valueForKey:@"lat_long"];
            
//            [[UserInfo instance] setLatitude:[[userDict valueForKey:kLatitude] doubleValue]];
//            [[UserInfo instance] setLongitude:[[userDict valueForKey:kLongitude] doubleValue]];
//            [[UserInfo instance] saveUserInfo];
            
            self.superKey = [[UserInfo instance] superUser];
            self.propertyId = [[userDict valueForKey:kPropertyId] intValue];
            self.hotelLatitude = [[userDict valueForKey:kLatitude] doubleValue];
            self.hotelLongitude = [[userDict valueForKey:kLongitude] doubleValue];
            
            NSLog(@"Status = %d", status);
            NSLog(@"%@", [userDict valueForKey:@"latitude"]);
            NSLog(@"%@", [userDict valueForKey:@"longitude"]);
            NSLog(@"%@", [userDict valueForKey:@"property_id"]);
//
            NSLog(@"Staus = 1 | Latitude = %f, Longitude = %f", self.hotelLatitude, self.hotelLongitude);
            return;
        }
        else {
            NSLog(@"Property Id - Status = %d", status);
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"Error");
    }];
}

@end