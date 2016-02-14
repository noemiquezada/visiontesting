//
//  VoiceViewController.m
//  viewtestingremote
//
//  Created by Maira Ahmad on 2/13/16.
//  Copyright © 2016 Cache me if you can. All rights reserved.
//

#import "VoiceViewController.h"

@interface VoiceViewController ()

@end

@implementation VoiceViewController
@synthesize microphoneButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleReceivedDataWithNotification:)
                                                 name:@"didReceiveDataNotification"
                                               object:nil];
}

- (void)handleReceivedDataWithNotification:(NSNotification *)notification {
    // Get the user info dictionary that was received along with the notification.
    NSLog(@"Received a notification");
    NSDictionary *userInfoDict = [notification userInfo];
    
    // Convert the received data into a NSString object.
    NSData *receivedData = [userInfoDict objectForKey:@"data"];
    NSString *message = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    MCPeerID *senderPeerId = [userInfoDict objectForKey:@"peerID"];
    if ([message isEqualToString:@"location"])
    {
        //Get current location
        CLLocation * remoteLocation = [self.appDelegate.locationController currentLocation];
        NSString * locationDataString = [NSString stringWithFormat:@"%f,%f", remoteLocation.coordinate.latitude, remoteLocation.coordinate.longitude];
        //Send Location
        NSData * locationData = [locationDataString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        [self.appDelegate.sessionController.session sendData:locationData toPeers:[NSArray arrayWithObject:senderPeerId] withMode:MCSessionSendDataReliable error:&error];
        
        //If any error occurs just log its description.
        if (error != nil)
        {
            NSLog(@"%@", [error localizedDescription]);
        }
        NSLog(@"I sent a location");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)speakNow:(id)sender{
    NSLog(@"the user should speak now");
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
