//
//  ImageGallery.m
//  eAgent
//
//  Created by Jacky Mok on 7/1/2016.
//  Copyright © 2016 OR Media Limited. All rights reserved.
//

#import "ImageGallery.h"
#import "AppDelegate.h"
#import "ImageZoomViewController.h"

@interface ImageGallery ()

@end

@implementation ImageGallery
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        viewPanel = [[ImageZoomViewController alloc] initWithNibName:nil bundle:nil];
        
        UIImageView *watermark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"watermark.png"]];
        [watermark setContentMode:UIViewContentModeScaleAspectFit];
        [watermark setFrame:CGRectMake(20,20,delegate.screenWidth-40,delegate.screenHeight-PANEL_HEIGHT-40)];
        [viewPanel.view addSubview:watermark];
        nav = [[UINavigationController alloc] initWithRootViewController:viewPanel];
        
        UIButton *back = [UIButton buttonWithType:UIButtonTypeSystem];
        [back setTitle:[NSString stringWithFormat:@"%@ %@",LEFT_ARROW, TEXT_BACK] forState:UIControlStateNormal];
        [back setFrame:CGRectMake(10,14,100,20)];
        [back.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [nav.navigationBar addSubview:back];
        [nav.view setFrame:CGRectMake(0,0,delegate.screenWidth,delegate.screenHeight-PANEL_HEIGHT)];
        [self.view addSubview:nav.view];
        
        panel = [[UIScrollView alloc] initWithFrame:CGRectMake(0,delegate.screenHeight-PANEL_HEIGHT-delegate.footerHeight,delegate.screenWidth,PANEL_HEIGHT)];
        [panel setBackgroundColor:[UIColor colorWithWhite:0.98 alpha:1.0]];
        [self.view addSubview:panel];
        

    }
    return self;
}
-(void) back {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void) setImages:(NSArray *)_images {
    images = _images;
    vcs = nil;
    viewPanel.title = [NSString stringWithFormat:@"照片 (共%d張)",(int)[images count]];
    vcs = [[NSMutableArray alloc] initWithCapacity:[images count]];
    for (UIView *v in panel.subviews) {
        [v removeFromSuperview];
    }
    NSString *url = [images objectAtIndex:0];
    
    [viewPanel loadImage:[delegate getImage:url callback:^(UIImage *image) {
        [viewPanel loadImage:image];
    }]];
    int panel_x = 10;
    for (int i = 0;i < [images count]; i++) {

        UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(panel_x,10,PANEL_HEIGHT-20,PANEL_HEIGHT-20)];
        NSString *imgurl = [images objectAtIndex:i];
        [v setImage:[delegate getImage:imgurl callback:^(UIImage *image) {
            [v setImage:image];
        }]];
        [v setContentMode:UIViewContentModeScaleAspectFit];
        [v setTag:i];
        v.layer.borderWidth = 1.0;
        v.layer.borderColor = [[UIColor colorWithWhite:0.95 alpha:1.0] CGColor];
        v.layer.cornerRadius = 2.0;
        [v setBackgroundColor:[UIColor colorWithWhite:0.98 alpha:1.0]];
        
        [v setUserInteractionEnabled:YES];
        [v addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage:)]];
        [panel addSubview:v];
        panel_x+=PANEL_HEIGHT+10;
        
    }
    [panel setContentSize:CGSizeMake(panel_x+10,PANEL_HEIGHT)];
}
-(void) chooseImage:(UITapGestureRecognizer *)t {
    
    NSString *imgurl = [images objectAtIndex:t.view.tag];
    [viewPanel loadImage:[delegate getImage:imgurl callback:^(UIImage *image) {
        [self->viewPanel loadImage:image];
    }]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
