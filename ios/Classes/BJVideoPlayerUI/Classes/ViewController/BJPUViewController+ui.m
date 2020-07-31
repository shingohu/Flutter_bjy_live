//
//  BJPUViewController+ui.m
//  BJVideoPlayerUI
//
//  Created by HuangJie on 2018/3/8.
//

#import <BJLiveBase/BJLiveBase+UIKit.h>

#import "BJPUViewController+ui.h"
#import "BJPUViewController+protected.h"
#import "BJPUViewController+media.h"
#import "BJPUTheme.h"

@implementation BJPUViewController (ui)

- (void)setupSubviews {
    // playerView
    UIView *playerView = self.playerManager.playerView;
    [self.view addSubview:playerView];
    [playerView bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // audioOnlyImageView
    [self.view addSubview:self.audioOnlyImageView];
    [self.audioOnlyImageView bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.edges.equalTo(playerView);
    }];
    
    // subtitleLabel
    [self.view addSubview:self.subtitleLabel];
    [self.subtitleLabel bjl_makeConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.centerX.equalTo(self.view);
        make.bottom.left.right.equalTo(self.view.bjl_safeAreaLayoutGuide ?: self.view).inset(18.0);
    }];
    
    // mediaControlView
    [self.view addSubview:self.mediaControlView];
    [self.mediaControlView bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view.bjl_safeAreaLayoutGuide ?: self.view);
        make.height.equalTo(@40.0).priorityHigh();
    }];
    
    // topBarView
    CGFloat topBarHeight = 40.0;
    [self.view addSubview:self.topBarView];
    [self.topBarView bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(topBarHeight)).priorityHigh();
    }];
    
    // cancelButton
    UIButton *cancelButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button setImage:[BJPUTheme backButtonImage] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.imageEdgeInsets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.topBarView addSubview:cancelButton];
    [cancelButton bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.top.left.equalTo(self.topBarView.bjl_safeAreaLayoutGuide ?: self.topBarView);
        make.size.equal.sizeOffset(CGSizeMake(topBarHeight * 1.5, topBarHeight));
    }];
    
    // sliderView
    [self.view addSubview:self.sliderView];
    [self.sliderView bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topBarView.bjl_bottom);
        make.bottom.equalTo(self.mediaControlView.bjl_top);
    }];
    
    // lockButton
    [self.view addSubview:self.lockButton];
    [self.lockButton bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.left.equalTo(self.view.bjl_safeAreaLayoutGuide ?: self.view).offset(20.0);
        make.centerY.equalTo(self.view);
    }];
    
    // mediaSettingView
    [self.view addSubview:self.mediaSettingView];
    [self.mediaSettingView bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.view.bjl_safeAreaLayoutGuide ?: self.view);
        make.width.equalTo(self.view).multipliedBy(0.21);
    }];
    
    // reload view
    [self.view addSubview:self.reloadView];
    [self.reloadView bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self setupControlActions];
    [self setupVerticalButton];
}

- (void)setupVerticalButton {
    self.vSubtitleButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.clipsToBounds = YES;
        [button setTitleColor:[BJPUTheme defaultTextColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitle:@"字幕" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(vShowSubtitleList) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    self.vRateButton =  ({
        UIButton *button = [[UIButton alloc] init];
        button.clipsToBounds = YES;
        [button setTitleColor:[BJPUTheme defaultTextColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitle:@"倍速" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(vShowRateList) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    [self.view addSubview:self.vSubtitleButton];
    [self.view addSubview:self.vRateButton];
    
    [self.vRateButton bjl_makeConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.right.equalTo(self.view.bjl_safeAreaLayoutGuide ?: self.view).offset(-5);
        make.top.equalTo(self.view.bjl_safeAreaLayoutGuide ?: self.view).offset(10);
        make.height.equalTo(@(30));
        make.width.equalTo(@0.0); // to update
    }];
    [self.vSubtitleButton bjl_makeConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.centerY.height.equalTo(self.vRateButton);
        make.right.equalTo(self.vRateButton.bjl_left).offset(-5);
        make.width.equalTo(@0.0); // to update
    }];
}

#pragma mark - actions

- (void)setupControlActions {
    // show & hide
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideInterfaceViews)];
    [self.sliderView addGestureRecognizer:tap];
    
    // lock
    [self.lockButton addTarget:self action:@selector(lockAction) forControlEvents:UIControlEventTouchUpInside];
    
    // cancel
    bjl_weakify(self);
    [self.reloadView setCancelCallback:^{
        bjl_strongify(self);
        [self cancelAction];
    }];
}

- (void)backAction {
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad && self.layoutType == BJVPlayerViewLayoutType_Horizon) {
        [self setLayoutType:BJVPlayerViewLayoutType_Vertical];
    }
    else {
        [self cancelAction];
    }
}

- (void)cancelAction {
    if (self.cancelCallback) {
        self.cancelCallback();
    }
    else if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.parentViewController) {
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }
    [self.playerManager destroy];
}

