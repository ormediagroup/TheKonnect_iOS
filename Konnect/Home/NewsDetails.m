//
//  NewsDetails.m
//  Konnect
//
//  Created by Jacky Mok on 16/2/2020.
//  Copyright © 2020 Jacky Mok. All rights reserved.
//

#import "NewsDetails.h"
#import "AppDelegate.h"
@interface NewsDetails ()

@end

@implementation NewsDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];

}
-(void) loadMessage:(int)messageID {
    if (!wkweb) {
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        wkweb = [[WKWebView alloc] initWithFrame:CGRectMake(0,delegate.headerHeight, delegate.screenWidth, delegate.screenHeight-delegate.headerHeight-delegate.footerHeight)];
        [self.view addSubview:wkweb];
        [wkweb setBackgroundColor:[UIColor whiteColor]];
        wkweb.navigationDelegate = self;
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,delegate.headerHeight+LINE_PAD,delegate.screenWidth-SIDE_PAD_2,1)];
        [title setBackgroundColor:[UIColor whiteColor]];
        [title setNumberOfLines:-1];
        [title setTextColor:[UIColor blackColor]];
        [title setFont:[UIFont boldSystemFontOfSize:FONT_L]];
        [self.view addSubview:title];
       
        ts = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth,1)];
        [ts setBackgroundColor:[UIColor whiteColor]];
        [ts setFont:[UIFont systemFontOfSize:FONT_S]];
        [ts setNumberOfLines:1];
        [ts setTextColor:UICOLOR_LIGHT_GREY];
        [self.view addSubview:ts];
        
        sep = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,10)];
        [sep setBackgroundColor:UICOLOR_VERY_LIGHT_GREY_BORDER];
        [self.view addSubview:sep];
    }
    [title setFrame:CGRectMake(SIDE_PAD,delegate.headerHeight+LINE_PAD,delegate.screenWidth-SIDE_PAD_2,1)];
    [ts setFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth,1)];

    [delegate startLoading];
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-home",K_API_ENDPOINT]  param:
     @{
       @"action":@"get-news-details",
       @"messageID":[NSNumber numberWithInt:messageID]
       } interation:0 callback:^(NSDictionary *data) {
           if ([[data objectForKey:@"errcode"] intValue]==0) {
               if ([[data objectForKey:@"rc"] intValue]==0 && [[data objectForKey:@"data"]  isKindOfClass:[NSDictionary class]])  {
                   [self->title setText:[[data objectForKey:@"data"] objectForKey:@"title"]];
                   [self->title sizeToFit];
                   [self->ts setText:[[data objectForKey:@"data"] objectForKey:@"timestamp"]];
                   [self->ts setFrame:CGRectMake(SIDE_PAD,self->title.frame.size.height+self->title.frame.origin.y+LINE_PAD,self->delegate.screenWidth-SIDE_PAD_2,14)];
                   [self->sep setFrame:CGRectMake(0,self->ts.frame.size.height+self->ts.frame.origin.y+LINE_PAD,self->delegate.screenWidth,10)];
                   
                   [self->wkweb setFrame:CGRectMake(SIDE_PAD,self->sep.frame.origin.y+10+LINE_PAD, self->delegate.screenWidth-SIDE_PAD_2, self->delegate.screenHeight-(self->sep.frame.origin.y+10+LINE_PAD)-self->delegate.footerHeight)];
                   [self->wkweb loadHTMLString:
                    [NSString stringWithFormat:@"<html><body style='font-size:40px'>%@</body></html>",
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
