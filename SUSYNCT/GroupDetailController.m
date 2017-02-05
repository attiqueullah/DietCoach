//
//  GroupDetailController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 29/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "GroupDetailController.h"

@interface GroupDetailController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation GroupDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnSettings:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Report an Issue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Unsubscribe" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        // OK button tapped.
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];

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
    return 3;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        //SubCourseInfo* info = self.schedulesArr[indexPath.section];
        
        if (indexPath.section==0) {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventDetailCell2" forIndexPath:indexPath];
            return cell;
            
        }
        if (indexPath.section==1) {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventDetailCell3" forIndexPath:indexPath];
            return cell;
            
        }
        if (indexPath.section==2) {
            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventDetailCell4" forIndexPath:indexPath];
            return cell;
            
        }
        TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventsCell" forIndexPath:indexPath];
        return cell;
        
    }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        
        if (indexPath.section==0) {
            return 101.0f;
        }
        if (indexPath.section==1) {
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
