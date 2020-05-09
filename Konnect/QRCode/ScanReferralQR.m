//
//  ScanReferralQR.m
//  Konnect
//
//  Created by Jacky Mok on 21/4/2020.
//  Copyright © 2020 Jacky Mok. All rights reserved.
//

#import "ScanReferralQR.h"
#import "AppDelegate.h"
#import "LoginOrReg.h"
@interface ScanReferralQR ()
@property (nonatomic) BOOL isReading;
@property (nonatomic) IBOutlet UIView *viewPreview;


@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

-(BOOL)startReading;
@end

@implementation ScanReferralQR
@synthesize parent;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

  
    _viewPreview = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.screenHeight)];
    [self.view addSubview:_viewPreview];
    staticImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.screenHeight)];
    [staticImage setContentMode:UIViewContentModeScaleAspectFit];
    [_viewPreview addSubview:staticImage];
    
    UIButton *album = [UIButton buttonWithType:UIButtonTypeCustom];
    [album setImage:[UIImage imageNamed:@"refalbum.png"] forState:UIControlStateNormal];
    [album setFrame:CGRectMake(delegate.screenWidth-80,10,30,30)];
    [album addTarget:parent action:@selector(chooseFromAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:album];
    
    UIButton *cam = [UIButton buttonWithType:UIButtonTypeCustom];
       [cam setImage:[UIImage imageNamed:@"refcam.png"] forState:UIControlStateNormal];
       [cam setFrame:CGRectMake(delegate.screenWidth-120,10,30,30)];
       [cam addTarget:self action:@selector(camera) forControlEvents:UIControlEventTouchUpInside];
       [self.view addSubview:cam];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitle:CLOSE_X forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [cancel setFrame:CGRectMake(delegate.screenWidth-40,10,30,30)];
    [cancel.layer setCornerRadius:15];
    [cancel addTarget:parent action:@selector(killRefScan) forControlEvents:UIControlEventTouchUpInside];
    [cancel setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:cancel];
    _isReading = NO;
    _captureSession = nil;
    
}
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:@"掃描QR Code"];
    [self camera];
}
-(void) back {
    [parent backPressed];
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

-(void) camera {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    [staticImage setImage:nil];
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
-(void)stopReading{
    AudioServicesPlaySystemSound (1052);
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            _isReading = NO;
            NSDictionary *params = [self readParam:[metadataObj stringValue]];
            if ([[params objectForKey:@"refname"] isEqualToString:@""] || [[params objectForKey:@"refid"] isEqualToString:@""]) {
                dispatch_async(dispatch_get_main_queue(),^{
                    [self->delegate raiseAlert:TEXT_ERROR msg:TEXT_CANNOT_DETECT_QR];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(),^{
                    [self->parent setReferrer:[params objectForKey:@"refname"] withID:[params objectForKey:@"refid"]];
                    [self->parent killRefScan];
                    [self stopReading];
                });
                
            }
        }
    }
}
-(NSDictionary *)readParam:(NSString *)url {
    NSString *encodedURL = [url stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@" "] invertedSet]];
    NSURLComponents *q = [NSURLComponents componentsWithString:encodedURL];
    NSMutableDictionary *queryStrings = [[NSMutableDictionary alloc] init];
    if ([[q host] isEqualToString:@"thekonnect.com.hk"]) {
        for (NSString *qs in [[q query] componentsSeparatedByString:@"&"]) {
            // Get the parameter name
            NSString *key = [[qs componentsSeparatedByString:@"="] objectAtIndex:0];
            // Get the parameter value
            NSString *value = [[qs componentsSeparatedByString:@"="] objectAtIndex:1];
            value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            queryStrings[key] = value;
        }
    }
    if (![[queryStrings objectForKey:@"refname"] isKindOfClass:[NSString class]]) {
        [queryStrings setObject:@"" forKey:@"refname"];
    }
    if (![[queryStrings objectForKey:@"refid"] isKindOfClass:[NSString class]]) {
        [queryStrings setObject:@"" forKey:@"refid"];
    }
        
    return queryStrings;
}
-(void) setImage:(UIImage *)img {
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
    [staticImage setImage:img];
    
    CIDetector *cid = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray *features = [cid featuresInImage:[CIImage imageWithCGImage:[img CGImage]]];
    
    if ([features count]>0) {
        CIQRCodeFeature *f = [features objectAtIndex:0];
        NSLog(@"Got QR Code: %@",f.messageString);
        NSDictionary *params = [self readParam:f.messageString];
        if ([[params objectForKey:@"refname"] isEqualToString:@""] || [[params objectForKey:@"refid"] isEqualToString:@""]) {
            dispatch_async(dispatch_get_main_queue(),^{
                [self->delegate raiseAlert:TEXT_ERROR msg:TEXT_CANNOT_DETECT_QR];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(),^{
                [self->parent setReferrer:[params objectForKey:@"refname"] withID:[params objectForKey:@"refid"]];
                [self->parent killRefScan];
                [self stopReading];
            });
            
        }
    }
    else if ([features count]==0) {
        dispatch_async(dispatch_get_main_queue(),^{
            [self->delegate raiseAlert:TEXT_ERROR msg:TEXT_CANNOT_DETECT_QR];
        });
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
