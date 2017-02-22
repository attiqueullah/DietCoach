//
//  ProfileViewController.m
//  MODEL_1
//
//  Created by Attique Ullah on 08/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "ProfileViewController.h"
#import "HCSStarRatingView.h"
#import <QuartzCore/QuartzCore.h>
@interface ProfileViewController ()<DNDDragSourceDelegate, DNDDropTargetDelegate>
@property(nonatomic,strong)NSMutableArray* foodData;
@property (weak, nonatomic) IBOutlet UICollectionView *foodCollection;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRateing;
@property (nonatomic,strong)UIImageView* tempImage;
@property (weak, nonatomic) IBOutlet UIImageView *userFeedImg;
@property (weak, nonatomic) IBOutlet UIImageView *userEnergy;

@property(nonatomic,strong)NSMutableArray* userFeedArray;
@property(nonatomic,strong)NSMutableArray* userFoodArray;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.foodData = [NSMutableArray new];
    self.userFeedArray = [NSMutableArray new];
    self.userFoodArray = [NSMutableArray new];
    
    [self getAvatarData];
    // Do any additional setup after loading the view.
    self.starRateing.userInteractionEnabled = false;
    self.starRateing.value = 5.0;
    [self registerTableViewForDragging:self.foodCollection];
    [self feedAvatar:nil];
   
   }
- (void)registerTableViewForDragging:(UICollectionView *)tableView {
    DNDLongPressDragRecognizer *dragRecognizer = [[DNDLongPressDragRecognizer alloc] init];
    dragRecognizer.minimumPressDuration = 0.1;
    [tableView.panGestureRecognizer requireGestureRecognizerToFail:dragRecognizer]; // prevent UITableView from hijacking touches
    
    [self.dragAndDropController registerDragSource:tableView withDelegate:self dragRecognizer:dragRecognizer];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    for (UIView *dropTargetView in self.dropTargetViews) {
        [self.dragAndDropController registerDropTarget:dropTargetView withDelegate:self];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getAvatarData
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"avatarData" ofType:@"plist"];
    // Read plist from bundle and get Root Dictionary out of it
    NSArray *dictRoot = [NSArray arrayWithContentsOfFile:path];
    
    self.foodData = [dictRoot mutableCopy];
    [self.foodCollection reloadData];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL)feedAvatar:(UIImageView*)img
{
    if (self.userFeedArray.count>6) {
        [DATAMANAGER showWithStatus:@"You cannot choose more than 6 foods" withType:ERROR];
        
        return false;
    }
   
    self.userFeedImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"male_%d",(int)self.userFeedArray.count]];
    self.userEnergy.image = [UIImage imageNamed:[NSString stringWithFormat:@"energy-%d",(int)self.userFeedArray.count]];
     [self.userFeedArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"male_%d",(int)self.userFeedArray.count]]];
    return true;
}
#pragma mark CollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.foodData.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LabelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FoodCollectionCell" forIndexPath:indexPath];
    NSDictionary* dic = self.foodData[indexPath.row];
    cell.lblInput2.text = dic[@"name"];
    cell.contentView.tag = indexPath.item;
    cell.imgFood.image = [UIImage imageNamed:dic[@"image"]];
    
    cell.imgFood.layer.masksToBounds = NO;
    cell.imgFood.clipsToBounds = YES;
    cell.imgFood.layer.cornerRadius = cell.imgFood.frame.size.width/2;
    
    if (self.userFoodArray.count>0) {
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF.name == %@ ", dic[@"name"]];
        NSArray *filteredArray = [self.userFoodArray filteredArrayUsingPredicate:namePredicate];
        if (filteredArray.count>0) {
            cell.lblInput3.hidden = false;
        }
        else
        {
            cell.lblInput3.hidden = true;
        }
    }
    else
        cell.lblInput3.hidden = true;
    
    cell.lblInput3.layer.masksToBounds = NO;
    cell.lblInput3.clipsToBounds = YES;
    cell.lblInput3.layer.cornerRadius = cell.lblInput3.frame.size.width/2;
    

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(80, 100);
}


#pragma mark - Drag Source Delegate

- (UIView *)draggingViewForDragOperation:(DNDDragOperation *)operation {
    UICollectionView *tableView = (UICollectionView *)operation.dragSourceView;
    
    NSIndexPath *indexPath = [tableView indexPathForItemAtPoint:[operation locationInView:tableView]];
    if (indexPath == nil) {
        return nil;
    }
    LabelCollectionCell* cell = (LabelCollectionCell*)[tableView cellForItemAtIndexPath:indexPath];
    
    if (!cell.lblInput3.isHidden) {
        return nil;
    }
    NSDictionary* dic = self.foodData[cell.contentView.tag];
    UIImageView* tempImg = [[UIImageView alloc]initWithFrame:cell.imgFood.frame];
    tempImg.image = [UIImage imageNamed:dic[@"image"]];
    
    tempImg.layer.masksToBounds = NO;
    tempImg.clipsToBounds = YES;
    tempImg.layer.cornerRadius = cell.imgFood.frame.size.width/2;
    tempImg.tag =cell.contentView.tag;
    
    /*NSString *item = [items objectAtIndex:indexPath.row];
    [items removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    self.sourceIndexPath = indexPath;*/
    
   
    return tempImg;
}

- (void)dragOperationWillCancel:(DNDDragOperation *)operation {
    [operation removeDraggingViewAnimatedWithDuration:0.2 animations:^(UIView *draggingView) {
        draggingView.alpha = 0.0f;
        draggingView.center = [operation convertPoint:operation.dragSourceView.center fromView:self.view];
    }];
}


#pragma mark - Drop Target Delegate

- (void)dragOperation:(DNDDragOperation *)operation didDropInDropTarget:(UIView *)target {
    
    UIImageView* tempImg = (UIImageView *)operation.draggingView;
    
    if ([self feedAvatar:tempImg]) {
        UICollectionView *tableView = (UICollectionView *)operation.dragSourceView;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:tempImg.tag inSection:0];
        if (indexPath == nil) {
            return ;
        }
        LabelCollectionCell* cell = (LabelCollectionCell*)[tableView cellForItemAtIndexPath:indexPath];
        cell.lblInput3.hidden = false;
        
        NSDictionary* dic = self.foodData[tempImg.tag];
        [self.userFoodArray addObject:dic];

    }
        /*UIView* imgv = operation.dragSourceView;
    [self.foodData removeObjectAtIndex:imgv.tag];*/
    
    //[operation removeDraggingView];
    
}

- (void)dragOperation:(DNDDragOperation *)operation didEnterDropTarget:(UIView *)target {
    
}

- (void)dragOperation:(DNDDragOperation *)operation didLeaveDropTarget:(UIView *)target {
    
    
}

@end
