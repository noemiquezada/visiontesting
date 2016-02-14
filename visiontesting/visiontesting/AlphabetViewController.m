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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *letter = @"A";
    letter = [self getRandomCharAsNString];
    letterLabel.text= [NSString stringWithFormat:@"%@", letter];
    

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
