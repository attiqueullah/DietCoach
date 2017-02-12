//
//  SaudiMealsController.m
//  MODEL_1
//
//  Created by Attique Ullah on 08/02/2017.
//  Copyright © 2017 V-PRO. All rights reserved.
//

#import "SaudiMealsController.h"
#import "QuizViewController.h"
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
#pragma mark Custom Methods
-(void)takeQuiz:(NSUInteger)trck
{
    if (trck == self.saudiMeals.count-1) {
         NSArray* arrQuiz = [DATAMANAGER loadUserInfo:QuizTypeFirst];
        UIBarButtonItem* btnQuiz = [[UIBarButtonItem alloc]initWithTitle:@"Take a Quℹ️z" style:UIBarButtonItemStylePlain target:self action:@selector(btnTakeQuiz)];
        if (arrQuiz.count!=2) {
           self.navigationItem.rightBarButtonItem = btnQuiz; 
        }
        
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
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

-(void)btnTakeQuiz
{
    [self performSegueWithIdentifier:@"quiz" sender:@"First"];
}
- (IBAction)btnPrevious:(id)sender {
    track = track - 1;
   [self takeQuiz:track];
    [self.foodCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:track inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
}
- (IBAction)btnForward:(id)sender {
    track = track + 1;
    [self takeQuiz:track];
     [self.foodCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:track inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark Load Quizes
-(QuestionType)loadPreviousQuizesQuestions
{
    NSArray* arrQuiz = [DATAMANAGER loadUserInfo:QuizTypeFirst];
    for (Answers* ans in arrQuiz) {
        if (ans.questionType==QuestionTypeFirst) {
            return QuestionTypeSecond;
            break;
        }
        else
        {
            return QuestionTypeFirst;
            break;
        }
    }
    
    return QuestionTypeFirst;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"quiz"]) {
        QuizViewController* vc = segue.destinationViewController;
        vc.quizType = QuizTypeFirst;
        vc.questionType = [self loadPreviousQuizesQuestions];
        vc.quiz = sender;
        vc.questionArray = [DATAMANAGER loadUserInfo:QuizTypeFirst];
    }
}

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
    [self takeQuiz:visibleIndexPath.item];
}
@end
