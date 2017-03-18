//
//  UIButton+AFNetworking.h
//
//  Created by David Pettigrew on 6/12/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

// Based upon UIImageView+AFNetworking.h
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
#import "AFImageRequestOperation.h"

#import <Availability.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ImageViewCropType) {
    ImageViewCropTypeNone = 0,
    ImageViewCropTypeAdjustWidth = 1,
    ImageViewCropTypeAdjustHeight = 2
};

typedef NS_ENUM(NSUInteger, ImageCropAlignment) {
    ImageCropAlignmentCener = 0,
    ImageCropAlignmentTop = 1,
    ImageCropAlignmentBottom = 2,
    ImageCropAlignmentLeft = 3,
    ImageCropAlignmentRight = 4,
};

@interface UIImage (Crop)
- (UIImage *)croppedWithSize:(CGSize)size;
- (UIImage *)croppedWithSize:(CGSize)size alignment:(ImageCropAlignment)alignment;
@end

@interface UIButton (AFNetworking)
-(void)downloadImageUsingURL:(NSURL*)strURL placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state;
- (void)clearImageCacheForURL:(NSURL *)url;
- (void)setBackgroundImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state;
- (void)setImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage
               forState:(UIControlState)state
                success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

@end

#endif