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
    // Do any additional setup after loading the view.
//    
    //values to be passed into EyeObject
    NSString *letter = @"A";
//    letter = [self getRandomCharAsNString];
//    letterLabel.text= [NSString stringWithFormat:@"%@", letter];
    
    int points = 0;
    int level = 5;
    BOOL done = false;
    
    BOOL upOrDown = [self moveUpOrDown:level];
    NSLog(@"%@",[NSNumber numberWithBool: upOrDown]);
    
    //Create an instance of EyeObject
    EyeObject * myVisionExam = [[EyeObject alloc]initWithPoints:points withALevel:level withLetter:letter finishedEyeExam:done];
    
    //if you will go down the vision board
    if (upOrDown == true)
    {
        myVisionExam.level++;
        while (level <= 8 && !done)
        {
            NSLog(@"MyVision level before %d",myVisionExam.level);
            NSLog(@"MyVision finishedEyeExam before %@", [NSNumber numberWithBool:myVisionExam.finishedEyeExam]);
            
            [self moveDownEyeChartWith:myVisionExam];
            
            level = myVisionExam.level;
            done = myVisionExam.finishedEyeExam;
            NSLog(@"MyVision level after %d",myVisionExam.level);
            NSLog(@"MyVision finishedEyeExam after %@", [NSNumber numberWithBool:myVisionExam.finishedEyeExam]);
        }
        if (!done)
        {
            NSLog(@"%@",[self getEyeLevel:myVisionExam.level]);
        }
    }
    else//if you will go up the vision board
    {
        myVisionExam.level--;
        while (level >=1 && !done)
        {
            NSLog(@"MyVision level before %d",myVisionExam.level);
            NSLog(@"MyVision finishedEyeExam before %@", [NSNumber numberWithBool:myVisionExam.finishedEyeExam]);
            
            [self moveUpEyeChartWith:myVisionExam];
            
            level = myVisionExam.level;
            done = myVisionExam.finishedEyeExam;
            NSLog(@"MyVision level after %d",myVisionExam.level);
            NSLog(@"MyVision finishedEyeExam after %@", [NSNumber numberWithBool:myVisionExam.finishedEyeExam]);
            
        }
        if (!done)
        {
            NSLog(@"%@",[self getEyeLevel:myVisionExam.level]);
        }
    }
    
    //[self moveDownEyeChartWith:points withLetter:letter withLevel:level];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [usersAnswerField resignFirstResponder];
    return YES;
}
//Initialize whether to start moving up or down
//return 1 means that the user's vision testing will continue going DOWN
//return 0 means that user's vision testing will continue going UP
-(BOOL) moveUpOrDown:(int) level
{
    NSLog(@"Im in moveUpOrDown");
    BOOL upOrDown = false;
    int points = 0;
    NSString *randletter = @"A";
    
    int fontSize = 0;
    fontSize = [self getFontSize:level];
    NSLog(@"The font size is %d", fontSize);
    
    // This sets the font for the label
    [letterLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    
    for (int i = 0; i < 5; i++)
    {
        /*************UNCOMMENT LINE BELOW TO GENERATE RANDOM LETTER************/
        randletter = [self getRandomCharAsNString];
        NSLog(@"%@", randletter);
        /*************NEED TO IMPLMENT WITH IBM WATSON************/
        //Display letter on screen
        letterLabel.text= [NSString stringWithFormat:@"%@", randletter];
        
        //Get audio from user
        //Convert audio to text
        
        
        /**************CHANGE LINE BELOW TO GET ACTUAL REALTIME RESPONSE*********/
        NSString * userResponse= [NSString stringWithFormat:@"%@", [usersAnswerField text]];
        
        if ([userResponse isEqualToString:randletter])
        {
            points++;
        }
    }
    if (points > 4)
        return upOrDown = true;
        //The user passed the level and will continue to go down.
    else
        return upOrDown = false;
        //the user failed the level
    
}
- (IBAction)submitPressed:(id)sender{
     NSString * userResponse= usersAnswerField.text;
}





-(EyeObject*)moveDownEyeChartWith:(EyeObject*) myVisionTest
{
    NSLog(@"Im in moveDownEyeChartWith");
    myVisionTest.points = 0;
    
    int fontSize = 0;
    fontSize = [self getFontSize: myVisionTest.level];
    NSLog(@"The font size is %d", fontSize);
    // This sets the font for the label
    [letterLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    
    for (int i = 0; i < 5; i++)
    {
        /*************UNCOMMENT LINE BELOW TO GENERATE RANDOM LETTER************/
        myVisionTest.letter = [self getRandomCharAsNString];
        NSLog(@"My Vision letter %d %@", i, myVisionTest.letter);
        /*************NEED TO IMPLMENT WITH IBM WATSON************/
        //Display letter on screen
        letterLabel.text= [NSString stringWithFormat:@"%@", myVisionTest.letter];
        //Get audio from user
        //Convert audio to text
        /**************CHANGE LINE BELOW TO GET ACTUAL REALTIME RESPONSE*********/
         NSString * userResponse= usersAnswerField.text;
        if ([myVisionTest.letter isEqualToString:userResponse])
        {
            myVisionTest.points++;
        }
    }
    if (myVisionTest.points > 4)
    {
        NSLog(@"You need to go to the next level which is:");
        myVisionTest.level++;
        NSLog(@"%d",myVisionTest.level);
        
    }
    else
    {
        NSLog(@"%@",[self getEyeLevel:myVisionTest.level]);
        myVisionTest.finishedEyeExam = true;
    }
    
    return myVisionTest;
}

-(EyeObject*)moveUpEyeChartWith:(EyeObject*) myVisionTest
{
        NSLog(@"Im in moveUpEyeChartWith");
    myVisionTest.points = 0;
    
    int fontSize = 0;
    fontSize = [self getFontSize: myVisionTest.level];
    NSLog(@"The font size is %d", fontSize);
    
    // This sets the font for the label
    [letterLabel setFont:[UIFont boldSystemFontOfSize:fontSize]];
    for (int i = 0; i < 5; i++)
    {
        /*************UNCOMMENT LINE BELOW TO GENERATE RANDOM LETTER************/
        myVisionTest.letter = [self getRandomCharAsNString];
        NSLog(@"My Vision letter %d %@", i, myVisionTest.letter);
        /*************NEED TO IMPLMENT WITH IBM WATSON************/
        //Display letter on screen
        letterLabel.text= [NSString stringWithFormat:@"%@", myVisionTest.letter];
        
        //Get audio from user
        //Convert audio to text
        /**************CHANGE LINE BELOW TO GET ACTUAL REALTIME RESPONSE*********/
        NSString * userResponse= [NSString stringWithFormat:@"%@", [usersAnswerField text]];
        if ([myVisionTest.letter isEqualToString:userResponse])
        {
            myVisionTest.points++;
        }
    }
    if (myVisionTest.points < 4)
    {
        NSLog(@"You need to go to the next level which is:");
        myVisionTest.level--;
        NSLog(@"%d",myVisionTest.level);
        
    }
    else
    {
        NSLog(@"%@",[self getEyeLevel:myVisionTest.level]);
        myVisionTest.finishedEyeExam = true;
    }
    return myVisionTest;
}



- (NSString *) getEyeLevel:(int) level
{
    if(level == 1)
        return @"Your vision is 20/200";
    else if (level == 2)
        return @"Your vision is 20/100";
    else if (level == 3)
        return @"Your vision is 20/70";
    else if (level == 4)
        return @"Your vision is 20/50";
    else if (level == 5)
        return @"Your vision is 20/40";
    else if (level == 6)
        return @"Your vision is 20/30";
    else if (level == 7)
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
