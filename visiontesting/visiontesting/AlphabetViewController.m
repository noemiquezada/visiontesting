//
//  AlphabetViewController.m
//  visiontesting
//
//  Created by Maira Ahmad on 2/14/16.
//  Copyright © 2016 Cache me if you can. All rights reserved.
//

#import "AlphabetViewController.h"

@interface AlphabetViewController ()

@end

@implementation AlphabetViewController
@synthesize letterLabel;
@synthesize usersAnswerField;

- (void)viewDidLoad {
    [super viewDidLoad];
    visionScore=0;
    level=5;
    letterSize=0;
    NSString *letter = @"A";
    testFinished=false;
    
    //Create an instance of EyeObject
    myVisionExam = [[EyeObject alloc]initWithPoints:visionScore withALevel:level withLetter:letter finishedEyeExam:testFinished];
    
    counter=0;
   
    [self setRandomLetter:level];
    
    
}
-(void)setRandomLetter: (int)alevel{
    NSString *letter = @"A";
    letter = [self getRandomCharAsNString];
    letterLabel.text= [NSString stringWithFormat:@"%@", letter];
    
    letterSize = [self getFontSize:alevel];
    NSLog(@"The font size is %d for level %d", letterSize, alevel);
    // This sets the font for the label
    [letterLabel setFont:[UIFont boldSystemFontOfSize:letterSize]];
    
    
}
-(void)checkifAnswerMatches{
    NSString * userResponse= [NSString stringWithFormat:@"%@", [usersAnswerField text]];
    if ([userResponse isEqualToString:[NSString stringWithFormat:@"%@", [letterLabel text]]]){
        NSLog(@"match");
        visionScore++;
    }
    else{
        NSLog(@"no match");
    }
}
- (IBAction)submitPressed:(id)sender{
    counter++;
    [self checkifAnswerMatches];
    [self setRandomLetter:level];
    usersAnswerField.text=@"";
    NSLog(@"vision score: %d", visionScore);
    if(testFinished==true){
        letterLabel.text=[NSString stringWithFormat:@"Thank You, your score is %@", [self getEyeLevel:myVisionExam.level]];
    }
    if (myVisionExam.level==5 && counter==5){
            if (visionScore > 4){
                level--;
                myVisionExam.level=level;
                NSLog(@"user passed");
                //The user passed the level and will continue to go down.
            }
            else{
                level++;
                NSLog(@"user failed");
                myVisionExam.level=level;
                //the user failed the level
            }
            counter=0;
    }
    if (myVisionExam.level<5 && counter==5){
       if (visionScore > 4){
            level++;
            myVisionExam.level=level;
            NSLog(@"user passed");
            //The user passed the level and will continue to go down.
        }
        else{
            myVisionExam.level=level;
            testFinished=true;
        }
        counter=0;
    }
    if (myVisionExam.level>5 && counter==5){
        if (visionScore < 4){
            myVisionExam.level=level;
            testFinished=true;
        }
        else{
            level--;
            myVisionExam.level=level;
            NSLog(@"user failed");
            //The user failed the level and will have to go up the chart.
        }
        counter=0;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [usersAnswerField resignFirstResponder];
    return YES;
}
- (NSString *) getEyeLevel:(int) alevel
{
    if(alevel == 1)
        return @"Your vision is 20/200";
    else if (alevel == 2)
        return @"Your vision is 20/100";
    else if (alevel == 3)
        return @"Your vision is 20/70";
    else if (alevel == 4)
        return @"Your vision is 20/50";
    else if (alevel == 5)
        return @"Your vision is 20/40";
    else if (alevel == 6)
        return @"Your vision is 20/30";
    else if (alevel == 7)
        return @"Your vision is 20/25";
    else
        return @"Your vision is 20/20";
}

-(int) getFontSize:(int) level
{
    if(level == 1)
        return 220;
    else if (level == 2)
        return 120;
    else if (level == 3)
        return 80;
    else if (level == 4)
        return 60;
    else if (level == 5)
        return 45;
    else if (level == 6)
        return 35;
    else if (level == 7)
        return 30;
    else
        return 25;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)getRandomCharAsNString {
    //For better implementation, need to change so that there will not be duplicate letters
    NSString *letters = @"ABDEFGHKLMNPQSTVXYZ";
    NSInteger index = arc4random_uniform([letters length]);
    NSString *randomLetter = [letters substringWithRange:NSMakeRange(index, 1)];
    return randomLetter;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
