//
//  SavedMapsCell.h
//  Map_v3.7
//
//  Created by Joy Tao on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IMLazyLoadTableViewCell.h"

@interface SavedMapsCell : IMLazyLoadTableViewCell

@property (nonatomic, retain) id mapObject;

@property (nonatomic, readonly) UILabel *titleLabel;        // maptitle
@property (nonatomic, readonly) UILabel *subtitleLabel;     // mapAuthor
@property (nonatomic, readonly) UILabel *dateLabel;         // mapCreatedTime

@property (nonatomic , readonly) UIImageView * gLogoImageview;

@end
