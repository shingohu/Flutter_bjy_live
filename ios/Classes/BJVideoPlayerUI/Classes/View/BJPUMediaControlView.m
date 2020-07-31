//
//  BJPUMediaControlView.m
//  BJVideoPlayerUI
//
//  Created by HuangJie on 2018/3/8.
//

#import <BJLiveBase/BJLiveBase+UIKit.h>

#import "BJPUMediaControlView.h"
#import "BJPUSliderView.h"
#import "BJPUProgressView.h"
#import "BJPUTheme.h"
#import "BJPUAppearance.h"

static const CGFloat controlButtonH = 30.0;

@interface BJPUMediaControlView () <BJPUSliderProtocol>

@property (nonatomic) UIButton *playButton;
@property (nonatomic) UIButton *pauseButton;
@property (nonatomic) UIButton *scaleButton;
@property (nonatomic) UIButton *subtitleButton;
@property (nonatomic) UIButton *definitionButton;
@property (nonatomic) UIButton *rateButton;

@property (nonatomic) UILabel *currentTimeLabel;
@property (nonatomic) UILabel *durationLabel;
@property (nonatomic) BJPUProgressView *progressView;
@property (nonatomic) BOOL stopUpdateProgress;
@property (nonatomic, readwrite) BOOL existSubtitle;
@property (nonatomic) BOOL horizen;

@end

@implementation BJPUMediaControlView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [[BJPUTheme brandColor] colorWithAlphaComponent:0.4];
        [self setupSubviews];
    }
    return self;
}

#pragma mark - subViews

- (void)setupSubviews {
    CGFloat margin = 5.0;
    
    // 播放按钮
    [self addSubview:self.playButton];
    [self.playButton bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.left.equalTo(self).offset(margin);
        make.centerY.equalTo(self);
        make.size.equal.sizeOffset(CGSizeMake(controlButtonH, controlButtonH));
    }];
    
    // 暂停按钮
    [self addSubview:self.pauseButton];
    [self.pauseButton bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.edges.equalTo(self.playButton);
    }];
    
    // 横竖屏切换按钮
    [self addSubview:self.scaleButton];
    [self.scaleButton bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-margin);
        make.height.equalTo(@(controlButtonH));
        make.width.equalTo(@(controlButtonH));
    }];
    
    // 进度条: 约束待定
    [self addSubview:self.progressView];
    
    // 当前时间: 约束待定
    [self addSubview:self.currentTimeLabel];
    
    // 总时间: 约束待定
    [self addSubview:self.durationLabel];
    
    // 倍速按钮
    [self addSubview:self.rateButton];
    [self.rateButton bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.scaleButton.bjl_left).offset(-margin);
        make.height.equalTo(@(controlButtonH));
        make.width.equalTo(@0.0); // to update
    }];
    
    // 清晰度按钮
    [self addSubview:self.definitionButton];
    [self.definitionButton bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.rateButton.bjl_left);
        make.height.equalTo(@(controlButtonH));
        make.width.equalTo(@0.0); // to update
    }];
    
    // 字幕
    [self addSubview:self.subtitleButton];
    [self.subtitleButton bjl_makeConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.definitionButton.bjl_left);
        make.height.equalTo(@(controlButtonH));
        make.width.equalTo(@0.0); // to update
    }];
}

#pragma mark - public

- (void)updateConstraintsWithLayoutType:(BOOL)horizon {
    self.horizen = horizon;
    CGFloat margin = 5.0;
    
    if (self.horizen) {
        [self.scaleButton setImage:[UIImage bjpu_imageNamed:@"ic_scale_horizen"] forState:UIControlStateNormal];
    }
    else {
        [self.scaleButton setImage:[UIImage bjpu_imageNamed:@"ic_scale"] forState:UIControlStateNormal];
    }
    
    // 竖屏下controlView上不显示倍速, 在屏幕的右上方显示
    [self.rateButton bjl_updateConstraints:^(BJLConstraintMaker *make) {
        make.width.equalTo((self.horizen)? @45.0 : @0.0);
    }];
    
    [self.definitionButton bjl_updateConstraints:^(BJLConstraintMaker *make) {
        make.width.equalTo(@45.0);
    }];
    
    // 竖屏下controlView上不显示字幕, 在屏幕的右上方显示
    [self.subtitleButton bjl_updateConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.width.equalTo((self.existSubtitle && self.horizen)? @45.0 : @0.0);
    }];
    
    [self.durationLabel bjl_remakeConstraints:^(BJLConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.subtitleButton.bjl_left).offset(-margin);
    }];
    
    [self.currentTimeLabel bjl_remakeConstraints:^(BJLConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.playButton.bjl_right).offset(margin);
    }];
    
    [self.progressView bjl_remakeConstraints:^(BJLConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.currentTimeLabel.bjl_right).offset(15.0);
        make.right.equalTo(self.durationLabel.bjl_left).offset(-15.0);
        make.height.equalTo(self);
    }];
}

- (void)updateProgressWithCurrentTime:(NSTimeInterval)currentTime
                        cacheDuration:(NSTimeInterval)cacheDuration
                        totalDuration:(NSTimeInterval)totalDuration {
    if (self.stopUpdateProgress) {
        return;
    }
    BOOL durationInvalid = (ceil(totalDuration) <= 0);
    self.currentTimeLabel.text = durationInvalid? @"" : [NSString stringFromTimeInterval:currentTime totalTimeInterval:totalDuration];
    self.durationLabel.text = durationInvalid? @"" : [NSString stringWithFormat:@"%@", [NSString stringFromTimeInterval:totalDuration]];
    [self.progressView setValue:currentTime cache:cacheDuration duration:totalDuration];
}

