//
//  MyMap.m
//  Map_v3
//
//  Created by Joy Tao on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyMap.h"

@implementation MyMap
@synthesize mapTitle = _mapTitle;
@synthesize mapAuthor = _mapAuthor;
@synthesize mapCreatedTime = _mapCreatedTime;
//@synthesize mapContent = _mapContent;
@synthesize myPlaces = _myPlaces;
@synthesize update, upload;

- (void) dealloc
{
    [_mapTitle release];
    [_mapAuthor release];
    [_mapCreatedTime release];
    [_myPlaces release];
        
    [super dealloc];
}

+(NSArray *)keys {
	
	return [NSArray arrayWithObjects:
			@"mapTitle",
			@"mapAuthor",
			@"mapCreatedTime",
			@"myPlaces",
            @"upload",
            @"update",
			nil];
}

- (id) init
{
    self = [super init];

    
    return self;
}

-(id)initWithDictionary: (NSDictionary*)dictionary
{
    self= [self init];
    
    NSMutableDictionary *mutableDict = [dictionary mutableCopy];
    [self setValuesForKeysWithDictionary: mutableDict];
    
    return self;
}


@end
