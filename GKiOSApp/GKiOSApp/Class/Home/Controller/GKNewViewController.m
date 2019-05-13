//
//  GKNewViewController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/10.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewViewController.h"

@interface GKNewViewController ()

@end

@implementation GKNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATHeaderRefresh|ATHeaderAutoRefresh];
    // Do any additional setup after loading the view.
}
- (void)refreshData:(NSInteger)page{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
