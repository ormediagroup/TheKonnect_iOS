//
//  Facility.m
//  Konnect
//
//  Created by Jacky Mok on 12/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "Facility.h"
#import "AppDelegate.h"
#import "const.h"
#import "ImageList.h"
@implementation Facility
@synthesize facilityid;
-(void) viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:scroll];
    toolbar = [[UIView alloc] initWithFrame:CGRectMake(0,delegate.screenHeight-delegate.footerHeight-FB_TOOLBAR_HEIGHT,delegate.screenWidth,FB_TOOLBAR_HEIGHT)];
    [toolbar setBackgroundColor:[UIColor whiteColor]];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,1)];
    [line setBackgroundColor:UICOLOR_VERY_LIGHT_GREY_BORDER];
    [toolbar addSubview:line];
    {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setTitle:TEXT_RESERVATION forState:UIControlStateNormal];
        [b setBackgroundColor:UICOLOR_PURPLE];
        [b setFrame:CGRectMake(0,0,delegate.screenWidth-120,FB_TOOLBAR_HEIGHT)];
        [b setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
        [b addTarget:self action:@selector(makeBooking) forControlEvents:UIControlEventTouchUpInside];
        [toolbar addSubview:b];
    }
    {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15,15,30,30)];
        [icon setImage:[UIImage imageNamed:@"cs.png"]];
        [b addSubview:icon];
        [b setFrame:CGRectMake(delegate.screenWidth-120,0,50,FB_TOOLBAR_HEIGHT)];
        [b addTarget:self action:@selector(makeBooking) forControlEvents:UIControlEventTouchUpInside];
        [toolbar addSubview:b];
    }
    {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15,15,30,30)];
        [icon setImage:[UIImage imageNamed:@"icon64_appwx_logo.png"]];
        [b addSubview:icon];
        [b setFrame:CGRectMake(delegate.screenWidth-60,0,50,FB_TOOLBAR_HEIGHT)];
        [b addTarget:self action:@selector(makeBooking) forControlEvents:UIControlEventTouchUpInside];
        [toolbar addSubview:b];
    }
}
-(void) viewWillAppear:(BOOL)animated {
    if (![facilityid isEqualToString:@""]) {
        [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-home",K_API_ENDPOINT] param:
         [[NSDictionary alloc] initWithObjects:@[
                                                 @"get-vendor",
                                                 @"10"
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
    {
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:[UIColor blackColor]];
        [p setFont:[UIFont systemFontOfSize:FONT_M]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setNumberOfLines:-1];
        [p setText:[NSString stringWithFormat:@"%@\n%@",[d objectForKey:@"name_zh"],[d objectForKey:@"name_en"]]];
        [p sizeToFit];
        [scroll addSubview:p];
        y+=p.frame.size.height + LINE_PAD;
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
        NSAttributedString *hS = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"<html><body style='font-size:%dpx;font-color:#333;font-family:Arial'>%@<p>%@</p></body></html>",FONT_S,[d objectForKey:@"address_zh"],[d objectForKey:@"address_en"]] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        [l setAttributedText:hS];
        [l sizeToFit];
        [scroll addSubview:l];
        y+=l.frame.size.height-6;
        
    }
    {
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:UICOLOR_LIGHT_GREY];
        [p setFont:[UIFont systemFontOfSize:FONT_S]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setText:TEXT_BOOKING_PHONE];
        [scroll addSubview:p];
        
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100,y+4,delegate.screenWidth-SIDE_PAD-100,LINE_HEIGHT)];
        [l setNumberOfLines:-1];
        NSAttributedString *hS;
        if (![[d objectForKey:@"phone_2"] isEqualToString:@"0"]) {
            hS = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"<html><body style='font-size:%dpx;font-color:#333;font-family:Arial'>%@<p>%@</p></body></html>",FONT_S,[d objectForKey:@"phone_1"],[d objectForKey:@"phone_2"]] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        } else {
            hS = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"<html><body style='font-size:%dpx;font-color:#333;font-family:Arial'>%@</body></html>",FONT_S,[d objectForKey:@"phone_1"]] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        }
        [l setAttributedText:hS];
        [l sizeToFit];
        [scroll addSubview:l];
        y+=l.frame.size.height+LINE_PAD;
        
    }
    {
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [p setTextColor:UICOLOR_LIGHT_GREY];
        [p setFont:[UIFont systemFontOfSize:FONT_S]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setText:TEXT_OPERATION_HOURS];
        [scroll addSubview:p];
        
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100,y+4,delegate.screenWidth-SIDE_PAD-100,LINE_HEIGHT)];
        [l setNumberOfLines:-1];
        NSAttributedString *hS = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"<html><body style='font-size:%dpx;font-color:#333;font-family:Arial'>%@</body></html>",FONT_S,[d objectForKey:@"hours"]] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        [l setAttributedText:hS];
        [l sizeToFit];
        [scroll addSubview:l];
        y+=l.frame.size.height+LINE_PAD;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,y-1,delegate.screenWidth,1)];
        [line setBackgroundColor:UICOLOR_VERY_LIGHT_GREY_BORDER];
        [scroll addSubview:line];
        y+=LINE_PAD;
    }
    [scroll setContentSize:CGSizeMake(delegate.screenWidth, y)];
    
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
        [l setTextAlignment:NSTextAlignmentLeft];
        [l setText:[d objectForKey:@"description"]];
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
    [scroll setContentSize:CGSizeMake(delegate.screenWidth,y+LINE_PAD+FB_TOOLBAR_HEIGHT)];
    [self.view addSubview:toolbar];
}
-(void) makeBooking {
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_RESTAURANT_BOOKING],datasrc] forKeys:@[@"type",@"facility"]]];
}
-(void) imagePressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_IMAGE_GALLERY],[datasrc objectForKey:@"otherimages"]] forKeys:@[@"type",@"images"]]];

}
@end
