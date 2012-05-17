//
//  MyPlace.m
//  Map_v3
//
//  Created by Joy Tao on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyPlace.h"

@implementation MyPlace

@synthesize comment=_comment;
@synthesize locationName=_locationName;

@synthesize timestamp=_timestamp;
@dynamic time;

@synthesize latitude=_latitude;
@synthesize longitude=_longitude;


@synthesize streetAddress = _streetAddress;
@synthesize subStreetAddress = _subStreetAddress;
@synthesize city = _city;
@synthesize zipCode = _zipCode;
@synthesize state = _state;
@synthesize country = _country;

-(void)dealloc {
	
	//[_locCoordinates release];
	[_comment release];
	[_locationName release];
	[_timestamp release];	
	[_latitude release];
	[_longitude release];
    
    [_streetAddress release];
    [_subStreetAddress release];
    [_city release];
    [_zipCode release];
    [_state release];
    [_country release];
    
    [super dealloc];
}

+(NSArray *)keys {
	
	return [NSArray arrayWithObjects:
			@"comment",
			@"latitude",
			@"longitude",
			@"locationName",
			@"timestamp",
            @"streetAddress",
            @"subStreetAddress",
            @"city",
            @"zipCode",
            @"state",
            @"country",
			nil];
}

-(id)init {
	
	self= [super init];
	return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary {
    
	self= [self init];
	
    NSMutableDictionary *mutableDict = [dictionary mutableCopy];
    [self setValuesForKeysWithDictionary: mutableDict];
    [mutableDict release];
    
	return self;
}

@end
