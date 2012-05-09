//
//  UZLazyLoadTableViewCell.m
//  UrbanZombie
//
//  Created by Justin Leger on 4/10/12.
//  Copyright (c) 2012 Leger Incorporated. All rights reserved.
//

#import "IMLazyLoadTableViewCell.h"
#import "UIImageView+WebCache.h"
//#import "SDImageCache.h"

@interface IMLazyLoadTableViewCell () {
	NSMutableArray * _lazyLoadImages;
}
@end

@implementation IMLazyLoadTableViewCell

- (void) dealloc
{	
	if ([_lazyLoadImages count] > 0)
		[_lazyLoadImages makeObjectsPerformSelector:@selector(cancelCurrentImageLoad)];
	
	[_lazyLoadImages release];
	
	[super dealloc];
	 
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		_lazyLoadImages = [[NSMutableArray alloc] init];
//        NSLog(@"Count %i", [_lazyLoadImages count]);
	}
	return self;
}

- (void) addLazyLoadImage:(UIImageView *)image
{
	if (![_lazyLoadImages containsObject:image])
		[_lazyLoadImages addObject:image];
//    NSLog(@"Count %i", [_lazyLoadImages count]);
}

- (void) removeLazyLoadImage:(UIImageView *)image
{
//	if (![_lazyLoadImages containsObject:image]) {
		[_lazyLoadImages removeObject:image];
		[image cancelCurrentImageLoad];
//	}
//    NSLog(@"Count %i", [_lazyLoadImages count]);
}

- (void) loadLazyLoadImages
{
	if ([_lazyLoadImages count] > 0) {
		[_lazyLoadImages makeObjectsPerformSelector:@selector(startDownloadWithOptions:) withObject:nil];
    }
}



@end
