//
//  ViewController.m
//  WKWebview与js交互
//
//  Created by 陈伟杰 on 2018/11/9.
//  Copyright © 2018年 陈伟杰. All rights reserved.
//
#import <WebKit/WebKit.h>
#import "ViewController.h"

@interface ViewController ()<WKNavigationDelegate,WKScriptMessageHandler>
@property(nonatomic,strong)WKWebView *wkwebview;
@property(nonatomic,strong)WKUserContentController *userConfiguration;
@property(nonatomic,strong)UIButton *btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.wkwebview];
    NSString *url = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    [self.wkwebview loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:url]]];
    [self.view addSubview:self.btn];
}

- (void)goNativeCallJS{
    [self.wkwebview evaluateJavaScript:@"nativeCallJS('callyou')" completionHandler:^(id _Nullable dic, NSError * _Nullable error) {
        NSLog(@"js的回调:%@",dic);
    }];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"%@",message.name);
    NSLog(@"%@",message.body);
    
    if ([message.name isEqualToString:@"ZXEventHandler"]) {
        NSString *js = [NSString stringWithFormat:@"ZXEventHandler.callBack('%@','%@');",message.body[@"callBackID"],@"[\"111\",\"222\"]"];
        [self.wkwebview evaluateJavaScript:js completionHandler:^(id _Nullable dic, NSError * _Nullable error) {
            
        }];
    }
    
}

-(WKWebView *)wkwebview{
    if (!_wkwebview) {
        WKWebViewConfiguration * Configuration = [[WKWebViewConfiguration
                                                   alloc]init];
        Configuration.userContentController = self.userConfiguration;
        _wkwebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) configuration:Configuration];
        _wkwebview.navigationDelegate = self;
        [_wkwebview.configuration.userContentController addScriptMessageHandler:self name:@"ZXEventHandler"];
    }
    return _wkwebview;
}

-(WKUserContentController *)userConfiguration{
    if (!_userConfiguration) {
        _userConfiguration = [[WKUserContentController alloc] init];
    }
    return _userConfiguration;
}

-(UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(10, 350, 100, 21);
        [_btn setTitle:@"nativeCalljs" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btn setBackgroundColor:[UIColor lightGrayColor]];
        _btn.titleLabel.font = [UIFont systemFontOfSize:14];
        _btn.layer.borderWidth = 0.5;
        _btn.layer.borderColor = [UIColor blackColor].CGColor;
        _btn.layer.cornerRadius = 10;
        [_btn addTarget:self action:@selector(goNativeCallJS) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}


@end
