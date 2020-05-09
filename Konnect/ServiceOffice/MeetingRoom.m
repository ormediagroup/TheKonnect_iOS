//
//  MeetingRoom.m
//  Konnect
//
//  Created by Jacky Mok on 12/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "MeetingRoom.h"
#import "AppDelegate.h"
#import "ImageList.h"
@interface MeetingRoom ()

@end

@implementation MeetingRoom
@synthesize facilityID, bookDate, bookStartTime, bookEndTime, cost, startTime, endTime, bookingInfo;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [self.view addSubview:scroll];

}
-(void) viewWillAppear:(BOOL)animated {
    if (facilityID && ![facilityID isEqualToString:@""]) {
        [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-home",K_API_ENDPOINT] param:
         [[NSDictionary alloc] initWithObjects:@[
                                                 @"get-vendor",
                                                 facilityID
                                                 ]
                                       forKeys:@[
                                                 @"action",
                                                 @"faciltiyid"
                                                 ]]
         
                                         interation:0 callback:^(NSDictionary *data) {
                                             //NSLog(@"Wallet %@",data);
                                             if ([[data objectForKey:@"rc"] intValue]==0) {
                                                 [self loadData:[data objectForKey:@"data"]];
                                             } else if ([[data objectForKey:@"rc"] intValue]==1) {
                                             } else {
                                                 [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                             }
                                         }];
        
    }
}
-(UIView *) addDisclaimer:(CGFloat) y {
    UIView *scroll = [[UIView alloc] initWithFrame:CGRectMake(0,y,delegate.screenWidth-SIDE_PAD_2,100+LINE_HEIGHT)];
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
    [toolbar removeFromSuperview];
    datasrc = d;
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:[d objectForKey:@"name_zh"]];
    if ([[d objectForKey:@"images"] isKindOfClass:[NSString class]] && [[d objectForKey:@"images"] length]>0) {
        UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,300)];
        [v setImage:[delegate getImage:[d objectForKey:@"images"] callback:^(UIImage *image) {
            [v setImage:image];
        }]];
        [scroll addSubview:v];
    }
    int y = 300+LINE_PAD;
    if (![[d objectForKey:@"name_zh"] isEqualToString:@""]) {
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:[UIColor blackColor]];
        [p setFont:[UIFont systemFontOfSize:FONT_M]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setNumberOfLines:-1];
        [p setText:[d objectForKey:@"name_zh"]];
        [p sizeToFit];
        [scroll addSubview:p];
        y+=p.frame.size.height;
    }
    if (![[d objectForKey:@"name_en"] isEqualToString:@""]) {
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:[UIColor blackColor]];
        [p setFont:[UIFont systemFontOfSize:FONT_M]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setNumberOfLines:-1];
        [p setText:[d objectForKey:@"name_en"]];
        [p sizeToFit];
        [scroll addSubview:p];
        y+=p.frame.size.height;
    }
    y+=LINE_PAD;
    {
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:UICOLOR_LIGHT_GREY];
        [p setFont:[UIFont systemFontOfSize:FONT_XS]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setText:TEXT_ADDRESS];
        [scroll addSubview:p];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100,y+4,delegate.screenWidth-SIDE_PAD-100,LINE_HEIGHT)];
        [l setNumberOfLines:-1];
        [l setText:[d objectForKey:@"address"]];
        [l setTextColor:UICOLOR_DARK_GREY];
        [l setFont:[UIFont systemFontOfSize:FONT_XS]];
        [l sizeToFit];
        [scroll addSubview:l];
        y+=l.frame.size.height+LINE_PAD;
    }
    {
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:UICOLOR_LIGHT_GREY];
        [p setFont:[UIFont systemFontOfSize:FONT_XS]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setText:TEXT_CAPACITY];
        [scroll addSubview:p];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100,y+4,delegate.screenWidth-SIDE_PAD-100,LINE_HEIGHT)];
        [l setNumberOfLines:-1];
        [l setFont:[UIFont systemFontOfSize:FONT_XS]];
        [l setText:[d objectForKey:@"capacity"]];
        [l sizeToFit];
        [l setTextColor:UICOLOR_DARK_GREY];
        [scroll addSubview:l];
        y+=l.frame.size.height+LINE_PAD;
    }
    {
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:UICOLOR_LIGHT_GREY];
        [p setFont:[UIFont systemFontOfSize:FONT_XS]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setText:TEXT_EQUIPMENT];
        [scroll addSubview:p];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100,y+4,delegate.screenWidth-SIDE_PAD-100,LINE_HEIGHT)];
        [l setNumberOfLines:-1];
        [l setText:[d objectForKey:@"equipment"]];
        [l setFont:[UIFont systemFontOfSize:FONT_XS]];
        [l sizeToFit];
        [l setTextColor:UICOLOR_DARK_GREY];
        [scroll addSubview:l];
        y+=l.frame.size.height+LINE_PAD;
    }
    {
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:UICOLOR_LIGHT_GREY];
        [p setFont:[UIFont systemFontOfSize:FONT_XS]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setText:TEXT_PRICE];
        [scroll addSubview:p];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100,y+4,delegate.screenWidth-SIDE_PAD-100,LINE_HEIGHT)];
        [l setNumberOfLines:-1];
        [l setFont:[UIFont systemFontOfSize:FONT_XS]];
        [l setText:[d objectForKey:@"pricetag"]];
        [l sizeToFit];
        [l setTextColor:UICOLOR_DARK_GREY];
        [scroll addSubview:l];
        y+=l.frame.size.height+LINE_PAD;;
    }
    y+=LINE_PAD;
    if (bookingInfo) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,10)];
        [v.layer setBorderColor:[UICOLOR_GOLD CGColor]];
        v.layer.borderWidth = 1.0f;
        v.layer.cornerRadius = 5.0f;
        
        int y2 = LINE_PAD;
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y2,v.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
        [l setNumberOfLines:-1];
        [l setFont:[UIFont systemFontOfSize:FONT_XS]];
        [l setText:[bookingInfo objectForKey:@"description"]];
        [l setTextAlignment:NSTextAlignmentCenter];
        [v addSubview:l];
        [l setTextColor:[UIColor darkTextColor]];
        y2+=l.frame.size.height;
        
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setTitle:TEXT_CANCEL_MEETING_ROOM forState:UIControlStateNormal];
        [v addSubview:b];
        [b.titleLabel setFont:[UIFont systemFontOfSize:FONT_S]];
        [b setTitleColor:UICOLOR_ERROR forState:UIControlStateNormal];
        [b addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [b setFrame:CGRectMake(0, y2, v.frame.size.width, 30)];
        y2+= 30+LINE_PAD;
        
        if ([[bookingInfo objectForKey:@"cancancel"] isEqualToString:@"0"]) {
            [b setEnabled:NO];
            [b setTitle:TEXT_CANNOT_CANCEL_NOW forState:UIControlStateNormal];
            [b setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        [v addSubview:[self addDisclaimer:y2]];
        y2+=100+LINE_PAD+LINE_PAD;
        [v setFrame:CGRectMake(v.frame.origin.x,v.frame.origin.y,v.frame.size.width,y2)];
        [scroll addSubview:v];
        y+=y2+LINE_PAD;
        
               
    } else if (bookDate && ![bookDate isEqualToString:@""]) {
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,10)];
        [v.layer setBorderColor:[UICOLOR_GOLD CGColor]];
        v.layer.borderWidth = 1.0f;
        v.layer.cornerRadius = 5.0f;
        
        int y2 = LINE_PAD;
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y2,v.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
        [l setNumberOfLines:-1];
        [l setFont:[UIFont systemFontOfSize:FONT_XS]];
        [l setText:[NSString stringWithFormat:@"%@: %@",TEXT_DATE,bookDate]];
        [l setTextAlignment:NSTextAlignmentCenter];
        [v addSubview:l];
        [l setTextColor:[UIColor darkTextColor]];
        y2+=l.frame.size.height;
        
        UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y2,v.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
        [l2 setNumberOfLines:-1];
        [l2 setFont:[UIFont systemFontOfSize:FONT_XS]];
        [l2 setText:[NSString stringWithFormat:@"%@: %@-%@",TEXT_TIME,bookStartTime, bookEndTime]];
        [l2 setTextAlignment:NSTextAlignmentCenter];
        [v addSubview:l2];
        [l2 setTextColor:[UIColor darkTextColor]];
        y2+=l2.frame.size.height;
        
        UILabel *l3 = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y2,v.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
        [l3 setNumberOfLines:-1];
        [l3 setFont:[UIFont systemFontOfSize:FONT_XS]];
        [l3 setText:[NSString stringWithFormat:@"%@: HKD %d",TEXT_PRICE, cost]];
        [l3 setTextAlignment:NSTextAlignmentCenter];
        [l3 setTextColor:[UIColor darkTextColor]];
        [v addSubview:l3];
        y2+=l3.frame.size.height+LINE_PAD;
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setTitle:TEXT_RENT_MEETING_ROOM_NOW forState:UIControlStateNormal];
        [v addSubview:b];
        [b.titleLabel setFont:[UIFont systemFontOfSize:FONT_S]];
        [b setBackgroundColor:[delegate getThemeColor]];
        [b setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
        [b addTarget:self action:@selector(book) forControlEvents:UIControlEventTouchUpInside];
        [b setFrame:CGRectMake(SIDE_PAD, y2, v.frame.size.width-SIDE_PAD_2, 30)];
        y2+= 30+LINE_PAD;
        
        UIView *h = [[UIView alloc] initWithFrame:CGRectMake(delegate.screenWidth/2-120,y2,240,LINE_HEIGHT)];
        [v addSubview:h];
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
        y2+=LINE_HEIGHT;
        
        
        [v addSubview:[self addDisclaimer:y2]];
        y2+=100+LINE_PAD+LINE_PAD;
        
        [v setFrame:CGRectMake(v.frame.origin.x,v.frame.origin.y,v.frame.size.width,y2)];
        [scroll addSubview:v];
        y+=y2+LINE_PAD;
    }
    
    
    y+=LINE_PAD;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,y-1,delegate.screenWidth,1)];
    [line setBackgroundColor:UICOLOR_VERY_LIGHT_GREY_BORDER];
    [scroll addSubview:line];
    y+=LINE_PAD;
    if ([[d objectForKey:@"description_zh"] isKindOfClass:[NSString class]] && ![[d objectForKey:@"description_zh"] isEqualToString:@""]){
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:UICOLOR_GOLD];
        [p setFont:[UIFont systemFontOfSize:FONT_S]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setText:TEXT_RESTAURANT_INFO];
        [p setTextColor:[UIColor darkTextColor]];
        [scroll addSubview:p];
        [p sizeToFit];
        y+=p.frame.size.height+LINE_PAD;
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [l setNumberOfLines:-1];
        [l setFont:[UIFont systemFontOfSize:FONT_S]];
        NSAttributedString *hS = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"<html><body style='font-size:%dpx;font-color:#333;line-height:150%%;font-family:Arial'>%@</body></html>",FONT_XS,[d objectForKey:@"description_zh"]] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        [l setAttributedText:hS];
        [l sizeToFit];
        [scroll addSubview:l];
        y+=l.frame.size.height+LINE_PAD;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,y-1,delegate.screenWidth,1)];
        [line setBackgroundColor:UICOLOR_VERY_LIGHT_GREY_BORDER];
        [scroll addSubview:line];
        y+=LINE_PAD;
    }
    if ([[d objectForKey:@"otherimages"] isKindOfClass:[NSArray class]] && [[d objectForKey:@"otherimages"] count]>0) {
        {
            UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
            [p setTextColor:UICOLOR_GOLD];
            [p setFont:[UIFont systemFontOfSize:FONT_S]];
            [p setTextAlignment:NSTextAlignmentLeft];
            [p setText:[NSString stringWithFormat:@"%@ (%@: %ld)", TEXT_PHOTOS,TEXT_BROWSE_ALL,[[d objectForKey:@"otherimages"] count]]];
            [scroll addSubview:p];
            [p sizeToFit];
            y+=p.frame.size.height+LINE_PAD;
        }
        int x = SIDE_PAD;
        CGFloat w = (delegate.screenWidth-(SIDE_PAD*4))/3;
        CGFloat h = w/16*9;
        int curr =0 ;
        for (NSString *src in [d objectForKey:@"otherimages"]) {
            UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(x,y,w,h)];
            [v setClipsToBounds:YES];
            [v addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed)]];
            [v setUserInteractionEnabled:YES];
            [v setContentMode:UIViewContentModeScaleAspectFill];
            [v setImage:[delegate getImage:src callback:^(UIImage *image) {
                [v setImage:image];
            }]];
            [scroll addSubview:v];
            x+=w+SIDE_PAD;
            if (x >= delegate.screenWidth-SIDE_PAD) {
                x = SIDE_PAD;
                y+=h+LINE_PAD;
            }
            if ((++curr)>=6) {
                break;
            }
        }
        y+=h;
        y+=LINE_PAD;
        {
          UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,y-1,delegate.screenWidth,1)];
          [line setBackgroundColor:UICOLOR_VERY_LIGHT_GREY_BORDER];
          [scroll addSubview:line];
        }
        y+=LINE_PAD;
    }
  
   
    
    if (bookingInfo) {
    } else if (bookDate && ![bookDate isEqualToString:@""]) {
    } else {
        toolbar = [[UIView alloc] initWithFrame:CGRectMake(0,delegate.screenHeight-delegate.footerHeight-60,delegate.screenWidth,60)];
        [toolbar setBackgroundColor:[UIColor whiteColor]];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,1)];
        [line setBackgroundColor:UICOLOR_VERY_LIGHT_GREY_BORDER];
        [toolbar addSubview:line];
        {
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            if ([[datasrc objectForKey:@"ID"] isEqualToString:TEXT_POPUP_LOUNGE_ID] ||
                [[datasrc objectForKey:@"ID"] isEqualToString:TEXT_POLYFORM_EVENT_ID]) {
                [b setTitle:TEXT_INQUIRY forState:UIControlStateNormal];
            } else {
                [b setTitle:TEXT_RENT_MEETING_ROOM_NOW forState:UIControlStateNormal];
            }
            [b setBackgroundColor:[delegate getThemeColor]];
            b.tag=99;
            [b setFrame:CGRectMake(0,0,delegate.screenWidth,60)];
            [b setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
            [b addTarget:self action:@selector(makeBooking) forControlEvents:UIControlEventTouchUpInside];
            [toolbar addSubview:b];
        }
        [self.view addSubview:toolbar];
        y+=60;
    }

    [scroll setContentSize:CGSizeMake(delegate.screenWidth,y+LINE_PAD)];
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
-(void) makeBooking{
   [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
    [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_TOU],[NSString stringWithFormat:@"%@/#/meeting-room-enquiry?userToken=%@",domain,[delegate.preferences objectForKey:K_USER_OPENID]]] forKeys:@[@"type",@"url"]]];
    /*
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_SEARCH_MEETING_ROOM],@"search",datasrc] forKeys:@[@"type",@"action",@"facility"]]];
     */
}
-(void) book{
    /// [self->delegate raiseAlert:TEXT_BOOK_ROOM_SUCCESS msg:[NSString stringWithFormat:@"%@ %@:%@ - %@:%@",self->bookDate,self->bookStartTimeHr,self->bookStartTimeMin,self->bookStartTimeHr,self->bookStartTimeHr]];
    if (tou.tag==0) {
        [delegate raiseAlert:TEXT_ACCEPT_TOU msg:@""];
    } else {
        [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-meeting-room",K_API_ENDPOINT] param:
         [[NSDictionary alloc] initWithObjects:@[bookDate,[NSNumber numberWithFloat:startTime],[NSNumber numberWithFloat:endTime],
                                                 facilityID,@"book"
                                                 ]
                                       forKeys:@[@"bookingdate",@"bookingstarttime",@"bookingendtime",@"vendor_id", @"action"]]
                                         interation:0 callback:^(NSDictionary *bookdata) {
                                            NSLog(@"Meeting Room %@",[bookdata description]);
                                            [[NSNotificationCenter defaultCenter] postNotificationName:ON_BACK_PRESSED object:nil];

                                             if ([bookdata isKindOfClass:[NSDictionary class]] && [[bookdata objectForKey:@"rc"] intValue]==0) {
                                                 [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-payment-token",K_API_ENDPOINT]
                                                                                       param:[[NSDictionary alloc] initWithObjects:@[@"get-token"]
                                                                                                                           forKeys:@[@"action"]]
                                                  
                                                                                  interation:0 callback:^(NSDictionary *data) {
                                                                                      if ([[data objectForKey:@"rc"] intValue]==0) {
                                                                                          [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVE_TRANSACTION_REQUEST object:[[NSDictionary alloc] initWithObjects:@[[data objectForKey:@"data"],[NSNumber numberWithInt:self->cost],@"meetingroom",[bookdata objectForKey:@"bookingid"]] forKeys:@[PAYMENT_TOKEN,@"amount",@"vendorid",@"remarks"]]];
                                                                                          
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
                                             } else {
                                                 [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[bookdata objectForKey:@"errmsg"]];
                                             }
                                         }];
    }
    
}
-(void) cancel:(UIButton *)b{
    [[NSNotificationCenter defaultCenter] postNotificationName:ON_BACK_PRESSED object:nil];
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-meeting-room",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[[bookingInfo objectForKey:@"bookingID"],@"cancel-booking"
                                             ]
                                   forKeys:@[@"booking_id",@"action"]]
                                     interation:0 callback:^(NSDictionary *bookdata) {
                                         [self->delegate raiseAlert:[NSString stringWithFormat:@"%@%@",TEXT_CANCEL_MEETING_ROOM,TEXT_SAVE_SUCCESS] msg:@""];
                                  }];
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
