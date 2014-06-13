//
//  Store.m
//  MrDigit
//
//  Created by Derek Bertubin on 6/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Store.h"

@implementation Store
{
    NSUserDefaults * _prefs;
    CCLabelTTF *_coinText;
    CCLabelTTF *_livesText;
    CCLabelTTF *_darkNinjaBurstText;
    int _coins;
    int _lives;
    int _darkNinjaBurstCount;
    
}

- (void)didLoadFromCCB {
     _prefs = [NSUserDefaults standardUserDefaults];
    _coins = [_prefs integerForKey:@"coins"];
    _lives = [_prefs integerForKey:@"lives"];
    _darkNinjaBurstCount = [_prefs integerForKey:@"darkninjaburst"];
}

- (void)showAlert {
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"You don't have enough coins to make this purchase" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)onBuyLife{
    
    if (_coins >= 10) {
        int newCount = _coins - 10;
        [_prefs setInteger:(_lives+1) forKey:@"lives"];
        [_prefs setInteger:newCount forKey:@"coins"];
        [_prefs synchronize];
        _coins = newCount;
        _lives++;
    } else {
        [self showAlert];
        
    }
    
    
}

-(void)onBuyDNB{
    
    if (_coins >= 10) {
        int newCount = _coins - 10;
        [_prefs setInteger:(_darkNinjaBurstCount+5) forKey:@"darkninjaburst"];
        [_prefs setInteger:newCount forKey:@"coins"];
        [_prefs synchronize];
        _coins = newCount;
        _darkNinjaBurstCount = _darkNinjaBurstCount + 5;
    } else {
        [self showAlert];
        
    }
    
    
}


-(void)onBack{
    CCScene *newScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:newScene];
    
    // access audio object
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    // play sound effect
    [audio playEffect:@"woodblock_hit.mp3"];
}

- (void)update:(CCTime)delta{
    _coinText.string = [NSString stringWithFormat:@"%d", _coins];
    _livesText.string = [NSString stringWithFormat:@"%d", _lives];
    _darkNinjaBurstText.string = [NSString stringWithFormat:@"%d" ,_darkNinjaBurstCount];
}

@end
