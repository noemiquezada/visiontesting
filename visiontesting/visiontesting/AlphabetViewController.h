//
//  AlphabetViewController.h
//  visiontesting
//
//  Created by Maira Ahmad on 2/14/16.
//  Copyright © 2016 Cache me if you can. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EyeObject.h"
#import "AppDelegate.h"

@interface AlphabetViewController : UIViewController <UITextFieldDelegate>{
    int visionScore;
    int counter;
    int level;
    int letterSize;
    bool testFinished;
    EyeObject * myVisionExam;
}
@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UILabel *letterLabel;
@property (strong, nonatomic) IBOutlet UITextField *usersAnswerField;
- (IBAction)submitPressed:(id)sender;





- (NSString *)getRandomCharAsNString;
- (NSString *) getEyeLevel:(int) level;
-(int) getFontSize:(int) level;


@end


