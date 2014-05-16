//
//  Mouse.m
//  MrDigit
//
//  Created by Derek Bertubin on 5/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Mouse.h"

@implementation Mouse
- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"mouse";
}



@end
