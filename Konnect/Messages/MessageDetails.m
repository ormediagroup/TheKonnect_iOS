//
//  MessageDetails.m
//  Konnect
//
//  Created by Jacky Mok on 3/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "MessageDetails.h"
#import "AppDelegate.h"
@interface MessageDetails ()

@end

@implementation MessageDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}
-(void) loadMessage:(int)messageID {
    if (!wkweb) {
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        wkweb = [[WKWebView alloc] initWithFrame:CGRectMake(0,delegate.headerHeight, delegate.screenWidth, delegate.screenHeight-delegate.headerHeight-delegate.footerHeight)];
        [self.view addSubview:wkweb];
        wkweb.navigationDelegate = self;
    }
    [delegate startLoading];
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-message",K_API_ENDPOINT]  param:
     @{
       @"action":@"getmessage",
       @"messageID":[NSNumber numberWithInt:messageID]
       } interation:0 callback:^(NSDictionary *data) {
           if ([[data objectForKey:@"errcode"] intValue]==0) {
               if ([[data objectForKey:@"rc"] intValue]==0 && [[data objectForKey:@"data"]  isKindOfClass:[NSDictionary class]])  {
                   NSLog(@"Loading Message Details %@",[data objectForKey:@"message"]);
                  // [self->wkweb loadHTMLString:[self->data objectForKey:@"message"] baseURL:[NSURL URLWithString:@""]];
                   [self->wkweb loadHTMLString:
                    
                    [NSString stringWithFormat:@"%@",
                     [[data objectForKey:@"data"] objectForKey:@"message"]]
                                       baseURL:[NSURL URLWithString:@""]];
               } else {
                   [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
               }
           } else {
               [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
           }
       }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
