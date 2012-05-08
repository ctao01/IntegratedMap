//
//  MyMap.h
//  Map_v3
//
//  Created by Joy Tao on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyMap : NSObject
{
    NSString * _mapTitle;
    NSString * _mapAuthor;
    NSDate * _mapCreatedTime;
    NSMutableArray * _myPlaces;
    
    NSString * _mapImagePath;
    
    BOOL update;
    BOOL upload;
}

@property (nonatomic , retain) NSString * mapTitle;
@property (nonatomic , retain) NSString * mapAuthor;
@property (nonatomic , retain) NSDate * mapCreatedTime;
@property (nonatomic , retain) NSMutableArray * myPlaces;
@property (nonatomic , retain) NSString * mapImagePath;

@property (nonatomic , assign) BOOL update;
@property (nonatomic , assign) BOOL upload;

+(NSArray *)keys;
-(id)initWithDictionary: (NSDictionary*)dictionary;

@end
