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
    
    
}

- (void)didLoadFromCCB {
    
    
    
    
}
- (void)play {
    
    _prefs = [NSUserDefaults standardUserDefaults];
    if ([_prefs boolForKey:@"firstRun"] == YES) {
        
        
        CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
        
        // access audio object
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        // play sound effect
        [audio playEffect:@"woodblock_hit.mp3"];
        
    }
    else
    {
        CCScene *tutScene = [CCBReader loadAsScene:@"Tutorial"];
        [[CCDirector sharedDirector] replaceScene:tutScene];
        
        // access audio object
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        // play sound effect
        [audio playEffect:@"woodblock_hit.mp3"];
        
        [_prefs setBool:YES forKey:@"firstRun"];
        [_prefs synchronize];
    }
    
    
}

-(void)credits{
    CCScene *creditsScene = [CCBReader loadAsScene:@"Credits"];
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


@end
