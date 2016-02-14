//
//  VoiceViewController.h
//  viewtestingremote
//
//  Created by Maira Ahmad on 2/13/16.
//  Copyright © 2016 Cache me if you can. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <SpeechKit/SpeechKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SKSConfiguration.h"


@interface VoiceViewController : UIViewController <SKTransactionDelegate, SKAudioPlayerDelegate> {
    SKSession* _skSession;
    SKTransaction *_skTransaction;
}

- (void)resetTransaction;

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIButton *microphoneButton;
@property (strong, nonatomic) NSString *languageCode;
- (IBAction)speakNow:(id)sender;

@end
