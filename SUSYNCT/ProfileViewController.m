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
#import "TimerReusableView.h"

@interface ProfileViewController ()<DNDDragSourceDelegate, DNDDropTargetDelegate , MZTimerLabelDelegate>
{
    BOOL isSubmit;
}
@property(nonatomic,strong)NSMutableArray* foodData;
@property (weak, nonatomic) IBOutlet UICollectionView *foodCollection;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRateing;
@property (nonatomic,strong)UIImageView* tempImage;
@property (weak, nonatomic) IBOutlet UIImageView *userFeedImg;
@property (weak, nonatomic) IBOutlet UIImageView *userEnergy;

@property(nonatomic,strong)NSMutableArray* userFeedArray;
@property(nonatomic,strong)NSMutableArray* userFoodArray;

@property(nonatomic,strong)NSArray* lastFoods;
@property(nonatomic,strong)PFObject* currentFoodItem;

@property(nonatomic,strong)NSDate* currentDate;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SoundManager sharedManager].allowsBackgroundMusic = YES;
    [[SoundManager sharedManager] prepareToPlay];
    
    NSDate* submitDate = [NSUserDefaults retrieveObjectForKey:@"submit"];
    if (submitDate == nil) {
        submitDate = [[DATAMANAGER userData] submit];
    }
    NSUInteger hours = [[submitDate dateAtStartOfDay] hoursBeforeDate:[NSDate date]];
    //hours = 34;
    if (submitDate!=nil) {
        if (hours>=24) {
            isSubmit = YES;
            NSDate* newDate = [NSDate date];
            //[NSUserDefaults deleteObjectForKey:@"startDate"];
            [PFUser currentUser][@"login_date"] = newDate;
            [[PFUser currentUser] saveInBackground];
            [PARSEMANAGER storeParseObject:[PFUser currentUser]];
            self.currentDate = newDate;
            [NSUserDefaults deleteObjectForKey:@"submit"];
        }
        else
        {
            isSubmit = NO;
        }
    }
    else
    {
        isSubmit = YES;
    }
    
    self.starRateing.value = 0;
    NSDate* dateOld = [NSUserDefaults retrieveObjectForKey:@"startDate"];
    
    NSUInteger passedDays = [[NSDate date] daysAfterDate:dateOld];
    NSTimeInterval remainTime = [[NSDate date] timeIntervalSinceDate:dateOld];
    NSTimeInterval remTime = TOTAL_TIME-remainTime;
    if ((passedDays >=DAYS && dateOld) && remTime <=0) {
        self.currentDate = [NSDate date];
        [self getLastThreeDaysFoods];
    }
    else
    {
        if ([[DATAMANAGER userData] startDate]) {
            [NSUserDefaults saveObject:[[DATAMANAGER userData] startDate] forKey:@"startDate"];
            self.currentDate = [[DATAMANAGER userData] startDate];
            [PFUser currentUser][@"login_date"] = self.currentDate;
             [PARSEMANAGER storeParseObject:[PFUser currentUser]];

        }
        else
        {
            if (dateOld) {
                self.currentDate = dateOld;
            }
            else
            {
                [NSUserDefaults saveObject:[NSDate date] forKey:@"startDate"];
                self.currentDate = [NSDate date];
                [PFUser currentUser][@"login_date"] = self.currentDate;
                [PARSEMANAGER storeParseObject:[PFUser currentUser]];
            }

        }
        [self getUserFoods];
    }
    
    
    self.foodData = [NSMutableArray new];
    self.userFeedArray = [NSMutableArray new];
    self.userFoodArray = [NSMutableArray new];
   
    [self getAvatarData];
    // Do any additional setup after loading the view.
    self.starRateing.userInteractionEnabled = false;
    self.starRateing.value = 0.0;
    self.starRateing.maximumValue = 5.0;
    [self registerTableViewForDragging:self.foodCollection];
    [self updateAvatar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userTimeExpireNotification:) name:@"timeExpire" object:nil];
    }
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [DATAMANAGER trackPage:@"Avatar"];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [DATAMANAGER showTutorialForItem:@"Avatar" withController:self WithCompletionBlock:^(BOOL isDone){
        [self.navigationController setNavigationBarHidden:NO];
    }];
    for (UIView *dropTargetView in self.dropTargetViews) {
        [self.dragAndDropController registerDropTarget:dropTargetView withDelegate:self];
    }
    
}

-(UIBarButtonItem*)addSuggesstion
{
    UIBarButtonItem* btnSugesstions = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bulb"] style:UIBarButtonItemStylePlain target:self action:@selector(btnSuggesstions)];
    return btnSugesstions;
    

}
-(UIBarButtonItem*)addSubmitAction
{
    UIBarButtonItem* btnSubmit = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(btnSubmitPressed)];
    return btnSubmit;
}
-(void)btnSuggesstions
{
    [self performSegueWithIdentifier:@"game_result" sender:self];
}

