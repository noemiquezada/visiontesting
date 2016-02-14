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
        _skTransaction = [_skSession speakString:@"To record your answer, hold down the button"
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
