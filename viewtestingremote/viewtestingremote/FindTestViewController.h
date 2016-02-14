//
//  FindTestViewController.h
//  viewtestingremote
//
//  Created by App Development on 2/13/16.
//  Copyright © 2016 Cache me if you can. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <SpeechKit/SpeechKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SKSConfiguration.h"

@interface FindTestViewController : UIViewController <UIAlertViewDelegate, SKTransactionDelegate, SKAudioPlayerDelegate> {
    SKSession* _skSession;
    SKTransaction *_skTransaction;
}

- (void)resetTransaction;


@property (strong, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIButton *continueTestButton;
@property (strong, nonatomic) IBOutlet UIImageView *pulser;
@property (strong, nonatomic) NSString *languageCode;

- (IBAction)exitTestAction:(id)sender;
- (IBAction)joinTestAction:(id)sender;
- (void)showConfirmationAlert;


@end
