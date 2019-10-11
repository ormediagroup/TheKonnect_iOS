//
//  TopUp.m
//  Konnect
//
//  Created by Jacky Mok on 9/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "TopUp.h"
#import "AppDelegate.h"
@interface TopUp ()

@end

@implementation TopUp
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_TOP_UP_POINTS];
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-transaction",K_API_ENDPOINT]
                                          param:[[NSDictionary alloc] initWithObjects:@[@"get-promo"]
                                                                              forKeys:@[@"action"]]
     
     
     
                                     interation:0 callback:^(NSDictionary *data) {
                                         if ([[data objectForKey:@"rc"] intValue]==0) {
                                             self->dataSrc = [data objectForKey:@"data"];
                                             [self reloadData];
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                         }
                                     }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:scroll];
    btns = [[NSMutableArray alloc] initWithCapacity:6];
    chargeAmount = 0;
    topupPoints = 0;
    chargeType = @"";
    chargeMap = @[
                  @[[NSNumber numberWithFloat:50000],[NSNumber numberWithFloat:50000]],
                  @[[NSNumber numberWithFloat:20000],[NSNumber numberWithFloat:20000]],
                  @[[NSNumber numberWithFloat:10000],[NSNumber numberWithFloat:10000]],
                  @[[NSNumber numberWithFloat:5000],[NSNumber numberWithFloat:5000]],
                  @[[NSNumber numberWithFloat:3000],[NSNumber numberWithFloat:3000]],
                  @[[NSNumber numberWithFloat:1000],[NSNumber numberWithFloat:1000]]
                  ];
    // Do any additional setup after loading the view.
    paymentBar =[[UIView alloc] initWithFrame:CGRectMake(0,delegate.screenHeight-delegate.footerHeight-40,delegate.screenWidth,40)];
    UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,12,100,16)];
    [p setTextColor:[UIColor darkTextColor]];
    [p setFont:[UIFont systemFontOfSize:FONT_M]];
    [p setTextAlignment:NSTextAlignmentLeft];
    [p setText:TEXT_SHOULD_PAY];
    [paymentBar addSubview:p];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,1)];
    [v setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
    [paymentBar addSubview:v];
    UILabel *a = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD+60,0,200,40)];
    [a setTextColor:UICOLOR_GOLD];
    [a setFont:[UIFont systemFontOfSize:FONT_XL]];
    [a setTextAlignment:NSTextAlignmentLeft];
    a.tag = 100;
    [paymentBar addSubview:a];
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b setBackgroundColor:UICOLOR_PURPLE];
    [b setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
    [b setTitle:TEXT_PAY forState:UIControlStateNormal];
    [b addTarget:self action:@selector(charge) forControlEvents:UIControlEventTouchUpInside];
    [b setFrame:CGRectMake(delegate.screenWidth-140,0,140,40)];
    [paymentBar addSubview:b];
    
}
-(void) reloadData {
    for (UIView *v in scroll.subviews) {
        [v removeFromSuperview];
    }
    int y = LINE_PAD;
    CGFloat width = ((delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2)/3.0);
    CGFloat height = 60;
    int x = SIDE_PAD;
    [scroll addSubview:[self createButton:@"50,000" andLabel:[NSString stringWithFormat:@"%@ 50,000HKD",TEXT_SALES] inRect:CGRectMake(x,y,width,height) withTag:0]];
    x += width+SIDE_PAD;
    [scroll addSubview:[self createButton:@"20,000" andLabel:[NSString stringWithFormat:@"%@ 20,000HKD",TEXT_SALES] inRect:CGRectMake(x,y,width,height) withTag:1]];
    x += width+SIDE_PAD;
    [scroll addSubview:[self createButton:@"10,000" andLabel:[NSString stringWithFormat:@"%@ 10,000HKD",TEXT_SALES] inRect:CGRectMake(x,y,width,height) withTag:2]];
    y+=SIDE_PAD+height;
    x = SIDE_PAD;
    [scroll addSubview:[self createButton:@"5,000" andLabel:[NSString stringWithFormat:@"%@: 5,000HKD",TEXT_SALES] inRect:CGRectMake(x,y,width,height) withTag:3]];
    x += width+SIDE_PAD;
    [scroll addSubview:[self createButton:@"3,000" andLabel:[NSString stringWithFormat:@"%@ 3,000HKD",TEXT_SALES] inRect:CGRectMake(x,y,width,height) withTag:4]];
    x += width+SIDE_PAD;
    [scroll addSubview:[self createButton:@"1,000" andLabel:[NSString stringWithFormat:@"%@: 1,000HKD",TEXT_SALES] inRect:CGRectMake(x,y,width,height) withTag:5]];
    
    y+= SIDE_PAD+height;
    
    for (NSDictionary *d in dataSrc) {
        if ([d isKindOfClass:[NSDictionary class]]) {
            if ([[d objectForKey:@"image"] isKindOfClass:[NSArray class]]) {
                
                int width = [[[d objectForKey:@"image"] objectAtIndex:1] intValue];
                CGFloat height = [[[d objectForKey:@"image"] objectAtIndex:2] floatValue];
                CGFloat newHeight= (delegate.screenWidth-SIDE_PAD_2)/width * height;
                UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,newHeight)];
                [v setUserInteractionEnabled:YES];
                [v setContentMode:UIViewContentModeScaleAspectFill];
                [v setImage:[delegate getImage:[[d objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
                    [v setImage:image];
                }]];
                [scroll addSubview:v];
                y+= newHeight+LINE_PAD;
            }
        }
    }
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,y,delegate.screenWidth,LINE_PAD)];
    [v setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
    [scroll addSubview:v];
    y+=LINE_PAD;
    {
        wechat = [[UIView alloc] initWithFrame:CGRectMake(0,y,delegate.screenWidth,60)];
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD,15,30,30)];
        [logo setImage:[UIImage imageNamed:@"paybywechat.png"]];
        [wechat addSubview:logo];
        wechat.tag = 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePaymentType:)];
        [wechat addGestureRecognizer:tap];
        
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(40+SIDE_PAD,0,delegate.screenWidth-SIDE_PAD_2-50,60)];
        [p setTextColor:[UIColor darkTextColor]];
        [p setFont:[UIFont systemFontOfSize:FONT_M]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setText:TEXT_PAY_BY_WECHAT];
        [wechat addSubview:p];
        
        UIImageView *cb = [[UIImageView alloc] initWithFrame:CGRectMake(delegate.screenWidth-40,18,24,24)];
        cb.tag = 99;
        [cb setImage:[UIImage imageNamed:@"unchecked.png"]];
        [wechat addSubview:cb];
        [scroll addSubview:wechat];
        y+=60;
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,59,delegate.screenWidth,1)];
        [v setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
        [wechat addSubview:v];
    }
    {
        ali = [[UIView alloc] initWithFrame:CGRectMake(0,y,delegate.screenWidth,60)];
        ali.tag = 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePaymentType:)];
        [ali addGestureRecognizer:tap];
        UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD,15,30,30)];
        [logo setImage:[UIImage imageNamed:@"paybyali.png"]];
        [ali addSubview:logo];
        
        UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(40+SIDE_PAD,0,delegate.screenWidth-SIDE_PAD_2-50,60)];
        [p setTextColor:[UIColor darkTextColor]];
        [p setFont:[UIFont systemFontOfSize:FONT_L]];
        [p setTextAlignment:NSTextAlignmentLeft];
        [p setText:TEXT_PAY_BY_ALIPAY];
        [ali addSubview:p];
        
        UIImageView *cb = [[UIImageView alloc] initWithFrame:CGRectMake(delegate.screenWidth-40,18,24,24)];
        cb.tag = 99;
        [cb setImage:[UIImage imageNamed:@"unchecked.png"]];
        [ali addSubview:cb];
        [scroll addSubview:ali];
        y+=60;
    }
    
    [scroll setContentSize:CGSizeMake(delegate.screenWidth,y+LINE_PAD)];
}
-(void) choosePaymentType:(UITapGestureRecognizer *)tap{
    if (tap.view==wechat) {
        UIImageView *b = (UIImageView*)[ali viewWithTag:99];
        [b setImage:[UIImage imageNamed:@"unchecked.png"]];
        UIImageView *c = (UIImageView*)[wechat viewWithTag:99];
        [c setImage:[UIImage imageNamed:@"checked.png"]];
        chargeType = @"wechat";
    } else {
        UIImageView *b = (UIImageView*)[ali viewWithTag:99];
        [b setImage:[UIImage imageNamed:@"checked.png"]];
        UIImageView *c = (UIImageView*)[wechat viewWithTag:99];
        [c setImage:[UIImage imageNamed:@"unchecked.png"]];
        chargeType = @"alipay";
    }
    if (chargeAmount>0) {
        [self paymentBar];
    }
}
-(void) choosePaymentAmount:(UIButton *)b {
    if (b.tag >= 0 && b.tag <6) {
        for (UIButton *bt in btns) {
            if (bt.tag==b.tag) {
                bt.layer.borderColor = [UICOLOR_GOLD CGColor];;
                bt.layer.borderWidth = 2.0f;
            } else {
                bt.layer.borderColor = [UICOLOR_VERY_LIGHT_GREY CGColor];;
                bt.layer.borderWidth = 0.5f;
            }
        }
        chargeAmount = [[[chargeMap objectAtIndex:b.tag] objectAtIndex:0] floatValue];
        topupPoints = [[[chargeMap objectAtIndex:b.tag] objectAtIndex:1] floatValue];
        if (![@"" isEqualToString:chargeType]) {
            [self paymentBar];
        }
    }
}
-(void) charge {
    [delegate startLoading];
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-payment-token",K_API_ENDPOINT]
                                          param:[[NSDictionary alloc] initWithObjects:@[@"get-token"]
                                                                              forKeys:@[@"action"]]
                                     interation:0 callback:^(NSDictionary *data) {
                                         [self->delegate stopLoading];
                                         if ([[data objectForKey:@"rc"] intValue]==0) {
                                             [self topup:[data objectForKey:@"data"]];
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                         }
                                     }];
}
-(void) topup:(NSString *) paymentToken {
    [delegate startLoading];
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-perform-transaction",K_API_ENDPOINT]
                                          param:[[NSDictionary alloc] initWithObjects:@[@"topup",paymentToken,chargeType,[NSNumber numberWithFloat:topupPoints],[NSNumber numberWithFloat:chargeAmount]]
                                                                              forKeys:@[@"action",@"paymentToken",@"paymentType",@"amount",@"cash"]]
                                     interation:0 callback:^(NSDictionary *data) {
                                         [self->delegate stopLoading];
                                         if ([[data objectForKey:@"rc"] intValue]==0) {
                                             [delegate raiseAlert:TEXT_TOPUP_SUCCESS msg:[NSString stringWithFormat:@"%@%@", TEXT_NEW_BALANCE,[data objectForKey:@"balance"]]];
                                             [[NSNotificationCenter defaultCenter] postNotificationName:ON_BACK_PRESSED object:nil];
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                         }
                                     }];
}
-(void) paymentBar {
    UILabel *l = (UILabel *)[paymentBar viewWithTag:100];
    [l setText:[NSString stringWithFormat:@"%0.2f",chargeAmount]];
    [self.view addSubview:paymentBar];
}
-(UIButton *) createButton:(NSString *)points andLabel:(NSString *)label inRect:(CGRect) f withTag:(int)t{
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.layer.borderColor = [UICOLOR_VERY_LIGHT_GREY CGColor];;
    [b setBackgroundColor:[UIColor whiteColor]];
    b.layer.borderWidth = 0.5f;
    b.tag = t;
    [b setFrame:f];
    int TEXT_WIDTH = 40;
    
    UILabel *p = [[UILabel alloc] initWithFrame:CGRectMake(0,0,f.size.width-TEXT_WIDTH,f.size.height*0.6)];
    [p setTextColor:UICOLOR_GOLD];
    [p setFont:[UIFont systemFontOfSize:FONT_M]];
    [p setTextAlignment:NSTextAlignmentRight];
    [p setText:points];
    [b addSubview:p];
    
    UILabel *p2 = [[UILabel alloc] initWithFrame:CGRectMake(f.size.width-TEXT_WIDTH,0,TEXT_WIDTH,f.size.height*0.6)];
    [p2 setText:TEXT_POINTS];
    [p2 setTextColor:UICOLOR_GOLD];
    [p2 setFont:[UIFont systemFontOfSize:(FONT_XS-4)]];
    [p2 setTextAlignment:NSTextAlignmentCenter];
    [b addSubview:p2];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0,f.size.height*0.5,f.size.width,f.size.height*0.5)];
    [l setTextColor:[UIColor darkTextColor]];
    [l setText:label];
    [l setFont:[UIFont systemFontOfSize:(FONT_XS-2)]];
    [l setTextAlignment:NSTextAlignmentCenter];
    [b addSubview:l];
  
    b.layer.shadowRadius  = 10.0f;
    b.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:0.7f].CGColor;
    b.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    b.layer.shadowOpacity = 0.4f;
    b.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(b.bounds, shadowInsets)];
    b.layer.shadowPath    = shadowPath.CGPath;
    
    [b addTarget:self action:@selector(choosePaymentAmount:) forControlEvents:UIControlEventTouchUpInside];
    [btns addObject:b];
    return b;
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
