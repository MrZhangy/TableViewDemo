//
//  MenuViewController.h
//  ShouGongKe
//
//  Created by qianfeng on 15/4/23.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

//==============================================================
/**
 *  使用方法
 *
1.设置titleArray  , vcArray , frame
2.添加view
 _menuvc = [[MenuViewController alloc] initViewControllerWithTitleArray:@[@"首页",@"动态"] vcArray:@[marsterVc, dynamicVc]];
 _menuvc.view.frame = CGRectMake(0, 64, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 49);
 [self.view addSubview:_menuvc.view];
 */
//==============================================================


#import <UIKit/UIKit.h>

@class MenuView;
@protocol MenuViewDelegate <NSObject>

-(void)menuView:(MenuView*)view currentPageChanged:(NSInteger)pageIndex;

@end

@interface MenuView : UIView
@property(nonatomic,assign) id<MenuViewDelegate>delegate;

-(id)initWithFrame:(CGRect)frame titles:(NSArray*)titleArray viewArray:(NSArray *)Array;

-(id)initViewControllerWithTitleArray:(NSArray *)titleArray viewArray:(NSArray*)Array;
@end
