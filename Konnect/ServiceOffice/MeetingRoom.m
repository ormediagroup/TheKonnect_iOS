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
-(void) loadData:(NSDictionary *)d {
    for (UIView *v in scroll.subviews) {
        [v removeFromSuperview];
    }
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
        [l setFont:[UIFont systemFontOfSize:FONT_XS]];
        [l sizeToFit];
        [scroll addSubview:l];
        y+=l.frame.size.height;
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
        [scroll addSubview:l];
        y+=l.frame.size.height;
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
        [scroll addSubview:l];
        y+=l.frame.size.height;
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
        [scroll addSubview:l];
        y+=l.frame.size.height;
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
        y2+=l.frame.size.height;
        
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setTitle:TEXT_CANCEL_MEETING_ROOM forState:UIControlStateNormal];
        [v addSubview:b];
        [b setTitleColor:UICOLOR_ERROR forState:UIControlStateNormal];
        [b addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [b setFrame:CGRectMake(0, y2, v.frame.size.width, 30)];
        y2+= 30+LINE_PAD;
        
        if ([[bookingInfo objectForKey:@"cancancel"] isEqualToString:@"0"]) {
            [b setEnabled:NO];
            [b setTitle:TEXT_CANNOT_CANCEL_NOW forState:UIControlStateNormal];
            [b setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        
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
        y2+=l.frame.size.height;
        
        UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y2,v.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
        [l2 setNumberOfLines:-1];
        [l2 setFont:[UIFont systemFontOfSize:FONT_XS]];
        [l2 setText:[NSString stringWithFormat:@"%@: %@-%@",TEXT_TIME,bookStartTime, bookEndTime]];
        [l2 setTextAlignment:NSTextAlignmentCenter];
        [v addSubview:l2];
        y2+=l2.frame.size.height;
        
        UILabel *l3 = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y2,v.frame.size.width-SIDE_PAD_2,LINE_HEIGHT)];
        [l3 setNumberOfLines:-1];
        [l3 setFont:[UIFont systemFontOfSize:FONT_XS]];
        [l3 setText:[NSString stringWithFormat:@"%@: HKD %d",TEXT_PRICE, cost]];
        [l3 setTextAlignment:NSTextAlignmentCenter];
        [v addSubview:l3];
        y2+=l3.frame.size.height;
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setTitle:TEXT_RENT_MEETING_ROOM_NOW forState:UIControlStateNormal];
        [v addSubview:b];
        [b setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
        [b addTarget:self action:@selector(book) forControlEvents:UIControlEventTouchUpInside];
        [b setFrame:CGRectMake(0, y2, v.frame.size.width, 30)];
        y2+= 30+LINE_PAD;
        
        [v setFrame:CGRectMake(v.frame.origin.x,v.frame.origin.y,v.frame.size.width,y2)];
        [scroll addSubview:v];
        y+=y2+LINE_PAD;
    }
    
    
    y+=LINE_PAD;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,y-1,delegate.screenWidth,1)];
    [line setBackgroundColor:UICOLOR_VERY_LIGHT_GREY_BORDER];
    [scroll addSubview:line];
    y+=LINE_PAD;
    {
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:UICOLOR_GOLD];
        [p setFont:[UIFont systemFontOfSize:FONT_S]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setText:TEXT_RESTAURANT_INFO];
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
    }
    y+=LINE_PAD;
    
    if (bookingInfo) {
    } else if (bookDate && ![bookDate isEqualToString:@""]) {
    } else {
        UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(0,delegate.screenHeight-delegate.footerHeight-60,delegate.screenWidth,60)];
        [toolbar setBackgroundColor:[UIColor whiteColor]];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,1)];
        [line setBackgroundColor:UICOLOR_VERY_LIGHT_GREY_BORDER];
        [toolbar addSubview:line];
        {
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            [b setTitle:TEXT_RENT_MEETING_ROOM_NOW forState:UIControlStateNormal];
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
-(void) makeBooking{
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_SEARCH_MEETING_ROOM],@"search",datasrc] forKeys:@[@"type",@"action",@"facility"]]];
}
-(void) book{
    /// [self->delegate raiseAlert:TEXT_BOOK_ROOM_SUCCESS msg:[NSString stringWithFormat:@"%@ %@:%@ - %@:%@",self->bookDate,self->bookStartTimeHr,self->bookStartTimeMin,self->bookStartTimeHr,self->bookStartTimeHr]];
    [[NSNotificationCenter defaultCenter] postNotificationName:ON_BACK_PRESSED object:nil];
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-meeting-room",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[bookDate,[NSNumber numberWithFloat:startTime],[NSNumber numberWithFloat:endTime],
                                             facilityID,@"book"
                                             ]
                                   forKeys:@[@"bookingdate",@"bookingstarttime",@"bookingendtime",@"vendor_id",@"action"]]
                                     interation:0 callback:^(NSDictionary *bookdata) {
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
