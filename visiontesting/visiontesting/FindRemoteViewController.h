//
//  FindRemoteViewController.h
//  visiontesting
//
//  Created by App Development on 2/13/16.
//  Copyright © 2016 Cache me if you can. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FindRemoteViewController : UIViewController

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UIImageView *pulser;
- (IBAction)exitTestAction:(id)sender;

@end
