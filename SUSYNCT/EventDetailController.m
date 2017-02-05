//
//  EventDetailController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 28/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "EventDetailController.h"

@interface EventDetailController ()
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation EventDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //SubCourseInfo* info = self.schedulesArr[indexPath.section];
    if (indexPath.section==0) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventDetailCell1" forIndexPath:indexPath];
        return cell;

    }
    if (indexPath.section==1) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventDetailCell2" forIndexPath:indexPath];
        return cell;
        
    }
    if (indexPath.section==2) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventDetailCell3" forIndexPath:indexPath];
        return cell;
        
    }
    if (indexPath.section==3) {
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventDetailCell4" forIndexPath:indexPath];
        return cell;
        
    }
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventsCell" forIndexPath:indexPath];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 90.0f;
    }
    if (indexPath.section==1) {
        return 101.0f;
    }
    if (indexPath.section==2) {
        return 200.0f;
    }
    return 30.0f;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}
@end
