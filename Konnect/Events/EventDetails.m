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
        [b setBackgroundColor:[delegate getThemeColor]];
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
-(UIView *) addDisclaimer:(CGFloat) y {
    UIView *scroll = [[UIView alloc] initWithFrame:CGRectMake(0,y,delegate.screenWidth-SIDE_PAD,100+LINE_HEIGHT)];
   {
         UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
         [l setFont:[UIFont systemFontOfSize:FONT_S]];
         [l setBackgroundColor:[UIColor whiteColor]];
         [l setTextColor:UICOLOR_GOLD];
         [l setText:TEXT_IMPORTANT_NOTICE];
         [scroll addSubview:l];
         y+=LINE_HEIGHT;
     }
   int y2 = 4;
   UIScrollView *scroll2 = [[UIScrollView alloc] initWithFrame:CGRectMake(SIDE_PAD, LINE_HEIGHT, scroll.frame.size.width-SIDE_PAD_2, 100)];
   scroll2.layer.cornerRadius = 5.0f;
   scroll2.layer.borderColor = [UICOLOR_VERY_LIGHT_GREY_BORDER CGColor];;
   scroll2.layer.borderWidth = 1.0f;
   [scroll addSubview:scroll2];
   
   {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y2,scroll2.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
        [l setFont:[UIFont systemFontOfSize:FONT_XS]];
        [l setBackgroundColor:[UIColor whiteColor]];
        [l setTextColor:[UIColor darkTextColor]];
        [l setText:TEXT_WEATHER_CONDITION];
        [scroll2 addSubview:l];
        y2+=LINE_HEIGHT;
    }
  {
      UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y2,scroll2.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
      [l setFont:[UIFont systemFontOfSize:FONT_XS]];
      [l setBackgroundColor:[UIColor whiteColor]];
      [l setTextAlignment:NSTextAlignmentJustified];
      [l setNumberOfLines:-1];
      [l setText:@"The Function will be automatically considered “CANCELLED” if black rain/typhoon signal 8 or above is hoisted 4 hours Before the function’s starting time. Cancellation due to black rain/typhoon no 8 will be granted a single rescheduled date and time within two months of the original date and time, subject to the mutual agreement of both parties and availability of the venue."];
      [l setTextColor:UICOLOR_DARK_GREY];
      [l sizeToFit];
      [scroll2 addSubview:l];
      y2+=l.frame.size.height;
  }
   {
         UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y2,scroll2.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
         [l setFont:[UIFont systemFontOfSize:FONT_XS]];
         [l setBackgroundColor:[UIColor whiteColor]];
         [l setTextColor:[UIColor darkTextColor]];
         [l setText:TEXT_CANCELLATION_POLICY];
         [scroll2 addSubview:l];
         y2+=LINE_HEIGHT;
     }
   {
       UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y2,scroll2.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
       [l setFont:[UIFont systemFontOfSize:FONT_XS]];
       [l setBackgroundColor:[UIColor whiteColor]];
       [l setTextAlignment:NSTextAlignmentJustified];
       [l setNumberOfLines:-1];
       [l setText:@"In an event of a “No Show”, the full amount of the Licence Fee will be required from the Applicant. Cancellations made within 5 business days of event date: 100% fee will be charged. Cancellations made over 5 business days prior to event date: 1-time rescheduling subject to approval. In case of cancellation, deposit will be forfeited."];
       [l setTextColor:UICOLOR_DARK_GREY];
       [l sizeToFit];
       [scroll2 addSubview:l];
       y2+=l.frame.size.height;
   }
   {
         UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y2,scroll2.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
         [l setFont:[UIFont systemFontOfSize:FONT_XS]];
         [l setBackgroundColor:[UIColor whiteColor]];
         [l setTextColor:[UIColor darkTextColor]];
         [l setText:TEXT_GUARANTEE];
         [scroll2 addSubview:l];
         y2+=LINE_HEIGHT;
     }
   {
       UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y2,scroll2.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
       [l setFont:[UIFont systemFontOfSize:FONT_XS]];
       [l setBackgroundColor:[UIColor whiteColor]];
       [l setTextAlignment:NSTextAlignmentJustified];
       [l setNumberOfLines:-1];
       [l setText:@"In order to confirm the reservation with a package, signing of the proposal must be done with an understanding of the Terms and Conditions. A deposit must be put down either by cash, cheque or credit card. If there is no signed signature for Confirmation, KONNECT has the right to cancel the Reservation until further request is given."];
       [l setTextColor:UICOLOR_DARK_GREY];
       [l sizeToFit];
       [scroll2 addSubview:l];
       y2+=l.frame.size.height;
   }
   {
         UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y2,scroll2.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
         [l setFont:[UIFont systemFontOfSize:FONT_XS]];
         [l setBackgroundColor:[UIColor whiteColor]];
         [l setTextColor:[UIColor darkTextColor]];
         [l setText:TEXT_LIABILITY];
         [scroll2 addSubview:l];
         y2+=LINE_HEIGHT;
     }
   {
       UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y2,scroll2.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
       [l setFont:[UIFont systemFontOfSize:FONT_XS]];
       [l setBackgroundColor:[UIColor whiteColor]];
       [l setTextAlignment:NSTextAlignmentJustified];
       [l setNumberOfLines:-1];
       [l setText:@"In case of any damage caused inside the function venue or the building, the Applicant must be liable for all compensation to KONNECT."];
       [l setTextColor:UICOLOR_DARK_GREY];
       [l sizeToFit];
       [scroll2 addSubview:l];
       y2+=l.frame.size.height;
   }
   {
         UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y2,scroll2.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
         [l setFont:[UIFont systemFontOfSize:FONT_XS]];
         [l setBackgroundColor:[UIColor whiteColor]];
         [l setTextColor:[UIColor darkTextColor]];
         [l setText:TEXT_DISCLAIMER];
         [scroll2 addSubview:l];
         y2+=LINE_HEIGHT;
     }
   {
       UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y2,scroll2.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
       [l setFont:[UIFont systemFontOfSize:FONT_XS]];
       [l setBackgroundColor:[UIColor whiteColor]];
       [l setTextAlignment:NSTextAlignmentJustified];
       [l setNumberOfLines:-1];
       [l setText:@"KONNECT does not accept any liability for equipment, displays, or any materials (such as addiTonal food and beverage items) which are brought to the venue. For Hygiene reasons, all food items will be disposed of within the next 24 hours unless KONNECT’s prior approval is obtained. KONNECT is not responsible for any items le in event space, rooms or public areas in and around the event space or the building. 4/F KONNECT, 303 Jaffe Road, +852 2722 3456 Wan Chai, Hong Kong info@thekonnect.com.hk 香港灣仔謝斐道 303 號 4 樓樓 www.thekonnect.com.hk"];
       [l setTextColor:UICOLOR_DARK_GREY];
       [l sizeToFit];
       [scroll2 addSubview:l];
       y2+=l.frame.size.height+LINE_PAD;
   }
   [scroll2 setContentSize:CGSizeMake(scroll2.frame.size.width, y2)];
   return scroll;
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
        [l setTextColor:[UIColor darkTextColor]];
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
        [l setTextColor:[UIColor darkTextColor]];
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
        [l setTextColor:[UIColor darkTextColor]];
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
        [l setTextColor:[UIColor darkTextColor]];
        [scroll addSubview:l];
        y+=l.frame.size.height+LINE_PAD;
        
    }
    /*
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
        [l setTextColor:[UIColor darkTextColor]];
        [scroll addSubview:l];
        y+=l.frame.size.height+LINE_PAD;
        
    }
     */
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
        NSAttributedString *hS = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"<html><body style='font-size:%dpx;font-color:#333;font-family:Arial'>%@</body></html>",FONT_S,[datasrc objectForKey:@"remarks"]] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        [l setAttributedText:hS];
        [l sizeToFit];
        [scroll addSubview:l];
        y+=l.frame.size.height+LINE_PAD;
        
    }
    [scroll addSubview:[self addDisclaimer:y]];
    y+=100+LINE_PAD+LINE_PAD;
    
    UIView *h = [[UIView alloc] initWithFrame:CGRectMake(delegate.screenWidth/2-120,y,240,LINE_HEIGHT)];
    [scroll addSubview:h];
    tou = [UIButton buttonWithType:UIButtonTypeCustom];
    [tou setFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
    [tou setTitle:@"我已閱讀並接受" forState:UIControlStateNormal];
    [tou setContentEdgeInsets:UIEdgeInsetsMake(0,30, 0, 0)];
    tou.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    tou.tag = 0;
    [tou setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [tou.titleLabel setFont:[UIFont systemFontOfSize:FONT_XS]];
    [tou addTarget:self action:@selector(toggleCheck) forControlEvents:UIControlEventTouchUpInside];
     
    UIImageView *tick = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unchecked.png"]];
    tick.tag=99;
    [tick setFrame:CGRectMake(0,4,20,20)];
    [tou addSubview:tick];
    [h addSubview:tou];
     
    UIButton *goTOU = [UIButton buttonWithType:UIButtonTypeCustom];
    [goTOU setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
    [goTOU setTitle:@"《使用條款》" forState:UIControlStateNormal];
    [goTOU addTarget:self action:@selector(gotou) forControlEvents:UIControlEventTouchUpInside];
    goTOU.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [goTOU.titleLabel setFont:[UIFont systemFontOfSize:FONT_XS]];
    [goTOU setFrame:CGRectMake(146,0,100,LINE_HEIGHT)];
    [h addSubview:goTOU];
    y+=LINE_HEIGHT;
    
    UIButton *b = [toolbar viewWithTag:99];
    if ([[datasrc objectForKey:@"registered"] intValue]==1) {
        [b setEnabled:NO];
        [b setBackgroundColor:UICOLOR_LIGHT_GREY];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [b setTitle:TEXT_REGISTERED forState:UIControlStateNormal];
    } else {
        [b setEnabled:YES];
        [b setBackgroundColor:[delegate getThemeColor]];
        [b setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
        [b setTitle:TEXT_REGISTER_EVENT forState:UIControlStateNormal];
    }
    [scroll setContentSize:CGSizeMake(delegate.screenWidth,y+LINE_PAD+FB_TOOLBAR_HEIGHT)];
    [self.view addSubview:toolbar];
}
-(void) makeBooking {
    
    if ([delegate isLoggedIn]) {
        if (tou.tag==0) {
            [delegate raiseAlert:TEXT_ACCEPT_TOU msg:@""];
            } else {
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
        }
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
-(void) toggleCheck {
    UIImageView *c = [tou viewWithTag:99];
    if (tou.tag==0) {
        tou.tag = 1;
        [c setImage:[UIImage imageNamed:@"checked.png"]];
    } else {
        tou.tag = 0;
        [c setImage:[UIImage imageNamed:@"unchecked.png"]];
    }
}
-(void) gotou {
    NSURL *touURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/Events_Meeting_Room_Terms_Conditions.pdf",domain]];
    if ([[UIApplication sharedApplication] canOpenURL:touURL]) {
        [[UIApplication sharedApplication] openURL:touURL options:@{} completionHandler:^(BOOL success) {}];
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
