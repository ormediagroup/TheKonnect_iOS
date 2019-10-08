//
//  PaymentQR.m
//  Konnect
//
//  Created by Jacky Mok on 7/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "PaymentQR.h"
#import "AppDelegate.h"
@interface PaymentQR ()

@end

@implementation PaymentQR

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:UICOLOR_GOLD];
    
    UIButton *back = [UIButton  buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(SIDE_PAD,delegate.headerHeight-30,24,24)];
    back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [back setImage:[UIImage imageNamed:@"backbtnwhite.png"] forState:UIControlStateNormal];
    [back.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [back addTarget:self action:@selector(onBackPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,delegate.headerHeight-30 ,delegate.screenWidth-SIDE_PAD_2,24)];
    [t setText:@"積分付款二維碼"];
    [t setTextColor:[UIColor whiteColor]];
    [t setFont:[UIFont systemFontOfSize:FONT_M]];
    [t setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:t];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD,200,delegate.screenWidth-SIDE_PAD_2,delegate.screenHeight-250-delegate.footerHeight-SIDE_PAD_2-SIDE_PAD_2)];
    v.layer.cornerRadius = 5.0f;
    [v setBackgroundColor:[UIColor whiteColor]];
    v.layer.borderWidth = 0.5f;
    v.layer.borderColor = [UICOLOR_LIGHT_GREY CGColor];
    [self.view addSubview:v];
    
    v.layer.shadowRadius  = 10.0f;
    v.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:0.7f].CGColor;
    v.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    v.layer.shadowOpacity = 0.4f;
    v.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(v.bounds, shadowInsets)];
    v.layer.shadowPath    = shadowPath.CGPath;
    
    UILabel *purple = [[UILabel alloc] initWithFrame:CGRectMake(0,0,v.frame.size.width,80)];
    [purple setText:@"使用積分向商家付款"];
    [purple setTextColor:UICOLOR_GOLD];
    [purple setFont:[UIFont systemFontOfSize:FONT_L]];
    [purple setTextAlignment:NSTextAlignmentCenter];
    [purple setBackgroundColor:UICOLOR_PURPLE];
    [v addSubview:purple];
    
    qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD+20,v.frame.size.height-v.frame.size.width-SIDE_PAD_2+40,v.frame.size.width-SIDE_PAD_2-40,v.frame.size.width-SIDE_PAD_2-40)];
    qrImageView.layer.borderColor = [UICOLOR_GOLD CGColor];
    qrImageView.layer.borderWidth = 0.5f;
    
    [v addSubview:qrImageView];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD_2,v.frame.size.height-50,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2-SIDE_PAD_2,50)];
    [l setText:@"付款之前請不要將二維碼向他人展示 以免造成不必要的損失"];
    [l setNumberOfLines:-1];
    [l setFont:[UIFont systemFontOfSize:FONT_XS]];
    [l setTextAlignment:NSTextAlignmentCenter];
    [v addSubview:l];
}
-(void) viewWillAppear:(BOOL)animated {
    NSString *qrString = [NSString stringWithFormat:@"%@",[delegate.preferences objectForKey:K_USER_OPENID]];
    NSData *stringData = [qrString dataUsingEncoding: NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    float scaleX = qrImageView.frame.size.width / qrImage.extent.size.width;
    float scaleY = qrImageView.frame.size.height / qrImage.extent.size.height;
    
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    qrImageView.image = [UIImage imageWithCIImage:qrImage
                                            scale:[UIScreen mainScreen].scale
                                      orientation:UIImageOrientationUp];
   
}
-(void) genQRCode:(NSString *)s {
}
-(void) onBackPressed {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        
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