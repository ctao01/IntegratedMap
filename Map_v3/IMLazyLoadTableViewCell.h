//
//  UZLazyLoadTableViewCell.h
//  UrbanZombie
//
//  Created by Justin Leger on 4/10/12.
//  Copyright (c) 2012 Leger Incorporated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMLazyLoadTableViewCell : UITableViewCell

- (void) addLazyLoadImage:(UIImageView *)image;

- (void) removeLazyLoadImage:(UIImageView *)image;

- (void) loadLazyLoadImages;


@end
