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
    UISwipeGestureRecognizer * _swipeRight;
    UISwipeGestureRecognizer * _swipeLeft;
    UISwipeGestureRecognizer * _swipeUp;
    UISwipeGestureRecognizer * _swipeDown;
    UITapGestureRecognizer * _tap;
    CCNode *_digit;
    NSTimeInterval _sinceTouch;
    CCNode *_mouseNode;
    
}

- (void)didLoadFromCCB {

    _physicsNode.collisionDelegate = self;
    
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    // visualize physics bodies & joints
    _physicsNode.debugDraw = TRUE;
    
    
    _audio= [OALSimpleAudio sharedInstance];
    // play sound background
//    [_audio playBg:@"background.mp3" loop:true];
    
    //set up Tap
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(launchBurst:)];
    _tap.numberOfTapsRequired = 2;
    
    // Set up Swipes
    _swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    _swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    _swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    _swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
    _swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    
    _swipeDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
    _swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    
    // add recognizers to view
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeRight];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeLeft];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeUp];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeDown];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeDown];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_tap];
    
    if (_swipeRight||_swipeLeft||_swipeUp||_swipeDown != nil) {
        
    }


}

- (void)onBack{
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
    [_audio stopBg];
    [_audio playEffect:@"woodblock_hit.mp3"];
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{

    
    CCLOG(@"This happened");
    [[CCDirector sharedDirector] view];
    CGPoint touchLocation = [touch locationInNode:self];
//    _mouseNode.physicsBody = CCPhysicsBodyTypeDynamic;
//    [_physicsNode addChild:_mouseNode];
//    _mouseNode.position = touchLocation;
    
    if (CGRectContainsPoint([_digit boundingBox], touchLocation))
    {
        [_audio playEffect:@"P2E_sound.mp3"];
    }else {
        CCLOG(@"This didn't work");
    }
}



-(void)handleSwipeGesture:(UISwipeGestureRecognizer*) swipe
{
    //Gesture detect - swipe up/down , can be recognized direction
    if(swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        CCLOG(@"Up ");
    }
    
    else if(swipe.direction == UISwipeGestureRecognizerDirectionDown)
    {
        CCLOG(@"Down ");
    }
    
    else if(swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        CCLOG(@"Left ");
    }

    else if(swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        CCLOG(@"Right");
    }
}


- (void)update:(CCTime)delta {
//    _digit.position = ccp(_digit.position.x + delta, _digit.position.y);
//    _physicsNode.position = ccp(_physicsNode.position.x , _physicsNode.position.y);
//    
//    _sinceTouch += delta;
}

- (void)launchBurst:(UITapGestureRecognizer*)tap {

    // loads the Penguin.ccb we have set up in Spritebuilder
    CCNode* burst = [CCBReader load:@"Burst"];
    CCLOG(@"loads the Burst.ccb");
    
    burst.position = ccpAdd(_digit.position, ccp(110, 85));
    
    [_physicsNode addChild:burst];
    [_audio playEffect:@"fire_sound.mp3"];
    
    // manually create & apply a force to launch the burst
    CGPoint launchDirection = ccp(1, 0);
    CGPoint force = ccpMult(launchDirection, 500000);
    [burst.physicsBody applyForce:force];
    
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ninja:(CCNode *)nodeA burst:(CCNode *)nodeB
{
    float energy = [pair totalKineticEnergy];
    CCLOG(@"This fired");
    // if energy is large enough, remove the seal
    if (energy > 0.f)
    {
        [self ninjaRemoved:nodeA];
        [self burstRemoved:nodeB];
        [_audio playEffect:@"hit_sound.mp3"];
    }
}


//-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair digit:(CCNode *)nodeA wildcard:(CCNode *)nodeB
//{
//     [_audio playEffect:@"P2E_sound.mp3"];
//}




- (void)selectNodeForTouch:(CGPoint)touchLocation {

    //    [_audio playEffect:@"P2E_sound.mp3"];
    
}

- (void)ninjaRemoved:(CCNode *)ninja {
    // load explsion particle effect
    
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"NinjaExplosion"];
    // clear effect , once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    // place the particle effect on the ninja position
    explosion.position = ninja.position;
    [ninja.parent addChild:explosion];
    
    // finally, remove the destroyed seal
    [ninja removeFromParent];
}

- (void)burstRemoved:(CCNode *)burst {

    [burst removeFromParent];
}


@end
