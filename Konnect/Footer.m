//
//  Footer.m
//  Konnect
//
//  Created by Jacky Mok on 27/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "Footer.h"
#import "AppDelegate.h"
#import "const.h"
#import "Home.h"
@interface Footer ()

@end

@implementation Footer
@synthesize parent;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,1)];
    [v setBackgroundColor:UICOLOR_LIGHT_GREY];
    [self.view addSubview:v];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:[self makeBtn:0 withImageSrc:@"home.png" andText:@"首頁"]];
    [self.view addSubview:[self makeBtn:1 withImageSrc:@"me.png" andText:@"我的"]];
    [self.view addSubview:[self makeBtn:2 withImageSrc:@"scanqr.png" andText:@""]];
    [self.view addSubview:[self makeBtn:3 withImageSrc:@"msg.png" andText:@"消息"]];
    [self.view addSubview:[self makeBtn:4 withImageSrc:@"cs.png" andText:@"客服"]];
    
   
}
-(UIButton *) makeBtn:(int) tag withImageSrc:(NSString *)imageSrc andText:(NSString *)lbl {
    CGFloat bottomPad =0;
    if (delegate.isX) {
        bottomPad =16;
    }
    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
    b1.tag = tag;
    CGFloat f = tag*delegate.screenWidth/5;
    [b1 addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
    [b1 setFrame:CGRectMake(f,0,delegate.screenWidth/5,delegate.footerHeight)];
    [self.view addSubview:b1];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(0,8,b1.frame.size.width, b1.frame.size.height-30-bottomPad)];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [icon setImage:[UIImage imageNamed:imageSrc]];
    [b1 addSubview:icon];
    
    if ([lbl isEqualToString:@""]) {
        
        [icon setFrame:CGRectMake(0,5,b1.frame.size.width, b1.frame.size.height-bottomPad-5)];
    } else {
        UILabel *btnText = [[UILabel alloc] initWithFrame:CGRectMake(0,delegate.footerHeight-20-bottomPad,b1.frame.size.width,20)];
        [btnText setText:lbl];
        [btnText setTextAlignment:NSTextAlignmentCenter];
        [btnText setFont:[UIFont boldSystemFontOfSize:FONT_XS]];
        [btnText setTextColor:[UIColor lightGrayColor]];
        [b1 addSubview:btnText];
    }
    return b1;
    
}
-(void) pressed:(UIButton *)b {
    if (b.tag==3) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_MESSAGE_LIST]] forKeys:@[@"type"]]];
    } else if (b.tag==2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_SCAN_QRCODE]] forKeys:@[@"type"]]];
    } else if (b.tag==1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_MY]] forKeys:@[@"type"]]];
    } else if (b.tag==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_HOME]] forKeys:@[@"type"]]];
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
