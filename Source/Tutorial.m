//
//  Tutorial.m
//  MrDigit
//
//  Created by Derek Bertubin on 5/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Tutorial.h"

static const int MOVEBY = 50;

@implementation Tutorial

{
    float minDelay,maxDelay;
    CCPhysicsNode *_physicsNode;
    Tutorial *_contentNode;
    OALSimpleAudio *_audio;
    UISwipeGestureRecognizer *_swipeRight;
    UISwipeGestureRecognizer *_swipeLeft;
    UISwipeGestureRecognizer *_swipeUp;
    UISwipeGestureRecognizer *_swipeDown;
    UITapGestureRecognizer *_tap;
    
    CCNode *_digit;
    CCNode *_mouseNode;
    WalkingDigit *_walkingDigit;
    CCNodeColor *_menuBg;
    CCNodeColor *_gameOverBg;
    CCNodeColor *_swipeUpBG;
    CCButton *_resumeButton;
    CCButton *_mmButton;
    CCButton *_menuButton;
    CCButton *_replayButton;
    CCLabelTTF *_gameOverLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_scoreLabelLabel;
    CCLabelTTF *_coinLabel;
    CCLabelTTF *_highScoreText;
    CCLabelTTF *_jumpCoinText;
    CCLabelTTF *_jumpText;
    CCLabelTTF *_swipeRightText;
    CCLabelTTF *_fireBallText;
    CCButton *_playButton;
    
    CCNode *_burst;
    CCNode *_ninja;
    CCNode *_coin;
    CCNode *_ninjaBurst;
    NSUserDefaults * _prefs;
    
    
    CGSize _winSize;
    int _atCenter;
    
    float _intensity;
    
    NSTimeInterval _sinceTouch;
    CGPoint _destinationPoint;
    CGPoint _currentPosition;
    CGPoint _touchLocation;
    
    CCNode *_ground1;
    CCNode *_ground2;
    NSArray *_grounds;
    
    BOOL movedLeft;
    BOOL movedRight;
    BOOL movedUp;
    BOOL movedDown;
    BOOL isPaused;
    
    int _score;
    int _coins;
    CGFloat scrollSpeed;
    NSInteger _hiScore;
    
    
}



- (void)didLoadFromCCB {
    
    
    _swipeUpBG.visible = NO;
    isPaused =NO;
    
    _score = 0;
    
    scrollSpeed= 50.f;
    
    //Set grounds in array to loop in update
    _grounds = @[_ground1, _ground2];
    
    
    // Assign delegate
    _physicsNode.collisionDelegate = self;
    
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    
    
    _walkingDigit = (WalkingDigit*)[CCBReader load:@"WalkingDigit"];
    [_physicsNode addChild:_walkingDigit];
    _walkingDigit.position = ccp(80, 60);
    _walkingDigit.scale = 2;

    
    
    _audio= [OALSimpleAudio sharedInstance];
    // play sound background
//    [_audio playBg:@"background.mp3" loop:true];
    
    
    [self scheduleOnce:@selector(addNinja:) delay:.1];
    [self scheduleOnce:@selector(pauseForFireball) delay:1.0f];
    [self scheduleOnce:@selector(pauseForJump) delay:2.0f];
    [self scheduleOnce:@selector(pauseForCoin) delay:7.1f];
    [self scheduleOnce:@selector(pauseForSwipe) delay:9.1f];
    [self scheduleOnce:@selector(launchNinjaBurst) delay:.3f];
    

    
}

#pragma mark - Tut Sequence
-(void)pauseForJump{
    
    _contentNode.paused = YES;
    _swipeUpBG.visible = YES;
    _jumpText.visible = YES;
    _jumpCoinText.visible = NO;
    _swipeRightText.visible = NO;
    _fireBallText.visible= NO;
    _playButton.visible=NO;
    
    _swipeUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
    _swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeUp];

    
}

-(void)pauseForCoin{
    
    _contentNode.paused = YES;
    _swipeUpBG.visible = YES;
    _jumpCoinText.visible = YES;
    _jumpText.visible = NO;
    _swipeRightText.visible = NO;
    _fireBallText.visible= NO;
    _playButton.visible=NO;
    
    
}

-(void)pauseForSwipe{
    
    _contentNode.paused = YES;
    _swipeUpBG.visible = YES;
    _jumpCoinText.visible = NO;
    _jumpText.visible = NO;
    _swipeRightText.visible = YES;
    _fireBallText.visible= NO;
    _playButton.visible=NO;
    
    _swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_swipeRight];
    
    
}

