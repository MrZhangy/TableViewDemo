//
//  ViewController.m
//  TableViewDemo
//
//  Created by zhangyafeng on 15/5/7.
//  Copyright (c) 2015年 think. All rights reserved.
//

#import "ViewController.h"
#import "MenuViewEx.h"
#import "MenuViewController.h"
#import "TableViewViewController.h"
#import "TripleNestGestureRecognizer.h"




@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

-(void)run;
@end

@implementation ViewController
{
    UIView *topView;
    UIView *bottomView;
    
}
- (IBAction)addButton:(id)sender {
    
    UIViewController *viewController = [self viewControllerWithView:self.view];
    
    NSLog(@"%p", viewController);
    
}

- (UIViewController *)viewControllerWithView:(UIView*)view {
    for (UIView* next = view; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}




- (void)viewDidLoad {
    [super viewDidLoad];

    
    //scrollView三级嵌套问题
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 300)];
    topView.backgroundColor = [UIColor blueColor];
    
    UIScrollView * hhScrollView = [self createBottomScrollView];
    [self createTableView];
    [hhScrollView addSubview:self.tableView];
    
    MenuViewEx *menuEx = [[MenuViewEx alloc] initWithFrame:self.view.bounds topView:topView bottomView:hhScrollView];
    [menuEx addObserverWithView:self.tableView];
    [self.view addSubview:menuEx];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIScrollView*)createBottomScrollView
{
    UIScrollView *hhScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(topView.frame), self.view.frame.size.width, CGRectGetHeight(self.view.frame))];
    hhScrollView.contentSize = self.view.bounds.size;
    hhScrollView.backgroundColor = [UIColor redColor];
    
    return hhScrollView;
}

-(void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    [bottomView addSubview:self.tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}





@end
