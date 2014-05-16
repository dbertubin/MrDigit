//
//  Digit.m
//  MrDigit
//
//  Created by Derek Bertubin on 5/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Digit.h"

@implementation Digit

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"digit";
}


@end
