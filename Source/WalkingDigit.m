//
//  WalkingDigit.m
//  MrDigit
//
//  Created by Derek Bertubin on 5/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "WalkingDigit.h"

@implementation WalkingDigit
- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"walkingdigit";
}

@end    
