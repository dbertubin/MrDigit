//
//  Credits.m
//  MrDigit
//
//  Created by Derek Bertubin on 5/26/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Credits.h"

@implementation Credits

-(void)onBack{
    CCScene *creditsScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:creditsScene];
    
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play sound effect
    [audio playEffect:@"woodblock_hit.mp3"];
    
}


@end
