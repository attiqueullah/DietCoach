//
//  GameResultController.m
//  Diet Coach
//
//  Created by Attique Ullah on 28/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "GameResultController.h"

@interface GameResultController ()
@property(nonatomic,strong)NSMutableArray* foodData;
@property(nonatomic,strong)PFObject* adventure;
@property (weak, nonatomic) IBOutlet UITableView *tblUsers;
@property(nonatomic,strong)NSArray* userFoods;
@end

@implementation GameResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getAvatarData];
    [self getUserFoods];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getUserFoods
{
    NSDate* dateOld = [NSUserDefaults retrieveObjectForKey:@"startDate"];
    [PARSEMANAGER getFoodsWithDate:dateOld WithCompletionBlock:^(PFObject* foods, NSError* error){
        
        self.adventure = foods;
        self.userFoods = foods[@"foods"];
        
        for (NSDictionary* dic in self.userFoods) {
            
            for (int i=0; i<self.foodData.count; i++) {
                NSDictionary* dic2  = self.foodData[i];
                if ([dic[@"name"] isEqualToString:dic2[@"name"]]) {
                    [self.foodData removeObjectAtIndex:i];
                    break;
                }
            }
        }
        [self.tblUsers reloadData];
    }];
}

-(void)getAvatarData
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"avatarData" ofType:@"plist"];
    // Read plist from bundle and get Root Dictionary out of it
    NSArray *dictRoot = [NSArray arrayWithContentsOfFile:path];
    
    self.foodData = [dictRoot mutableCopy];    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return self.userFoods.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TextFieldCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"SuggestionCell" forIndexPath:indexPath];
    
    NSDictionary* dic = self.userFoods[indexPath.section];
    cell.lblInput1.text = dic[@"name"];
    cell.imgUser.image = [UIImage imageNamed:dic[@"image"]];
    
    cell.imgUser.layer.masksToBounds = NO;
    cell.imgUser.clipsToBounds = YES;
    cell.imgUser.layer.cornerRadius = cell.imgUser.frame.size.width/2;
    
    //// Get Suggesstion ////
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"(SELF.category CONTAINS[cd] %@) ", dic[@"category"]];
    NSArray *filteredArray = [self.foodData filteredArrayUsingPredicate:namePredicate];
    
    NSMutableArray* newFoodsArr = [NSMutableArray new];
    for (int i=0; i<filteredArray.count; i++) {
        NSDictionary* tempdic = filteredArray[i];
        if (![tempdic[@"name"] isEqualToString:dic[@"name"]]) {
            [newFoodsArr addObject:tempdic];
        }
    }
    
    if (newFoodsArr.count>0) {
        NSSortDescriptor* brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:NO];
        NSArray* sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
        NSArray *sortedArray = [newFoodsArr sortedArrayUsingDescriptors:sortDescriptors];
        if (sortedArray.count>0) {
            NSLog(@"%@",sortedArray);
            NSDictionary* highValue = [sortedArray firstObject];
            cell.lblInput2.text = highValue[@"name"];
            cell.imgInput1.image = [UIImage imageNamed:highValue[@"image"]];
            
            cell.imgInput1.layer.masksToBounds = NO;
            cell.imgInput1.clipsToBounds = YES;
            cell.imgInput1.layer.cornerRadius = cell.imgInput1.frame.size.width/2;
        }
        
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v=[[UIView alloc]initWithFrame:CGRectZero];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v=[[UIView alloc]initWithFrame:CGRectZero];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10.0f;
}


@end
