//
//  NewsDetails.h
//  Konnect
//
//  Created by Jacky Mok on 16/2/2020.
//  Copyright © 2020 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsDetails : ORViewController<WKNavigationDelegate> {
    WKWebView *wkweb;
    UILabel *title;
    UILabel *ts;
    UIView *sep;
}
-(void) loadMessage:(int)messageID;
@end

NS_ASSUME_NONNULL_END
