//
//  LocationController.m
//  visiontesting
//
//  Created by App Development on 2/13/16.
//  Copyright © 2016 Cache me if you can. All rights reserved.
//

#import "LocationController.h"

static LocationController *_sharedLocationController;

@implementation LocationController

@synthesize locationManager;
@synthesize currentLocation;

+(LocationController *)sharedLocationController {
    return _sharedLocationController;
}

+(void)initialize {
    if ([LocationController class] == self)
    {
        _sharedLocationController = [self new];
    }
}

+(id)allocWithZone:(struct _NSZone *)zone {
    if (_sharedLocationController && [LocationController class] == self)
    {
        [NSException raise:NSGenericException format:@"May not create more than one instance of a singleton class!"];
    }
    return [super allocWithZone:zone];
}

- (CLBeaconRegion *)beaconRegionWithItem:(RWTItem *)item {
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:item.uuid
                                                                           major:item.majorValue
                                                                           minor:item.minorValue
                                                                      identifier:item.name];
    return beaconRegion;
}

- (void)startMonitoringItem:(RWTItem *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
}

- (void)stopMonitoringItem:(RWTItem *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    [self.locationManager stopMonitoringForRegion:beaconRegion];
    [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
}

- (void)startLocationServices {
    NSLog(@"Starting Location Services"); 
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation]; 
    
//    if ([CLLocationManager locationServicesEnabled]) {
//        NSLog(@"I am enabled");
//        [locationManager startUpdatingLocation];
//    } else {
//        NSLog(@"Location services is not enabled");
//    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"I am here");
    CLLocation* loc = [locations lastObject]; // locations is guaranteed to have at least one object
    float latitude = loc.coordinate.latitude;
    float longitude = loc.coordinate.longitude;
    NSLog(@"%.8f",latitude);
    NSLog(@"%.8f",longitude);
    self.currentLocation = loc;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [locationManager stopUpdatingLocation];
    NSLog(@"Update failed with error: %@", error);
}
@end
