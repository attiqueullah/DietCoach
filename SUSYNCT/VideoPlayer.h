//
//  VideoPlayer.h
//  AdBo
//
//  Created by Attique Ullah on 20/12/2015.
//  Copyright © 2015 IQH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBJVideoPlayerController.h"
@interface VideoPlayer : UIView
@property(nonatomic,strong)PBJVideoPlayerController *_videoPlayerController;
@property(nonatomic,strong)UIImageView *_playButton;
-(void)createVideoPlayer:(UIView*)cusView inController:(UIViewController*)controller withName:(NSString*)name;
@end
