//
//  TextFieldCell.h
//  SUSYNCT
//
//  Created by Attique Ullah on 08/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "HCSStarRatingView.h"
@interface TextFieldCell : UITableViewCell<TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtInput1;
@property (weak, nonatomic) IBOutlet UITextField *txtInput2;
@property (weak, nonatomic) IBOutlet UITextField *txtInput3;
@property (weak, nonatomic) IBOutlet UIImageView *imgInput1;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;
@property (weak, nonatomic) IBOutlet UIButton *btnShowPassword;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityCell;

@property (weak, nonatomic) IBOutlet UILabel *lblInput1;
@property (weak, nonatomic) IBOutlet UILabel *lblInput2;
@property (weak, nonatomic) IBOutlet UILabel *lblInput3;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRateing;

@property (weak, nonatomic) IBOutlet UIImageView *imgUser;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
-(void)createLink;
@end
