//
//  MenuViewEx.m
//  TableViewDemo
//
//  Created by zhangyafeng on 15/5/9.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "MenuViewEx.h"
#import "TripleNestGestureRecognizer.h"

#define kTopViewHeightInset 200

#define kVelocityAllowUp -200
#define kVelocityAllowDown 200

@interface MenuViewEx ()<UIScrollViewDelegate>
@property(nonatomic, strong) UIView * topView;
@property(nonatomic, strong) UIView * bottomView;
@property(nonatomic, strong) UIScrollView * scrollView;

@property(nonatomic, strong) UIScrollView *curScrollView;

@property(nonatomic, strong) NSMutableDictionary * nestGestureDict;

@end

@implementation MenuViewEx


-(id)initWithFrame:(CGRect)frame topView:(UIView*)topView bottomView:(UIView*)bottomView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.topView = topView;
        self.bottomView = bottomView;
        
        [self createUI];
    }
    return self;
}


-(void)addObserverWithView:(id)view
{
    if ([view isKindOfClass:[UITableView class]] || [view isKindOfClass:[UICollectionView class]]) {
        
        //获取当前tableView
        self.curScrollView = view;
        
        //设置init scrollEnabled属性
        if ([self topViewIsHide] == NO) {
            ((UIScrollView*)view).scrollEnabled = NO;
        }
        
        
        //当前view注册过手势，return
        if(self.nestGestureDict[view])
            return;

        //添加嵌套手势
        TripleNestGestureRecognizer* recognizer = [[TripleNestGestureRecognizer alloc] initWithTarget:nil action:nil];
        [view addGestureRecognizer:recognizer];
//        [self.nestGestureDict setObject:recognizer forKey:view];

        
    }
    else{
        NSLog(@"不是tableView 或collectionView");
    }
    
    
}


-(void)removeGresture
{
    NSArray *viewArray = [self.nestGestureDict allKeys];
    for (UIView *view in viewArray) {
        [view removeGestureRecognizer:self.nestGestureDict[view]];
  
    }
}
-(void)dealloc
{
    [self removeGresture];
}


-(void)createUI
{
//    self.topView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - kTopViewHeightInset);
//    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.topView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.nestGestureDict = [[NSMutableDictionary alloc] init];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.topView.frame) + CGRectGetHeight(self.bottomView.frame));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.topView];
    [self.scrollView addSubview:self.bottomView];
    
}


#pragma mark scrollViewDelegate

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [scrollView setContentOffset:scrollView.contentOffset animated:YES];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offset_y = scrollView.contentOffset.y ;
    
    CGFloat  velocity = [scrollView.panGestureRecognizer velocityInView:self.scrollView].y;
    NSLog(@"%f",velocity);
    if (velocity < kVelocityAllowUp) {
         [UIView animateWithDuration:0.1 animations:^{
            [scrollView setContentOffset:CGPointMake(0, CGRectGetHeight(self.topView.frame)) animated:NO];
         }];
          self.curScrollView.scrollEnabled = YES;
    }
    else if(velocity > kVelocityAllowDown) {
        [UIView animateWithDuration:0.1 animations:^{
            [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        }];
        self.curScrollView.scrollEnabled = NO;
    }
    else if (offset_y < CGRectGetHeight(self.topView. frame)/2) {
        [UIView animateWithDuration:0.1 animations:^{
            [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        }];
        
       self.curScrollView.scrollEnabled = NO;
    }
    
    else if (offset_y >= CGRectGetHeight(self.topView.frame)/2) {
        
        [UIView animateWithDuration:0.1 animations:^{
            [scrollView setContentOffset:CGPointMake(0, CGRectGetHeight(self.topView.frame)) animated:NO];
            
            self.curScrollView.scrollEnabled = YES;
            
        }];
    }

}


-(BOOL)topViewIsHide
{
    return   self.scrollView.contentOffset.y == CGRectGetHeight(self.topView.frame);
}


@end
