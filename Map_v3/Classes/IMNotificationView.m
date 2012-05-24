//
//  IMNotificationView.m
//  Map_v3.7
//
//  Created by Joy Tao on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IMNotificationView.h"

@implementation IMNotificationView
@synthesize pinTypes, selectedType , delegate = _delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        UIImageView * bgImageView = [[UIImageView alloc]initWithFrame:self.frame];
//        bgImageView.image = [UIImage imageNamed:@"notificationToast"];
//        
//        [self addSubview:bgImageView];
//        [bgImageView release];
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | 
                                UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) setPinTypes:(NSArray *)array
{
    if (pinTypes != array) {
        for (UIButton * button in pinTypes) 
            [button removeFromSuperview];
        
        pinTypes =  array;
        
        for (UIButton * button in pinTypes) 
        {
            button.userInteractionEnabled = YES;
            [button addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchDown];
            
        }
        
        [self setNeedsLayout];
    }
    
    
}

@end
