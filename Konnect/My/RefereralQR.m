//
//  RefereralQR.m
//  Konnect
//
//  Created by Jacky Mok on 8/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "RefereralQR.h"
#import "AppDelegate.h"

@interface RefereralQR ()

@end

@implementation RefereralQR

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
    
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD,100,delegate.screenWidth-SIDE_PAD_2,delegate.screenHeight-50-delegate.footerHeight-SIDE_PAD_2-SIDE_PAD_2)];
    v.layer.cornerRadius = 5.0f;
    [v setBackgroundColor:[UIColor whiteColor]];
    v.layer.borderWidth = 0.5f;
    v.layer.borderColor = [UICOLOR_LIGHT_GREY CGColor];
    [self.view addSubview:v];
    
    CGFloat QRCodeSize = v.frame.size.width-SIDE_PAD_2-SIDE_PAD_2;
    
    UILabel *purple = [[UILabel alloc] initWithFrame:CGRectMake(0,0,v.frame.size.width,60)];
    [purple setText:TEXT_CLICK_TO_SHARE_QR_CODE];
    [purple setTextColor:UICOLOR_GOLD];
    [purple setFont:[UIFont systemFontOfSize:FONT_M]];
    [purple setTextAlignment:NSTextAlignmentCenter];
    [purple setBackgroundColor:[delegate getThemeColor]];
    [v addSubview:purple];
    
    
    v.layer.shadowRadius  = 10.0f;
    v.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:0.7f].CGColor;
    v.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    v.layer.shadowOpacity = 0.4f;
    v.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(0, 0, -1.5f, 0);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(v.bounds, shadowInsets)];
    v.layer.shadowPath    = shadowPath.CGPath;
    
    CGFloat whiteHeight = v.frame.size.height-60;
    CGFloat qrCenterV = (whiteHeight-QRCodeSize)/2+60;
    
    qrImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD_2,qrCenterV,QRCodeSize,QRCodeSize)];
    qrImageView.layer.borderColor = [UICOLOR_GOLD CGColor];
    qrImageView.layer.borderWidth = 0.5f;
    [qrImageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(share)];
    [qrImageView addGestureRecognizer:tap];
    
    
    [v addSubview:qrImageView];
    [self genQRCode:[NSString stringWithFormat:@"%@earlyregistration/?qr_code=%@",domain,[delegate.preferences objectForKey:K_USER_OPENID]]];
}
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_REFERRAL_QR];
}
-(void) genQRCode:(NSString *)qrString {
    
    NSData *stringData = [qrString dataUsingEncoding: NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    float scaleX = qrImageView.frame.size.width / qrImage.extent.size.width;
    float scaleY = qrImageView.frame.size.height / qrImage.extent.size.height;
    
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    UIGraphicsBeginImageContext(CGSizeMake(qrImageView.frame.size.width, qrImageView.frame.size.height));
    [[UIImage imageWithCIImage:qrImage
                        scale:[UIScreen mainScreen].scale
                  orientation:UIImageOrientationUp] drawInRect:CGRectMake(0,0,qrImageView.frame.size.width, qrImageView.frame.size.height)];
    [[UIImage imageNamed:@"logo_qr-012.png"] drawInRect:CGRectMake(qrImageView.frame.size.width/2-40, qrImageView.frame.size.height/2-40,80,80)];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    qrImageView.image = finalImage;
    
}
-(void) onBackPressed {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void) share{
    NSData *idata = UIImagePNGRepresentation(qrImageView.image);
    NSString *content = [NSString stringWithFormat:@"KONNECT %@",TEXT_REFERRAL_QR];
    NSArray* sharedObjects=[NSArray arrayWithObjects:[UIImage imageWithData:idata],nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:nil];
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:activityViewController animated:YES completion:nil];
    

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
