//
//  LLAlterView.m
//  LiteratureProject
//
//  Created by 闪闪互动 on 2019/3/26.
//  Copyright © 2019 Glittering. All rights reserved.
//

#import "LLAlterView.h"

#define kButtonTag 100
@interface LLAlterView ()

@property (nonatomic ,strong) UIView *customview;
@property (nonatomic, strong) NSMutableArray <LLAlterViewAction *> *actionArray;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic,strong)  UIView *buttonContentView;
@end

@implementation LLAlterView
{
    CGSize viewSize;
    CGFloat buttonH;
}

-(instancetype)initWithFrameSize:(UIView*)messageview
{
    CGRect frame = [UIScreen mainScreen].bounds;
    if (self = [super initWithFrame:frame])
    {
        
        self.frame = frame;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _customview = messageview;
        _customview.backgroundColor = [UIColor whiteColor];
        viewSize = _customview.frame.size;
        _cornerRadius = 9;
        [self createUI];
    }
    return self;
}

-(void)createUI
{
   
    self.actionArray = [NSMutableArray array];
    self.buttons = [NSMutableArray array];
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((SCREEN_HEIGHT-viewSize.height)/2);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, viewSize.height));
    }];
    [self.backView addSubview:_customview];
    [self.backView addSubview:self.buttonContentView];
    
}

-(void)show{
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    self.backView.alpha = 0;
    self.backView.transform = CGAffineTransformScale(self.backView.transform,0.1,0.1);
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.transform = CGAffineTransformIdentity;
        self.backView.alpha = 1;
    }];
}

-(void)addAction:(LLAlterViewAction*)action
{
    if (action == nil) {
        return;
    }
   
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:action.title forState:UIControlStateNormal];
    [btn setTitleColor:action.titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = action.titleFont;
   // btn.backgroundColor = action.BackgroundColor;
    btn.enabled = action.enabled;
    btn.tag = kButtonTag + _buttons.count;
    [btn addTarget:self action:@selector(actionButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
   
    CGFloat newheight = action.buttonHeight+viewSize.height;
    [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((SCREEN_HEIGHT-newheight)/2);
        make.centerX.mas_equalTo(self);
        make.height.mas_offset(newheight);
    }];
    [self.buttonContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_customview.mas_bottom).offset(0);
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, action.buttonHeight));
    }];
    self.buttonContentView.backgroundColor = _buttonViewBackColor;
    [self.actionArray addObject:action];
    [self.buttons addObject:btn];
    [self layoutButtons];
}

-(void)layoutButtons
{
    [self.buttons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = obj;
        [button removeFromSuperview];
    }];
    CGFloat buttonw = viewSize.width/self.buttons.count;
    
    for(int i = 0; i< self.buttons.count;i++)
    {
        UIButton *btton = self.buttons[i];
        LLAlterViewAction *aciont = self.actionArray[i];
        btton.frame = CGRectMake(i*buttonw, 0, buttonw, aciont.buttonHeight);
       [self.buttonContentView addSubview:btton];
    }
}


- (UIView *)buttonContentView{
    if (!_buttonContentView) {
        _buttonContentView = [[UIView alloc]init];
        _buttonContentView.backgroundColor = [UIColor whiteColor];
        
    }
    return _buttonContentView;
}

//弹出隐藏
-(void)hide{
    if (self.superview) {
        [UIView animateWithDuration:0.5 animations:^{
            self.backView.transform = CGAffineTransformScale(self.backView.transform,0.1,0.1);
            self.backView.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

-(UIView*)backView
{
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = _cornerRadius;
        _backView.clipsToBounds = true;
    }
    return _backView;
}

- (void)actionButtonOnClick:(UIButton *)sender{
    
    LLAlterViewAction *action = _actionArray[sender.tag - kButtonTag];
    [self hide];
    
    if (action.handler) {
        action.handler(action);
    }
}
@end

#pragma mark -*********** LLAlterViewAction ************
@implementation LLAlterViewAction

- (instancetype)initWithTitle:(NSString *)title handler:(void(^)(LLAlterViewAction *))handler{
    
    if (self = [super init]) {
        self.enabled = true;
        _handler = handler;
        self.title = title;
        self.buttonHeight = 47;
    }
    return self;
}
+ (instancetype)actionTitle:(NSString *)title handler:(void(^)(LLAlterViewAction *action))handler{
    
    return [[self alloc]initWithTitle:title handler:handler];
}

@end
