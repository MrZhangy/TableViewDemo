//
//  TableViewCell.m
//  TableViewDemo
//
//  Created by zhangyafeng on 15/5/7.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "TableViewCell.h"
#import "ViewController.h"

@interface TableViewCell()<UITableViewDelegate, UITableViewDataSource>


@end

@implementation TableViewCell
{
    UIPanGestureRecognizer *_pan;
}
- (void)awakeFromNib {
    // Initialization code
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}


-(void)panDrag:(UIPanGestureRecognizer*)pan
{
 
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}



-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"%@", scrollView.nextResponder);
    
    CGFloat y = [scrollView.panGestureRecognizer velocityInView:self.tableView].y;
    if (scrollView.contentOffset.y <= 0 && y > 0) {
        self.tableView.scrollEnabled = NO;
        NSLog(@"scrollEnabled == NO");
        
        id obj = [self nextResponder];
        
        while (![obj isKindOfClass:[ViewController class]]) {
            obj = [obj nextResponder];
        }
        
        
        // 遍历nextResponder,查找外层tableview
    }else{
        self.tableView.scrollEnabled = YES;
    }
}




//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat y = [scrollView.panGestureRecognizer velocityInView:self.tableView].y;
//    if (scrollView.contentOffset.y <= 0) {
//        self.tableView.scrollEnabled = NO;
//        NSLog(@"scrollEnabled == NO");
//    }
//}
//
//
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if (scrollView.contentOffset.y <= 0) {
//        self.tableView.scrollEnabled = NO;
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    
//}








@end
