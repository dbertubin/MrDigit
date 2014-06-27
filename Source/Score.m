//
//  Score.m
//  MrDigit
//
//  Created by Derek Bertubin on 6/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Score.h"

@implementation Score

@synthesize score =_score;
@synthesize date =_date;
@synthesize initals =_initals;

-(void)setScore:(NSInteger)score{
    score= _score;
}

-(int)getScore{
    
    return _score;
}

-(void)setDate:(NSString *)date{
    date = _date;
}

-(NSString*)getDate{
    return _date;
}

-(void)setInitals:(NSString *)initals{
    initals = _initals;
}

-(NSString*)getInitial{
    return _initals;
}

@end

