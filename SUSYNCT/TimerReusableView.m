//
//  TimerReusableView.m
//  Diet Coach
//
//  Created by Attique Ullah on 05/03/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "TimerReusableView.h"


@implementation TimerReusableView
-(void)configureTimer:(NSDate*)dte
{
    [self.lblTimer reset];
   
    NSDate* dateOld = dte;
    NSTimeInterval remainTime = [[NSDate date] timeIntervalSinceDate:dateOld];
    if (remainTime>0) {
        NSTimeInterval remTime = TOTAL_TIME-remainTime;
        if (remTime>0) {
            [self.lblTimer setCountDownTime:(TOTAL_TIME-remainTime)];
        }
        else
        {
            [self.lblTimer setCountDownTime:TOTAL_TIME];
        }
    }
    else
    {
        [self.lblTimer setCountDownTime:TOTAL_TIME];
    }
    
    self.lblTimer.timerType  = MZTimerLabelTypeTimer;
    self.lblTimer.delegate = self;
    [self.lblTimer startWithEndingBlock:^(NSTimeInterval countTime) {
        //oh my gosh, it's awesome!!
        [NSUserDefaults deleteObjectForKey:@"startDate"];
        [PFUser currentUser][@"login_date"] = [NSDate date];
        [PARSEMANAGER storeParseObject:[PFUser currentUser]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"timeExpire" object:nil];
    }];
}
#pragma mark MZTimerLabel DELEGATE Method

- (NSString*)timerLabel:(MZTimerLabel *)timerLabel customTextToDisplayAtTime:(NSTimeInterval)time
{
    int second = (int)time  % 60;
    int minute = ((int)time / 60) % 60;
    int hours = time / 3600;
    
    if (hours >0 && hours < 24) {
        self.lblTitle.text = @"1 Day Remaining";
    }
    else if (hours >24 && hours < 48) {
        self.lblTitle.text = @"2 Days Remaining";
    }
    else if (hours >48 && hours < 72) {
        self.lblTitle.text = @"3 Days Remaining";
    }
    return [NSString stringWithFormat:@"%02dh %02dm %02ds",hours,minute,second];
}
@end
