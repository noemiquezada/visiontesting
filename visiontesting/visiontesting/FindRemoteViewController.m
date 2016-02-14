//
//  FindRemoteViewController.m
//  visiontesting
//
//  Created by App Development on 2/13/16.
//  Copyright © 2016 Cache me if you can. All rights reserved.
//

#import "FindRemoteViewController.h"
#import "LocationController.h"

@interface FindRemoteViewController ()

@end

@implementation FindRemoteViewController
@synthesize pulser;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.appDelegate.sessionController setupPeerWithDisplayName:[UIDevice currentDevice].name];
    [self.appDelegate.sessionController setupSession];
    [self.appDelegate.sessionController setupAdvertising];
    [self.appDelegate.sessionController.serviceAdvertiser startAdvertisingPeer];
   //[self.appDelegate.sessionController advertiseSelf:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerChangedStateWithNotification:)
                                                 name:@"didChangeStateNotification"
                                               object:nil];

    
    //Animation loading for the pulsing radar
    NSArray * imageArray  = [[NSArray alloc] initWithObjects:
                             [UIImage imageNamed:@"pulse-1.png"],
                             [UIImage imageNamed:@"pulse-2.png"],
                             [UIImage imageNamed:@"pulse-3.png"],
                             [UIImage imageNamed:@"pulse-4.png"],
                             nil];
    pulser.animationImages = imageArray;
    pulser.animationDuration = 1.0;
    
    [pulser startAnimating];
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
        [self.appDelegate.sessionController stopAdvertising];
        [self performSegueWithIdentifier:@"continueToDistanceAnalyzer" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitTestAction:(id)sender {
    [self.appDelegate.sessionController.serviceAdvertiser stopAdvertisingPeer];
    //[self.appDelegate.sessionController advertiseSelf:NO];
    [self.appDelegate.sessionController destroySession];
    [self dismissViewControllerAnimated:YES completion:nil];
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
