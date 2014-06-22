//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"


@implementation MainScene
{
    NSUserDefaults * _prefs;
    BOOL _gameCenterEnabled;
    NSString *_leaderboardIdentifier;
}

- (void)didLoadFromCCB {
    
    
    [self authenticateLocalPlayer];
    
}




- (void)play {
    
    _prefs = [NSUserDefaults standardUserDefaults];
//    if ([_prefs boolForKey:@"firstRun"] == YES) {
    
        
        CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
        
        // access audio object
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        // play sound effect
        [audio playEffect:@"woodblock_hit.mp3"];
        
//    }
//    else
//    {
//        CCScene *tutScene = [CCBReader loadAsScene:@"Tutorial"];
//        [[CCDirector sharedDirector] replaceScene:tutScene];
//        
//        // access audio object
//        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
//        // play sound effect
//        [audio playEffect:@"woodblock_hit.mp3"];
//        
//        [_prefs setBool:YES forKey:@"firstRun"];
//        [_prefs synchronize];
//    }
//    
//    
}

-(void)credits{
    CCScene *creditsScene = [CCBReader loadAsScene:@"Leaderboard"];
    [[CCDirector sharedDirector] replaceScene:creditsScene];
    
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play sound effect
    [audio playEffect:@"woodblock_hit.mp3"];
    
}

-(void)onTut{
    CCScene *tutScene = [CCBReader loadAsScene:@"Tutorial"];
    [[CCDirector sharedDirector] replaceScene:tutScene];
    
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play sound effect
    [audio playEffect:@"woodblock_hit.mp3"];
    
    [_prefs setBool:YES forKey:@"firstRun"];
    [_prefs synchronize];
    
}

-(void)onStore{
    CCScene *newScene = [CCBReader loadAsScene:@"Store"];
    [[CCDirector sharedDirector] replaceScene:newScene];
    
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play sound effect
    [audio playEffect:@"woodblock_hit.mp3"];
}


-(void)authenticateLocalPlayer{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
            
//            UIView *viewCon = viewController.view;
//            
//            [[[CCDirector sharedDirector] view] addSubview:viewCon];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                _gameCenterEnabled = YES;
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        _leaderboardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            
            else{
                _gameCenterEnabled = NO;
            }
        }
    };
}




@end
