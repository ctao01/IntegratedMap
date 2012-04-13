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
//    NSString * _mapContent;
    NSMutableArray * _myPlaces;
}

@property (nonatomic , retain) NSString * mapTitle;
@property (nonatomic , retain) NSString * mapAuthor;
@property (nonatomic , retain) NSDate * mapCreatedTime;
//@property (nonatomic , retain) NSString * mapContent;
@property (nonatomic , retain) NSMutableArray * myPlaces;


+(NSArray *)keys;
-(id)initWithDictionary: (NSDictionary*)dictionary;

@end
