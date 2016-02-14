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
//Initialize whether to start moving up or down
//return 1 means that the user's vision testing will continue going DOWN
//return 0 means that user's vision testing will continue going UP
-(BOOL) moveUpOrDown:(int) level;
-(EyeObject*)moveDownEyeChartWith:(EyeObject*) myVisionTest;
- (NSString *) getEyeLevel:(int) level;
-(int) getFontSize:(int) level;


@end


