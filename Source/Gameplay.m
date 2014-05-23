//
//  Gameplay.m
//  MrDigit
//
//  Created by Derek Bertubin on 5/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

static const int MOVEBY = 50;

@implementation Gameplay{
    
    
    float minDelay,maxDelay;
    CCPhysicsNode *_physicsNode;
    Gameplay *_contentNode;
    OALSimpleAudio *_audio;
    UISwipeGestureRecognizer *_swipeRight;
    UISwipeGestureRecognizer *_swipeLeft;
    UISwipeGestureRecognizer *_swipeUp;
    UISwipeGestureRecognizer *_swipeDown;
    UITapGestureRecognizer *_tap;
    
    CCNode *_digit;
    CCNode *_mouseNode;
    CCNode *_walkingDigit;
    CCNodeColor *_menuBg;
    CCNodeColor *_gameOverBg;
    CCButton *_resumeButton;
    CCButton *_mmButton;
    CCButton *_menuButton;
    CCButton *_replayButton;
    CCLabelTTF *_gameOverLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_scoreLabelLabel;
    
    CCNode *_burst;
    CCNode *_ninja;
    
    CGSize _winSize;
    int _atCenter;
    
    float _intensity;
    
    NSTimeInterval _sinceTouch;
    CGPoint _destinationPoint;
    CGPoint _currentPosition;
    
    
    CCNode *_ground1;
    CCNode *_ground2;
    NSArray *_grounds;
    
    BOOL movedLeft;
    BOOL movedRight;
    BOOL movedUp;
    BOOL movedDown;
    BOOL isPaused;
    
    int _score;
    CGFloat scrollSpeed;
    
    
}



static CGSize designSize = {480, 320};

-(CGPoint) scalePoint:(CGPoint)point
{
    CGSize winSize = [[CCDirector sharedDirector]viewSize];
    CGSize scaleFactor = CGSizeMake(winSize.width / designSize.width,
                                    winSize.height / designSize.height);
    return CGPointMake(point.x * scaleFactor.width, point.y * scaleFactor.height);
}

