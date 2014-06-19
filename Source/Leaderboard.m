//
//  Leaderbaord.m
//  MrDigit
//
//  Created by Derek Bertubin on 6/18/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Leaderboard.h"

@implementation Leaderboard
{
    CCLabelTTF *_firstText;
    CCLabelTTF *_secondText;
    CCLabelTTF *_thirdText;
//    CCLabelTTF *_fourthText;
//    CCLabelTTF *_fifthText;
    
    CCLabelTTF *_firstScore;
    CCLabelTTF *_secondScore;
    CCLabelTTF *_thirdScore;
    int _firstScoreVal;
    int _secondScoreVal;
    int _thirdScoreVal;

    
    NSUserDefaults * _prefs;
}


- (void)didLoadFromCCB {
    _prefs = [NSUserDefaults standardUserDefaults];
    CCLOG(@"%@",[_prefs stringForKey:@"first"]);
    
    
    // Set first place text from NSUD
    if ([_prefs stringForKey:@"first"] != nil) {
        NSString * string = [_prefs stringForKey:@"first"];
        _firstText.string = string;
    }
    
    // Set second text from NSUD
    if ([_prefs stringForKey:@"second"] != nil) {
        _secondText.string =[_prefs stringForKey:@"second"];
    }
    
    // Set third text from NSUD
    if ([_prefs stringForKey:@"third"] != nil) {
        _thirdText.string =[_prefs stringForKey:@"third"];
    }
    

    
    
    if ([_prefs integerForKey:@"firstScore"] > 0) {
        _firstScore.string = [NSString stringWithFormat:@"%i",[_prefs integerForKey:@"firstScore"]];
    }
    
    if ([_prefs integerForKey:@"secondScore"] > 0) {
        _secondScore.string = [NSString stringWithFormat:@"%i",[_prefs integerForKey:@"secondScore"]];
    }
    
    if ([_prefs integerForKey:@"thirdScore"] > 0) {
        _thirdScore.string = [NSString stringWithFormat:@"%i",[_prefs integerForKey:@"thirdScore"]];
    }
    

    
}

-(void)onBack{
    CCScene *creditsScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:creditsScene];
    
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play sound effect
    [audio playEffect:@"woodblock_hit.mp3"];
    
}

@end