- (void)updateWithPlayState:(BOOL)playing {
    self.playButton.hidden = playing;
    self.pauseButton.hidden = !playing;
}

- (void)setSlideEnable:(BOOL)enable {
    self.progressView.userInteractionEnabled = enable;
}

- (void)updateWithRate:(NSString *)rateString {
    [self.rateButton setTitle:rateString ?: @"1.0X" forState:UIControlStateNormal];
}

- (void)updateWithDefinition:(NSString *)definitionString {
    [self.definitionButton setTitle:definitionString ?: @"高清" forState:UIControlStateNormal];
}

- (void)updateSubtitleExist:(BOOL)exist {
    self.existSubtitle = exist;
    [self updateConstraintsWithLayoutType:self.horizen];
}

#pragma mark - actions

- (void)playAction:(UIButton *)button {
    if (self.mediaPlayCallback) {
        self.mediaPlayCallback();
    }
    
    [self disablePlayControlsAndThenRecover];
}

- (void)pauseAction:(UIButton *)button {
    if (self.mediaPauseCallback) {
        self.mediaPauseCallback();
    }
    
    [self disablePlayControlsAndThenRecover];
}

- (void)scaleAction:(UIButton *)button {
    if (self.scaleCallback) {
        self.scaleCallback(!self.horizen);
    }
}

- (void)showSubtitleList {
    if (self.showSubtitleListCallback) {
        self.showSubtitleListCallback();
    }
}

- (void)showRateList {
    if (self.showRateListCallback) {
        self.showRateListCallback();
    }
}

- (void)showDefinitionList {
    if (self.showDefinitionListCallback) {
        self.showDefinitionListCallback();
    }
}

- (void)sliderChanged:(BJPUVideoSlider *)slider {
    self.stopUpdateProgress = YES;
    self.slideCanceled = NO;
    if (slider.maximumValue > 0.0) {
        self.currentTimeLabel.text = [NSString stringFromTimeInterval:slider.value totalTimeInterval:slider.maximumValue];
    }
}

- (void)touchSlider:(BJPUVideoSlider *)slider {
    self.stopUpdateProgress = YES;
    self.slideCanceled = NO;
    if (slider.maximumValue > 0.0) {
        self.currentTimeLabel.text = [NSString stringFromTimeInterval:slider.value totalTimeInterval:slider.maximumValue];
    }
}

- (void)dragSlider:(BJPUVideoSlider *)slider {
    self.stopUpdateProgress = NO;
    self.slideCanceled = YES;
    if (self.mediaSeekCallback) {
        self.mediaSeekCallback(slider.value);
    }
}

- (void)disablePlayControlsAndThenRecover {
    [self setPlayControlButtonsEnabled:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setPlayControlButtonsEnabled:YES];
    });
}

- (void)setPlayControlButtonsEnabled:(BOOL)enabled {
    self.playButton.enabled = enabled;
    self.pauseButton.enabled = enabled;
}

#pragma mark - setters & getters

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = ({
            UIButton *button = [[UIButton alloc] init];
            [button setImage:[BJPUTheme playButtonImage] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _playButton;
}

- (UIButton *)pauseButton {
    if (!_pauseButton) {
        _pauseButton = ({
            UIButton *button = [[UIButton alloc] init];
            [button setImage:[BJPUTheme pauseButtonImage] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(pauseAction:) forControlEvents:UIControlEventTouchUpInside];
            button.hidden = YES;
            button;
        });
    }
    return _pauseButton;
}

- (UIButton *)scaleButton {
    if (!_scaleButton) {
        _scaleButton = ({
            UIButton *button = [[UIButton alloc] init];
            [button setImage:[BJPUTheme scaleButtonImage] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(scaleAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _scaleButton;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [BJPUTheme defaultTextColor];
            label.font = [UIFont systemFontOfSize:10.0];
            label;
        });
    }
    return _currentTimeLabel;
}

- (UILabel *)durationLabel {
    if (!_durationLabel) {
        _durationLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [BJPUTheme defaultTextColor];
            label.font = [UIFont systemFontOfSize:10.0];
            label;
        });
    }
    return _durationLabel;
}

- (BJPUProgressView *)progressView {
    if (!_progressView) {
        _progressView = ({
            BJPUProgressView *view = [[BJPUProgressView alloc] init];
            [view.slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
            [view.slider addTarget:self action:@selector(touchSlider:) forControlEvents:UIControlEventTouchDragInside];
            [view.slider addTarget:self action:@selector(dragSlider:) forControlEvents:UIControlEventTouchUpInside];
            [view.slider addTarget:self action:@selector(dragSlider:) forControlEvents:UIControlEventTouchUpOutside];
            [view.slider addTarget:self action:@selector(dragSlider:) forControlEvents:UIControlEventTouchCancel];
            view;
        });
    }
    return _progressView;
}

- (UIButton *)subtitleButton {
    if (!_subtitleButton) {
        _subtitleButton = ({
            UIButton *button = [[UIButton alloc] init];
            button.clipsToBounds = YES;
            [button setTitleColor:[BJPUTheme defaultTextColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setTitle:@"字幕" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(showSubtitleList) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _subtitleButton;
}

- (UIButton *)definitionButton {
    if (!_definitionButton) {
        _definitionButton = ({
            UIButton *button = [[UIButton alloc] init];
            button.clipsToBounds = YES;
            [button setTitleColor:[BJPUTheme defaultTextColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setTitle:@"清晰度" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(showDefinitionList) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _definitionButton;
}

- (UIButton *)rateButton {
    if (!_rateButton) {
        _rateButton = ({
            UIButton *button = [[UIButton alloc] init];
            button.clipsToBounds = YES;
            [button setTitleColor:[BJPUTheme defaultTextColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setTitle:@"倍速" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(showRateList) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _rateButton;
}

@end
