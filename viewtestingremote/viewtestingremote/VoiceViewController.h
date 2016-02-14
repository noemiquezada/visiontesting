//
//  VoiceViewController.h
//  viewtestingremote
//
//  Created by Maira Ahmad on 2/13/16.
//  Copyright © 2016 Cache me if you can. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface VoiceViewController : UIViewController

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIButton *microphoneButton;
- (IBAction)speakNow:(id)sender;

@end
