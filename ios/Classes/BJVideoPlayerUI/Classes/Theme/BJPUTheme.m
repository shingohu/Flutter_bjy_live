//
//  BJPUTheme.m
//  BJVideoPlayerUI
//
//  Created by DLM on 2017/4/26.
//
//

#import "BJPUTheme.h"
#import "BJPUAppearance.h"

@interface BJPUTheme ()
@property (nonatomic) UIColor *defaultTextColor;
@property (nonatomic) UIColor *highlightTextColor;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) UIColor *brandColor;
@property (nonatomic) UIColor *blueBrandColor;
@property (nonatomic) UIImage *logoImage;
@property (nonatomic) UIImage *backButtonImage;
@property (nonatomic) UIImage *playButtonImage;
@property (nonatomic) UIImage *pauseButtonImage;
@property (nonatomic) UIImage *stopButtonImage;
@property (nonatomic) UIImage *nextButtonImage;
@property (nonatomic) UIImage *sliderImage;
@property (nonatomic) UIImage *scaleButtonImage;
@property (nonatomic) UIImage *forwardImage;
@property (nonatomic) UIImage *backwardImage;
@end

@implementation BJPUTheme
+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - set
+ (void)setDefaultTextColor:(UIColor *)color {
    [[BJPUTheme sharedInstance] setDefaultTextColor:color];
}

+ (void)setHighlightTextColor:(UIColor *)color {
    [[BJPUTheme sharedInstance] setHighlightTextColor:color];
}

+ (void)setBrandColor:(UIColor *)color {
    [[BJPUTheme sharedInstance] setBrandColor:color];
}

+ (void)setBlueBrandColor:(UIColor *)color {
    [[BJPUTheme sharedInstance] setBlueBrandColor:color];
}

////view
//+ (void)setCustomerView:(UIView *)view;
//{
//    
//}
//small image
+ (void)setLogoImage:(UIImage *)image {
    [BJPUTheme sharedInstance].logoImage = image;
}

+ (void)setBackButtonImage:(UIImage *)image {
    [BJPUTheme sharedInstance].backButtonImage = image;
}

+ (void)setPlayButtonImage:(UIImage *)image {
    [BJPUTheme sharedInstance].playButtonImage = image;
}

+ (void)setPauseButtonImage:(UIImage *)image {
    [BJPUTheme sharedInstance].pauseButtonImage = image;
}

+ (void)setStopButtonImage:(UIImage *)image {
    [BJPUTheme sharedInstance].stopButtonImage = image;
}

+ (void)setNextButtonImage:(UIImage *)image {
    [BJPUTheme sharedInstance].nextButtonImage = image;
}

+ (void)setProgressSliderImage:(UIImage *)image {
    [BJPUTheme sharedInstance].sliderImage = image;
}

+ (void)setScaleButtonImage:(UIImage *)image {
    [BJPUTheme sharedInstance].scaleButtonImage = image;
}

+ (void)setForwardImage:(UIImage *)image {
    [BJPUTheme sharedInstance].forwardImage = image;
}

+ (void)setBackwardImage:(UIImage *)image {
    [BJPUTheme sharedInstance].backwardImage = image;
}

#pragma mark - getter

+ (UIColor *)defaultTextColor {
    if ([BJPUTheme sharedInstance].defaultTextColor) {
        return [BJPUTheme sharedInstance].defaultTextColor;
    }
    else {
        return [UIColor bjpu_colorWithHexString:@"0xFFFFFF"];
    }
}

+ (UIColor *)highlightTextColor {
    if ([BJPUTheme sharedInstance].highlightTextColor) {
        return [BJPUTheme sharedInstance].highlightTextColor;
    }
    else {
        return [UIColor bjpu_colorWithHexString:@"0xabcdef"];
    }
}

+ (UIColor *)brandColor {
    if ([BJPUTheme sharedInstance].brandColor) {
        return [BJPUTheme sharedInstance].brandColor;
    }
    else {
        return [UIColor bjpu_colorWithHexString:@"0x000000"];
    }
}

+ (UIColor *)blueBrandColor {
    if ([BJPUTheme sharedInstance].blueBrandColor) {
        return [BJPUTheme sharedInstance].blueBrandColor;
    }
    else {
        return [UIColor bjpu_colorWithHexString:@"0x1795FF"];
    }
}

////view
//+ (UIImage *)customerView
//{
//    if ([BJPUTheme sharedInstance].customerView) {
//        return [BJPUTheme sharedInstance].customerView;
//    }
//    else {
//        return nil;
//    }
//}

//small image
+ (UIImage *)logoImage {
    if ([BJPUTheme sharedInstance].logoImage) {
        return [BJPUTheme sharedInstance].logoImage;
    }
    else {
        return [UIImage bjpu_imageNamed:@"ic_logo"];
    }
}

+ (UIImage *)playButtonImage {
    if ([BJPUTheme sharedInstance].playButtonImage) {
        return [BJPUTheme sharedInstance].playButtonImage;
    }
    else {
        return [UIImage bjpu_imageNamed:@"ic_play"];
    }
}

+ (UIImage *)pauseButtonImage {
    if ([BJPUTheme sharedInstance].pauseButtonImage) {
        return [BJPUTheme sharedInstance].pauseButtonImage;
    }
    else {
        return [UIImage bjpu_imageNamed:@"ic_pause"];
    }
}

+ (UIImage *)stopButtonImage {
    if ([BJPUTheme sharedInstance].stopButtonImage) {
        return [BJPUTheme sharedInstance].stopButtonImage;
    }
    else {
        return [UIImage bjpu_imageNamed:@"ic_stop"];
    }
}

+ (UIImage *)nextButtonImage {
    if ([BJPUTheme sharedInstance].nextButtonImage) {
        return [BJPUTheme sharedInstance].nextButtonImage;
    }
    else {
        return [UIImage bjpu_imageNamed:@"ic_next"];
    }
}

+ (UIImage *)backButtonImage {
    if ([BJPUTheme sharedInstance].backButtonImage) {
        return [BJPUTheme sharedInstance].backButtonImage;
    }
    else {
        return [UIImage bjpu_imageNamed:@"ic_back"];
    }
}

+ (UIImage *)sliderImage {
    if ([BJPUTheme sharedInstance].sliderImage) {
        return [BJPUTheme sharedInstance].sliderImage;
    }
    else {
        return [UIImage bjpu_imageNamed:@"ic_slider_s"];
    }
}

+ (UIImage *)scaleButtonImage {
    if ([BJPUTheme sharedInstance].scaleButtonImage) {
        return [BJPUTheme sharedInstance].scaleButtonImage;
    }
    else {
        return [UIImage bjpu_imageNamed:@"ic_scale"];
    }
}
+ (UIImage *)forwardImage {
    if ([BJPUTheme sharedInstance].forwardImage) {
        return [BJPUTheme sharedInstance].forwardImage;
    }
    else {
        return [UIImage bjpu_imageNamed:@"ic_forward"];
    }
}
+ (UIImage *)backwardImage {
    if ([BJPUTheme sharedInstance].backwardImage) {
        return [BJPUTheme sharedInstance].backwardImage;
    }
    else {
        return [UIImage bjpu_imageNamed:@"ic_backward"];
    }
}

@end
