//
//  Gameplay.m
//  MrDigit
//
//  Created by Derek Bertubin on 5/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay{
    CCPhysicsNode *_physicsNode;
    OALSimpleAudio *_audio;

}

- (void)didLoadFromCCB {
    
    _physicsNode.collisionDelegate = self;
    
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    // visualize physics bodies & joints
    _physicsNode.debugDraw = TRUE;
    
    _audio= [OALSimpleAudio sharedInstance];
    // play sound background
    [_audio playBg:@"background.mp3" loop:true];

}

- (void)onBack{
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
    [_audio stopBg];
    [_audio playEffect:@"woodblock_hit.mp3"];
}

@end
