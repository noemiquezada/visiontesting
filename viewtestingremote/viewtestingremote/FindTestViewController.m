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
//    pulser.contentMode = UIViewContentModeCenter;
//    pulser.contentMode = UIViewContentModeScaleAspectFit;
//    [self.view addSubview:pulser];
       [self.pulser startAnimating];
    

    
}

-(void)viewWillAppear:(BOOL)animated {
    _skTransaction = nil;
    self.languageCode = @"eng-USA";
    
    _skSession = [[SKSession alloc] initWithURL:[NSURL URLWithString:SKSServerUrl] appToken:SKSAppKey];
    
    if (!_skSession) {
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"SpeechKit"
                                                           message:@"Failed to initialize SpeechKit session."
                                                          delegate:nil cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil, nil];
        [alertView show];
    }
    if (!_skTransaction) {
        NSLog(@"In skTranslaction initialization");
        // Start a TTS transaction
        _skTransaction = [_skSession speakString:@"Actively searching for Hubspot"
                                    withLanguage:self.languageCode
                                        delegate:self];
        
    } else {
        // Cancel the TTS transaction
        [_skTransaction cancel];
        
        [self resetTransaction];
    }
    [self performSelector:@selector(viewDidLoad) withObject:nil afterDelay:3.0];
}

-(void) createTransaction: (NSString *)s {
    if (!_skTransaction) {
        NSLog(@"In skTranslaction initialization");
        // Start a TTS transaction
        _skTransaction = [_skSession speakString:s
                                    withLanguage:self.languageCode
                                        delegate:self];
        
    } else {
        // Cancel the TTS transaction
        [_skTransaction cancel];
        
        [self resetTransaction];
    }
}


    - (void)resetTransaction
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            _skTransaction = nil;
        }];
    }

- (void)didFoundPeerNotification:(NSNotification *) notification {
    NSLog(@"notification: %@", notification);
    if ([self.appDelegate.sessionController.foundPeersArray count] > 0) {
        testButton.titleLabel.text = [[self.appDelegate.sessionController.foundPeersArray objectAtIndex:0] displayName];
        [self.appDelegate.sessionController sendInvitationToPeer:[[notification userInfo] objectForKey:@"peerID"]];
        testButton.titleLabel.text = @"Ipad";
        
//        testButton.titleLabel.text = [[self.appDelegate.sessionController.foundPeersArray objectAtIndex:0] displayName];
        [pulser stopAnimating];
        [self showConfirmationAlert];
        [self.appDelegate.sessionController stopBrowsing];
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
        [self.appDelegate.sessionController stopBrowsing];
    } 
}

- (IBAction)exitTestAction:(id)sender {
    [self.appDelegate.sessionController stopBrowsing];
    [self.appDelegate.sessionController destroySession];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)joinTestAction:(id)sender {

 
}


- (IBAction)continueTestAction:(id)sender {
  //  [self performSegueWithIdentifier:@"continueGame" sender:self];
    if ([self.appDelegate.sessionController.foundPeersArray count] > 0) {
        [self.appDelegate.sessionController sendInvitationToPeer:[self.appDelegate.sessionController.foundPeersArray objectAtIndex:0]];
    }
    [pulser startAnimating];
}
-(void)showConfirmationAlert{
    [self createTransaction:@"Device Pairing Successful"];
    if([self.appDelegate.sessionController.foundPeersArray count] == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Device Pairing Successful"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"Continue"
                                              otherButtonTitles:nil];
        [alert show];
    }

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
#pragma mark - SKTransactionDelegate

- (void)transaction:(SKTransaction *)transaction didReceiveAudio:(SKAudio *)audio
{
    NSLog(@"didReceiveAudio");
    
    [self resetTransaction];
}

- (void)transaction:(SKTransaction *)transaction didFinishWithSuggestion:(NSString *)suggestion
{
    NSLog(@"didFinishWithSuggestion");
    
    // Notification of a successful transaction. Nothing to do here.
}

- (void)transaction:(SKTransaction *)transaction didFailWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    NSLog(@"%@", [NSString stringWithFormat:@"didFailWithError: %@. %@", [error description], suggestion]);
    
    // Something went wrong. Check Configuration.mm to ensure that your settings are correct.
    // The user could also be offline, so be sure to handle this case appropriately.
    
    [self resetTransaction];
}

#pragma mark - SKAudioPlayerDelegate

- (void)audioPlayer:(SKAudioPlayer *)player willBeginPlaying:(SKAudio *)audio
{
    NSLog(@"willBeginPlaying");
    
    // The TTS Audio will begin playing.
}

- (void)audioPlayer:(SKAudioPlayer *)player didFinishPlaying:(SKAudio *)audio
{
    NSLog(@"didFinishPlaying");
    
    // The TTS Audio has finished playing.
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
