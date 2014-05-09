//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene
- (void)play {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play sound effect
    [audio playEffect:@"woodblock_hit.mp3"];
}
@end