-(void)btnSubmitPressed
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Adventure Chamber"
                                                                   message:@"Do you want submit your results?"
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Submit"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              
                                                              isSubmit = NO;
                                                              NSDate* newDate = [NSDate date];
                                                              [NSUserDefaults saveObject:newDate forKey:@"submit"];
                                                              [NSUserDefaults saveObject:newDate forKey:@"submit"];
                                                              [PFUser currentUser][@"submit"] = newDate;
                                                              
                                                              
                                                              //NSUInteger points = 0;
                                                              NSUInteger totPoints = 0;
                                                              for (int i=0; i<self.userFoodArray.count; i++) {
                                                                  NSDictionary* dic = self.userFoodArray[i];
                                                                  NSUInteger pt = [dic[@"value"] integerValue];
                                                                  totPoints = totPoints + pt;
                                                                  
                                                              }
                                                              
                                                              float average = totPoints/self.userFoodArray.count;
                                                              [self updateStars:average];
                                                              
                                                              
                                                              NSUInteger totalMeals = [[PFUser currentUser][@"total_meals"] integerValue];
                                                              totalMeals = totalMeals + 1;
                                                              [DATAMANAGER userData].totalMeals = totalMeals;
                                                              [PFUser currentUser][@"total_meals"] = [NSNumber numberWithInteger:[[DATAMANAGER userData] totalMeals]];
                                                              

                                                              [[PFUser currentUser] saveInBackground];
                                                              
                                                              [NSUserDefaults saveObject:[NSNumber numberWithInteger:0] forKey:@"total_avatar_points"];
                                                              
                                                              [DATAMANAGER removeAllNotifications];
                                                              [DATAMANAGER configureNotifications];
                                                               if([[DATAMANAGER userData] totalMeals]%DAYS==0)
                                                               {
                                                                   //// Get Last Three Meals ///
                                                                   [self getLastThreeDaysFoods];
                                                                   
                                                               }
                                                               else
                                                               {
                                                                  [DATAMANAGER goToLeaderBoard:self.revealViewController];
                                                               }
                                                              
                                                          }];
    UIAlertAction *reset = [UIAlertAction actionWithTitle:@"Reset"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              
                                                              [self.userFoodArray removeAllObjects];
                                                              [self.userFeedArray removeAllObjects];
                                                              self.currentFoodItem[@"foods"] = self.userFoodArray;
                                                              self.currentFoodItem[@"points"] = [NSNumber numberWithInteger:0];
                                                              self.currentFoodItem[@"number_foods"] = [NSNumber numberWithInteger:self.userFoodArray.count];
                                                              [NSUserDefaults saveObject:[NSNumber numberWithInteger:0] forKey:@"total_avatar_points"];
                                                              [self updateAvatar];
                                                              [self.foodCollection reloadData];
                                                              
                                                              [DATAMANAGER removeAllNotifications];
                                                              [DATAMANAGER configureNotifications];

                                                              [PARSEMANAGER storeParseObject:self.currentFoodItem];
                                                              
                                                          }];
    
    [alert addAction:firstAction];
    [alert addAction:reset];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)userTimeExpireNotification:(NSNotification*)notifi
{
    self.currentDate = [NSDate date];
    [self getLastThreeDaysFoods];
}
- (void)registerTableViewForDragging:(UICollectionView *)tableView {
    DNDLongPressDragRecognizer *dragRecognizer = [[DNDLongPressDragRecognizer alloc] init];
    dragRecognizer.minimumPressDuration = 0.1;
    [tableView.panGestureRecognizer requireGestureRecognizerToFail:dragRecognizer]; // prevent UITableView from hijacking touches
    
    [self.dragAndDropController registerDragSource:tableView withDelegate:self dragRecognizer:dragRecognizer];
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
-(void)updateAvatarFoodItems:(PFObject*)foods
{
    self.currentFoodItem = foods;
    [DATAMANAGER setAvatarObject:foods];
    
    NSDate* updateDate = [NSUserDefaults retrieveObjectForKey:@"avatarDate"];
    if (!updateDate) {
        [NSUserDefaults saveObject:foods.updatedAt forKey:@"avatarDate"];
        [DATAMANAGER setAvatarDate:foods.updatedAt];
    }
    
    self.userFoodArray = [foods[@"foods"] mutableCopy];
    if (self.userFoodArray==nil) {
        self.userFoodArray = [NSMutableArray new];
    }
    for (NSDictionary* dic in self.userFoodArray) {
        [self.userFeedArray addObject:[UIImage imageNamed:dic[@"image"]]];
    }
    [self updateAvatar];
    
    //NSUInteger points = [foods[@"points"] integerValue];
    

    if (self.userFoodArray.count>0) {
       // NSUInteger points = 0;
        NSUInteger totPoints = 0;
        for (int i=0; i<self.userFoodArray.count; i++) {
            NSDictionary* dic = self.userFoodArray[i];
            NSUInteger pt = [dic[@"value"] integerValue];
            //points = (pt * (i+1)) + points;
            totPoints = totPoints + pt;
            
        }
         //float avg = points/totPoints;
         //
       
        float average = totPoints/self.userFoodArray.count;
        NSMutableArray* array = [NSMutableArray new];
        if (self.userFoodArray.count>=3) {
            if (isSubmit) {
                [array addObject:[self addSubmitAction]];
            }
        }
        if (average < 60) {
            [array addObject:[self addSuggesstion]];
        }
        [self updateStars:average];
        self.navigationItem.rightBarButtonItems = array;


    }
   else
   {
        [self updateStars:0];
   }
        [self.foodCollection reloadData];
}
-(void)getUserFoods
{
    [PARSEMANAGER getFoodsWithDate:self.currentDate WithCompletionBlock:^(PFObject* foods, NSError* error){
        [self updateAvatarFoodItems:foods];
    }];
}

-(void)getLastThreeDaysFoods
{
    NSDate* dateOld = [NSUserDefaults retrieveObjectForKey:@"startDate"];
    [PARSEMANAGER getLastFoodsWithDate:dateOld withNewDate:self.currentDate WithCompletionBlock:^(NSArray* foods, NSError* error){
        
        [NSUserDefaults saveObject:self.currentDate forKey:@"startDate"];
        [PFUser currentUser][@"login_date"] = self.currentDate;
        [PARSEMANAGER storeParseObject:[PFUser currentUser]];

        self.lastFoods = foods;
        
        if([[DATAMANAGER userData] totalMeals]%DAYS==0)
        {
            CGFloat totalAvg = 0.0;
            for (PFObject* obj in foods) {
                NSArray* foodItems = obj[@"foods"];
                NSUInteger total = [obj[@"points"] integerValue];
                float avg = total/foodItems.count;
                
                totalAvg = totalAvg + avg;
                obj[@"passed"] = [NSNumber numberWithBool:YES];
                [PARSEMANAGER storeParseObject:obj];
            }
            
            CGFloat average = totalAvg/DAYS;
            if ([[[DATAMANAGER userData] gender] isEqualToString:@"male"]) {
                if (average < 75) {
                    [self showFailureAlert:@"The food choices you have made for the last three days were not so healthy. Your friend is not fit to join the national team for the World Cup. You can try helping him again by giving him healthier food choices ☹️"];
                }
                else
                {
                    [self showSucessAlert:@"The food choices you have made for the last three days were not so healthy. Your friend not fit to join the national team for the World Cup. You can try helping him again by giving him healthier food choices 😀"];
                }
            }
            else
            {
                if (average < 75) {
                    [self showFailureAlert:@"The food choices you have made for the last three days were not so healthy. Your friend is not fit to join the cast for her dream movie. You can try helping her again by giving her healthier food choices ☹️"];
                }
                else
                {
                    [self showSucessAlert:@"You have done a great job feeding your friend for the last three days. She is now fit and ready to join the cast for her dream movie. Congratulations! 😀"];
                }
                
            }
 
        }
        
    }];
}

-(void)checkFoodItems
{
    if (self.userFoodArray.count==5 && [self.currentDate daysAfterDate:[NSDate date]]>DAYS) {
        [self getLastThreeDaysFoods];
    }
}
-(void)updateAvatar
{
    NSString* str = @"male";
    
    NSDictionary* player = [NSUserDefaults retrieveObjectForKey:@"Player"];
    
    if (player) {
        str = player[@"image"];
    }
    else
    {
        if ([[[DATAMANAGER userData] gender] isEqualToString:@"male"]) {
            str = @"male";
        }
        else
        {
            str = @"female";
        }
    }
    
    self.userFeedImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%d",str,(int)self.userFeedArray.count]];
    self.userEnergy.image = [UIImage imageNamed:[NSString stringWithFormat:@"energy-%d",(int)self.userFeedArray.count]];
    
    [self checkFoodItems];
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
    NSDate* dateOld = [NSUserDefaults retrieveObjectForKey:@"startDate"];
    NSTimeInterval remainTime = [[NSDate date] timeIntervalSinceDate:dateOld];
    NSTimeInterval remTime = TOTAL_TIME-remainTime;
    
    if (self.userFeedArray.count==5 || (remTime < 0 || remTime ==0)) {
        [self checkFoodItems];
        [DATAMANAGER showWithStatus:@"You cannot choose more than 5 foods" withType:ERROR];
        return false;
    }
    
    NSString* str = @"male";
    
    NSDictionary* player = [NSUserDefaults retrieveObjectForKey:@"Player"];
    
    if (player) {
        str = player[@"image"];
    }
    else
    {
        if ([[[DATAMANAGER userData] gender] isEqualToString:@"male"]) {
            str = @"male";
        }
        else
        {
            str = @"female";
        }
    }
    
    [self.userFeedArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%d",str,(int)self.userFeedArray.count]]];
    self.userFeedImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_%d",str,(int)self.userFeedArray.count]];
    self.userEnergy.image = [UIImage imageNamed:[NSString stringWithFormat:@"energy-%d",(int)self.userFeedArray.count]];
    
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        TimerReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TimerCell" forIndexPath:indexPath];
        [headerView configureTimer:self.currentDate];
        reusableview = headerView;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
    }
    
    return reusableview;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(self.foodCollection.frame.size.width, 60);
    }
    
    return CGSizeZero;
}

