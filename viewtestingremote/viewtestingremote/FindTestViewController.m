//
//  FindTestViewController.m
//  viewtestingremote
//
//  Created by App Development on 2/13/16.
//  Copyright © 2016 Cache me if you can. All rights reserved.
//

#import "FindTestViewController.h"

@interface FindTestViewController ()

@end

@implementation FindTestViewController

@synthesize testButton;
@synthesize continueTestButton;
@synthesize pulser;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [continueTestButton setEnabled:NO];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.appDelegate.sessionController setupPeerWithDisplayName:[UIDevice currentDevice].name];
    [self.appDelegate.sessionController setupSession];
    [self.appDelegate.sessionController setupBrowser];
    [self.appDelegate.sessionController startBrowsing];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerChangedStateWithNotification:)
                                                 name:@"didChangeStateNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFoundPeerNotification:)
                                                 name:@"foundPeerNotification"
                                               object:nil];
    //Animation loading for the pulsing radar
    NSArray * imageArray  = [[NSArray alloc] initWithObjects:
                             [UIImage imageNamed:@"pulse-1.png"],
                             [UIImage imageNamed:@"pulse-2.png"],
                             [UIImage imageNamed:@"pulse-3.png"],
                             nil];
    pulser.animationImages = imageArray;
    pulser.animationDuration = 1.0;

}

- (void)didFoundPeerNotification:(NSNotification *) notification {
    if ([self.appDelegate.sessionController.foundPeersArray count] > 0) {
//        testButton.titleLabel.text = [[self.appDelegate.sessionController.foundPeersArray objectAtIndex:0] displayName];
        [pulser stopAnimating];
        [self showConfirmationAlert];
    } else {
        testButton.titleLabel.text = @"Test";
        [pulser stopAnimating];
    }
    
}

- (void)peerChangedStateWithNotification:(NSNotification *)notification {
    int state = [[[notification userInfo] objectForKey:@"state"] intValue];
    if (state != MCSessionStateConnecting) {
        [continueTestButton setEnabled:YES];
        NSString *allTests = [[NSString alloc]init];
        for (int i = 0; i < self.appDelegate.sessionController.session.connectedPeers.count; i++) {
            
            NSString *displayName = [[self.appDelegate.sessionController.session.connectedPeers objectAtIndex:i] displayName];
            allTests = [allTests stringByAppendingString:@"\n"];
            allTests = [allTests stringByAppendingString:displayName];
        }
        NSLog(@"%@", allTests);
    }
}

- (IBAction)exitTestAction:(id)sender {
    [self.appDelegate.sessionController stopBrowsing];
    [self.appDelegate.sessionController destroySession];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)joinTestAction:(id)sender {
    if ([self.appDelegate.sessionController.foundPeersArray count] > 0) {
        [self.appDelegate.sessionController sendInvitationToPeer:[self.appDelegate.sessionController.foundPeersArray objectAtIndex:0]];
    }
    [pulser startAnimating];
}
-(void)showConfirmationAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Device Pairing Successful"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"Continue"
                                          otherButtonTitles:nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked continue
    if (buttonIndex == 0) {
        //take them to start speaking with Alexa
        [self performSegueWithIdentifier:@"pairedSegue" sender:self];
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
