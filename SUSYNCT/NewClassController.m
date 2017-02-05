//
//  NewClassController.m
//  SUSYNCT
//
//  Created by Attique Ullah on 14/12/2016.
//  Copyright © 2016 V-PRO. All rights reserved.
//

#import "NewClassController.h"
#import "LabelCollectionCell.h"
#import "TextFieldCell.h"
@interface NewClassController ()
@property (weak, nonatomic) IBOutlet UICollectionView *coursesCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *courseCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblCounter;
@property(nonatomic,strong)NSMutableArray* coursesArr;
@property(nonatomic,strong)NSMutableArray* schedulesArr;
@property(nonatomic,strong)NSArray* subCoursesSection;
@end

@implementation NewClassController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.coursesArr = [NSMutableArray new];
    self.schedulesArr = [NSMutableArray new];
    self.tableView.tableFooterView = [UIView new];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark IBActions
- (IBAction)btnAddToSchedules:(UIButton*)sender {
    SubCourseInfo* info = self.subCoursesSection[sender.tag];
    [self.schedulesArr addObject:info];
    [self.tableView reloadData];
    [self.courseCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]]];
}

#pragma mark Methods
-(void)setCounter:(int)index
{
    self.lblCounter.text = [NSString stringWithFormat:@"%d Of %d",index,(int)self.subCoursesSection.count];
}
#pragma mark WEBAPI CALLS

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma CollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(collectionView == self.courseCollectionView)
    {
        return self.subCoursesSection.count;
    }
    return self.coursesArr.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(collectionView == self.courseCollectionView)
    {
        LabelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LabelCollectionCell4" forIndexPath:indexPath];
        SubCourseInfo* info = self.subCoursesSection[indexPath.row];
        cell.lblInput2.text = info.title;
        cell.lblInput3.text = [NSString stringWithFormat:@"Day: %@",info.day];
        cell.lblInput4.text = [NSString stringWithFormat:@"Time: %@-%@",info.start_time,info.end_time];
        cell.lblInput5.text = [NSString stringWithFormat:@"Instructor: %@ %@",info.instructor[@"first_name"],info.instructor[@"last_name"]];
        cell.lblInput6.text = [NSString stringWithFormat:@"Location: %@",info.location];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF.subCourse_id.intValue == %@", info.subCourse_id]];
        NSArray* filteredData = [self.schedulesArr filteredArrayUsingPredicate:predicate];
        if (filteredData.count==0) {
            cell.btnAction.hidden = NO;
        }
        else
        {
            cell.btnAction.hidden = YES;
        }
        
        cell.btnAction.tag = indexPath.row;
        return cell;
    }
    else
    {
        LabelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LabelCollectionCell3" forIndexPath:indexPath];
        CourseInfo* info = self.coursesArr[indexPath.row];
        cell.lblInput1.text = info.scheduledCourseId;
        if (indexPath.row==0) {
            cell.lblInput1.backgroundColor = [UIColor blackColor];
            cell.lblInput1.textColor = [UIColor whiteColor];
            [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [self collectionView:collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        }
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(collectionView == self.courseCollectionView)
    {
        
    }
    else
    {
        CourseInfo* info = self.coursesArr[indexPath.row];
        LabelCollectionCell *cell = (LabelCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
        cell.lblInput1.backgroundColor = [UIColor blackColor];
        cell.lblInput1.textColor = [UIColor whiteColor];
        self.subCoursesSection = info.sectionData;
        [self setCounter:1];
        [self.courseCollectionView reloadData];
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView == self.courseCollectionView)
    {
        
    }
    else
    {
        LabelCollectionCell *cell = (LabelCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
        cell.lblInput1.backgroundColor = [UIColor clearColor];
        cell.lblInput1.textColor = [UIColor blackColor];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(collectionView == self.courseCollectionView)
    {
        return CGSizeMake(collectionView.frame.size.width,collectionView.frame.size.height);
    }
    return CGSizeMake(100, 40);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.courseCollectionView.frame.size.width;
    float currentPage = self.courseCollectionView.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f))
    {
        [self setCounter:currentPage ];
    }
    else
    {
        [self setCounter:currentPage + 1];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return self.schedulesArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubCourseInfo* info = self.schedulesArr[indexPath.section];
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell" forIndexPath:indexPath];
    
    cell.txtInput1.text =  info.title;
    cell.txtInput2.text = info.day;
    cell.txtInput3.text = [NSString stringWithFormat:@"%@-%@",info.start_time,info.end_time];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *v=[[UIView alloc]initWithFrame:CGRectZero];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10.0f;
}

@end
