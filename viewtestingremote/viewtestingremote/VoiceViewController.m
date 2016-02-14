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

-(void)sendAnswerWithResponse: (NSString *) response
{
    //Send Message to send Ipad
    NSString *messageToSend = [NSString stringWithFormat:@"%@", response];
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

-(void)viewWillAppear:(BOOL)animated {
    
    _recognitionType = SKTransactionSpeechTypeDictation;
    _endpointer = SKTransactionEndOfSpeechDetectionShort;
    _language = @"eng-USA";
    
    _state = SKSIdle;

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
    
    //[self loadEarcons];
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

- (void)recognize
{
    // Start listening to the user.
    //[_toggleRecogButton setTitle:@"Stop" forState:UIControlStateNormal];
    
    _skTransaction = [_skSession recognizeWithType:self.recognitionType
                                         detection:self.endpointer
                                          language:self.language
                                          delegate:self];
}

- (void)stopRecording
{
    // Stop recording the user.
    [_skTransaction stopRecording];
    // Disable the button until we received notification that the transaction is completed.

}

- (void)cancel
{
    // Cancel the Reco transaction.
    // This will only cancel if we have not received a response from the server yet.
    [_skTransaction cancel];
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
    [self recognize];
}


#pragma mark - SKTransactionDelegate

- (void)transaction:(SKTransaction *)transaction didReceiveAudio:(SKAudio *)audio
{
    NSLog(@"didReceiveAudio");
    
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

- (void)loadEarcons
{
    // Load all of the earcons from disk
    
    NSString* startEarconPath = [[NSBundle mainBundle] pathForResource:@"sk_start" ofType:@"pcm"];
    NSString* stopEarconPath = [[NSBundle mainBundle] pathForResource:@"sk_stop" ofType:@"pcm"];
    NSString* errorEarconPath = [[NSBundle mainBundle] pathForResource:@"sk_error" ofType:@"pcm"];
    
    SKPCMFormat* audioFormat = [[SKPCMFormat alloc] init];
    audioFormat.sampleFormat = SKPCMSampleFormatSignedLinear16;
    audioFormat.sampleRate = 16000;
    audioFormat.channels = 1;
    
    // Attach them to the session
    
    _skSession.startEarcon = [[SKAudioFile alloc] initWithURL:[NSURL fileURLWithPath:startEarconPath] pcmFormat:audioFormat];
    _skSession.endEarcon = [[SKAudioFile alloc] initWithURL:[NSURL fileURLWithPath:stopEarconPath] pcmFormat:audioFormat];
    _skSession.errorEarcon = [[SKAudioFile alloc] initWithURL:[NSURL fileURLWithPath:errorEarconPath] pcmFormat:audioFormat];
}

# pragma mark - SKTransactionDelegate

- (void)transactionDidBeginRecording:(SKTransaction *)transaction
{
     NSLog(@"%@", @"transactionDidBeginRecording");
    
    _state = SKSListening;
    [self startPollingVolume];
    //[_toggleRecogButton setTitle:@"Listening.." forState:UIControlStateNormal];
}

- (void)transactionDidFinishRecording:(SKTransaction *)transaction
{
    NSLog(@"transactionDidFinishRecording");
    
    _state = SKSProcessing;
    [self stopPollingVolume];
    //[_toggleRecogButton setTitle:@"Processing.." forState:UIControlStateNormal];
}

- (void)transaction:(SKTransaction *)transaction didReceiveRecognition:(SKRecognition *)recognition
{
    NSLog(@"%@", [NSString stringWithFormat:@"didReceiveRecognition: %@", recognition.text]);
    [self sendAnswerWithResponse:[NSString stringWithFormat:@"%@", recognition.text]];
    
    _state = SKSIdle;
}

- (void)transaction:(SKTransaction *)transaction didReceiveServiceResponse:(NSDictionary *)response
{
    NSLog(@"%@", [NSString stringWithFormat:@"didReceiveServiceResponse: %@", response]);
    
}

- (void)transaction:(SKTransaction *)transaction didFinishWithSuggestion:(NSString *)suggestion
{
     NSLog(@"%@", @"didFinishWithSuggestion");
    
    _state = SKSIdle;
    [self resetTransaction];
}

- (void)transaction:(SKTransaction *)transaction didFailWithError:(NSError *)error suggestion:(NSString *)suggestion
{
     NSLog(@"%@", [NSString stringWithFormat:@"didFailWithError: %@. %@", [error description], suggestion]);
    
    _state = SKSIdle;
    [self resetTransaction];
}


# pragma mark - Volume level

- (void)startPollingVolume
{
    // Every 50 milliseconds we should update the volume meter in our UI.
    _volumePollTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                        target:self
                                                      selector:@selector(pollVolume)
                                                      userInfo:nil repeats:YES];
}

- (void) pollVolume
{
    float volumeLevel = [_skTransaction audioLevel];
    //[self.volumeLevelProgressView setProgress:volumeLevel/100.0];
}

- (void) stopPollingVolume
{
    [_volumePollTimer invalidate];
    _volumePollTimer = nil;
    //[self.volumeLevelProgressView setProgress:0.f];
}
@end
