//
//  SaudiMealsController.m
//  MODEL_1
//
//  Created by Attique Ullah on 08/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "SaudiMealsController.h"

@interface SaudiMealsController ()
{
    NSUInteger track;
}

@property (weak, nonatomic) IBOutlet UICollectionView *foodCollection;

@property(nonatomic,strong)NSMutableArray* saudiMeals;
@end

@implementation SaudiMealsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.saudiMeals = [NSMutableArray new];
    track = 0;
    [self getSaudiMeals];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark GET Saudi Meals
-(void)getSaudiMeals
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"SaudiMeals" ofType:@"plist"];
    // Read plist from bundle and get Root Dictionary out of it
    NSArray *dictRoot = [NSArray arrayWithContentsOfFile:path];
    
    self.saudiMeals = [dictRoot mutableCopy];
    [self.foodCollection reloadData];
    
}
#pragma mark Actions

- (IBAction)btnPrevious:(id)sender {
    track = track - 1;
   
    [self.foodCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:track inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}
- (IBAction)btnForward:(id)sender {
    track = track + 1;
    
     [self.foodCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:track inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
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
    
    return self.saudiMeals.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LabelCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FoodCell" forIndexPath:indexPath];
    cell.tableview.tableFooterView = [UIView new];
    [cell configureCell:self.saudiMeals withIndexPath:indexPath];
    
    return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.height);
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGRect visibleRect = (CGRect){.origin = self.foodCollection.contentOffset, .size = self.foodCollection.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.foodCollection indexPathForItemAtPoint:visiblePoint];
    track = visibleIndexPath.item;
}
@end
