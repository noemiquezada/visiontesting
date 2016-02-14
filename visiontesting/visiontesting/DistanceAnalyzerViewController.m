//
//  DistanceAnalyzerViewController.m
//  visiontesting
//
//  Created by App Development on 2/13/16.
//  Copyright © 2016 Cache me if you can. All rights reserved.
//

#import "DistanceAnalyzerViewController.h"

@interface DistanceAnalyzerViewController ()

@end

@implementation DistanceAnalyzerViewController

@synthesize remoteLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    remoteLocation = [[CLLocation alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerChangedStateWithNotification:)
                                                 name:@"didChangeStateNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleReceivedDataWithNotification:)
                                                 name:@"didReceiveDataNotification"
                                               object:nil];
    
    [self requestLocation];
    
}

- (void)peerChangedStateWithNotification:(NSNotification *)notification {
    int state = [[[notification userInfo] objectForKey:@"state"] intValue];
    if (state != MCSessionStateConnecting) {
        NSString *allPlayers = [[NSString alloc]init];
        for (int i = 0; i < self.appDelegate.sessionController.session.connectedPeers.count; i++) {
            
            NSString *displayName = [[self.appDelegate.sessionController.session.connectedPeers objectAtIndex:i] displayName];
            allPlayers = [allPlayers stringByAppendingString:@"\n"];
            allPlayers = [allPlayers stringByAppendingString:displayName];
        }
        NSLog(@"Connected");
        NSLog(@"%@", allPlayers);
    }
}

-(void)requestLocation
{
    //Send Message to send GameBoard from Host
    NSLog(@"Give me a location");
    NSString *messageToSend = @"location";
    NSData *messageAsData = [messageToSend dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    
    [self.appDelegate.sessionController.session sendData:messageAsData
                                                        toPeers:self.appDelegate.sessionController.session.connectedPeers
                                                       withMode:MCSessionSendDataReliable
                                                          error:&error];
    
    // If any error occurs, just log it.
    // Otherwise set the following couple of flags to YES, indicating that the current player is the creator
    // of the game and a game is in progress.
    if (error != nil) {
        NSLog(@"error"); 
        NSLog(@"%@", [error localizedDescription]);
        
    } else{
        
    }
}

- (void)handleReceivedDataWithNotification:(NSNotification *)notification {
    // Get the user info dictionary that was received along with the notification.
    NSDictionary *userInfoDict = [notification userInfo];
    NSLog(@"Data was returned back");
    // Convert the received data into a NSString object.
    NSData *receivedData = [userInfoDict objectForKey:@"data"];
    NSString *message = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", message);
    NSArray *items = [message componentsSeparatedByString:@","];
    NSString *longitude = items[0];
    NSString *latitude = items[1];
    self.remoteLocation = [[CLLocation alloc]initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
    //Calculate the distance
    CLLocationDistance distanceInMeters = [self.appDelegate.locationController calculateDistanceWithMyLocation:self.appDelegate.locationController.currentLocation remoteLocation:self.remoteLocation];
    
    if (distanceInMeters < 3.048) {
        //If not 10 feet
        [self requestLocation];
        NSLog(@"Not far enough keep going");
    } else {
        NSLog(@"Yay you can stop now");
        NSLog(@"Ready to start?"); 
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
