//
//  EyeObject.m
//  Vision
//
//  Created by Holly Ho on 2/13/16.
//  Copyright (c) 2016 Holly Ho. All rights reserved.
//

#import "EyeObject.h"

@implementation EyeObject

@synthesize letter;

-(EyeObject *)initWithPoints: (int) somePoints withALevel:(int)aLevel withLetter:(NSString *) aString finishedEyeExam:(BOOL)aBoolean {
    self = [super init];
    
    if (self) {
        self.points = somePoints;
        self.level = aLevel;
        self.letter = aString;
        self.finishedEyeExam = aBoolean;
    }
    
    return self;
}

@end
