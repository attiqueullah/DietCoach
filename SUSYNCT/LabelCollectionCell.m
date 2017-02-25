//
//  LabelCollectionCell.m
//  SUSYNCT
//
//  Created by Attique Ullah on 13/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "LabelCollectionCell.h"

@implementation LabelCollectionCell

#pragma  mark Configure Cell
-(void)configureCell:(NSArray*)foodItems withIndexPath:(NSIndexPath*)ind
{

    NSDictionary*foodItem = foodItems[ind.row];
    self.lblInput2.text = foodItem[@"title"];
    self.lblInput3.text = foodItem[@"score"];
    self.imgFood.image = [UIImage imageNamed:foodItem[@"image"]];
    self.mainIngrediants = foodItem[@"main_ingrediants"];
    self.foodGroup = foodItem[@"food_group"];
    [self.tableview reloadData];
    
    if (ind.item==0) {
        self.previousBtn.hidden = YES;
    }
    else
    {
        self.previousBtn.hidden = NO;
    }
    
    if (ind.item==foodItems.count-1) {
        self.forwardBtn.hidden = YES;
    }
    else
    {
        self.forwardBtn.hidden = NO;
    }
     [DATAMANAGER trackPage:self.lblInput2.text];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mainIngrediants.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderDetails" forIndexPath:indexPath];
    
    cell.lblInput1.text = self.mainIngrediants[indexPath.row];
    cell.lblInput2.text = self.foodGroup[indexPath.row];
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *HeaderCellIdentifier = @"Header";
    LeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HeaderCellIdentifier];
    return cell;
}
@end
