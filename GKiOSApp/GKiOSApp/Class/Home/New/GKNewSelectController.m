//
//  GKNewSelectController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/27.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "GKNewSelectController.h"
#import "GKHomeCollectionReusableView.h"
#import "GKNewSelectCell.h"
@interface GKNewSelectController ()
@property (strong, nonatomic) NSMutableArray *listData;
@property (strong, nonatomic) NSMutableArray *listTitles;
@property (strong, nonatomic) GKNewTopModel *model;
@property (assign, nonatomic)id<GKNewSelectDelegate>delegate;
@property (assign, nonatomic) BOOL editor;
@end

@implementation GKNewSelectController
+ (instancetype)vcWithSelect:(GKNewTopModel *)model delegate:(id<GKNewSelectDelegate>)delegate{
    GKNewSelectController *vc = [[[self class] alloc] init];
    vc.model = model;
    vc.delegate = delegate;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self setupEmpty:self.collectionView];
    [self setupRefresh:self.collectionView option:ATRefreshNone];
    [self headerRefreshing];
    // Do any additional setup after loading the view.
}
- (void)loadUI{
    self.listData = @[].mutableCopy;
    self.listTitles = @[].mutableCopy;
    [self showNavTitle:@"标签选择"];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [self.collectionView addGestureRecognizer:longPressGesture];
}
- (void)refreshData:(NSInteger)page{
    [GKNewTopQueue getDatasFromDataBases:^(NSArray<GKNewTopModel *> * _Nonnull listData) {
        [self.listTitles removeAllObjects];
        [self.listData removeAllObjects];
        [listData enumerateObjectsUsingBlock:^(GKNewTopModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.select ? [self.listTitles addObject:obj] : [self.listData addObject:obj];
        }];
        [self.collectionView reloadData];
        listData == 0 ? [self endRefreshFailure] : [self endRefresh:NO];
    }];
}
- (void)editorAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.editor = sender.selected;
    [self.collectionView reloadData];
}
//添加删除
- (void)updateAction:(GKNewTopModel *)model{
    if (model.editor) {
        return;
    }
    model.select = !model.select;
    [GKNewTopQueue updateDataToDataBase:model completion:^(BOOL success) {
        if (success) {
            [self headerRefreshing];
            if ([self.delegate respondsToSelector:@selector(viewDidLoad:topModel:)]) {
                [self.delegate viewDidLoad:self topModel:self.model];
            }
        }
    }];
}
//移动
- (void)moveAction{
    [GKNewTopQueue insertDataToDataBases:self.listTitles.copy completion:^(BOOL success) {
        if (success) {
            if ([self.delegate respondsToSelector:@selector(viewDidLoad:topModel:)]) {
                [self.delegate viewDidLoad:self topModel:self.model];
            }
        }
    }];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section ==0 ? self.listTitles.count : self.listData.count;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,10,10,10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - 50)/4,40);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH,55);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        GKHomeCollectionReusableView *reusableView = [GKHomeCollectionReusableView viewForCollectionView:collectionView elementKind:UICollectionElementKindSectionHeader indexPath:indexPath];
        reusableView.titleLab.hidden = reusableView.subTitleLab.hidden = NO;
        reusableView.editorBtn.hidden = indexPath.section == 1;
        reusableView.titleLab.text = indexPath.section == 0 ?@"我的频道":@"频道推荐";
        reusableView.subTitleLab.text = indexPath.section == 0 ?@"点击进入频道":@"点击添加频道";
        reusableView.editorBtn.selected = self.editor;
        [reusableView.editorBtn addTarget:self action:@selector(editorAction:) forControlEvents:UIControlEventTouchUpInside];
        return reusableView;
    }
    return [UICollectionReusableView new];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GKNewSelectCell *cell = [GKNewSelectCell cellForCollectionView:collectionView indexPath:indexPath];
    NSArray *listData = indexPath.section == 0 ? self.listTitles : self.listData;
    GKNewTopModel *model = listData[indexPath.row];
    cell.titleLab.textColor = [model.userId isEqualToString:self.model.userId] &&!self.editor ? AppColor : Appx333333;
    cell.titleLab.text = indexPath.section == 0 ? model.tname ?:@"" :[NSString stringWithFormat:@"+%@",model.tname?:@""];
    cell.imageV.hidden =  model.select && self.editor&&!model.editor? NO : YES;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *listData = indexPath.section == 0 ? self.listTitles : self.listData;
    GKNewTopModel *model = listData[indexPath.row];
    if (indexPath.section == 1) {
        [self updateAction:model];
    }else if (indexPath.section == 0){
        if (self.editor) {
            self.model = nil;
            [self updateAction:model];
        }else{
            if ([self.delegate respondsToSelector:@selector(viewDidItem:topModel:)]) {
                [self.delegate viewDidItem:self topModel:model];
            }
            [self goBack];
        }
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *listData = indexPath.section == 0 ? self.listTitles : self.listData;
    GKNewTopModel *model = listData[indexPath.row];
    return indexPath.section == 0 && !model.editor;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.section == 0 && destinationIndexPath.section == 0) {
        GKNewTopModel *model = self.listTitles[destinationIndexPath.row];
        if (!model.editor) {
            GKNewTopModel *topModel = self.listTitles[sourceIndexPath.row];
            NSInteger sort = model.sort;
            model.sort = topModel.sort;
            topModel.sort = sort;
            [self.listTitles exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
            [self moveAction];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    CGPoint point = [longPress locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            if (!indexPath) {
                break;
            }
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            break;
        case UIGestureRecognizerStateChanged:
            [self.collectionView updateInteractiveMovementTargetPosition:point];
            break;
        case UIGestureRecognizerStateEnded:
            [self.collectionView endInteractiveMovement];
//            [self.collectionView reloadData];
            break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}
@end