- (void)lockAction {
    BOOL lock = !self.lockButton.selected;
    self.lockButton.selected = lock;
    self.mediaControlView.hidden = lock;
    self.mediaSettingView.hidden = YES;
    self.topBarView.hidden = lock;
    self.sliderView.slideEnabled = !lock;
    [self.mediaControlView setSlideEnable:!lock];
    if (self.screenLockCallback) {
        self.screenLockCallback(lock);
    }
}

- (void)vShowSubtitleList {
    [self showSubtitleView];
}

- (void)vShowRateList {
    [self showRateList];
}

#pragma mark - show & hide

- (void)hideInterfaceViews {
    NSTimeInterval duration = 1.0;
    [self hideView:self.topBarView withDuration:duration];
    [self hideView:self.mediaControlView withDuration:duration];
    [self hideView:self.lockButton withDuration:duration];
    [self hideView:self.vRateButton withDuration:duration];
    [self hideView:self.vSubtitleButton withDuration:duration];
}

- (void)hideInterfaceViewsAutomatically {
    if (!self.mediaControlView.slideCanceled) {
        // 进度条响应交互中，不执行隐藏
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideInterfaceViewsAutomatically) object:nil];
        [self performSelector:@selector(hideInterfaceViewsAutomatically) withObject:nil afterDelay:5.0];
        return;
    }
    [self hideInterfaceViews];
}

- (void)showOrHideInterfaceViews {
    if (self.layoutType == BJVPlayerViewLayoutType_Horizon) {
        self.lockButton.hidden = !self.lockButton.hidden;
        [self hideView:self.mediaSettingView withDuration:0.5];
    }
    if (self.lockButton.selected) {
        return;
    }
    
    if (!self.mediaSettingView.hidden) {
        self.mediaSettingView.hidden = YES;
    }
    if (self.subtitleView) {
        [self.subtitleView removeFromSuperview];
        self.subtitleView = nil;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideInterfaceViewsAutomatically) object:nil];
    BOOL hidden = !self.mediaControlView.hidden;
    self.mediaControlView.hidden = hidden;
    self.topBarView.hidden = hidden;
    self.vSubtitleButton.hidden = hidden;
    self.vRateButton.hidden = hidden;
    if (!self.mediaControlView.hidden) {
        [self performSelector:@selector(hideInterfaceViewsAutomatically) withObject:nil afterDelay:5.0];
    }
}

- (void)hideView:(UIView *)view withDuration:(NSTimeInterval)duration {
    [UIView animateWithDuration:0.5 animations:^{
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        view.hidden = YES;
        view.alpha = 1.0;
    }];
}

#pragma mark - public

- (void)updateConstriantsWithLayoutType:(BJVPlayerViewLayoutType)layoutType {
    BOOL horizen = (layoutType == BJVPlayerViewLayoutType_Horizon);
    BOOL locked = self.lockButton.selected;
    if (locked && !horizen) {
        [self setLayoutType:BJVPlayerViewLayoutType_Horizon];
        return;
    }
    [self setLayoutType:layoutType];
    [self updatePlayProgress];

    [self.mediaControlView updateConstraintsWithLayoutType:horizen];
    
    BOOL controlHidden = self.mediaControlView.hidden;
    
    // mediaSettingView 和 subtitleView, 维持原来的状态
    self.mediaSettingView.hidden = self.mediaSettingView.hidden;
    self.subtitleView.hidden = self.subtitleView.hidden;
    
    // lockButton只有在横屏下才显示
    self.lockButton.hidden = !horizen || controlHidden;
    
    [self.vRateButton bjl_updateConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.width.equalTo(horizen? @0.0 : @45.0);
    }];
    
    [self.vSubtitleButton bjl_updateConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.width.equalTo((self.mediaControlView.existSubtitle && !horizen)? @45.0 : @0.0);
    }];
}

