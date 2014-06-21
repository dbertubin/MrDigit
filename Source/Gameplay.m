//
//  Gameplay.m
//  MrDigit
//
//  Created by Derek Bertubin on 5/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

static const int MOVEBY = 100;

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
    WalkingDigit *_walkingDigit;
    CCNodeColor *_menuBg;
    CCNodeColor *_gameOverBg;
    CCButton *_resumeButton;
    CCButton *_mmButton;
    CCButton *_menuButton;
    CCButton *_replayButton;
    CCButton *_darkNinjaBurstButton;
    CCLabelTTF *_gameOverLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_scoreLabelLabel;
    CCLabelTTF *_coinLabel;
    CCLabelTTF *_highScoreText;
    CCLabelTTF *_livesText;
    CCLabelTTF *_darkNinjaBurstLabel;
    
    
    CCNode *_burst;
    CCNode *_ninja;
    CCNode *_darkNinja;
    CCNode *_coin;
    CCNode *_ninjaBurst;
    CCNode *_darkNinjaBurst;
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
    BOOL _hit;
    
    int _score;
    int _coins;
    int _lives;
    int _darkNinjaBurstCount;
    
    CGFloat scrollSpeed;
    NSInteger _hiScore;
    NSMutableArray *_nbursts;
    
    // Values to Feed Leaderboard
    NSInteger _firstScoreVal;
    NSInteger _secondScoreVal;
    NSInteger _thirdScoreVal;

    NSString *_dateString;
    
    
    NSInteger _firstScoreValAllTime;
    NSInteger _secondScoreValAllTime;
    NSInteger _thirdScoreValAllTime;
    
    NSMutableArray *_scoreArray;
    UITextField *_userInitials;
    
    
    NSMutableArray* _firstArray;

    int _tag;
    
    NSString *_leaderboardIdentifier;
}



