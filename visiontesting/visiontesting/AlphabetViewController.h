//
//  AlphabetViewController.h
//  visiontesting
//
//  Created by Maira Ahmad on 2/14/16.
//  Copyright © 2016 Cache me if you can. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EyeObject.h"

@interface AlphabetViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *letterLabel;




- (NSString *)getRandomCharAsNString;


@end


