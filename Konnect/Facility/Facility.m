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
        [b setBackgroundColor:[delegate getThemeColor]];
        [b setFrame:CGRectMake(0,0,delegate.screenWidth-120,FB_TOOLBAR_HEIGHT)];
        [b setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
        [b addTarget:self action:@selector(makeBooking) forControlEvents:UIControlEventTouchUpInside];
        [toolbar addSubview:b];
    }
    {
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
-(void) share:(UIButton *)b {
    if (b.tag==1) {
        NSString *n = [datasrc objectForKey:@"phone_1"];
        NSString *phNo = [n stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"這裝置不支持撥打電話功能" message:@"" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil];
            [alert show];
            return;
        }
    } else {
        [delegate raiseAlert:TEXT_FUNCTION_NOTAVAIL msg:@""];
        return;
        /*
        NSString *content = [NSString stringWithFormat:@"KONNECT - %@%@",[datasrc objectForKey:@"name_zh"],[datasrc objectForKey:@"name_en"]];
        NSString *URL = [NSString stringWithFormat:@"%@/site/?siteid=%@",domain,[datasrc objectForKey:@"ID"]];
        NSURL *u = [NSURL URLWithString:[URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if ([[datasrc objectForKey:@"otherimages"] count]>0) {
            NSString *url = [[datasrc objectForKey:@"otherimages"]objectAtIndex:0];
            [delegate getImage:url callback:^(UIImage *image) {
                NSArray* sharedObjects=[NSArray arrayWithObjects:content,u,image,nil];
                UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:nil];
                activityViewController.popoverPresentationController.sourceView = self.view;
                [self presentViewController:activityViewController animated:YES completion:nil];
            }];
        } else {
            NSArray* sharedObjects=[NSArray arrayWithObjects:content,u, nil];
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:nil];
            activityViewController.popoverPresentationController.sourceView = self.view;
            [self presentViewController:activityViewController animated:YES completion:nil];
        }
         */
    }
}
-(void) viewWillAppear:(BOOL)animated {
    [scroll scrollRectToVisible:CGRectMake(0,0,1,1) animated:NO];
    if (facilityid && ![facilityid isEqualToString:@""]) {
        [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-home",K_API_ENDPOINT] param:
         [[NSDictionary alloc] initWithObjects:@[
                                                 @"get-vendor",
                                                 facilityid
                                                 ]
                                       forKeys:@[
                                                 @"action",
                                                 @"facilityid"
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
        [v setContentMode:UIViewContentModeScaleAspectFill];
        [v setClipsToBounds:YES];
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
        NSAttributedString *hS = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"<html><body style='font-size:%dpx;font-color:#333;font-family:Arial'>%@</body></html>",FONT_S,[d objectForKey:@"address"]] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
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
        [p setText:TEXT_BOOKING_PHONE];

        
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(100,y+4,delegate.screenWidth-SIDE_PAD-100,LINE_HEIGHT)];
        [l setNumberOfLines:-1];
        NSAttributedString *hS;
        if (![[d objectForKey:@"phone_2"] isEqualToString:@""] && ![[d objectForKey:@"phone_2"] isEqualToString:@"0"]) {
            hS = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"<html><body style='font-size:%dpx;font-color:#333;font-family:Arial'>%@<p>%@</p></body></html>",FONT_S,[d objectForKey:@"phone_1"],[d objectForKey:@"phone_2"]] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        } else if (![[d objectForKey:@"phone_1"] isEqualToString:@""] && ![[d objectForKey:@"phone_1"] isEqualToString:@"0"]) {
            hS = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"<html><body style='font-size:%dpx;font-color:#333;font-family:Arial'>%@</body></html>",FONT_S,[d objectForKey:@"phone_1"]] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        }
        if (hS) {
            [l setAttributedText:hS];
            [l sizeToFit];
            [scroll addSubview:p];
            [scroll addSubview:l];
            y+=l.frame.size.height;
        }
        
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
        NSAttributedString *hS = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"<html><body style='padding:0;font-size:%dpx;line-height:150%%;font-color:#333;font-family:Arial'>%@</body></html>",FONT_S,[d objectForKey:@"hours"]] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        [l setAttributedText:hS];
        [l sizeToFit];
        [scroll addSubview:l];
        y+=l.frame.size.height+LINE_PAD;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,y-1,delegate.screenWidth,1)];
        [line setBackgroundColor:UICOLOR_VERY_LIGHT_GREY_BORDER];
        [scroll addSubview:line];
        y+=LINE_PAD;
    }
    
    {
        if ([[d objectForKey:@"ads"] isKindOfClass:[NSArray class]] && [[d objectForKey:@"ads"] count]>0) {
            for (NSString *url in [d objectForKey:@"ads"]) {
                UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0,y,delegate.screenWidth,80)];
                [v setContentMode:UIViewContentModeScaleAspectFill];
                [v setImage:[delegate getImage:url callback:^(UIImage *image) {
                    [v setImage:image];
                }]];
                [scroll addSubview:v];
                y+=80;
            }
            y+=LINE_PAD;
        }
        
        
    }
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
        [l setTextColor:[UIColor darkTextColor]];
        [l setText:[d objectForKey:@"description_zh"]];
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
            if (x >= delegate.screenWidth-SIDE_PAD && curr < 5) {
                x = SIDE_PAD;
                y+=h+LINE_PAD;
            }
            if ((++curr)>=6) {
                break;
            }
        
        }
        y+=h;
        y+=LINE_PAD;
    }
    
    if ([[d objectForKey:@"foodimages"] isKindOfClass:[NSArray class]] && [[d objectForKey:@"foodimages"] count]>0) {
        {
            UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
            [p setTextColor:UICOLOR_GOLD];
            [p setFont:[UIFont systemFontOfSize:FONT_S]];
            [p setTextAlignment:NSTextAlignmentLeft];
            [p setText:[NSString stringWithFormat:@"%@ (%@: %ld)", TEXT_FOOD_PHOTOS,TEXT_BROWSE_ALL,[[d objectForKey:@"foodimages"] count]]];
            [scroll addSubview:p];
            [p sizeToFit];
            y+=p.frame.size.height+LINE_PAD;
        }
        int x = SIDE_PAD;
        CGFloat w = (delegate.screenWidth-(SIDE_PAD*4))/3;
        CGFloat h = w/16*9;
        int curr =0 ;
        for (NSString *src in [d objectForKey:@"foodimages"]) {
            UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(x,y,w,h)];
            [v setClipsToBounds:YES];
            [v addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foodImagePressed)]];
            [v setUserInteractionEnabled:YES];
            [v setContentMode:UIViewContentModeScaleAspectFill];
            [v setImage:[delegate getImage:src callback:^(UIImage *image) {
                [v setImage:image];
            }]];
            [scroll addSubview:v];
            x+=w+SIDE_PAD;
            if (x >= delegate.screenWidth-SIDE_PAD && curr < 5) {
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
    if ([delegate isLoggedIn]) {
       // if ([self checkTier]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_RESTAURANT_BOOKING],datasrc] forKeys:@[@"type",@"facility"]]];
     //   }
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
-(BOOL) checkTier {
    if ([delegate isLoggedIn]) {
        if ([[datasrc objectForKey:@"type"] isEqualToString:@"fnbvip"]) {
            if ([[delegate.preferences objectForKey:K_USER_TIER] isEqualToString:TEXT_MEMBERTIER_MEMBER]) {
                [delegate raiseAlert:[NSString stringWithFormat:K_USER_SORRY_TIER_NOT_SUFFICIENT,TEXT_MEMBERTIER_VIP] msg:@""];
                return NO;
            } else {
                return YES;
            }
        } else if ([[datasrc objectForKey:@"type"] isEqualToString:@"fnblegacy"]) {
            if ([[delegate.preferences objectForKey:K_USER_TIER] isEqualToString:TEXT_MEMBERTIER_LEGACY]) {
                return YES;
            } else {
                [delegate raiseAlert:[NSString stringWithFormat:K_USER_SORRY_TIER_NOT_SUFFICIENT,TEXT_MEMBERTIER_LEGACY] msg:@""];
                return NO;
            }
        }
    }
    return NO;
}
-(void) imagePressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_IMAGE_GALLERY],[datasrc objectForKey:@"otherimages"]] forKeys:@[@"type",@"images"]]];

}
-(void) foodImagePressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_IMAGE_GALLERY],[datasrc objectForKey:@"foodimages"]] forKeys:@[@"type",@"images"]]];
    
}
@end
