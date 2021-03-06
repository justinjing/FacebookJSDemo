//
//  RootViewController.h
//  BridgeDemo
//
//  Created by  xyh on 12-10-10.
//  Copyright (c) 2012年 xyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface RootViewController : UIViewController <UIWebViewDelegate> {
    @public
     UIWebView *wb;
     MBProgressHUD *HUD;
     NSURLConnection *connection;
}
@property(retain,nonatomic)NSURLConnection *connection ;

+ (RootViewController*)share;

- (void)loaUrlWithString:(NSString*)str;

@end
