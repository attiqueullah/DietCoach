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

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.foodData = [NSMutableArray new];
    [self getAvatarData];
    // Do any additional setup after loading the view.
    self.starRateing.userInteractionEnabled = false;
    self.starRateing.value = 5.0;
    [self registerTableViewForDragging:self.foodCollection];
   
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
        dropTargetView.layer.borderColor = [[UIColor clearColor] CGColor];
        dropTargetView.layer.borderWidth = 4.0f;
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
   // [self.dragAndDropController registerDragSource:cell.contentView withDelegate:self];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(80, 80);
}


#pragma mark - Drag Source Delegate

- (UIView *)draggingViewForDragOperation:(DNDDragOperation *)operation {
    UICollectionView *tableView = (UICollectionView *)operation.dragSourceView;
    
    NSIndexPath *indexPath = [tableView indexPathForItemAtPoint:[operation locationInView:tableView]];
    if (indexPath == nil) {
        return nil;
    }
    LabelCollectionCell* cell = (LabelCollectionCell*)[tableView cellForItemAtIndexPath:indexPath];
    NSData *tempArchiveView = [NSKeyedArchiver archivedDataWithRootObject:cell];
    LabelCollectionCell *viewOfSelf = (LabelCollectionCell*)[NSKeyedUnarchiver unarchiveObjectWithData:tempArchiveView];
   
    
    /*NSString *item = [items objectAtIndex:indexPath.row];
    [items removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    self.sourceIndexPath = indexPath;*/
    
   
    return viewOfSelf;
}

- (void)dragOperationWillCancel:(DNDDragOperation *)operation {
    [operation removeDraggingViewAnimatedWithDuration:0.2 animations:^(UIView *draggingView) {
        draggingView.alpha = 0.0f;
        draggingView.center = [operation convertPoint:operation.dragSourceView.center fromView:self.view];
    }];
}


#pragma mark - Drop Target Delegate

- (void)dragOperation:(DNDDragOperation *)operation didDropInDropTarget:(UIView *)target {
    target.backgroundColor = operation.draggingView.backgroundColor;
    target.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    /*UIView* imgv = operation.dragSourceView;
    [self.foodData removeObjectAtIndex:imgv.tag];*/
    
    //[operation removeDraggingView];
}

- (void)dragOperation:(DNDDragOperation *)operation didEnterDropTarget:(UIView *)target {
    target.layer.borderColor = [operation.draggingView.backgroundColor CGColor];
}

- (void)dragOperation:(DNDDragOperation *)operation didLeaveDropTarget:(UIView *)target {
    target.layer.borderColor = [[UIColor whiteColor] CGColor];
    
}

@end
