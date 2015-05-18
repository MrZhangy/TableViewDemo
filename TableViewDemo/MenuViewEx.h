//
//  MenuViewEx.h
//  TableViewDemo
//
//  Created by zhangyafeng on 15/5/9.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewEx : UIView
-(id)initWithFrame:(CGRect)frame topView:(UIView*)topView bottomView:(UIView*)bottomView;

-(void)addObserverWithView:(id)view;
@end
