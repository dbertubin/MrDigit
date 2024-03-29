//
//  Tutorial.h
//  MrDigit
//
//  Created by Derek Bertubin on 5/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Burst.h"
#import "Ninja.h"
#import "WalkingDigit.h"
#import <GameKit/GameKit.h>
#import "Coin.h"

@interface Tutorial : CCNode <CCPhysicsCollisionDelegate, UIGestureRecognizerDelegate, GKGameCenterControllerDelegate>

@end
