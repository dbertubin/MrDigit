//
//  Gameplay.h
//  MrDigit
//
//  Created by Derek Bertubin on 5/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "Burst.h"
#import "Ninja.h"
#import "WalkingDigit.h"
#import "Coin.h"
#import <GameKit/GameKit.h>
#import <Social/Social.h>

@interface Gameplay : CCNode <CCPhysicsCollisionDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>

@end
