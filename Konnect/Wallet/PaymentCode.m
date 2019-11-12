//
//  PaymentCode.m
//  Konnect
//
//  Created by Jacky Mok on 10/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "PaymentCode.h"
#import "const.h"
#import "AppDelegate.h"
#import "PaymentCodeDigit.h"
@interface PaymentCode ()

@end

@implementation PaymentCode
@synthesize state;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //scode=@"";
    //amount=@"0";
}
-(void) paymentRequest:(NSString *)code andAmount:(NSString*)amt forVendor:(NSString *)vid  withRemarks:(NSString *)iid{
    transactionCode = code;
    vendorid = vid;
    remarks = iid;
    amount = amt;
    self.state = PC_STATE_NORMAL;
    [self makeInit];
}
-(void) paymentRequest:(NSString *)code andAmount:(NSString*)amount  withRemarks:(NSString *)iid {
    [self paymentRequest:code andAmount:amount forVendor:@"3" withRemarks:@""];
}
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_PAYMENT_CODE];
    if (state == PC_STATE_INIT) {
        [self makeInit];
    } else if (state== PC_STATE_NORMAL) {
        
    }
}
-(void) back {
    if (state==PC_STATE_INIT_2) {
        state= PC_STATE_INIT;
        [self makeInit];
        [[NSNotificationCenter defaultCenter] postNotificationName:RESTORE_BACK_BTN object:nil];
    }
}
-(void) clearSubviews {
    for (UIView *v in self.view.subviews) {
        [v removeFromSuperview];
    }
}
-(void) makeInit {
    [self clearSubviews];
    if (state == PC_STATE_INIT || state==PC_STATE_NORMAL) {
        code = @"";
    } else if (state==PC_STATE_INIT_2) {
        verifycode = @"";
        SEL selector = @selector(back);
        [[NSNotificationCenter defaultCenter] postNotificationName:REDIRECT_BACK_BTN
                                                            object:[[NSDictionary alloc]
                                                                    initWithObjects:@[self,
                                                                                      [NSValue valueWithBytes:&selector objCType:@encode(SEL)]]
                                                                    forKeys:@[                                                             @"target",                                                     @"selector"                                                        ]]
         ];
    }
    int y  = delegate.headerHeight+SIDE_PAD;
    if (state==PC_STATE_NORMAL){
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,30)];
        [l setFont:[UIFont boldSystemFontOfSize:FONT_L]];
        [l setText:[NSString stringWithFormat:@"%@%@", TEXT_PAY_POINTS,amount]];
        [l setTextAlignment:NSTextAlignmentCenter];
        [l setTextColor:[UIColor darkTextColor]];
        [self.view addSubview:l];
    }
    y+=30+LINE_PAD;
    {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,30)];
        [l setFont:[UIFont boldSystemFontOfSize:FONT_L]];
        if (state==PC_STATE_INIT) {
            [l setText:TEXT_SET_PAYMENT_CODE];
        } else if (state==PC_STATE_INIT_2) {
            [l setText:TEXT_SET_PAYMENT_CODE_2];
        } else if (state==PC_STATE_NORMAL) {
            [l setText:TEXT_ENTER_PAYMENT_CODE];
        }
        [l setTextAlignment:NSTextAlignmentCenter];
        [l setTextColor:[UIColor darkTextColor]];
        [self.view addSubview:l];
    }
    y+=30;
    
    int h = 80;
    codeHolder = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,h)];
    [self.view addSubview:codeHolder];
    int w = (codeHolder.frame.size.width-(SIDE_PAD_2*2) - (SIDE_PAD*5))/6;
    int x = SIDE_PAD_2;
    
    for (int i =0 ;i < 6; i++) {
        
        PaymentCodeDigit *d = [[PaymentCodeDigit alloc] initWithFrame:CGRectMake(x,0,w,h)];
        d.tag = 10+i;
        [codeHolder addSubview:d];
        x += w+SIDE_PAD;
    }
    y+=h+LINE_PAD+LINE_PAD;
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    if (state == PC_STATE_INIT) {
        [b setTitle:TEXT_NEXT_STEP forState:UIControlStateNormal];
    } else if (state == PC_STATE_INIT_2) {
        [b setTitle:TEXT_SET forState:UIControlStateNormal];
    } else if (state==PC_STATE_NORMAL) {
        [b setTitle:TEXT_PAY forState:UIControlStateNormal];
    }
    b.layer.cornerRadius = 10.0f;
    [b setBackgroundColor:UICOLOR_PURPLE];
    [b setFrame:CGRectMake(SIDE_PAD_2,y,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2,50)];
    [b.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [b setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
    [b addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    
    y=0;
    UIView *keyboard = [[UIView alloc] initWithFrame:CGRectMake(0,delegate.screenHeight-delegate.footerHeight-200,delegate.screenWidth,200)];
    keyboard.layer.borderWidth=0.5f;
    keyboard.layer.borderColor = [UICOLOR_VERY_LIGHT_GREY_BORDER CGColor];
    
    [self.view addSubview:keyboard];
    CGFloat width = (delegate.screenWidth/3);
    CGFloat height = 50;
    x = 0;
    [keyboard addSubview:[self createNumber:7 inFrame:CGRectMake(x,y,width,height)]];
    x+=width;
    [keyboard addSubview:[self createNumber:8 inFrame:CGRectMake(x,y,width,height)]];
    x+=width;
    [keyboard addSubview:[self createNumber:9 inFrame:CGRectMake(x,y,width,height)]];
    x = 0;
    y+=height;
    [keyboard addSubview:[self createNumber:4 inFrame:CGRectMake(x,y,width,height)]];
    x+=width;
    [keyboard addSubview:[self createNumber:5 inFrame:CGRectMake(x,y,width,height)]];
    x+=width;
    [keyboard addSubview:[self createNumber:6 inFrame:CGRectMake(x,y,width,height)]];
    x = 0;
    y+=height;
    [keyboard addSubview:[self createNumber:1 inFrame:CGRectMake(x,y,width,height)]];
    x+=width;
    [keyboard addSubview:[self createNumber:2 inFrame:CGRectMake(x,y,width,height)]];
    x+=width;
    [keyboard addSubview:[self createNumber:3 inFrame:CGRectMake(x,y,width,height)]];
    x = 0;
    y+=height;
    [keyboard addSubview:[self createNumber:-1 inFrame:CGRectMake(x,y,width,height)]];
    x+=width;
    [keyboard addSubview:[self createNumber:0 inFrame:CGRectMake(x,y,width,height)]];
    x+=width;
    [keyboard addSubview:[self createNumber:-2 inFrame:CGRectMake(x,y,width,height)]];
}

-(UIButton *)createNumber:(int) i inFrame:(CGRect)f {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    if (i==-1) {
        [b setTitle:LEFT_ARROW forState:UIControlStateNormal];
        [b addTarget:self action:@selector(delNum) forControlEvents:UIControlEventTouchUpInside];
    } else if (i==-2) {
        [b setTitle:TEXT_CLEAR forState:UIControlStateNormal];
        [b addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [b setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [b addTarget:self action:@selector(selectNum:) forControlEvents:UIControlEventTouchUpInside];
    }
    [b setFrame:f];
    b.layer.borderWidth=0.5f;
    b.layer.borderColor = [UICOLOR_VERY_LIGHT_GREY_BORDER CGColor];
    [b setBackgroundImage:[self imageWithColor:UICOLOR_VERY_LIGHT_GREY_BORDER] forState:UIControlStateHighlighted];

    b.tag = i;
    [b setBackgroundColor:[UIColor whiteColor]];
    [b setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [b.titleLabel setFont:[UIFont boldSystemFontOfSize:FONT_L]];
    return b;
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(void) selectNum:(UIButton *)b{
    NSString *codeptr;
    if (state==PC_STATE_INIT || state==PC_STATE_NORMAL) {
        if ([code length]<6) {
            code = [NSString stringWithFormat:@"%@%d",code,(int)b.tag];
        }
        codeptr = code;
       
    } else if (state==PC_STATE_INIT_2) {
        if ([verifycode length]<6) {
            verifycode = [NSString stringWithFormat:@"%@%d",verifycode,(int)b.tag];
        }
        codeptr = verifycode;
    }
  
    for (int i =0; i < [codeptr length];i++) {
        PaymentCodeDigit *d = (PaymentCodeDigit *)[codeHolder viewWithTag:(10+i)];
        [d setText:@"*"];
    }
}
-(void) delNum {
    NSString *codeptr=@"";
    if (state==PC_STATE_INIT|| state==PC_STATE_NORMAL) {
        if ([code length]<=1) {
            [self clearAll];
            return;
        } else {
            code = [code substringWithRange:NSMakeRange(0, [code length]-1)];
            codeptr = code;
        }
    } else if (state == PC_STATE_INIT_2) {
        if ([verifycode length]<=1) {
            [self clearAll];
            return;
        } else {
            verifycode = [verifycode substringWithRange:NSMakeRange(0, [verifycode length]-1)];
            codeptr = code;
        }
    }
    for (int i =0; i < [codeptr length];i++) {
        PaymentCodeDigit *d = (PaymentCodeDigit *)[codeHolder viewWithTag:(10+i)];
        [d setText:@"*"];
    }
    for (int i = (int)[codeptr length]; i < 6; i++) {
        PaymentCodeDigit *d = (PaymentCodeDigit *)[codeHolder viewWithTag:(10+i)];
        [d setText:@""];
    }
}
-(void) clearAll {
    if (state==PC_STATE_INIT|| state==PC_STATE_NORMAL) {
        code = @"";
    } else if (state==PC_STATE_INIT_2) {
        verifycode = @"";
    }
    for (int i =0; i < 6;i++) {
        PaymentCodeDigit *d = (PaymentCodeDigit *)[codeHolder viewWithTag:(10+i)];
        [d setText:@""];
    }
}
-(void) submit {
    if (state==PC_STATE_INIT) {
        if ([code length]==6) {
            state = PC_STATE_INIT_2;
            [self makeInit];
        }
    } else if (state==PC_STATE_INIT_2) {
        if ([verifycode length]==6) {
            if ([verifycode isEqualToString:code]) {
                [delegate startLoading];
                [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-payment-token",K_API_ENDPOINT]
                                                      param:[[NSDictionary alloc] initWithObjects:@[
                                                                                                    @"set-payment-code",
                                                                                                    verifycode,
                                                                                                    ]
                                                                                          forKeys:@[
                                                                                                    @"action",
                                                                                                    @"paymentCode"
                                                                                                    ]]
                                                 interation:0
                                                   callback:^(NSDictionary *data) {
                                                       if ([[data objectForKey:@"rc"] intValue]==0) {
                                                           [self->delegate raiseAlert:TEXT_SAVE_SUCCESS msg:@""];
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:RESTORE_BACK_BTN object:nil];
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:ON_BACK_PRESSED object:nil];
                                                       } else {
                                                           [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                                       }
                }];
                
                
            } else {
                [delegate raiseAlert:TEXT_INPUT_ERROR msg:TEXT_PASSWORD_DONT_MATCH];
                [self makeInit];
            }
        }
    } else if (state==PC_STATE_NORMAL) {
        if ([code length]==6) {
            if ([code isEqualToString:code]) {
                [delegate startLoading];
                [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-perform-transaction",K_API_ENDPOINT]
                                                      param:[[NSDictionary alloc] initWithObjects:@[
                                                                                                    @"charge",
                                                                                                    transactionCode,
                                                                                                    code,
                                                                                                    amount,
                                                                                                    vendorid,
                                                                                                    remarks
                                                                                                    ]
                                                                                          forKeys:@[
                                                                                                    @"action",
                                                                                                    @"paymentToken",
                                                                                                    @"paymentPassword",
                                                                                                    @"amount",
                                                                                                    @"vendor_id",
                                                                                                    @"remarks"
                                                                                                    
                                                                                                    ]]
                                                 interation:0
                                                   callback:^(NSDictionary *data) {
                                                       if ([[data objectForKey:@"rc"] intValue]==0) {
                                                           [self->delegate raiseAlert:TEXT_PAYMENT_SUCCESS msg:@""];
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:RESTORE_BACK_BTN object:nil];
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:ON_BACK_PRESSED object:nil];
                                                           if ([vendorid isEqualToString:@"print"]) {
                                                                [[NSNotificationCenter defaultCenter] postNotificationName:ON_BACK_PRESSED object:nil];
                                                           }
                                                       } else if ([[data objectForKey:@"rc"] intValue]==6) {
                                                           [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                                       } else {
                                                           [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                                       }
                                                   }];
                
                
            } else {
                [delegate raiseAlert:TEXT_INPUT_ERROR msg:TEXT_PASSWORD_DONT_MATCH];
                [self makeInit];
            }
        }
    }
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
