//
//  LabelCollectionCell.h
//  SUSYNCT
//
//  Created by Attique Ullah on 13/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *lblInput1;
@property (weak, nonatomic) IBOutlet UILabel *lblInput2;
@property (weak, nonatomic) IBOutlet UILabel *lblInput3;
@property (weak, nonatomic) IBOutlet UILabel *lblInput4;
@property (weak, nonatomic) IBOutlet UILabel *lblInput5;
@property (weak, nonatomic) IBOutlet UILabel *lblInput6;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *previousBtn;
@property (weak, nonatomic) IBOutlet UIButton *forwardBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgFood;

@property(nonatomic,strong)NSArray* mainIngrediants;
@property(nonatomic,strong)NSArray* foodGroup;

#pragma  mark Configure Cell
-(void)configureCell:(NSArray*)foodItem withIndexPath:(NSIndexPath*)ind;
@end
