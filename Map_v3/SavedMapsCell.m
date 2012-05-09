//
//  SavedMapsCell.m
//  Map_v3.7
//
//  Created by Joy Tao on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SavedMapsCell.h"

@implementation SavedMapsCell

@synthesize mapObject = _mapObject;
@synthesize titleLabel, subtitleLabel, dateLabel;

- (void)dealloc
{
    [_mapObject release]; self.mapObject = nil;
    
    [titleLabel release];
    [subtitleLabel release];
    [dateLabel release];
    
    [super dealloc];
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) 
    {
        self.frame = CGRectMake(0, 0, self.frame.size.width, 50);
        
        // Initialize title and subtitle and date
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        
        subtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 30)];
        subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
        subtitleLabel.frame = CGRectOffset(subtitleLabel.frame, 0.0f, 21.0f);
        
        [self addSubview:titleLabel];
        [self addSubview:subtitleLabel];
    }
    
    return self;
}

- (void) setMapObject:(id)mapObject
{
    if (_mapObject == mapObject) return;
    [_mapObject release];
    _mapObject = [mapObject retain];
    
    MyMap * _theMap = (MyMap*)_mapObject;
    
    titleLabel.text = _theMap.mapTitle ? _theMap.mapTitle : @"Untitled Map";
    subtitleLabel.text = _theMap.mapAuthor ? _theMap.mapAuthor : @"Unknown Author";
}

@end
