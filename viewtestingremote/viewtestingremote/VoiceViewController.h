//
//  VoiceViewController.h
//  viewtestingremote
//
//  Created by Maira Ahmad on 2/13/16.
//  Copyright © 2016 Cache me if you can. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VoiceViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *microphoneButton;
- (IBAction)speakNow:(id)sender;

@end
