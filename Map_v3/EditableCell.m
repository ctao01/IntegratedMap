//
//  EditableCell.m
//  Map_v3
//
//  Created by Joy Tao on 3/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditableCell.h"

@implementation EditableCell
@synthesize textField;


#pragma mark -

- (void) dealloc
{
    [textField performSelector:@selector(release)
                    withObject:nil 
                    afterDelay:1.0];
    
    [super dealloc];
}

#pragma mark -
#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self == nil)
    {
        return nil;
    }
    
    CGRect bounds = [[self contentView] bounds];
    CGRect rect = CGRectInset(bounds, 20.0, 10.0);
    //UITextField *textField = [[UITextField alloc] initWithFrame:rect];
    textField = [[UITextField alloc] initWithFrame:rect];
    
    //  Set the keyboard's return key label to 'Next'.
    //
    [textField setReturnKeyType:UIReturnKeyNext];
    
    //  Make the clear button appear automatically.
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textField setBackgroundColor:[UIColor clearColor]];
    [textField setOpaque:YES];
    
    [[self contentView] addSubview:textField];
    [self setTextField:textField];
    
    [textField release];    
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Configure the view for the selected state
}

@end
