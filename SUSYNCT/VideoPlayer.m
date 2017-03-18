//
//  VideoPlayer.m
//  AdBo
//
//  Created by Attique Ullah on 20/12/2015.
//  Copyright © 2015 IQH. All rights reserved.
//

#import "VideoPlayer.h"



@interface VideoPlayer () <PBJVideoPlayerControllerDelegate>

@end

@implementation VideoPlayer


-(void)createVideoPlayer:(UIView*)cusView inController:(UIViewController*)controller withName:(NSString*)name
{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopPlayer) name:@"player" object:nil];
    self._videoPlayerController = [[PBJVideoPlayerController alloc] init];
    self._videoPlayerController.delegate = self;
    self._videoPlayerController.view.frame = cusView.bounds;
    
    //[self addChildViewController:_videoPlayerController];
    [cusView addSubview:self._videoPlayerController.view];
     [cusView bringSubviewToFront:self._videoPlayerController.view];
    [self._videoPlayerController didMoveToParentViewController:controller];
    
    //self._playButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_button"]];
    //self._playButton.center = cusView.center;
    //[cusView addSubview:self._playButton];
    //[cusView bringSubviewToFront:self._playButton];
    
    // setup media
    NSString* path = [[NSBundle mainBundle] pathForResource:name ofType:@"mp4"];
    self._videoPlayerController.videoPath = path;  
}

-(void)stopPlayer
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"player" object:nil];
    [self._videoPlayerController stop];
    self._videoPlayerController = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - PBJVideoPlayerControllerDelegate

- (void)videoPlayerReady:(PBJVideoPlayerController *)videoPlayer
{
    //NSLog(@"Max duration of the video: %f", videoPlayer.maxDuration);
}

- (void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)videoPlayer
{
    NSLog(@"%d",(int)videoPlayer.view.tag);
   
}

- (void)videoPlayerBufferringStateDidChange:(PBJVideoPlayerController *)videoPlayer
{
    /*switch (videoPlayer.bufferingState) {
     case PBJVideoPlayerBufferingStateUnknown:
     NSLog(@"Buffering state unknown!");
     break;
     
     case PBJVideoPlayerBufferingStateReady:
     NSLog(@"Buffering state Ready! Video will start/ready playing now.");
     break;
     
     case PBJVideoPlayerBufferingStateDelayed:
     NSLog(@"Buffering state Delayed! Video will pause/stop playing now.");
     break;
     default:
     break;
     }*/
}

- (void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)videoPlayer
{
    self._playButton.alpha = 1.0f;
    self._playButton.hidden = NO;
    
    [UIView animateWithDuration:0.1f animations:^{
        self._playButton.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self._playButton.hidden = YES;
    }];
}

- (void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)videoPlayer
{
    self._playButton.hidden = NO;
    
    [UIView animateWithDuration:0.1f animations:^{
        self._playButton.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

@end
