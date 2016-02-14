//
//  FindTestViewController.h
//  viewtestingremote
//
//  Created by App Development on 2/13/16.
//  Copyright © 2016 Cache me if you can. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FindTestViewController : UIViewController

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIButton *continueTestButton;
@property (strong, nonatomic) IBOutlet UIImageView *pulser;
- (IBAction)exitTestAction:(id)sender;
- (IBAction)joinTestAction:(id)sender;
- (IBAction)continueTestAction:(id)sender;

@end
