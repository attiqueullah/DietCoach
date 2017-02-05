//
//  LeftTableViewCell.m
//  inv-Unlimited
//
//  Created by Attique Ullah on 24/12/2014.
//  Copyright (c) 2014 SFS. All rights reserved.
//

#import "LeftTableViewCell.h"

@implementation LeftTableViewCell

-(void)configureCell:(UIColor*)color
{
    self.lblNTitle.textColor = color;
    self.userInteractionEnabled = YES;
    self.lblNTitle.font = [UIFont fontWithName:AvenirBold size:20.0];
}
@end
