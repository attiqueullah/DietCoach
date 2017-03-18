//
//  TimerReusableView.h
//  Diet Coach
//
//  Created by Attique Ullah on 05/03/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"

@interface TimerReusableView : UICollectionReusableView<MZTimerLabelDelegate>
@property (weak, nonatomic) IBOutlet MZTimerLabel *lblTimer;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
-(void)configureTimer:(NSDate*)dte;
@end
