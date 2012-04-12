//
//  Annotation.m
//  Map_v1
//
//  Created by Joy Tao on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlacedPin.h"

@implementation PlacedPin

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;


- (id) initWithCoordinate : (CLLocationCoordinate2D) theCoordinate
{
    self = [super init];
    if (self != nil) coordinate = theCoordinate;
    
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)dealloc
{
	[title release];
	[subtitle release];
	
	[super dealloc];
}

#pragma mark - NSCoding

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:subtitle forKey:@"subtitle"];
    
    NSString * latStr = [NSString stringWithFormat:@"%f",coordinate.latitude];
    NSString * lngStr = [NSString stringWithFormat:@"%f",coordinate.longitude];

    
    [aCoder encodeObject:latStr forKey:@"Latitude"];
    [aCoder encodeObject:lngStr forKey:@"Longitude"];

}

- (id)initWithCoder:(NSCoder *)aDecoder 
{
    title = [aDecoder decodeObjectForKey:@"title"];
    subtitle = [aDecoder decodeObjectForKey:@"subtitle"];
    
    NSString * latStr = [aDecoder decodeObjectForKey:@"Latitude"];
    NSString * lngStr = [aDecoder decodeObjectForKey:@"Longitude"];
    
    coordinate.latitude = [latStr doubleValue];
    coordinate.longitude = [lngStr doubleValue];
    
    return self;

}

@end
