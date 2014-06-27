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
    
    CCLabelTTF *_firstScore;
    CCLabelTTF *_secondScore;
    CCLabelTTF *_thirdScore;
    
    CCLabelTTF *_firstScoreDate;
    CCLabelTTF *_secondScoreDate;
    CCLabelTTF *_thirdScoreDate;
    
    int _firstScoreVal;
    int _secondScoreVal;
    int _thirdScoreVal;
    
    NSInteger _firstScoreValAllTime;
    NSInteger _secondScoreValAllTime;
    NSInteger _thirdScoreValAllTime;

    NSMutableArray* _firstArray;
    NSString* leaderboardID;
    
    NSUserDefaults * _prefs;
}


- (void)didLoadFromCCB {
    _prefs = [NSUserDefaults standardUserDefaults];
    CCLOG(@"%@",[_prefs stringForKey:@"first"]);
    leaderboardID = @"Mr_Digit_Leaderboard";
    
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

-(void)onToday{
    

}

-(void)onAllTime{
    
}


-(void)makePost:(NSString*)conCatedStringWithItem
{
    SLComposeViewController * postController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    if (postController != nil)
    {
        
        
        [postController setInitialText:conCatedStringWithItem];
        
        UIView *view = postController.view;
        
        [[[CCDirector sharedDirector] view] addSubview:view];
//        [self presentViewController:postController animated:YES completion:nil];
        
        postController.completionHandler = ^(SLComposeViewControllerResult result)
        {
            if (result == SLComposeViewControllerResultDone)
            {
                [[[CCDirector sharedDirector] view]removeFromSuperview];
//                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else if (result == SLComposeViewControllerResultCancelled)
            {
                [[[CCDirector sharedDirector] view]removeFromSuperview];
//                [self dismissViewControllerAnimated:YES completion:nil];
                NSLog(@"User Cancelled");
            }
        };
        
        
    }
}


-(void)onGC{
    [self showLeaderboard:leaderboardID];
}

- (void) showLeaderboard: (NSString*) leaderboardID
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateAchievements;
        [[CCDirector sharedDirector] presentViewController: gameCenterController animated: YES completion:nil];
    }
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
