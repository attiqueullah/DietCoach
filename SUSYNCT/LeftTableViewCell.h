//
//  LeftTableViewCell.h
//  inv-Unlimited
//
//  Created by Attique Ullah on 24/12/2014.
//  Copyright (c) 2014 SFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblNIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblNTitle;
@property (nonatomic)  BOOL isSelected;
-(void)configureCell:(UIColor*)color;
@end
