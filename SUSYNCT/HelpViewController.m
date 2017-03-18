//
//  HelpViewController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 31/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "HelpViewController.h"
#import "VideoPlayer.h"
#import <AVKit/AVKit.h>
@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureVideo:@"help"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnPlay:(id)sender {
    
    [self performSegueWithIdentifier:@"videoPlayer" sender:[[NSBundle mainBundle] URLForResource:@"help" withExtension:@"mp4"]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [DATAMANAGER trackPage:@"Help"];
}
-(void)configureVideo:(NSString*)link
{
    VideoPlayer* player = [[VideoPlayer alloc]initWithFrame:CGRectMake(0, 0, self.vwVideo.frame.size.width, 300)];
    [player createVideoPlayer:player inController:self withName:link];
    player._playButton.hidden = YES;
    self.vwVideo.userInteractionEnabled = FALSE;
    [self.vwVideo addSubview:player];
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    AVPlayerViewController* vc = segue.destinationViewController;
    vc.player = [AVPlayer playerWithURL:sender];
    [vc.player play];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