-(void)pauseForFireball{
    
    _contentNode.paused = YES;
    _swipeUpBG.visible = YES;
    _jumpCoinText.visible = NO;
    _jumpText.visible = NO;
    _swipeRightText.visible = NO;
    _fireBallText.visible= YES;
    _playButton.visible=NO;
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(launchBurst:)];
    _tap.numberOfTapsRequired = 2;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:_tap];

}

-(void)pauseForPlay{
    
    _contentNode.paused = YES;
    _swipeUpBG.visible = YES;
    _jumpCoinText.visible = NO;
    _jumpText.visible = NO;
    _swipeRightText.visible = NO;
    _fireBallText.visible= YES;
    _fireBallText.string = @"Excellent!!! Now you know how to play.\nTap Play to play a game.";
    _playButton.visible=YES;
    
    [self updateAchievements];
    
}





-(void)updateAchievements{
    NSString *achievementIdentifier;
    float progressPercentage = 0.0;
    BOOL progressInLevelAchievement = NO;
    
    GKAchievement *scoreAchievement = nil;
    
    progressPercentage = 100;
    achievementIdentifier = @"Tutorial_Completion";
 
    scoreAchievement.showsCompletionBanner = YES;
    scoreAchievement = [[GKAchievement alloc] initWithIdentifier:achievementIdentifier];
    scoreAchievement.percentComplete = progressPercentage;
    
    NSArray *achievements = (progressInLevelAchievement) ? @[scoreAchievement] : @[scoreAchievement];
    
    [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}




-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Button actions

-(void)onPlay{
    
    //        if (isPaused == YES) {
    //            [[CCDirector sharedDirector] resume];
    //        }
    [self removeFromParentAndCleanup:YES];
    CCScene *mainScene = [CCBReader loadAsScene:@"GamePlay"];
    
    [[CCDirector sharedDirector] replaceScene:mainScene];
    [_audio stopBg];
    [_audio playEffect:@"woodblock_hit.mp3"];
    
    
}


- (void)onMenu{
    [_audio playEffect:@"woodblock_hit.mp3"];
    
    if (isPaused == NO) {
        [[CCDirector sharedDirector] pause];
        _physicsNode.paused = YES;
        _physicsNode.userInteractionEnabled = NO;
        _contentNode.userInteractionEnabled = NO;           scrollSpeed = 0;
        isPaused = YES;
        _audio.paused = YES;
        
        
    }
    else
    {
        _physicsNode.paused = NO;
        _contentNode.userInteractionEnabled = YES ;
        _physicsNode.userInteractionEnabled = YES;
        scrollSpeed = 70;
        isPaused = NO;
        _audio.paused = NO;
        [[CCDirector sharedDirector] resume];
    }
    
}


-(void)onBack{
    
    if (isPaused == YES) {
        [[CCDirector sharedDirector] resume];
    }
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    
    [[CCDirector sharedDirector] replaceScene:mainScene];
    [_audio stopBg];
    [_audio playEffect:@"woodblock_hit.mp3"];
    
}

#pragma mark - Touch actions

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Tocuh happened");
    _touchLocation = [touch locationInNode:self];
    _mouseNode.position = _touchLocation;
    
    if (CGRectContainsPoint([_walkingDigit boundingBox], _touchLocation))
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
        _destinationPoint=  CGPointMake(_walkingDigit.position.x , _walkingDigit.position.y + 100);
        //        [_walkingDigit.physicsBody applyImpulse:ccp(0, 250.f)];
        // set BOOLS direction
        [self startWalking];
        movedUp = true;
        movedDown = false;
        movedLeft = false;
        movedRight = false;
        CCLOG(@"Up ");
        _contentNode.paused = NO;
        _swipeUpBG.visible=NO;
        [self scheduleOnce:@selector(addCoin:) delay:1];
        

        
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
        
        //        [self startWalking];
        // set BOOLS direction
        movedUp = false;
        movedDown = false;
        movedLeft = false;
        movedRight = true;
        
        if (_contentNode.paused == YES) {
            _contentNode.paused = NO;
            _swipeUpBG.visible = NO;
        }
        [self scheduleOnce:@selector(pauseForPlay) delay:2.0f];
    }
    
}

/********************************************************************************
 *
 *                               UPDATE STARTS HERE
 *
 ********************************************************************************/
