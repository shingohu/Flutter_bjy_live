//
//  BJPUSubtitleView.h
//  BJVideoPlayerUI
//
//  Created by xijia dai on 2019/12/25.
//  Copyright © 2019 BaijiaYun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BJPUSubtitleCell : UITableViewCell

@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UIImageView *selectedImageView;

- (void)updateWithName:(nullable NSString *)name selected:(BOOL)selected;
- (void)remakeSubviewConstraints;

@end

@interface BJPUSubtitleView : UIView

- (void)updateWithSettingOptons:(NSArray<NSString *> *)options selectedIndex:(NSUInteger)selectedIndex on:(BOOL)on;

@property (nonatomic, copy) void (^selectCallback)(NSUInteger selectedIndex);
@property (nonatomic, copy) void (^showSubtitleCallback)(BOOL showSubtitle);

@end

NS_ASSUME_NONNULL_END