- (void)updatePlayerViewConstraintWithVideoRatio:(CGFloat)ratio {
    UIView *playerView = self.playerManager.playerView;
    [playerView bjl_remakeConstraints:^(BJLConstraintMaker *make) {
        if (ratio > 0) {
            make.edges.equalTo(self.view).priorityHigh();
            make.width.equalTo(playerView.bjl_height).multipliedBy(ratio);
            make.center.equalTo(self.view);
            make.top.left.greaterThanOrEqualTo(self.view);
            make.bottom.right.lessThanOrEqualTo(self.view);
        }
        else {
            make.edges.equalTo(self.view);
        }
    }];
}

- (void)updatePlayProgress {
    NSTimeInterval curr = self.playerManager.currentTime;
    NSTimeInterval cache = self.playerManager.cachedDuration;
    NSTimeInterval total = self.playerManager.duration;    
    [self.mediaControlView updateProgressWithCurrentTime:curr
                                           cacheDuration:cache
                                           totalDuration:total];
}

- (void)updateWithPlayState:(BJVPlayerStatus)state {
    if (state == BJVPlayerStatus_paused ||
        state == BJVPlayerStatus_stopped ||
        state == BJVPlayerStatus_reachEnd ||
        state == BJVPlayerStatus_failed ||
        state == BJVPlayerStatus_ready) {
        [self.mediaControlView updateWithPlayState:NO];
    }
    else if (state == BJVPlayerStatus_playing) {
        [self.mediaControlView updateWithPlayState:YES];
    }
    
    [self updatePlayProgress];
}

- (void)showMediaSettingView {
    [self hideInterfaceViews];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mediaSettingView.hidden = NO;
    });
}

- (void)showSubtitleView {
    NSArray<BJVSubtitleInfo *> *infos = self.playerManager.playInfo.subtitleInfo;
    NSMutableArray<NSString *> *infoName = [NSMutableArray new];
    NSInteger selectedIndex = 0;
    for (NSInteger index = 0; index < infos.count; index ++) {
        BJVSubtitleInfo *info = [infos bjl_objectAtIndex:index];
        if (info.ID == self.playerManager.currentSubtitleInfo.ID) {
            selectedIndex = index;
        }
        [infoName bjl_addObject:info.name];
    }
    
    [self hideInterfaceViews];
    self.subtitleView = [BJPUSubtitleView new];
    [self.subtitleView updateWithSettingOptons:infoName selectedIndex:selectedIndex on:!self.subtitleLabel.hidden];
    bjl_weakify(self);
    [self.subtitleView setSelectCallback:^(NSUInteger selectedIndex) {
        bjl_strongify(self);
        [self.playerManager changeSubtitleWithIndex:selectedIndex];
    }];
    [self.subtitleView setShowSubtitleCallback:^(BOOL showSubtitle) {
        bjl_strongify(self);
        self.subtitleLabel.hidden = !showSubtitle;
    }];
    [self.view addSubview:self.subtitleView];
    [self.subtitleView bjl_makeConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.top.bottom.right.equalTo(self.view.bjl_safeAreaLayoutGuide ?: self.view);
        make.width.equalTo(self.view).multipliedBy(0.27);
    }];
}

- (BOOL)isHorizon {
    UIView *superView = self.view.superview;
    if (!superView) {
        return YES;
    }
    else {
        return superView.bounds.size.width > superView.bounds.size.height;
    }
}

- (void)updateVSubtitleButtonConstriants:(BOOL)subtitleExist {
    [self.vSubtitleButton bjl_updateConstraints:^(BJLConstraintMaker * _Nonnull make) {
        // 不是横屏 && 字幕存在的时候, 显示 vSubtitleButton
        make.width.equalTo((![self isHorizon] && subtitleExist)? @45.0 : @0.0);
    }];
}

@end