- (void)didLoadFromCCB {
    

    _score = 0;

    _gameOverBg.visible = NO;
    _menuBg.visible = NO;
    
    
    scrollSpeed= 70.f;
    
    //Set grounds in array to loop in update
    _grounds = @[_ground1, _ground2];
    
    
    // set current postions var
    

    _walkingDigit = (WalkingDigit*)[CCBReader load:@"WalkingDigit"];
    _walkingDigit.scale = 2;
    _walkingDigit.position = ccp(30, _ground1.contentSize.height);
    _physicsNode.collisionDelegate = self;
    [_physicsNode addChild:_walkingDigit];
    
    // Assign delegate

    
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    // visualize physics bodies & joints
    _physicsNode.debugDraw = TRUE;
    
    
    _audio= [OALSimpleAudio sharedInstance];
    // play sound background
//    [_audio playBg:@"background.mp3" loop:true];
    
    /************************************************************************************
     Gestures
     ************************************************************************************/
    
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

- (void)onMenu{
    [_audio playEffect:@"woodblock_hit.mp3"];
    
    if (isPaused == NO) {
        _physicsNode.paused = YES;
        _physicsNode.userInteractionEnabled = NO;
        scrollSpeed = 0;
        isPaused = YES;
        _menuBg.visible = YES;
        _resumeButton.visible = YES;
        _mmButton.visible = YES;
        _replayButton.visible = NO;
        _gameOverLabel.visible = NO;
        _menuButton.visible= NO;
        
    } else
    {
        _physicsNode.paused = NO;
        _physicsNode.userInteractionEnabled = YES;
        scrollSpeed = 70;
        isPaused = NO;
        _menuBg.visible = NO;
        _resumeButton.visible = NO;
        _mmButton.visible = NO;
        _menuButton.visible= YES;
    }
    
}


-(void)onBack{
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
    [_audio stopBg];
    [_audio playEffect:@"woodblock_hit.mp3"];
    
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Tocuh happened");
    CGPoint touchLocation = [touch locationInNode:self];
    _mouseNode.position = touchLocation;
    
    if (CGRectContainsPoint([_walkingDigit boundingBox], touchLocation))
    {
        //        [_audio playEffect:@"P2E_sound.mp3"];
    }else {
        CCLOG(@"Youre not touching digit");
    }
    
}



-(void)handleSwipeGesture:(UISwipeGestureRecognizer*) swipe
{
    //Gesture detect - swipe up/down , can be recognized direction
    if(swipe.direction == UISwipeGestureRecognizerDirectionUp)
    {
        
        [_walkingDigit.physicsBody applyImpulse:ccp(0, 250.f)];
        // set BOOLS direction
        movedUp = true;
        movedDown = false;
        movedLeft = false;
        movedRight = false;
        CCLOG(@"Up ");
    }
    else if(swipe.direction == UISwipeGestureRecognizerDirectionDown)
    {
        CCLOG(@"Down ");
        
        // set BOOLS direction
        movedUp = false;
        movedDown = true;
        movedLeft = false;
        movedRight = false;
    }
    else if(swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        CCLOG(@"Left ");

        _destinationPoint=  CGPointMake(_walkingDigit.position.x - MOVEBY, _walkingDigit.position.y + 0);

        // set BOOLS direction
        movedUp = false;
        movedDown = false;
        movedLeft = true;
        movedRight = false;
    }

    else if(swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        CCLOG(@"Right");
        _destinationPoint=  CGPointMake(_walkingDigit.position.x + MOVEBY, _walkingDigit.position.y + 0);

        [self startWalking];
        // set BOOLS direction
        movedUp = false;
        movedDown = false;
        movedLeft = false;
        movedRight = true;
    }
    
}

/********************************************************************************
 *
 *                               UPDATE STARTS HERE
 *
 ********************************************************************************/

- (void)update:(CCTime)delta
{
    
    _scoreLabel.string = [NSString stringWithFormat:@"%d", _score];
    
    /********************************************************************************
     Scrolling Background and Digit
     *******************************************************************************/
    
    _intensity++;
    
    minDelay = 0.5;                      // seconds
    maxDelay = 3.0;
    
    if (_intensity > 600) {
        CCLOG(@"Intensity++");
        maxDelay = 2.5;
    }
    
    if (_intensity > 1200) {
        maxDelay = 2.0;
    }
    
    if (_intensity > 1800) {
        maxDelay = 1.0;
    }
    
    
    if (isPaused==NO) {
        
        u_int32_t delta = (u_int32_t) (ABS(maxDelay-minDelay)*1000);  // ms resolution
        float randomDelta = arc4random_uniform(delta)/1000.;          // now in seconds
        [self scheduleOnce:@selector(addNinja:) delay:randomDelta];
        
    } else {
        // nothing
    }

    
    _ninja.position = ccp(_ninja.position.x + (delta * -1) * (scrollSpeed), _ninja.position.y);
    _ground1.position = ccp(_ground1.position.x - ((scrollSpeed) *delta), _ground1.position.y);
    _ground2.position = ccp(_ground2.position.x - ((scrollSpeed) *delta), _ground2.position.y);
    
    for (CCNode *ground in _grounds) {
        // get the world position of the ground
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        // get the screen position of the ground
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.x <= (-1 * ground.contentSize.width)) {
            ground.position = ccp(ground.position.x + 2 * ground.contentSize.width, ground.position.y);
        }
    }
    
    /*****************************************************************************
     Managing Bursts
     *****************************************************************************/
    
    if (_burst.position.x >= self.boundingBox.size.width + 30) {
        
        CCLOG(@"%f", _burst.position.x);
        CCLOG(@"%f", self.boundingBox.size.width);
        [_burst removeFromParent];
        
    }
    
    /*****************************************************************************
     Movements Based on Delta
     *****************************************************************************/
    
    if(movedRight)
    {
        CGPoint difValx;
        difValx.x = fabsf(_destinationPoint.x - _walkingDigit.position.x  );
        CGPoint newlocaton =  CGPointMake(_walkingDigit.position.x + (difValx.x*delta), _walkingDigit.position.y);
        if (_walkingDigit.position.x < _destinationPoint.x) {
            _walkingDigit.position = newlocaton;
            CCBAnimationManager* animationManager = _walkingDigit.userObject;
            [animationManager runAnimationsForSequenceNamed:@"Walking"];
        }else if(_walkingDigit.position.x == _destinationPoint.x){
            
        }
    }
    
    
    if (movedLeft)
    {
        CGPoint difValx;
        difValx.x = fabsf(_destinationPoint.x - _walkingDigit.position.x  );
        CGPoint newlocaton =  CGPointMake(_walkingDigit.position.x - (difValx.x*delta), _walkingDigit.position.y);
        if (_walkingDigit.position.x > _destinationPoint.x) {
            _walkingDigit.position = newlocaton;
        }else if(_walkingDigit.position.x == _destinationPoint.x){
            
        }
    }
    
    
}


