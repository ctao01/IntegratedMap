//
//  KMLElement.h
//  KML Framework
//
//  Created by NextBusinessSystem on 11/12/01.
//  Copyright (c) 2011 NextBusinessSystem Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KMLType.h"


/** KMLElement is the root class of KML element hierarchies. 
 */
@interface KMLElement : NSObject


/// ---------------------------------
/// @name Accessing Element Properties
/// ---------------------------------

/** A parent KMLElement of the receiver.
 */
@property (weak, nonatomic) KMLElement *parent;


/// ---------------------------------
/// @name KML
/// ---------------------------------

/** Return the KML generated by the receiver.
 @return The KML string.
 */
- (NSString *)kml;

@end