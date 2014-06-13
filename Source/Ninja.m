//
//  Ninja.m
//  MrDigit
//
//  Created by Derek Bertubin on 5/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Ninja.h"

@implementation Ninja

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"ninja";
    self.physicsBody.collisionGroup = @"ninjaToNinjaBurst";
    self.physicsBody.collisionMask = [[NSArray alloc]initWithObjects:@"burst", nil];
}

@end
