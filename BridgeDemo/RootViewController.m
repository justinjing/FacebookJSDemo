//
//  RootViewController.m
//  BridgeDemo
//
//  Created by  xyh on 12-10-10.
//  Copyright (c) 2012年 xyh. All rights reserved.
//

#import "RootViewController.h"


#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface UIWebView (JavaScriptAlert)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame;
- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame;

@end

@implementation UIWebView (JavaScriptAlert)
static BOOL diagStat = NO;

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame {
    
    UIAlertView* customAlert = [[UIAlertView alloc] initWithTitle:@"MEOA"
                                                          message:message
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
    
    [customAlert show];
    [customAlert autorelease];
    
}

- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WebFrame *)frame {
    UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:nil
                                                          message:message
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定", nil];
    
    [confirmDiag show];
    
    
    while (confirmDiag.hidden == NO && confirmDiag.superview != nil) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01f]];
    }
    [confirmDiag release];
    return diagStat;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){//取消;
        diagStat = NO;
    }
    else if (buttonIndex == 1) {//确定;
        diagStat = YES;
    }
}
@end

@interface RootViewController ()

@end

@implementation RootViewController
@synthesize connection;

static RootViewController *seh = nil;


+ (RootViewController*)share {
    if (seh==nil) {
        seh=[[RootViewController alloc]init];
    }
    return seh;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        seh = self;
        
        UIBarButtonItem *setUrl = [[UIBarButtonItem alloc] initWithTitle:@"清除缓存"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(clearCaches)];
        
        UIBarButtonItem *fresh = [[UIBarButtonItem alloc] initWithTitle:@"刷新"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(refresh)];
        
        //self.navigationItem.rightBarButtonItem = setUrl;
        self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:setUrl,fresh,nil];
        [setUrl release];
        [fresh release];
        
    }
    return self;
}

- (void)loaUrlWithString:(NSString*)str {
    NSURL *url = [NSURL URLWithString:str];
    wb.delegate = self;
    NSURLRequest *pURLRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:360];
    [wb loadRequest:pURLRequest];
    wb.scalesPageToFit = YES;
 
}

- (void)clearCaches{
    NSURLCache *sharedCache = [NSURLCache sharedURLCache];
    [sharedCache removeAllCachedResponses];
 
}


-(void)refresh{

       NSString *str = @"http://10.13.210.20/pamdm_ui/index.html";
    
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"url"] length]>1) {
            str = [[NSUserDefaults standardUserDefaults] objectForKey:@"url"];
        }
    
       [self loaUrlWithString:str];

}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSArray *array = [storage cookies];
//    for (int i=0; i<[array count]; i++) {
//        NSHTTPCookie *temp = [array objectAtIndex:i];
//        NSLog(@"ppppp===%@", temp.properties);
//    }
//    
  
   // NSString *requestString = [[request URL] absoluteString];
    return YES;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

 

- (void)viewDidLoad
{
 
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    wb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-20)];
    wb.delegate = self;
    wb.scalesPageToFit = YES;
    wb.scrollView.bounces=NO;
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil];
    [wb loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:file]]];
    [self.view addSubview:wb];
    [wb release];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:HUD];
    HUD.labelText = @"正在加载...";
    [HUD show:YES];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"finish");
    [HUD hide:YES];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"fail:%@", error);
    
    NSString *errorString=[NSString stringWithFormat:@"%@",error];
    
    if ([errorString rangeOfString:@"offline"].location!=NSNotFound) {
        HUD.labelText = @"网络问题,加载失败...";
        [HUD hide:YES afterDelay:2.0];
    }
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end