//
//  Coin.m
//  MrDigit
//
//  Created by Derek Bertubin on 5/26/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Coin.h"

@implementation Coin

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"coin";
    self.physicsBody.collisionGroup = @"coins";
    self.physicsBody.collisionMask = [[NSArray alloc]initWithObjects:@"burst", nil];
}


@end
