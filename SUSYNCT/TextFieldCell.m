//
//  TextFieldCell.m
//  SUSYNCT
//
//  Created by Attique Ullah on 08/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "TextFieldCell.h"

@implementation TextFieldCell
-(void)awakeFromNib{
    
    [super awakeFromNib];
    self.txtInput1.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    self.txtInput2.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
    
    self.btnAction.layer.cornerRadius = 6.0;
    self.btnAction.layer.masksToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)createLink
{
    NSString* str = @"I read terms & conditions";
    self.lblTitle.font = [UIFont fontWithName:AvenirUltraLight size:16];
    self.lblTitle.textColor = [UIColor blackColor];
    self.lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.lblTitle.linkAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],(NSString *)kCTUnderlineStyleAttributeName,[UIColor blackColor],(NSString *)kCTForegroundColorAttributeName, nil];
    self.lblTitle.highlightedTextColor = [UIColor clearColor];
    self.lblTitle.text =str;
    
    NSRange linkRange = [str rangeOfString:@"I read terms & conditions"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com"]];
    [self.lblTitle addLinkToURL:url withRange:linkRange];
    
}
#pragma CollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 3;
    
}

-(LabelCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LabelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LabelCollectionCell" forIndexPath:indexPath];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(50, 70);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //SubCourseInfo* info = self.schedulesArr[indexPath.section];
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsCell" forIndexPath:indexPath];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}

@end
