//
//  BrowserController.m
//  GKiOSApp
//
//  Created by wangws1990 on 2019/5/23.
//  Copyright © 2019 wangws1990. All rights reserved.
//

#import "ATBrowserController.h"

@interface ATBrowserController ()<VTMagicViewDataSource,VTMagicViewDelegate>
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) NSArray *listDatas;
@property (strong, nonatomic) NSMutableArray *listTitles;
@property (strong, nonatomic) VTMagicController * magicController;

@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *downBtn;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UILabel *subTitleLab;
@property (strong, nonatomic) UILabel *indexLab;
@property (strong, nonatomic) ATBrowserItemController *currentVc;
@end

@implementation ATBrowserController
- (void)dealloc{
    
}
+ (instancetype)vcWithDatas:(NSArray *)listData selectIndex:(NSInteger)index{
    ATBrowserController *vc = [[[self class] alloc] init];
    vc.listDatas = listData;
    vc.index = index;
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    [self loadUI];
    [self loadData];
    [self loadAction];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)loadUI{
    
    [self addChildViewController:self.magicController];
    [self.view addSubview:self.magicController.view];
    [self.view setNeedsUpdateConstraints];
    UIView * magicView = self.magicController.view;
    [magicView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[magicView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(magicView)]];
    [temp addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[magicView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(magicView)]];
    [self.view addConstraints:temp];

    [self.view addSubview:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(32);
        make.left.equalTo(self.backBtn.superview).offset(10);
        make.top.equalTo(self.backBtn.superview).offset(STATUS_BAR_HIGHT+6);
    }];
    [self.view addSubview:self.downBtn];
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(25);
        make.right.equalTo(self.downBtn.superview).offset(-10);
        make.centerY.equalTo(self.backBtn);
    }];
    
    [self.view addSubview:self.subTitleLab];
    [self.view addSubview:self.titleLab];
    [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.subTitleLab.superview).offset(-TAB_BAR_ADDING - 20);
        make.left.equalTo(self.subTitleLab.superview).offset(15);
        make.right.equalTo(self.subTitleLab.superview).offset(-15);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.subTitleLab);
        make.bottom.equalTo(self.subTitleLab.mas_top).offset(-15);
    }];
    
    
    [self.view addSubview:self.indexLab];
    [self.indexLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn);
        make.centerX.equalTo(self.indexLab.superview);
    }];
}
- (void)loadData{
    self.listTitles = @[].mutableCopy;
    [self.listDatas enumerateObjectsUsingBlock:^(ATBrowserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj conformsToProtocol:@protocol(ATBrowserProtocol)]) {
             [self.listTitles addObject:obj.title ?:@""];
        }
    }];
    [self.magicController.magicView reloadDataToPage:self.index];
}
- (void)loadAction{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}
- (void)tapAction:(UITapGestureRecognizer *)sender{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionPush;
    animation.duration = 0.3;
    [self.titleLab.layer addAnimation:animation forKey:nil];
    [self.subTitleLab.layer addAnimation:animation forKey:nil];
    self.titleLab.hidden = !self.titleLab.hidden;
    self.subTitleLab.hidden = self.titleLab.hidden;
}
- (void)saveAction{
    if ([self.currentVc respondsToSelector:@selector(saveAction)] && self.currentVc) {
        [self.currentVc saveAction];
    }
}
#pragma mark VTMagicViewDataSource,VTMagicViewDelegate
/**
 *  获取所有菜单名，数组中存放字符串类型对象
 *
 *  @param magicView self
 *
 *  @return header数组
 */
- (NSArray<__kindof NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView
{
    return self.listTitles;
}
/**
 *  根据itemIndex加载对应的menuItem
 *
 *  @param magicView self
 *  @param itemIndex 需要加载的菜单索引
 *
 *  @return 当前索引对应的菜单按钮
 */
- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex
{
    
    static NSString *itemIdentifier = @"com.browser.btn.itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return menuItem;
}
/**
 *  根据pageIndex加载对应的页面控制器
 *
 *  @param magicView self
 *  @param pageIndex 需要加载的页面索引
 *
 *  @return 页面控制器
 */
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex
{
    static NSString *itemIdentifier = @"com.browser.itemIdentifier";
    ATBrowserItemController *vc = [magicView dequeueReusablePageWithIdentifier:itemIdentifier];
    if (!vc) {
        vc = [[ATBrowserItemController alloc] init];
    }
    ATBrowserModel *model = self.listDatas[pageIndex];
    vc.object = model.url ?: model.image;
    return vc;
}
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController*)viewController atPage:(NSUInteger)pageIndex{
    ATBrowserModel *model = self.listDatas[pageIndex];
    self.indexLab.text = [NSString stringWithFormat:@"%@/%@",@(pageIndex+1),@(self.listDatas.count)];
    self.titleLab.text = model.title ?:@"";
    self.subTitleLab.attributedText = [self getTitle:model.desc ?:@""];
    self.currentVc = (ATBrowserItemController *)viewController;
}
- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex{

}

#pragma mark get
-(VTMagicController *)magicController {
    
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.separatorHeight = 0.0f;
        _magicController.magicView.navigationInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.layoutStyle = VTLayoutStyleDefault;
        _magicController.magicView.navigationHeight = 0.0f;
        _magicController.magicView.againstStatusBar = NO;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.needPreloading = YES;
        _magicController.magicView.bounces = NO;
        
    }
    return _magicController;
}
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"weather_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
- (UIButton *)downBtn{
    if (!_downBtn) {
        _downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downBtn setImage:[UIImage imageNamed:@"icon_down"] forState:UIControlStateNormal];
        [_downBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
//        _downBtn.layer.masksToBounds = YES;
//        _downBtn.layer.cornerRadius = 13;
//        _downBtn.layer.borderWidth = 1.0f;
//        _downBtn.layer.borderColor = [UIColor colorWithRGB:0xdddddd].CGColor;
    }
    return _downBtn;
}
- (UILabel *)indexLab{
    if (!_indexLab) {
        _indexLab = [[UILabel alloc] init];
        _indexLab.font = [UIFont systemFontOfSize:16];
        _indexLab.textColor = [UIColor whiteColor];
        _indexLab.translatesAutoresizingMaskIntoConstraints = NO;
        _indexLab.textAlignment = NSTextAlignmentCenter;
    }
    return _indexLab;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:16];
        _titleLab.textColor = [UIColor whiteColor];
        _titleLab.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLab.numberOfLines = 1;
    }
    return _titleLab;
}
- (UILabel *)subTitleLab{
    if (!_subTitleLab) {
        _subTitleLab = [[UILabel alloc] init];
        _subTitleLab.font = [UIFont systemFontOfSize:16];
        _subTitleLab.textColor = [UIColor whiteColor];
        _subTitleLab.translatesAutoresizingMaskIntoConstraints = NO;
        _subTitleLab.numberOfLines = 0;
    }
    return _subTitleLab;
}

- (NSMutableAttributedString*)getTitle:(NSString*)str {
    
    NSMutableParagraphStyle   *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//行间距
    paragraphStyle.alignment = NSTextAlignmentJustified;//文本对齐方式 左右对齐（两边对齐）
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:[str rangeOfString:str]];//设置段落样式
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:[str rangeOfString:str]];//设置字体大小
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:[str rangeOfString:str]];//这段话必须要添加，否则UIlabel两边对齐无效 NSUnderlineStyleAttributeName （设置下划线）
    
    return attributedString;
    
}
@end
