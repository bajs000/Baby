//
//  LCTabbar.m
//  LuoChang
//
//  Created by Rick on 15/4/29.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

#import "LCTabbar.h"
#import "LCTabBarController.h"
#import "Baby-Swift.h"
#define BarButtonCount 3

@interface LCTabbar()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    LCTabBarButton *_selectedBarButton;
}
@end

@implementation LCTabbar
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addBarButtons];
    }
    return self;
}

- (void)addBarButtons{
    for (int i = 0 ; i<BarButtonCount ; i++) {
        LCTabBarButton *btn = [[LCTabBarButton alloc] init];
        CGFloat btnW = self.frame.size.width/BarButtonCount;
        CGFloat btnX = i * btnW;
        CGFloat btnY = 0;
        
        CGFloat btnH = self.frame.size.height;
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        NSString *imageName = [NSString stringWithFormat:@"TabBar%d",i+1];
        NSString *selImageName = [NSString stringWithFormat:@"TabBar%dSel",i+1];
        NSString *title;
        if (i==0) {
            title = @"首页";
            btn.tag = i;
        }else if(i==1){
            imageName = @"摄影机图标_点击前";
            selImageName =@"摄影机图标_点击后";
            btn.tag = i;
        }else if(i==2){
            title = @"我";
            btn.tag = i - 1;
        }
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
        if (i!=1) {
//            [btn setTitle:title forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize: 11.0];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
//            [btn setTitleColor:RGB(29, 173, 248) forState:UIControlStateSelected];
//            [btn setTitleColor:RGB(128, 128, 128) forState:UIControlStateNormal];
            [self addSubview:btn];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        }
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if(i == 0){
            [self btnClick:btn];
        }
    }
}


- (void)btnClick:(UIButton *)button{
    if (button.tag == 1 && UserModel.share.userId.length == 0) {
        UIResponder *vc = self.nextResponder;
        for (int i = 0; i < 10; i++) {
            if ([vc isKindOfClass:[UITabBarController class]]) {
                UINavigationController *nav = [((UIViewController *)vc).storyboard instantiateViewControllerWithIdentifier:@"loginNav"];
                [((UIViewController *)vc) presentViewController:nav animated:true completion:nil];
                return;
            }
            vc = vc.nextResponder;
        }
    }
    [self.delegate changeNav:_selectedBarButton.tag to:button.tag];
    _selectedBarButton.selected = NO;
    button.selected = YES;
    _selectedBarButton = (LCTabBarButton *)button;
}

@end