- (void)didLoadFromCCB {
    
    
    _leaderboardIdentifier = @"Mr_Digit_Leaderboard";
    
    
    // set initail paused state
    isPaused =NO;
    
    // instanciate score at 0
    _score = 0;
    
    // instanciate Prefs and grab Hi Score
    _prefs = [NSUserDefaults standardUserDefaults];
    
    
    // Set values for gameplay vars
    _hiScore = [_prefs integerForKey:@"score"];
    _coins = [_prefs integerForKey:@"coins"];
    _lives = [_prefs integerForKey:@"lives"];
    _darkNinjaBurstCount = [_prefs integerForKey:@"darkninjaburst"];


    
    _firstScoreVal = [_prefs integerForKey:@"firstScore"];
//    _secondScoreVal = [_prefs integerForKey:@"secondScore"];
//    _thirdScoreVal = [_prefs integerForKey:@"thirdScore"];
//
//    
//    _firstScoreValAllTime = [_prefs integerForKey:@"firstScoreAllTime"];
//    _secondScoreValAllTime = [_prefs integerForKey:@"secondScoreAllTime"];
//    _thirdScoreValAllTime = [_prefs integerForKey:@"thirdScoreAllTime"];
//    

    
    
    
    // Set menus to invisible
    _gameOverBg.visible = NO;
    _menuBg.visible = NO;
    
    // set scroll speed
    scrollSpeed= 70.f;
    
    //Set grounds in array to loop in update
    _grounds = @[_ground1, _ground2];
    
    
    // Assign delegate
    _physicsNode.collisionDelegate = self;
    
    
    _walkingDigit = (WalkingDigit*)[CCBReader load:@"WalkingDigit"];
    [_physicsNode addChild:_walkingDigit];
    _walkingDigit.physicsBody.collisionType =@"walkingdigit";
    _walkingDigit.position = ccp(25, 45);
    _walkingDigit.scale = 2;
    
    
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    // visualize physics bodies & joints
    //    _physicsNode.debugDraw = TRUE;
    
    // play sound background
    _audio= [OALSimpleAudio sharedInstance];
    //    [_audio playBg:@"background.mp3" loop:true];
    
    
    /************************************************************************************
     Set up Gestures
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
    
}


#pragma mark - Button actions
- (void)onMenu{
    [_audio playEffect:@"woodblock_hit.mp3"];
    
    if (isPaused == NO) {
        [[CCDirector sharedDirector] pause];
        _physicsNode.paused = YES;
        _physicsNode.userInteractionEnabled = NO;
        _contentNode.userInteractionEnabled = NO;
        scrollSpeed = 0;
        isPaused = YES;
        _menuBg.visible = YES;
        _resumeButton.visible = YES;
        _mmButton.visible = YES;
        _replayButton.visible = NO;
        _gameOverLabel.visible = NO;
        _menuButton.visible= NO;
        _audio.paused = YES;
        
        
    }
    else
    {
        _physicsNode.paused = NO;
        _contentNode.userInteractionEnabled = YES ;
        _physicsNode.userInteractionEnabled = YES;
        scrollSpeed = 70;
        isPaused = NO;
        _menuBg.visible = NO;
        _resumeButton.visible = NO;
        _mmButton.visible = NO;
        _menuButton.visible= YES;
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

- (void)replay{
    // reload this level
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
    
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
        _destinationPoint=  CGPointMake(_walkingDigit.position.x , _walkingDigit.position.y + MOVEBY);
        [self startWalking];
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
        // set BOOLS direction
        movedUp = false;
        movedDown = false;
        movedLeft = false;
        movedRight = true;
    }
    
}
#pragma mark - Update
/********************************************************************************
 *
 *                               UPDATE STARTS HERE
 *
 ********************************************************************************/

- (void)update:(CCTime)delta
{
    
    // Set Values for string labels
    _scoreLabel.string = [NSString stringWithFormat:@"%d", _score];
    _coinLabel.string = [NSString stringWithFormat:@"%d", _coins ];
    _livesText.string = [NSString stringWithFormat:@"%d",_lives];
    _darkNinjaBurstLabel.string = [NSString stringWithFormat:@"%d",_darkNinjaBurstCount];
    

    if (_darkNinjaBurstCount<1) {
        _darkNinjaBurstButton.visible = NO;
        _darkNinjaBurstLabel.visible = NO;
    }
    
    
#pragma mark
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
    
    
    /********************************************************************************
     counter by frame increment to increate frequency of spawning
     *******************************************************************************/
    
    _intensity++;
    
    
    if (_intensity > 6000 && _intensity < 11999) {
        CCLOG(@"Intensity++");
        minDelay = 0.5;
        maxDelay = 2.5;
    }
    
    if (_intensity > 12000 && _intensity < 15999) {
        
        minDelay = 0.5;
        maxDelay = 2.0;
        CCLOG(@"Intensity++++");
    }
    
    if (_intensity > 18000) {
        minDelay = 0.5;
        maxDelay = 1.0;
        CCLOG(@"Intensity++++");
    }
    
    if (_intensity < 600) {
        CCLOG(@"Intensity++");
        

        minDelay = 0.5;
        maxDelay = 3.0;
    }
    
    
    /********************************************************************************
     Check to see if paused to spawn coins and ninjas
     *******************************************************************************/
    
    if (isPaused==NO) {
        
        u_int32_t delta = (u_int32_t) (ABS(maxDelay-minDelay)*1000);  // ms resolution
        float randomDelta = arc4random_uniform(delta)/1000.;          // now in seconds
        
        [self scheduleOnce:@selector(addNinja:) delay:randomDelta];
        [self scheduleOnce:@selector(addCoin:) delay:randomDelta];
        if (_intensity > 300) {
            [self scheduleOnce:@selector(addDarkNinja:) delay:randomDelta*5];
        }
        
    } else {
        // nothing
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
    
    
    if (_coin.position.x <=  -10 || _coin.position.y > _contentNode.contentSize.height || _coin.position.x > _contentNode.contentSize.width + 40) {
        
        [_coin removeFromParent];
        CCLOG(@"Coin removed");
    }
    
    /*****************************************************************************
     Movements Based on Delta
     *****************************************************************************/
    
    if (movedUp) {
        
        CGPoint difValx;
        difValx.y = fabsf(_destinationPoint.y - _walkingDigit.position.y  );
        CGPoint newlocaton =  CGPointMake(_walkingDigit.position.x , _destinationPoint.y);
        CCActionMoveTo * moveTo = [CCActionMoveTo actionWithDuration:0.20f position:newlocaton];
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
        CCActionMoveTo * moveTo = [CCActionMoveTo actionWithDuration:0.10f position:newlocaton];
        [_walkingDigit runAction:moveTo];

    }
    
    
    if (movedLeft)
    {
        CGPoint difValx;
        difValx.x = fabsf(_destinationPoint.x - _walkingDigit.position.x  );
        CGPoint newlocaton =  CGPointMake(_walkingDigit.position.x - (difValx.x*delta), _walkingDigit.position.y);
        CCActionMoveTo * moveTo = [CCActionMoveTo actionWithDuration:0.10f position:newlocaton];
        [_walkingDigit runAction:moveTo];
        //        if (_walkingDigit.position.x > _destinationPoint.x) {
        //            _walkingDigit.position = newlocaton;
        //        }else if(_walkingDigit.position.x == _destinationPoint.x){
        //
        //        }
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
    _ninja.physicsBody.collisionGroup = @"darkNinjaBurstToNinja";
    _ninja.physicsBody.collisionGroup = @"ninjaToNinjaBurst";
    _ninja.physicsBody.collisionMask = [[NSArray alloc]initWithObjects:@"burst", nil];
    _ninja.position = CGPointMake(self.contentSize.width + _ninja.contentSize.width/2, _walkingDigit.position.y);
    
    [_physicsNode addChild:_ninja];
    
    if (isPaused==NO) {
        [self scheduleOnce:@selector(launchNinjaBurst) delay:.5f];
    }
    
    
    CCAction *actionMove = [CCActionMoveTo actionWithDuration:7 position:CGPointMake(-_ninja.contentSize.width/2 + 20, _walkingDigit.position.y)];
    CCAction *actionRemove = [CCActionRemove action];
    [_ninja runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    
}

- (void)addDarkNinja:(CCTime)dt {
    
    
    int sort = 0;
    sort ++;
    _darkNinja = (Ninja*)[CCBReader load:@"DarkNinja"];
    _darkNinja.physicsBody.collisionType = @"darkninja";
    _darkNinja.physicsBody.collisionGroup = @"groupb";
    _darkNinja.physicsBody.collisionGroup = @"group";
    _darkNinja.scale =2.0f;
    _darkNinja.zOrder= sort;
    _darkNinja.position = CGPointMake(self.contentSize.width + _darkNinja.contentSize.width/2, _walkingDigit.position.y);
    
    [_physicsNode addChild:_darkNinja];
    

    CCAction *actionMove = [CCActionMoveTo actionWithDuration:7 position:CGPointMake(-_darkNinja.contentSize.width/2 + 20, _walkingDigit.position.y)];
    CCAction *actionRemove = [CCActionRemove action];
    [_darkNinja runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
    
}


- (void)addCoin:(CCTime)dt {
    
    
    int sort = 0;
    sort ++;
    _coin = (Coin*)[CCBReader load:@"Coin"];
    _coin.scale =.2f;
    _coin.zOrder= sort;
    _coin.physicsBody.collisionMask = [[NSArray alloc]initWithObjects:@"burst", nil];
    
    _coin.position = CGPointMake(self.contentSize.width + _coin.contentSize.width/2, 150);
    
    [_physicsNode addChild:_coin];
    
    
    CGPoint launchDirection = ccp(-1, 0);
    CGPoint force = ccpMult(launchDirection, 50000);
    [_coin.physicsBody applyForce:force];
    
    
}


- (void)launchBurst:(UITapGestureRecognizer*)tap {
    
    if (isPaused== NO) {
        // loads the Penguin.ccb we have set up in Spritebuilder
        _burst = [CCBReader load:@"Burst"];
        _burst.scale = .5f;
        CCLOG(@"loads the Burst.ccb");
//        _burst.physicsBody.collisionGroup = @"burstToNinjaBurst";
        _burst.physicsBody.collisionGroup = @"groupb";
        _burst.physicsBody.collisionGroup = @"group";
        _burst.position = ccpAdd(_walkingDigit.position, ccp(35 , 10));
        
        [_physicsNode addChild:_burst];
        [_audio playEffect:@"fire_sound.mp3"];
        
        // manually create & apply a force to launch the burst
        CGPoint launchDirection = ccp(1, 0                  );
        CGPoint force = ccpMult(launchDirection, 500000);
        [_burst.physicsBody applyForce:force];
    }
    
}

- (void)launchDarkNinjaBurst{
    
    if (isPaused== NO) {
        if (_darkNinjaBurstCount > 0)
        {
            _darkNinjaBurstCount--;
            // loads the Penguin.ccb we have set up in Spritebuilder
            _darkNinjaBurst = [CCBReader load:@"DarkNinjaBurst"];
            _darkNinjaBurst.physicsBody.collisionType = @"darkninjaburst";
            _darkNinjaBurst.physicsBody.collisionGroup = @"darkNinjaBurstToNinja";
            _darkNinjaBurst.scale = .5f;
            _darkNinjaBurst.position = ccpAdd(_walkingDigit.position, ccp(35 , 10));
            
            [_physicsNode addChild:_darkNinjaBurst];
            [_audio playEffect:@"fire_sound.mp3"];
            
            // manually create & apply a force to launch the burst
            CGPoint launchDirection = ccp(1, 0                  );
            CGPoint force = ccpMult(launchDirection, 500000);
            [_darkNinjaBurst.physicsBody applyForce:force];
            
        }
        else
        {
            _darkNinjaBurstButton.visible = NO;
            _darkNinjaBurstLabel.visible = NO;
        }
    }
    
}


- (void)launchNinjaBurst{
    
    int sort = 0;
    sort ++;
    if (_ninja.position.x < _contentNode.contentSize.width) {
        // loads the Penguin.ccb we have set up in Spritebuilder
        _ninjaBurst = [CCBReader load:@"NinjaBurst"];
        _ninjaBurst.physicsBody.collisionGroup = @"ninjaToNinjaBurst";
        _ninjaBurst.physicsBody.collisionGroup = @"group";
        
        _ninjaBurst.scale = .5f;
        _ninjaBurst.position = ccpAdd(_ninja.position, ccp(-35 , 20));
        [_physicsNode addChild:_ninjaBurst];
        [_audio playEffect:@"fire_sound.mp3"];
        
        
        CCAction *actionMove = [CCActionMoveTo actionWithDuration:2.25f position:CGPointMake(-_ninja.contentSize.width/2 + 20, _walkingDigit.position.y)];
        CCAction *actionRemove = [CCActionRemove action];
        [_ninjaBurst runAction:[CCActionSequence actionWithArray:@[actionMove,actionRemove]]];
        

    }
    
    
}

/*****************************************************************************
 COLLISIONS
 *****************************************************************************/

#pragma mark - Collisions

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ninja:(CCNode *)nodeA burst:(CCNode *)nodeB
{
    
    _score++;
    [self ninjaRemoved:nodeA];
    [self burstRemoved:nodeB];
    [_audio playEffect:@"hit_sound.mp3"];
    
}


-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair darkninja:(CCNode *)nodeA darkninjaburst:(CCNode *)nodeB
{
    
    _score = _score + 5;
    [self ninjaRemoved:nodeA];
    [self burstRemoved:nodeB];
    [_audio playEffect:@"hit_sound.mp3"];
    
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair walkingdigit:(CCNode *)nodeA ninjaburst:(CCNode *)nodeB
{
    
    [self burstRemoved:nodeB];
    [self gameOver];
    
}


-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair walkingdigit:(CCNode *)nodeA ninja:(CCNode *)nodeB
{
    
    [self ninjaRemoved:nodeB];
    //        [self digitRemoved:nodeA];
    //        [_audio playEffect:@"hit_sound.mp3"];
    [self gameOver];
    
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair walkingdigit:(CCNode *)nodeA darkninja:(CCNode *)nodeB
{
    
    [self gameOver];
    
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair coin:(CCNode *)nodeA walkingdigit:(CCNode *)nodeB
{
    _coins++;
    [self coinRemoved:nodeA];
    //        [_audio playEffect:@"hit_sound.mp3"];
    
    
}

-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair coin:(CCNode *)nodeA burst:(CCNode *)nodeB
{
    
    [self coinRemoved:nodeA];
    [self burstRemoved:nodeB];
    //        [_audio playEffect:@"hit_sound.mp3"];
    
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
    [self unschedule:@selector(launchNinjaBurst)];
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
    
    if (_lives > 0)
    {
        _lives--;
        
    }
    else if(_lives ==0)
    {
        [self reportScore];
        
        _menuButton.visible= NO;
        _mmButton.visible = YES;
        _physicsNode.paused = YES;
        _contentNode.userInteractionEnabled = FALSE;
        scrollSpeed = 0;
        _gameOverBg.visible = YES;
        _scoreLabel.visible = NO;
        _scoreLabelLabel.visible =NO;
        _coinLabel.visible = NO;
        
        
        NSDate *localDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"MM/dd/yy";
        
        _dateString = [dateFormatter stringFromDate: localDate];
        
        // remove touch thingys
        [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeRight];
        [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeLeft];
        [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeUp];
        [[[CCDirector sharedDirector] view] removeGestureRecognizer:_swipeDown];
        [[[CCDirector sharedDirector] view] removeGestureRecognizer:_tap];
        
        
        
        // clean up and sets scores
        _prefs = [NSUserDefaults standardUserDefaults];
        
        

        
        
        if (_score > _firstScoreVal) {
            
            _tag= 1;
            
            // BUMP THE VALUES DOWN THE CHAIN
            
            _thirdScoreVal =_secondScoreVal;
            _secondScoreVal = _firstScoreVal;
            _firstScoreVal = _score;
            
            CCLOG(@"%i",_secondScoreVal);
            CCLOG(@"%i",_thirdScoreVal);
            
            
            
            _highScoreText.string = [NSString stringWithFormat:@"Congratulations you beat your high score!\nThe new one is %i", _score];
            [_prefs setInteger:_firstScoreVal forKey:@"firstScore"];
            [_prefs setInteger:_secondScoreVal forKey:@"secondScore"];
            [_prefs setInteger:_thirdScoreVal forKey:@"thirdScore"];
            
            
            [self newScoreAlert];
            //            [_prefs setObject:_userInitials.text forKey:@"first"];
            CCLOG(@"%@",_userInitials.text);
        }
        
        
        if (_score < _firstScoreVal &&  _score > _secondScoreVal){
            
            _tag = 2;
            _thirdScoreVal =_secondScoreVal;
            _secondScoreVal = _score;
            
            [_prefs setInteger:_secondScoreVal forKey:@"secondScore"];
            [_prefs setInteger:_thirdScoreVal forKey:@"thirdScore"];
            
            
            
            [_prefs setInteger:_score forKey:@"secondScore"];
            
            
            [self newScoreAlert];
            //            [_prefs setObject:_userInitials forKey:@"second"];
            
        }
        
        if (_score < _secondScoreVal && _score > _thirdScoreVal){
            
            _tag = 3;
            _thirdScoreVal =_score;
            
            
            [_prefs setInteger:_thirdScoreVal forKey:@"thirdScore"];
            
            
            [self newScoreAlert];
            //            [_prefs setObject:_userInitials forKey:@"third"];
            
        }
        else{
            _highScoreText.string = [NSString stringWithFormat:@"Try to beat your high score of %li next time!", (long)_firstScoreVal];
        }
        
        
        [_prefs setInteger:_coins forKey:@"coins"];
        [_prefs setInteger:_lives forKey:@"lives"];
        [_prefs setInteger:_darkNinjaBurstCount forKey:@"darkninjaburst"];
        [_prefs synchronize];
    }
}



-(void)newScoreAlert{
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"New High Score" message:@"Enter your initials" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"Ok"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"You have clicked Cancel");
    }
    else if(buttonIndex == 1)
    {
        _userInitials = [alertView textFieldAtIndex:0];
        
        if (_tag ==1) {
            [_prefs setObject:_userInitials.text forKey:@"first"];
            
        } else if (_tag == 2){
            [_prefs setObject:_userInitials.text forKey:@"second"];
        } else if (_tag==3){
            [_prefs setObject:_userInitials.text forKey:@"third"];
            
        }
        
        [_prefs synchronize];
        
    }
    
}

-(void)reportScore{
    GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:_leaderboardIdentifier];
    score.value = _score;
    
    [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

@end
