//
//  EyeObject.h
//  Vision
//
//  Created by Holly Ho on 2/13/16.
//  Copyright (c) 2016 Holly Ho. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EyeObject : NSObject

@property (nonatomic) int points;
@property (nonatomic) int level;
@property (strong, nonatomic) NSString *letter;
@property (nonatomic) BOOL finishedEyeExam;
-(EyeObject *)initWithPoints: (int) somePoints withALevel:(int)aLevel withLetter:(NSString *) aString finishedEyeExam:(BOOL)aBoolean;

@end
