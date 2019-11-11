//
//  ORWebViewController.m
//  Konnect
//
//  Created by Jacky Mok on 6/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORWebViewController.h"
#import "AppDelegate.h"
#import "const.h"
@interface ORWebViewController ()

@end

@implementation ORWebViewController
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
        UIButton *back = [UIButton  buttonWithType:UIButtonTypeCustom];
        [back setFrame:CGRectMake(SIDE_PAD,delegate.headerHeight-30,100,24)];
        back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [back setTitle:[NSString stringWithFormat:@"%@ %@",CLOSE_X,TEXT_CLOSE] forState:UIControlStateNormal];
        [back setTitleColor:[UIColor colorWithWhite:0.0 alpha:0.8] forState:UIControlStateNormal];
        [back addTarget:self action:@selector(onBackPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:back];
        
        wkweb = [[WKWebView alloc] initWithFrame:CGRectMake(0,delegate.headerHeight+20, delegate.screenWidth, delegate.screenHeight-delegate.headerHeight-20)];
        [self.view addSubview:wkweb];
        wkweb.navigationDelegate = self;
        /*
        share = [UIButton buttonWithType:UIButtonTypeCustom];
        [share setImage:[UIImage imageNamed:@"share_150x150.png"] forState:UIControlStateNormal];
        [share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        [share setFrame:CGRectMake(delegate.screenWidth-50,delegate.screenHeight-50,40,40)];
        [self.view addSubview:share];
        */
    }
    return self;
}
-(void) onBackPressed{
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void) share {
  /*  if (![newsurl isEqualToString:@""]) {
        NSString *URL = [NSString stringWithFormat:@"%@",newsurl];
        //NSURL *u = [NSURL URLWithString:[URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSArray* sharedObjects=[NSArray arrayWithObjects:@"", URL, nil];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:sharedObjects applicationActivities:nil];
        activityViewController.popoverPresentationController.sourceView = self.view;
        [self presentViewController:activityViewController animated:YES completion:nil];
    }*/
}
-(void) loadData:(NSString *)url {
    if (url && [url isKindOfClass:[NSString class]]) {
        [delegate startLoading];
        NSURL *nurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?mobile=1",url]];
        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
        [urlRequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [urlRequest setHTTPShouldHandleCookies:NO];
        [urlRequest setTimeoutInterval:30];
        [urlRequest setHTTPMethod:@"POST"];
        //[delegate startLoading];
        
        // setting the body of the post to the reqeust
        [urlRequest setURL:nurl];
        [wkweb loadRequest:urlRequest];
    } else {
        [delegate networkError];
    }
   
}
-(void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [delegate stopLoading];
}

-(void) viewWillAppear:(BOOL)animated {
    [scroll scrollRectToVisible:CGRectMake(0,0,1,1) animated:NO];
    [self.view endEditing:YES];
    /*
     GADRequest *request = [GADRequest request];
     request.testDevices = @[kGADSimulatorID];
     [self.bannerView loadRequest:[GADRequest request]];
     [self.view bringSubviewToFront:self.bannerView];
     */
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