- (void)addNinja:(CCTime)dt {
    
 
    
    _ninja = (Ninja*)[CCBReader load:@"Ninja"];
    _ninja.scale =2.0f;
    
    _ninja.position = CGPointMake(self.contentSize.width + _ninja.contentSize.width/2, _walkingDigit.position.y);
        
    [_physicsNode addChild:_ninja];
    
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:7 position:CGPointMake(-_ninja.contentSize.width/2 + 20, _walkingDigit.position.y)];
    CCAction *actionRemove = [CCActionRemove action];
    [_ninja runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
}


//-(void)intervalForNinja{
//    float delay = (arc4random() % 2000) / 1000.f;
//    // call method to start animation after random delay
//    [self performSelector:@selector(addNinja) withObject:nil afterDelay:delay];
//}


//-(void)addNinja{
//    _ninja = (Ninja*)[CCBReader load:@"Ninja"];
//    [_physicsNode addChild:_ninja];
//}


- (void)launchBurst:(UITapGestureRecognizer*)tap {
    
    // loads the Penguin.ccb we have set up in Spritebuilder
    _burst = [CCBReader load:@"Burst"];
    _burst.scale = .5f;
    CCLOG(@"loads the Burst.ccb");
    
    _burst.position = ccpAdd(_walkingDigit.position, ccp(35 , 10));
    
    [_physicsNode addChild:_burst];
    [_audio playEffect:@"fire_sound.mp3"];
    
    // manually create & apply a force to launch the burst
    CGPoint launchDirection = ccp(1, -1);
    CGPoint force = ccpMult(launchDirection, 500000);
    [_burst.physicsBody applyForce:force];
    
}

/*****************************************************************************
 COLLISIONS
 *****************************************************************************/
-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ninja:(CCNode *)nodeA burst:(CCNode *)nodeB
{
    float energy = [pair totalKineticEnergy];
    CCLOG(@"This fired");
    // if energy is large enough, remove the ninja
    if (energy > 0.f)
    {
        
        _score++;
        [self ninjaRemoved:nodeA];
        [self burstRemoved:nodeB];
        [_audio playEffect:@"hit_sound.mp3"];
        
    }
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ninja:(CCNode *)nodeA digit:(CCNode *)nodeB
{
    float energy = [pair totalKineticEnergy];
    CCLOG(@"This fired");
    // if energy is large enough, remove the ninja
    if (energy > 0.f)
    {
        [self ninjaRemoved:nodeA];
        [self digitRemoved:nodeB];
        //        [_audio playEffect:@"hit_sound.mp3"];
        [self gameOver];
    }
}

- (void)ninjaRemoved:(CCNode *)ninja {
    // load explsion particle effect
    
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"NinjaExplosion"];
    // clear effect , once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    // place the particle effect on the ninja position
    explosion.position = ninja.position;
    [ninja.parent addChild:explosion];
    
    // finally, remove the  ninja
    [ninja removeFromParent];
}

- (void)burstRemoved:(CCNode *)burst {
    
    [burst removeFromParentAndCleanup:YES];
}

- (void)digitRemoved:(CCNode *)digit {
    
    
    [digit removeFromParentAndCleanup:YES];
    
    
}


- (void)startWalking
{
    // the animation manager of each node is stored in the 'userObject' property
    CCBAnimationManager* animationManager = _walkingDigit.userObject;
    // timelines can be referenced and run by name
    [animationManager runAnimationsForSequenceNamed:@"Walking"];
}


-(void)gameOver{
    CCLOG(@"GAME OVER!!!!");
    _menuButton.visible= NO;
    _physicsNode.paused = YES;
    _physicsNode.userInteractionEnabled = NO;
    scrollSpeed = 0;
    _gameOverBg.visible = YES;
    _scoreLabel.visible = NO;
    _scoreLabelLabel.visible =NO;
    
}

- (void)replay{
    // reload this level
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
}

@end
