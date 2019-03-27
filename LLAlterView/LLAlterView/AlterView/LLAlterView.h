//
//  LLAlterView.h
//  LiteratureProject
//
//  Created by 闪闪互动 on 2019/3/26.
//  Copyright © 2019 Glittering. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LLAlterViewAction:NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, getter=isEnabled) BOOL enabled;

@property(nonatomic,copy)void(^handler)(LLAlterViewAction *);
//设置按钮UI属性
@property (nonatomic, strong, nullable) UIFont *titleFont;
@property (nonatomic, strong, nullable) UIColor *titleColor;
@property (nonatomic, strong, nullable) UIColor *BackgroundColor;
@property (nonatomic, assign, ) CGFloat  buttonHeight;//默认47

+ (instancetype)actionTitle:(NSString *)title handler:(void(^)(LLAlterViewAction *action))handler;

@end

@interface LLAlterView : UIView

@property(nonatomic,strong)UIView *backView;

@property(nonatomic,assign)CGFloat cornerRadius;//圆角

-(instancetype)initWithFrameSize:(UIView*)messageview;

@property (nonatomic, strong, nullable) UIColor *buttonViewBackColor;

-(void)addAction:(LLAlterViewAction*)action;

-(void)show;
@end

NS_ASSUME_NONNULL_END
