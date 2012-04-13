//
//  MyPlace.h
//  Map_v3
//
//  Created by Joy Tao on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPlace : NSObject {
    NSString *_comment;
	
	NSNumber *_latitude;
	NSNumber *_longitude;
	
	NSString *_locationName;
	NSDate *_timestamp;
    
    NSString * _streetAddress;
    NSString * _subStreetAddress;
    NSString * _city;
    NSString * _zipCode;
    NSString * _state;
    NSString * _country;
}

@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, retain) NSString *locationName;
@property (nonatomic, retain) NSDate *timestamp;
@property (nonatomic, retain, readonly) NSString *time;

@property (nonatomic, retain) NSString *streetAddress;
@property (nonatomic, retain) NSString *subStreetAddress;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *zipCode;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *country;


+(NSArray *)keys;
-(id)initWithDictionary: (NSDictionary*)dictionary;

@end
