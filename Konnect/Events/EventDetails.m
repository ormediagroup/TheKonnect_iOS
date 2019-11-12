//
//  EventDetails.m
//  Konnect
//
//  Created by Jacky Mok on 10/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "EventDetails.h"
#import "AppDelegate.h"
#import "const.h"
#import "ImageList.h"
@interface EventDetails ()

@end

@implementation EventDetails
@synthesize eventID;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:scroll];
    toolbar = [[UIView alloc] initWithFrame:CGRectMake(0,delegate.screenHeight-delegate.footerHeight-FB_TOOLBAR_HEIGHT,delegate.screenWidth,FB_TOOLBAR_HEIGHT)];
    [toolbar setBackgroundColor:[UIColor whiteColor]];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,1)];
    [line setBackgroundColor:UICOLOR_VERY_LIGHT_GREY_BORDER];
    [toolbar addSubview:line];
    {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setTitle:TEXT_REGISTER_EVENT forState:UIControlStateNormal];
        [b setBackgroundColor:UICOLOR_PURPLE];
        b.tag=99;
        [b setFrame:CGRectMake(0,0,delegate.screenWidth-60,FB_TOOLBAR_HEIGHT)];
        [b setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
        [b addTarget:self action:@selector(makeBooking) forControlEvents:UIControlEventTouchUpInside];
        [toolbar addSubview:b];
    }
    {
        /*
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.tag = 1;
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15,5,30,30)];
        [icon setImage:[UIImage imageNamed:@"phone.png"]];
        [b addSubview:icon];
        [b setContentMode:UIViewContentModeScaleAspectFit];
        [b setFrame:CGRectMake(delegate.screenWidth-120,0,50,FB_TOOLBAR_HEIGHT)];
        [b addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0,35,60,FB_TOOLBAR_HEIGHT-40)];
        [l setText:TEXT_PHONE];
        [l setTextColor:UICOLOR_GOLD];
        [l setFont:[UIFont systemFontOfSize:FONT_XS]];
        [l setTextAlignment:NSTextAlignmentCenter];
        [b addSubview:l];
        [toolbar addSubview:b];
         */
    }
    {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        b.tag=2;
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15,5,30,30)];
        [icon setImage:[UIImage imageNamed:@"wechatshare.png"]];
        [b addSubview:icon];
        [b setFrame:CGRectMake(delegate.screenWidth-60,0,50,FB_TOOLBAR_HEIGHT)];
        [b addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0,35,60,FB_TOOLBAR_HEIGHT-40)];
        [l setText:TEXT_SHARE];
        [l setTextColor:UICOLOR_GOLD];
        [l setFont:[UIFont systemFontOfSize:FONT_XS]];
        [l setTextAlignment:NSTextAlignmentCenter];
        [b addSubview:l];
        [toolbar addSubview:b];
    }
}
-(void) share:(UIButton *) b{
}
-(void) viewWillAppear:(BOOL)animated {
    if (eventID && ![eventID isEqualToString:@""]) {
        [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-home",K_API_ENDPOINT] param:
         [[NSDictionary alloc] initWithObjects:@[
                                                 @"get-events",
                                                 eventID
                                                 ]
                                       forKeys:@[
                                                 @"action",
                                                 @"eventID"
                                                 ]]
         
                                         interation:0 callback:^(NSDictionary *data) {
                                             //NSLog(@"Wallet %@",data);
                                             if ([[data objectForKey:@"rc"] intValue]==0 && [[data objectForKey:@"data"] isKindOfClass:[NSArray class]] && [[data objectForKey:@"data"] count]>0) {
                                                 [self loadData:[[data objectForKey:@"data"] objectAtIndex:0]];
                                             } else if ([[data objectForKey:@"rc"] intValue]==1) {
                                             } else {
                                                 [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                             }
                                         }];
        
    }
}
-(void) loadData:(NSDictionary *)d {
    for (UIView *v in scroll.subviews) {
        [v removeFromSuperview];
    }
    datasrc = d;
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:[d objectForKey:@"title"]];
    if ([[d objectForKey:@"image"] isKindOfClass:[NSArray class]] && [[d objectForKey:@"image"] count]>0) {
        UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,300)];
        [v setImage:[delegate getImage:[[d objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
            [v setImage:image];
        }]];
        [scroll addSubview:v];
    }
    int y = 300+LINE_PAD;
    {
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:UICOLOR_GOLD];
        [p setFont:[UIFont systemFontOfSize:FONT_M]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setNumberOfLines:-1];
        [p setText:[d objectForKey:@"title"]];
        [p sizeToFit];
        [scroll addSubview:p];
        y+=p.frame.size.height + LINE_PAD;
    }
    {
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:UICOLOR_LIGHT_GREY];
        [p setFont:[UIFont systemFontOfSize:FONT_S]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setText:TEXT_FEE];
        [scroll addSubview:p];
        
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100,y+4,delegate.screenWidth-SIDE_PAD-100,LINE_HEIGHT)];
        [l setNumberOfLines:-1];
        [l setText:[datasrc objectForKey:@"fee"]];
        [l sizeToFit];
        [scroll addSubview:l];
        y+=l.frame.size.height+LINE_PAD;
        
    }
    {
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:UICOLOR_LIGHT_GREY];
        [p setFont:[UIFont systemFontOfSize:FONT_S]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setText:TEXT_TIME];
        [scroll addSubview:p];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100,y+4,delegate.screenWidth-SIDE_PAD-100,LINE_HEIGHT)];
        [l setNumberOfLines:-1];
        [l setText:[NSString stringWithFormat:@"%@\n%@-%@",[datasrc objectForKey:@"datestring"],[datasrc objectForKey:@"starttime"],[datasrc objectForKey:@"endtime"]]];
        [l sizeToFit];
        [scroll addSubview:l];
        y+=l.frame.size.height+LINE_PAD;
     
    }
    {
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:UICOLOR_LIGHT_GREY];
        [p setFont:[UIFont systemFontOfSize:FONT_S]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setText:TEXT_ADDRESS];
        [scroll addSubview:p];
        
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100,y+4,delegate.screenWidth-SIDE_PAD-100,LINE_HEIGHT)];
        [l setNumberOfLines:-1];
        [l setText:[datasrc objectForKey:@"location"]];
        [l sizeToFit];
        [scroll addSubview:l];
        y+=l.frame.size.height+LINE_PAD;
        
    }
    {
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:UICOLOR_LIGHT_GREY];
        [p setFont:[UIFont systemFontOfSize:FONT_S]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setText:TEXT_CAPACITY];
        [scroll addSubview:p];
        
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100,y+4,delegate.screenWidth-SIDE_PAD-100,LINE_HEIGHT)];
        [l setNumberOfLines:-1];
        [l setText:[datasrc objectForKey:@"capacity"]];
        [l sizeToFit];
        [scroll addSubview:l];
        y+=l.frame.size.height+LINE_PAD;
        
    }
    {
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:UICOLOR_LIGHT_GREY];
        [p setFont:[UIFont systemFontOfSize:FONT_S]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setText:TEXT_REMARKS];
        [scroll addSubview:p];
        
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100,y+4,delegate.screenWidth-SIDE_PAD-100,LINE_HEIGHT)];
        [l setNumberOfLines:-1];
        [l setText:[datasrc objectForKey:@"remarks"]];
        [l sizeToFit];
        [scroll addSubview:l];
        y+=l.frame.size.height+LINE_PAD;
        
    }
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,y-1,delegate.screenWidth,1)];
        [line setBackgroundColor:UICOLOR_VERY_LIGHT_GREY_BORDER];
        [scroll addSubview:line];
        y+=LINE_PAD;
        
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:UICOLOR_LIGHT_GREY];
        [p setFont:[UIFont systemFontOfSize:FONT_S]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setText:TEXT_EVENT_DETAILS];
        [scroll addSubview:p];
        
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100,y+4,delegate.screenWidth-SIDE_PAD-100,LINE_HEIGHT)];
        [l setNumberOfLines:-1];
        NSAttributedString *hS = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"<html><body style='font-size:%dpx;font-color:#333;font-family:Arial'>%@</body></html>",FONT_S,[datasrc objectForKey:@"post_content"]] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        [l setAttributedText:hS];
        [l sizeToFit];
        [scroll addSubview:l];
        y+=l.frame.size.height+LINE_PAD;
        
    }
    UIButton *b = [toolbar viewWithTag:99];
    if ([[datasrc objectForKey:@"registered"] intValue]==1) {
        [b setEnabled:NO];
        [b setBackgroundColor:UICOLOR_LIGHT_GREY];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setTitle:TEXT_REGISTERED forState:UIControlStateNormal];
    } else {
        [b setEnabled:YES];
        [b setBackgroundColor:UICOLOR_PURPLE];
        [b setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
        [b setTitle:TEXT_REGISTER_EVENT forState:UIControlStateNormal];
    }
    [scroll setContentSize:CGSizeMake(delegate.screenWidth,y+LINE_PAD+FB_TOOLBAR_HEIGHT)];
    [self.view addSubview:toolbar];
}
-(void) makeBooking {
    if ([delegate isLoggedIn]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:TEXT_CONFIRM_REGISTER,[datasrc objectForKey:@"fee"]]
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:TEXT_BACK style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [alert addAction:[UIAlertAction actionWithTitle:TEXT_REGISTER_EVENT style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self->delegate startLoading];
            [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-booking",K_API_ENDPOINT] param:
             [[NSDictionary alloc] initWithObjects:@[
                                                     @"book-events",
                                                     self->eventID
                                                     ]
                                           forKeys:@[
                                                     @"action",
                                                     @"event_id"
                                                     ]]
                                             interation:0 callback:^(NSDictionary *bookdata) {
                                                 //NSLog(@"Wallet %@",data);
                                                 if ([[bookdata objectForKey:@"rc"] intValue]==0) {
                                                     [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-payment-token",K_API_ENDPOINT]
                                                                                           param:[[NSDictionary alloc] initWithObjects:@[@"get-token"]
                                                                                                                               forKeys:@[@"action"]]
                                                      
                                                                                      interation:0 callback:^(NSDictionary *data) {
                                                                                          if ([[data objectForKey:@"rc"] intValue]==0) {
                                                                                              [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVE_TRANSACTION_REQUEST object:[[NSDictionary alloc] initWithObjects:@[[data objectForKey:@"data"],[self->datasrc objectForKey:@"fee"],@"event",[bookdata objectForKey:@"bookingid"]] forKeys:@[PAYMENT_TOKEN,@"amount",@"vendorid",@"remarks"]]];
                                                                                              
                                                                                          } else if ([[data objectForKey:@"rc"] intValue]==2) {
                                                                                              UIAlertController* alert = [UIAlertController alertControllerWithTitle:TEXT_TITLE_NO_PAYMENT_CODE
                                                                                                                                                             message:TEXT_NO_PAYMENT_CODE
                                                                                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                                                                                              
                                                                                              UIAlertAction* setCodeAction = [UIAlertAction actionWithTitle:TEXT_SET_PAYMENT_CODE style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                                                  [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
                                                                                                   [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_PAYMENT_CODE]] forKeys:@[@"type"]]];
                                                                                                  [self dismissViewControllerAnimated:YES
                                                                                                                           completion:^{}];
                                                                                              }];
                                                                                              [alert addAction:setCodeAction];
                                                                                              UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:TEXT_BACK style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                                                                  [self dismissViewControllerAnimated:YES
                                                                                                                           completion:^{
                                                                                                                           }];
                                                                                              }];
                                                                                              [alert addAction:defaultAction];
                                                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                  [self presentViewController:alert animated:YES completion:nil];
                                                                                              });
                                                                                          } else {
                                                                                              [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                                                                          }
                                                                                      }];
                                                 } else if ([[bookdata objectForKey:@"rc"] intValue]==2) {
                                                     [self->delegate raiseAlert:TEXT_NO_BALANCE msg:TEXT_PLEASE_TOP_UP];
                                                 } else {
                                                     [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[bookdata objectForKey:@"errmsg"]];
                                                 }
                                             }];
        }]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:TEXT_PLEASE_LOGIN
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:TEXT_GO_LOGIN style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_LOGIN object:nil];
            
        }];
        [alert addAction:defaultAction];
        [alert addAction:[UIAlertAction actionWithTitle:TEXT_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    }
}
-(void) imagePressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_IMAGE_GALLERY],[datasrc objectForKey:@"otherimages"]] forKeys:@[@"type",@"images"]]];
    
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
