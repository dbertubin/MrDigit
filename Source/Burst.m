//
//  Burst.m
//  MrDigit
//
//  Created by Derek Bertubin on 5/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Burst.h"

@implementation Burst

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"burst";
//    self.physicsBody.collisionGroup = @"burstToDarkNinja";
    self.physicsBody.collisionGroup =@"1";
}


@end