-(void)showSucessAlert:(NSString*)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Adventure Chamber"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button one");
                                                             [DATAMANAGER goToLeaderBoard:self.revealViewController];
                                                              
                                                          }]; // 2
    
    [alert addAction:firstAction]; // 4
    
    [self presentViewController:alert animated:YES completion:nil]; // 6

}
-(void)showFailureAlert:(NSString*)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Adventure Chamber"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              NSLog(@"You pressed button one");
                                                              
                                                
                                                              [DATAMANAGER goToLeaderBoard:self.revealViewController];
                                                          }]; // 2
    
    [alert addAction:firstAction]; // 4
    
    [self presentViewController:alert animated:YES completion:nil]; // 6
    
}
-(void)showFailureAlert2:(NSString*)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Adventure Chamber"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert]; // 1
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              
                                                          }]; // 2
    
    [alert addAction:firstAction]; // 4
    
    [self presentViewController:alert animated:YES completion:nil]; // 6
    
}
#pragma mark - Drag Source Delegate

- (UIView *)draggingViewForDragOperation:(DNDDragOperation *)operation {
    UICollectionView *tableView = (UICollectionView *)operation.dragSourceView;
    
    if (!isSubmit) {
        [self showFailureAlert2:@"Your hero is not hungry yet. Please try again later"];
        return nil;
    }
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
        
        NSUInteger totPoints = 0;
        for (int i=0; i<self.userFoodArray.count; i++) {
            NSDictionary* dic = self.userFoodArray[i];
            NSUInteger pt = [dic[@"value"] integerValue];
            totPoints = totPoints + pt;

        }
        
        self.currentFoodItem[@"foods"] = self.userFoodArray;
        self.currentFoodItem[@"points"] = [NSNumber numberWithInteger:totPoints];
        self.currentFoodItem[@"number_foods"] = [NSNumber numberWithInteger:self.userFoodArray.count];
        [NSUserDefaults saveObject:[NSNumber numberWithInteger:totPoints] forKey:@"total_avatar_points"];
        
        float average = totPoints/self.userFoodArray.count;
        NSMutableArray* array = [NSMutableArray new];
        if (self.userFoodArray.count>=3) {
            [array addObject:[self addSubmitAction]];
        }
        if (average < 60) {
            [array addObject:[self addSuggesstion]];
        }
        [self playSentPacketDebugSound];
        self.navigationItem.rightBarButtonItems = array;
        [DATAMANAGER configureNotifications];
       // [self updateStars:average];
        [PARSEMANAGER storeParseObject:self.currentFoodItem];
    }
}

- (void)dragOperation:(DNDDragOperation *)operation didEnterDropTarget:(UIView *)target {
    
}

- (void)dragOperation:(DNDDragOperation *)operation didLeaveDropTarget:(UIView *)target {
    
    
}

-(void)updateStars:(float)points
{
    //self.starRateing.value = points;
    if (points > 0 && points <= 20) {
        self.starRateing.value = 1.0;
    }
    else if (points > 20 && points <= 40) {
        self.starRateing.value = 2.0;
    }
    else if (points > 40 && points <= 60) {
        self.starRateing.value = 3.0;
    }
    else if (points > 60 && points <= 80) {
        self.starRateing.value = 4.0;
    }
    else if (points > 80 && points <= 100)
    {
        self.starRateing.value = 5.0;
    }
    else
    {
        self.starRateing.value = 0.0;
    }
    
}
-(void)playSentPacketDebugSound
{
    [[SoundManager sharedManager] playSound:@"send_packet.mp3" looping:NO];
}

@end