#pragma mark - UPDATE
- (void)update:(CCTime)delta
{
    
    /********************************************************************************
     Scrolling Background and Digit
     *******************************************************************************/
    
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

    
    
    if (_intensity < 600) {
        CCLOG(@"Intensity++");
        minDelay = 0.5;
        maxDelay = 3.0;
    }

    /*****************************************************************************
     Managing Objects
     *****************************************************************************/
    
    
    if (_burst.position.x >= self.boundingBox.size.width + 30) {
        
        [_burst removeFromParent];
        
    }
    
    
    if (_ninjaBurst.position.x <=  -10) {
        
        [_ninjaBurst removeFromParent];
        
    }
    
    
    
    /*****************************************************************************
     Movements Based on Delta
     *****************************************************************************/
    
    if (movedUp) {
        
        CGPoint difValx;
        difValx.y = fabsf(_destinationPoint.y - _walkingDigit.position.y  );
        CGPoint newlocaton =  CGPointMake(_walkingDigit.position.x , _destinationPoint.y);
        CCActionMoveTo * moveTo = [CCActionMoveTo actionWithDuration:0.25f position:newlocaton];
        [_walkingDigit runAction:moveTo];
        
        CCAnimationManager* animationManager = _walkingDigit.userObject;
        [animationManager runAnimationsForSequenceNamed:@"Walking"];
        movedUp = NO;
        
    }
    
    
    if(movedRight)
    {
        CGPoint difValx;
        difValx.x = fabsf(_destinationPoint.x - _walkingDigit.position.x  );
        CGPoint newlocaton =  CGPointMake(_walkingDigit.position.x + (difValx.x*delta), _walkingDigit.position.y);
        if (_walkingDigit.position.x < _destinationPoint.x) {
            _walkingDigit.position = newlocaton;
            //            CCBAnimationManager* animationManager = _walkingDigit.userObject;
            
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
    
    
    if (_walkingDigit.position.x < -20) {
        [self gameOver];
    }
    
    if (CGRectContainsRect([_walkingDigit boundingBox], [_ninja boundingBox]))
    {
        
        [self gameOver];
    }
    
}

#pragma mark - Add Stuff

- (void)addNinja:(CCTime)dt {
    
    
    int sort = 0;
    sort ++;
    _ninja = (Ninja*)[CCBReader load:@"Ninja"];
    _ninja.scale =2.0f;
    _ninja.zOrder= sort;
    
    _ninja.position = CGPointMake(568 + _ninja.contentSize.width/2, _walkingDigit.position.y);
    
    [_physicsNode addChild:_ninja];
    
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:7 position:CGPointMake(-_ninja.contentSize.width/2 + 20, _walkingDigit.position.y)];
    CCAction *actionRemove = [CCActionRemove action];
    [_ninja runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    
}

- (void)addCoin:(CCTime)dt {
    
    
    int sort = 0;
    sort ++;
    _coin = (Coin*)[CCBReader load:@"Coin"];
    _coin.scale =.2f;
    _coin.zOrder= sort;
    
    _coin.position = CGPointMake(568 + _coin.contentSize.width/2, 150);
    
    [_physicsNode addChild:_coin];
    
    
    CGPoint launchDirection = ccp(-1, 0);
    CGPoint force = ccpMult(launchDirection, 50000);
    [_coin.physicsBody applyForce:force];
    
    //    CCAction *actionMove = [CCActionMoveTo actionWithDuration:4 position:CGPointMake(-1, 150)];
    //    CCAction *actionRemove = [CCActionRemove action];
    //    [_coin runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];

    
}


- (void)launchBurst:(UITapGestureRecognizer*)tap {
    
    if (_contentNode.paused == YES) {
        _contentNode.paused = NO;
        _swipeUpBG.visible=NO;
    }
    
    if (isPaused== NO) {
        // loads the Penguin.ccb we have set up in Spritebuilder
        _burst = [CCBReader load:@"Burst"];
        _burst.scale = .5f;
        _burst.physicsBody.collisionGroup = @"groupb";
        _burst.physicsBody.collisionGroup = @"group";
        CCLOG(@"loads the Burst.ccb");
        
        _burst.position = ccpAdd(_walkingDigit.position, ccp(35 , 10));
        
        [_physicsNode addChild:_burst];
        [_audio playEffect:@"fire_sound.mp3"];
        
        // manually create & apply a force to launch the burst
        CGPoint launchDirection = ccp(1, 0                  );
        CGPoint force = ccpMult(launchDirection, 500000);
        [_burst.physicsBody applyForce:force];
    }
   
    
    
}


- (void)launchNinjaBurst{
    
    int sort = 0;
    sort ++;
    // loads the Penguin.ccb we have set up in Spritebuilder
    _ninjaBurst = [CCBReader load:@"NinjaBurst"];
    _ninjaBurst.scale = .5f;
    _ninjaBurst.zOrder = sort;
    _ninjaBurst.physicsBody.collisionGroup = @"ninjaToNinjaBurst";
    _ninjaBurst.physicsBody.collisionGroup = @"group";
    CCLOG(@"loads the Burst.ccb");
    
    _ninjaBurst.position = ccpAdd(_ninja.position, ccp(-35 , 20));
    
    [_physicsNode addChild:_ninjaBurst];
    [_audio playEffect:@"fire_sound.mp3"];
    
    
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:2.5 position:CGPointMake(-_ninja.contentSize.width/2 + 20, _walkingDigit.position.y)];
    CCAction *actionRemove = [CCActionRemove action];
    [_ninjaBurst runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    
    //        // manually create & apply a force to launch the burst
    //        CGPoint launchDirection = ccp(-1, 0);
    //        CGPoint force = ccpMult(launchDirection, 50000);
    //        [_ninjaBurst.physicsBody applyForce:force];
    
    
    
}

/*****************************************************************************
 COLLISIONS
 *****************************************************************************/

#pragma mark - Collisions

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

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair walkingdigit:(CCNode *)nodeA ninjaburst:(CCNode *)nodeB
{
    float energy = [pair totalKineticEnergy];
    CCLOG(@"This fired");
    // if energy is large enough, remove the ninja
    if (energy > 0.f)
    {
        
        _score++;
        [self burstRemoved:nodeB];
        [_audio playEffect:@"hit_sound.mp3"];
        [self gameOver];
    }
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair burst:(CCNode *)nodeA ninjaburst:(CCNode *)nodeB
{
    float energy = [pair totalKineticEnergy];
    CCLOG(@"This fired");
    // if energy is large enough, remove the ninja
    if (energy > 0.f)
    {
        
        _score++;
        [self burstRemoved:nodeB];
        [self burstRemoved:nodeA];
    }
}


-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair coin:(CCNode *)nodeA walkingdigit:(CCNode *)nodeB
{
    float energy = [pair totalKineticEnergy];
    // if energy is large enough, remove the ninja
    if (energy > 0.0f)
    {
        _coins++;
        [self coinRemoved:nodeA];
        //        [_audio playEffect:@"hit_sound.mp3"];
        
    }
}

#pragma mark - Remove Stuff

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
    
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"BurstExplosion"];
    // clear effect , once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    // place the particle effect on the ninja position
    explosion.position = burst.position;
    [burst.parent addChild:explosion];
    
    [burst removeFromParentAndCleanup:YES];
}


- (void)coinRemoved:(CCNode *)coin {
    
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"BurstExplosion"];
    // clear effect , once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    // place the particle effect on the ninja position
    explosion.position = coin.position;
    [coin.parent addChild:explosion];
    
    [coin removeFromParentAndCleanup:YES];
}

