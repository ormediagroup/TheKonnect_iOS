//
//  MessageDetails.h
//  Konnect
//
//  Created by Jacky Mok on 3/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORViewController.h"
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface MessageDetails : ORViewController <WKNavigationDelegate> {
     WKWebView *wkweb;
}
-(void) loadMessage:(int)messageID;
@end

NS_ASSUME_NONNULL_END
