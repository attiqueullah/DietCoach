//
//  ContactsViewController.m
//  Diet Coach
//
//  Created by Attique Ullah on 25/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "ContactsViewController.h"
#import "KTSContactsManager.h"
@interface ContactsViewController ()<KTSContactsManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tableData;
@property (weak, nonatomic) IBOutlet UISearchBar *tblSearchBar;
@property (strong, nonatomic) KTSContactsManager *contactsManager;
@property (strong, nonatomic) NSArray *userFilterContacts;
@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self contactManager];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Custom Methods
-(void)contactManager
{
    self.contactsManager = [KTSContactsManager sharedManager];
    self.contactsManager.delegate = self;
    self.contactsManager.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES] ];
    
}
#pragma mark Get Contacts
- (void)loadData
{
    [self.contactsManager importContacts:^(NSArray *contacts)
     {
         self.tableData = contacts;
         NSMutableArray* array = [NSMutableArray new];
         for (NSDictionary* dic in contacts) {
             
             NSArray *phones = dic[@"phones"];
             
             if ([phones count] > 0) {
                 [array addObject:dic];
             }
             
         }
         self.tableData = [array copy];
         self.userFilterContacts = [array copy];
         [self.tableView reloadData];
         NSLog(@"contacts: %@",contacts);
     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - TableView Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    NSDictionary* dic = self.userFilterContacts[indexPath.section];
    NSString *firstName = [dic[@"firstName"] stringByAppendingString:[NSString stringWithFormat:@" %@", dic[@"lastName"]]];

    
    
    NSArray *phones = dic[@"phones"];
    NSDictionary *phoneItem = phones[0];
    NSString* phonenumber = [phoneItem[@"value"] stringByReplacingOccurrencesOfString:@"-" withString:@""];

    cell.lblInput1.text = firstName;
    cell.lblInput2.text = phonenumber;
    
    cell.lblInput3.layer.masksToBounds = NO;
    cell.lblInput3.clipsToBounds = YES;
    cell.lblInput3.layer.borderColor = [UIColor blackColor].CGColor;
    cell.lblInput3.layer.borderWidth = 1.5;
    cell.lblInput3.layer.cornerRadius = cell.lblInput3.frame.size.width/2;
    cell.lblInput3.text = [DATAMANAGER createShortText:firstName];

        return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return self.userFilterContacts.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0;
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
    NSDictionary* dic = self.userFilterContacts[indexPath.section];
    [self.delegate contactDidSelect:dic];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 5.0;
}

#pragma mark UISearchbar Delegates
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterContacts:searchText];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self filterContacts:searchBar.text];
}
-(void)filterContacts:(NSString*)searchText
{
    if (searchText.length==0) {
        self.userFilterContacts = [self.tableData copy];
        [self.tableView reloadData];
        
        return;
    }
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"(SELF.firstName CONTAINS[cd] %@) OR (SELF.lastName CONTAINS[cd] %@) ", searchText,searchText];
    NSArray *filteredArray = [self.tableData filteredArrayUsingPredicate:namePredicate];
    
    self.userFilterContacts = filteredArray;

    [self.tableView reloadData];
}

@end
