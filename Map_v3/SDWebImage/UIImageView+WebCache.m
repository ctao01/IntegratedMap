/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */
#import <objc/runtime.h>
#import "UIImageView+WebCache.h"

static char const * const URLKey = "URLKey";

@implementation UIImageView (WebCache)

@dynamic imageURL;

- (id)imageURL {
    return objc_getAssociatedObject(self, URLKey);
}

- (void)setImageURL:(id)aImageURL {
    objc_setAssociatedObject(self, URLKey, aImageURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        self.imageURL = url;
        
        UIImage *image = [manager imageWithURL:url];
        
        if (image) {
            self.image = image;
            return;
        }
        
        // TODO: What if option is nil
        if ( !options || (options & ~SDWebImageLazyLoad) )
            [self startDownloadWithOptions:options];
    }
}

- (void)startDownloadWithOptions:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadWithURL:self.imageURL delegate:self options:options];
}



- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = image;
}

@end
