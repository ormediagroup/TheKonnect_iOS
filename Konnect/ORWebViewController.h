//
//  ORWebViewController.h
//  Konnect
//
//  Created by Jacky Mok on 6/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "ORViewController.h"
@class AppDelegate;
@class Home;
@interface ORWebViewController : ORViewController <WKNavigationDelegate> {
 //   AppDelegate *delegate;
 //   UIScrollView *scroll;
    NSMutableDictionary *data;
    int textFontSize;
    WKWebView *wkweb;
   // UIButton *share;
  // NSString *newsurl;
    int y;
}
-(void) loadData:(NSString *)url;

@end
