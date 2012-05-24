//
//  IMNotificationView.h
//  Map_v3.7
//
//  Created by Joy Tao on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IMNotificationView;

@protocol IMNotificationViewDelegate <NSObject>

- (void) selectedType:(NSUInteger)index;
@end


@interface IMNotificationView : UIView

@property (nonatomic , retain) NSArray * pinTypes;
@property (nonatomic , assign) NSUInteger  selectedType;
@property (nonatomic , retain) id < IMNotificationViewDelegate > delegate;


@end
