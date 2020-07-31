//
//  BJPUSubtitleView.m
//  BJVideoPlayerUI
//
//  Created by xijia dai on 2019/12/25.
//  Copyright © 2019 BaijiaYun. All rights reserved.
//

#import <BJLiveBase/BJLiveBase.h>

#import "BJPUSubtitleView.h"
#import "BJPUAppearance.h"
#import "BJPUTheme.h"

static NSString *cellIdentifier = @"cellIdentifier";

@implementation BJPUSubtitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeSubviewAndConstraints];
    }
    return self;
}

- (void)makeSubviewAndConstraints {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.selectedImageView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage bjpu_imageNamed:@"ic_subtitle_selected"];
        imageView;
    });
    [self.contentView addSubview:self.selectedImageView];
    [self.selectedImageView bjl_makeConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.left.equalTo(self.contentView).offset(16.0);
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@12.0);
    }];
    self.nameLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textColor = [BJPUTheme defaultTextColor];
        label.textAlignment = NSTextAlignmentLeft;
        label;
    });
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel bjl_makeConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.left.equalTo(self.selectedImageView.bjl_right).offset(4.0);
        make.right.equalTo(self.contentView.bjl_right).offset(-21.0);
        make.top.bottom.equalTo(self.contentView);
    }];
}

- (void)updateWithName:(nullable NSString *)name selected:(BOOL)selected {
    if (name) {
        self.nameLabel.text = name;
    }
    self.nameLabel.textColor = selected ? [BJPUTheme defaultTextColor] : [[BJPUTheme defaultTextColor] colorWithAlphaComponent:0.7];
    self.selectedImageView.hidden = !selected;
}

- (void)remakeSubviewConstraints {
    [self.nameLabel bjl_remakeConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.top.bottom.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView).offset(5);
    }];
    [self.selectedImageView bjl_remakeConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.centerY.equalTo(self.contentView);
        make.width.height.equalTo(@12.0);
        make.right.equalTo(self.nameLabel.bjl_left).offset(-10.0);
    }];
}

@end

@interface BJPUSubtitleView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UISwitch *subtitleSwitch;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray<NSString *> *options;
@property (nonatomic) NSUInteger selectedIndex;

@end

@implementation BJPUSubtitleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self makeSubviewAndConstraints];
    }
    return self;
}

- (void)dealloc {
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)makeSubviewAndConstraints {
    self.backgroundColor = [[BJPUTheme brandColor] colorWithAlphaComponent:0.6f];

    UILabel *switchLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"字幕：";
        label.textColor = [BJPUTheme defaultTextColor];
        label;
    });
    [self addSubview:switchLabel];
    [switchLabel bjl_makeConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.left.equalTo(self).offset(16.0);
        make.top.equalTo(self).offset(32.0);
        make.height.equalTo(@17.0);
    }];
    
    self.subtitleSwitch = ({
        UISwitch *swiitch = [UISwitch new];
        swiitch.onTintColor = [BJPUTheme blueBrandColor];
        swiitch.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
//        swiitch.layer.masksToBounds = YES;
        swiitch.layer.cornerRadius = 16;
        swiitch.on = YES;
        [swiitch addTarget:self action:@selector(updateSubtitleOn:) forControlEvents:UIControlEventValueChanged];
        // swiitch的系统默认size: h:31 w:51
        swiitch.transform = CGAffineTransformMakeScale(0.6f,0.6f);
        swiitch;
    });
    [self addSubview:self.subtitleSwitch];
    [self.subtitleSwitch bjl_makeConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.left.equalTo(switchLabel.bjl_right);
        make.centerY.equalTo(switchLabel);
        make.height.equalTo(@31.0);
    }];
    
    UILabel *subtitleLabel = ({
        UILabel *label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:12.0];
        label.textColor = [BJPUTheme defaultTextColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"切换：";
        label;
    });
    [self addSubview:subtitleLabel];
    [subtitleLabel bjl_makeConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.left.height.equalTo(switchLabel);
        make.top.equalTo(switchLabel.bjl_bottom).offset(12.0);
    }];
    
    self.tableView = ({
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
    [self addSubview:self.tableView];
    [self.tableView bjl_makeConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.top.equalTo(subtitleLabel.bjl_bottom);
        make.left.right.bottom.equalTo(self);
    }];
}

- (void)updateWithSettingOptons:(NSArray<NSString *> *)options selectedIndex:(NSUInteger)selectedIndex on:(BOOL)on {
    self.options = options;
    if (selectedIndex < self.options.count) {
        self.selectedIndex = selectedIndex;
    }
    if (self.tableView) {
        [self.tableView reloadData];
    }
    if (self.subtitleSwitch) {
        self.subtitleSwitch.on = on;
    }
}

- (void)updateSubtitleOn:(UISwitch *)swiitch {
    BOOL on = swiitch.on;
    if (self.showSubtitleCallback) {
        self.showSubtitleCallback(on);
    }
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BJPUSubtitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSInteger index = indexPath.row;
    NSString *name = [self.options bjl_objectAtIndex:index];
    [cell updateWithName:name selected:index == self.selectedIndex];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    if (self.selectCallback) {
        self.selectCallback(self.selectedIndex);
    }
    [tableView reloadData];
}

@end