- (void)digitRemoved:(CCNode *)digit {
    
    
    [digit removeFromParent];
    
}


- (void)startWalking
{
    // the animation manager of each node is stored in the 'userObject' property
    CCAnimationManager* animationManager = _walkingDigit.userObject;
    // timelines can be referenced and run by name
    [animationManager runAnimationsForSequenceNamed:@"Walking"];
}


-(void)gameOver{
    _menuButton.visible= NO;
    _mmButton.visible = YES;
    _physicsNode.paused = YES;
    _contentNode.userInteractionEnabled = FALSE;
    scrollSpeed = 0;
    _gameOverBg.visible = YES;
    _scoreLabel.visible = NO;
    _scoreLabelLabel.visible =NO;
    _coinLabel.visible = NO;
    
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeRight];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeLeft];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeUp];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeDown];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:_tap];
    
    
    _prefs = [NSUserDefaults standardUserDefaults];
    
    if (_score > _hiScore) {
        [_prefs setInteger:_score forKey:@"score"];
        [_prefs synchronize];
        CCLOG(@"High Score");
        _highScoreText.string = [NSString stringWithFormat:@"Congratulations you beat your high score!\nThe new one is %i", _score];
        
    } else
    {
        _highScoreText.string = [NSString stringWithFormat:@"Try to beat your high score of %li next time!", (long)_hiScore];
    }
    
}




- (void)replay{
    // reload this level
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
    
}


@end
