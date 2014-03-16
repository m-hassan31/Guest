//
//  AppDelegate.h
//  ÜberGuest
//
//  Created by Safyan Mughal on 12/16/13.
//  Copyright (c) 2013 Safyan Mughal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

{
    UIWindow *window;
    
    
}
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSTimer *timer;

// Location
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locations;

@property (nonatomic) UIBackgroundTaskIdentifier bgTask;
@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic) double hotelLatitude;
@property (nonatomic) double hotelLongitude;

@property (nonatomic, assign) int superKey;
@property (nonatomic, assign) int propertyId;

-(void) locationUpdate;

@end