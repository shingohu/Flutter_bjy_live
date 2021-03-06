//
//  BJPUMediaSettingView.m
//  BJVideoPlayerUI
//
//  Created by HuangJie on 2018/3/9.
//

#import <BJLiveBase/BJLiveBase+UIKit.h>

#import "BJPUMediaSettingView.h"
//#import "BJPUMediaSettingCell.h"
#import "BJPUTheme.h"

#import "BJPUSubtitleView.h"

static NSString *cellIdentifier = @"settingCell";

@interface BJPUMediaSettingView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *options;
@property (nonatomic, assign) NSUInteger selectIndex;

@end

@implementation BJPUMediaSettingView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [[BJPUTheme brandColor] colorWithAlphaComponent:0.6f];
        [self setupSubView];
    }
    return self;
}

#pragma mark - subViews

- (void)setupSubView {
    [self addSubview:self.tableView];
    [self.tableView bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.left.right.centerY.equalTo(self);
        make.height.equalTo(@0.0); // to update
    }];
}

#pragma mark - update

- (void)updateWithSettingOptons:(NSArray<NSString *> *)options selectIndex:(NSUInteger)selectIndex {
    self.options = options;
    self.selectIndex = selectIndex;
    [self.tableView bjl_updateConstraints:^(BJLConstraintMaker *make) {
        make.height.equalTo(@(options.count * 40.0));
    }];
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BJPUSubtitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSInteger index = indexPath.row;
    NSString *name = [self.options bjl_objectAtIndex:index];
    BOOL selected = (self.selectIndex == index);
    [cell updateWithName:name selected:selected];
    [cell remakeSubviewConstraints];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectIndex == indexPath.row) {
        return;
    }
    self.selectIndex = indexPath.row;
    [tableView reloadData];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(optionSelected) object:nil];
    [self performSelector:@selector(optionSelected) withObject:nil afterDelay:0.8];
}

- (void)optionSelected {
    if (self.selectCallback) {
        self.selectCallback(self.selectIndex);
    }
}

#pragma mark -  getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.rowHeight = 40.0;
            if (@available(iOS 9.0, *)) {
                tableView.cellLayoutMarginsFollowReadableWidth = NO;
            }
            tableView.dataSource = self;
            tableView.delegate = self;
            [tableView registerClass:[BJPUSubtitleCell class] forCellReuseIdentifier:cellIdentifier];
            tableView;
        });
    }
    return _tableView;
}

@end
