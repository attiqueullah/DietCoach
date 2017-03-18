// UIImageView+AFNetworking.m
//
// Copyright (c) 2011 Gowalla (http://gowalla.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
#import "UIImageView+AFNetworking.h"

static char * const kIndexPathAssociationKey = "JK_indexPath";
@interface AFImageCache : NSCache
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;
- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request;
- (UIImage *)cachedImageForURL:(NSURL *)url;
@end

#pragma mark -

static char kAFImageRequestOperationObjectKey;

@interface UIImageView (_AFNetworking)
@property (readwrite, nonatomic, strong, setter = af_setImageRequestOperation:) AFImageRequestOperation *af_imageRequestOperation;
@end

@implementation UIImageView (_AFNetworking)
@dynamic af_imageRequestOperation;
@end

#pragma mark -

@implementation UIImageView (AFNetworking)

- (AFHTTPRequestOperation *)af_imageRequestOperation {
    return (AFHTTPRequestOperation *)objc_getAssociatedObject(self, &kAFImageRequestOperationObjectKey);
}

- (void)af_setImageRequestOperation:(AFImageRequestOperation *)imageRequestOperation {
    objc_setAssociatedObject(self, &kAFImageRequestOperationObjectKey, imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSOperationQueue *)af_sharedImageRequestOperationQueue {
    static NSOperationQueue *_af_imageRequestOperationQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_af_imageRequestOperationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    });

    return _af_imageRequestOperationQueue;
}

+ (AFImageCache *)af_sharedImageCache {
    static AFImageCache *_af_imageCache = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _af_imageCache = [[AFImageCache alloc] init];
    });

    return _af_imageCache;
}

#pragma mark -

- (void)setImageWithURL:(NSURL *)url {
    
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:nil failure:nil];
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest
              placeholderImage:(UIImage *)placeholderImage
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{

    [self setImage:nil];

    [self cancelImageRequestOperation];
    
     UIImage *cachedImage= [[[self class] af_sharedImageCache] cachedImageForRequest:urlRequest];
        if (cachedImage) {
        self.af_imageRequestOperation = nil;

        if (success) {
            success(nil, nil, cachedImage);
        } else {
            self.image = cachedImage;
        }
    } else {
        if (placeholderImage) {
            self.image = placeholderImage;
        }

        AFImageRequestOperation *requestOperation = [[AFImageRequestOperation alloc] initWithRequest:urlRequest];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, UIImage* responseObject) {
            if ([urlRequest isEqual:[self.af_imageRequestOperation request]]) {
                if (self.af_imageRequestOperation == operation) {
                    self.af_imageRequestOperation = nil;
                }
                if (success) {
                    
                    success(operation.request, operation.response, responseObject);
                } else if (responseObject) {
                    
                    self.image = responseObject;
                }
            }

            [[[self class] af_sharedImageCache] cacheImage:responseObject forRequest:urlRequest];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([urlRequest isEqual:[self.af_imageRequestOperation request]]) {
                if (self.af_imageRequestOperation == operation) {
                    self.af_imageRequestOperation = nil;
                }

                if (failure) {
                    failure(operation.request, operation.response, error);
                }
            }
        }];

        self.af_imageRequestOperation = requestOperation;

        [[[self class] af_sharedImageRequestOperationQueue] addOperation:self.af_imageRequestOperation];
    }
}
-(void)downloadImageUsingURL:(NSURL*)strURL
{
    [self setImageUsingURL:strURL success:nil failure:nil];
}
-(void)setImageUsingURL:(NSURL*)imgUrl
             success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
             failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    [self setImage:nil];
    
    [self cancelImageRequestOperation];
        UIImage *cachedImage= [[[self class] af_sharedImageCache] cachedImageForURL:imgUrl];
    if (cachedImage) {
        self.af_imageRequestOperation = nil;
        
        if (success) {
            success(nil, nil, cachedImage);
        } else {
            self.image = cachedImage;
        }
    }
    UIImage *image2 = [[[self class] af_sharedImageCache] objectForKey:imgUrl];
	if (image2 ) {
        [self setImage:image2];
	} else {
		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        objc_setAssociatedObject(self, &kAFImageRequestOperationObjectKey, imgUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:imgUrl];
            UIImage *image = [UIImage imageWithData:data];
			
            dispatch_async(dispatch_get_main_queue(), ^{
				if (image!=nil) {
                    /*[self setImage:[image croppedWithSize:CGSizeMake(250, 250) alignment:ImageCropAlignmentCener]];*/
                    [[[self class] af_sharedImageCache] setObject:image forKey:imgUrl];
                }
				
			});
		});
	}
    
}
- (void)cancelImageRequestOperation {
    [self.af_imageRequestOperation cancel];
    self.af_imageRequestOperation = nil;
}

@end
/*@implementation UIImage (Crop)
- (UIImage *)croppedWithSize:(CGSize)size
{
    return [self croppedWithSize:size alignment:ImageCropAlignmentCener];
}

- (UIImage *)croppedWithSize:(CGSize)size alignment:(ImageCropAlignment)alignment
{
    CGFloat offsetX = 0, offsetY = 0;
    switch (alignment) {
        case ImageCropAlignmentCener: {
            offsetX = [self _centerWithLength:size.width max:self.size.width];
            offsetY = [self _centerWithLength:size.height max:self.size.height];
        }
            break;
        case ImageCropAlignmentTop: {
            offsetX = [self _centerWithLength:size.width max:self.size.width];
        }
            break;
        case ImageCropAlignmentBottom: {
            offsetX = [self _centerWithLength:size.width max:self.size.width];
            offsetY = self.size.height - size.height;
        }
            break;
        case ImageCropAlignmentLeft:  {
            offsetY = [self _centerWithLength:size.height max:self.size.height];
        }
            break;
        case ImageCropAlignmentRight: {
            offsetX = self.size.width - size.width;
            offsetY = [self _centerWithLength:size.height max:self.size.height];
        }
            break;
        default:
            break;
    }
    
    return [self _croppedWithSize:size offset:CGPointMake(offsetX, offsetY)];
}

- (UIImage *)_croppedWithSize:(CGSize)size offset:(CGPoint)offset
{
    CGRect croppingRect = CGRectMake(offset.x, offset.y, size.width, size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, croppingRect);
    UIImage *resultImage =[UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return resultImage;
}

- (CGFloat)_centerWithLength:(CGFloat)length max:(CGFloat)max
{
    CGFloat value = (max-length)/2;
    if (value <0) {
        return -(value);
    }
    return (max-length)/2;
}
@end*/

#pragma mark -

static inline NSString * AFImageCacheKeyFromURLRequest(NSURLRequest *request) {
    return [[request URL] absoluteString];
}

@implementation AFImageCache

- (UIImage *)cachedImageForRequest:(NSURLRequest *)request {
    switch ([request cachePolicy]) {
        case NSURLRequestReloadIgnoringCacheData:
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            return nil;
        default:
            break;
    }

	return [self objectForKey:AFImageCacheKeyFromURLRequest(request)];
}
- (UIImage *)cachedImageForURL:(NSURL *)url {
    
    return [self objectForKey:url];
}
- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request
{
    if (image && request) {
        [self setObject:image forKey:AFImageCacheKeyFromURLRequest(request)];
    }
}

@end

#endif
