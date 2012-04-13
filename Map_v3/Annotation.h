//
//  Annotation.h
//  Map_v1
//
//  Created by Joy Tao on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKAnnotation.h>

@interface Annotation : NSObject < MKAnnotation , NSCoding >

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

- (id) initWithCoordinate : (CLLocationCoordinate2D) theCoordinate;

@end
