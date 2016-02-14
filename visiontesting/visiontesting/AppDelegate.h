//
//  AppDelegate.h
//  visiontesting
//
//  Created by App Development on 2/13/16.
//  Copyright © 2016 Cache me if you can. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SessionController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SessionController *sessionController;


@end

