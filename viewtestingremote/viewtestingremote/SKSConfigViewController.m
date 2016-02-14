//
//  SKSConfigViewController.m
//  SpeechKitSample
//
//  Read-only screen to view configuration parameters set in SKSConfiguration.mm
//
//  Copyright (c) 2015 Nuance Communications. All rights reserved.
//

#import "SKSConfigViewController.h"
#import "SKSConfiguration.h"

@interface SKSConfigViewController ()

@end

@implementation SKSConfigViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.appId setText:SKSAppId];
    [self.contextTag setText:SKSNLUContextTag];
    [self.serverHost setText:SKSServerHost];
    [self.serverPort setText:SKSServerPort];
    [self.appKey setText:SKSAppKey];
    
    self.appKeyHeight.constant = [self textViewHeight:self.appKey];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) textViewHeight:(UITextView*) view
{
    NSString *text = [view text];
    UIFont *font = [view font];
    CGFloat width = [view frame].size.width;
    CGSize size = [text sizeWithFont:font
                   constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                       lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height;
}

@end
