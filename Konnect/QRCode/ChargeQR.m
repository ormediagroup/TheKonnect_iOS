//
//  ChargeQR.m
//  Konnect
//
//  Created by Jacky Mok on 10/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ChargeQR.h"
#import "const.h"
#import "AppDelegate.h"
@interface ChargeQR ()
@property (nonatomic) BOOL isReading;
@property (nonatomic) IBOutlet UIView *viewPreview;


@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

-(BOOL)startReading;
@end

@implementation ChargeQR

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewPreview = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.screenHeight)];
    _isReading = NO;

    _captureSession = nil;
  

}
-(void) setupInput {
    for (UIView *i in self.view.subviews) {
        [i removeFromSuperview];
    }
    charge = @"0";
    displayCharge = @"0";
    int y = LINE_PAD+delegate.headerHeight;
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    UIView *totalbg = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,70)];
    [totalbg setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
    totalbg.layer.cornerRadius = 5.0f;
    [self.view addSubview:totalbg];
    chargeTotal = [[UITextField alloc] initWithFrame:CGRectMake(SIDE_PAD,0,totalbg.frame.size.width-SIDE_PAD_2,totalbg.frame.size.height)];
    [chargeTotal setEnabled:NO];
    [chargeTotal setFont:[UIFont systemFontOfSize:(totalbg.frame.size.height-10)]];
    [chargeTotal setTextAlignment:NSTextAlignmentRight];
    [chargeTotal setTextColor:[UIColor darkTextColor]];
    [chargeTotal setText:displayCharge];
    [totalbg addSubview:chargeTotal];
    y+=totalbg.frame.size.height+LINE_PAD;
    
    
    CGFloat width = (delegate.screenWidth-(4*SIDE_PAD_2))/3;
    CGFloat height = width;
    CGFloat x = SIDE_PAD_2;
    [self.view addSubview:[self createNumber:7 inFrame:CGRectMake(x,y,width,height)]];
    x+=SIDE_PAD_2+width;
    [self.view addSubview:[self createNumber:8 inFrame:CGRectMake(x,y,width,height)]];
    x+=SIDE_PAD_2+width;
    [self.view addSubview:[self createNumber:9 inFrame:CGRectMake(x,y,width,height)]];
    x = SIDE_PAD_2;
    y+=LINE_PAD+height;
    [self.view addSubview:[self createNumber:4 inFrame:CGRectMake(x,y,width,height)]];
    x+=SIDE_PAD_2+width;
    [self.view addSubview:[self createNumber:5 inFrame:CGRectMake(x,y,width,height)]];
    x+=SIDE_PAD_2+width;
    [self.view addSubview:[self createNumber:6 inFrame:CGRectMake(x,y,width,height)]];
    x = SIDE_PAD_2;
    y+=LINE_PAD+height;
    [self.view addSubview:[self createNumber:1 inFrame:CGRectMake(x,y,width,height)]];
    x+=SIDE_PAD_2+width;
    [self.view addSubview:[self createNumber:2 inFrame:CGRectMake(x,y,width,height)]];
    x+=SIDE_PAD_2+width;
    [self.view addSubview:[self createNumber:3 inFrame:CGRectMake(x,y,width,height)]];
    x = SIDE_PAD_2;
    y+=LINE_PAD+height;
    [self.view addSubview:[self createNumber:0 inFrame:CGRectMake(x,y,width,height)]];
    x+=SIDE_PAD_2+width;
    {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [b setTitle:@"DEL" forState:UIControlStateNormal];
        [b setFrame:CGRectMake(x,y,width,height)];
        [b addTarget:self action:@selector(delNum) forControlEvents:UIControlEventTouchUpInside];
        b.layer.cornerRadius = height/2.0;
        [b setBackgroundColor:UICOLOR_LIGHT_GREY];
        [b.titleLabel setTextColor:[UIColor darkTextColor]];
        [b.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [self.view addSubview:b];
    }
    x+=SIDE_PAD_2+width;
    {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [b setTitle:@"AC" forState:UIControlStateNormal];
        [b setFrame:CGRectMake(x,y,width,height)];
        [b addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
        b.layer.cornerRadius = height/2.0;
        [b setBackgroundColor:UICOLOR_LIGHT_GREY];
        [b.titleLabel setTextColor:[UIColor darkTextColor]];
        [b.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        [self.view addSubview:b];
    }
    y+=height+LINE_PAD;
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b setTitle:TEXT_RECEIVE_PAYMENT forState:UIControlStateNormal];
    b.layer.cornerRadius = 10.0f;
    [b setBackgroundColor:[delegate getThemeColor]];
    [b setFrame:CGRectMake(SIDE_PAD_2,y,delegate.screenWidth-SIDE_PAD_2-SIDE_PAD_2,50)];
    [b.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [b setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
    [b addTarget:self action:@selector(goScan) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
}
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:@"掃描QR Code"];
    state = STATE_INIT;
    [self setupInput];
}
-(void) viewWillDisappear:(BOOL)animated {
    [self stopReading];
}
-(void) goScan {
    if ([charge isEqualToString:@"0"]) {
        [delegate raiseAlert:@"請輸入應收款項" msg:@""];
    } else {
        [self startScan];
    }
}
-(UIButton *)createNumber:(int) i inFrame:(CGRect)f {
    UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [b setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
    [b setFrame:f];
    b.tag = i;
    [b addTarget:self action:@selector(selectNum:) forControlEvents:UIControlEventTouchUpInside];
    b.layer.cornerRadius = f.size.height/2.0;
    [b setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
    [b.titleLabel setTextColor:[UIColor darkTextColor]];
    [b.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
    return b;
}
-(void) delNum {
    if ([charge isEqualToString:@"0"]) {
        return;
    }
    charge = [charge substringWithRange:NSMakeRange(0, ([charge length]-1))];
    if ([charge length]==0) {
        return [self clearAll];
    }
    displayCharge = @"";
    int k = 0;
    for (int i = ((int)[charge length]-1) ; i >=0 ; i--) {
        displayCharge = [NSString stringWithFormat:@"%@%@",[charge substringWithRange:NSMakeRange(i, 1)],displayCharge];
        k++;
        if (k==3 && i>0) {
            displayCharge = [NSString stringWithFormat:@",%@",displayCharge];
            k=0;
        }
    }
    [chargeTotal setText:displayCharge];
    [chargeTotal setAdjustsFontSizeToFitWidth:YES];
}
-(void) clearAll {
    charge = @"0";
    displayCharge = @"0";
    [chargeTotal setText:displayCharge];
    [chargeTotal setAdjustsFontSizeToFitWidth:YES];
}
-(void) selectNum:(UIButton *)b {
    if ([charge isEqualToString:@"0"]) {
        charge = [NSString stringWithFormat:@"%d",(int)b.tag];
    } else if ([charge length]>6) {
    } else {
        charge = [NSString stringWithFormat:@"%@%d",charge,(int)b.tag];
    }
 
    displayCharge = @"";
    int k = 0;
    for (int i = ((int)[charge length]-1) ; i >=0 ; i--) {
        displayCharge = [NSString stringWithFormat:@"%@%@",[charge substringWithRange:NSMakeRange(i, 1)],displayCharge];
        k++;
        if (k==3 && i>0) {
            displayCharge = [NSString stringWithFormat:@",%@",displayCharge];
            k=0;
        }
    }
    [chargeTotal setText:displayCharge];
    [chargeTotal setAdjustsFontSizeToFitWidth:YES];
}
-(void) startScan {
    for (UIView *i in self.view.subviews) {
        [i removeFromSuperview];
    }
    [self.view addSubview:_viewPreview];
    UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(0,delegate.headerHeight,delegate.screenWidth,50)];
    [v setText:[NSString stringWithFormat:[NSString stringWithFormat:@"%@",displayCharge]]];
    [v setTextAlignment:NSTextAlignmentCenter];
    [v setBackgroundColor:UICOLOR_GOLD];
    [v setTextColor:[UIColor darkGrayColor]];
    [v setFont:[UIFont systemFontOfSize:36]];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth,50)];
    [l setText:TEXT_RECEIVE_PAYMENT];
    [l setTextAlignment:NSTextAlignmentLeft];
    [l setTextColor:[UIColor darkGrayColor]];
    [l setFont:[UIFont systemFontOfSize:18]];
    [v addSubview:l];
    [self.view addSubview:v];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized)
    {
        [self startReading];
    }
    else if(authStatus == AVAuthorizationStatusNotDetermined)
    {
        NSLog(@"%@", @"Camera access not determined. Ask for permission.");
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
         {
             if(granted)
             {
                 NSLog(@"Granted access to %@", AVMediaTypeVideo);
                 [self startReading];
             }
             else
             {
                 NSLog(@"Not granted access to %@", AVMediaTypeVideo);
                 [self camDenied];
             }
         }];
    }
    else if (authStatus == AVAuthorizationStatusRestricted)
    {
        // My own Helper class is used here to pop a dialog in one simple line.
        [self camDenied];
    }
    else
    {
        [self camDenied];
    }
}
-(void) camDenied {
    [delegate raiseAlert:@"Cannot open camera" msg:@"please check your camera setting"];
}
- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

-(void)stopReading{
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:ON_BACK_PRESSED object:nil];
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            _isReading = NO;
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(gotCode:) withObject:[metadataObj stringValue] waitUntilDone:NO];

        }
    }
}
-(void) gotCode:(NSString *)code {
    AudioServicesPlaySystemSound (1052);
    NSLog(@"ChargeQR Got Payment: %@",code);
    [delegate startLoading];
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@vendor-perform-transaction",K_API_ENDPOINT]
                                          param:[[NSDictionary alloc] initWithObjects:@[
                                                     @"charge",
                                                     charge,
                                                     @"3",
                                                     code]
                                                                              forKeys:@[
                                                     @"action",
                                                     @"amount",
                                                     @"vendor_id",
                                                     @"paymentToken"]]
                                     interation:0 callback:^(NSDictionary *data) {
                                         NSLog(@"chargeQR Payment Completed: %@",data);
                                         if ([[data objectForKey:@"rc"] intValue]==2) {
                                             
                                             [self raiseAlert:TEXT_QR_CODE_EXPIRED msg:TEXT_GEN_NEW_QR];
                                             
                                         } else if ([[data objectForKey:@"rc"] intValue]!=0) {
                                             [self raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                             
                                         } else {
                                             [self raiseAlertSuccess:TEXT_RECEIVE_PAYMENT_SUCC msg:[NSString stringWithFormat:@"%@%@",TEXT_YOU_RECEIVED, self->chargeTotal]];
                                         }
                                     }];
}
-(void) raiseAlert:(NSString *)title msg:(NSString *)msg {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [self startScan];
    }];
    [alert addAction:defaultAction];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
 -(void) raiseAlertSuccess:(NSString *)title msg:(NSString *)msg {
     UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                    message:msg
                                                             preferredStyle:UIAlertControllerStyleAlert];
     
     UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
         [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:^{
             
         }];
     }];
     [alert addAction:defaultAction];
     dispatch_async(dispatch_get_main_queue(), ^{
         [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
     });
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
