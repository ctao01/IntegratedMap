//
//  EditableCell.h
//  Map_v3
//
//  Created by Joy Tao on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditableCell : UITableViewCell 
{
    UITextField * textField;
}

@property (nonatomic , retain) UITextField * textField;

@end
