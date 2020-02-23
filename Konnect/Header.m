//
//  Header.m
//  Konnect
//
//  Created by Jacky Mok on 26/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "Header.h"
#import "AppDelegate.h"
#import "const.h"
#import "ViewController.h"
#import "Home.h"
@interface Header ()

@end

@implementation Header
@synthesize parent;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[delegate getThemeColor]];
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    backEnabled = YES;

    back = [UIButton  buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(SIDE_PAD,delegate.headerHeight-30,24,24)];
    back.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [back setImage:[UIImage imageNamed:@"backbtnwhite.png"] forState:UIControlStateNormal];
    [back.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [back addTarget:self action:@selector(onBackPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    logo = [[UIImageView alloc] initWithFrame:CGRectMake(0,delegate.headerHeight-40,delegate.screenWidth,28)];
    [logo setImage:[UIImage imageNamed:@"logo-small.png"]];
    [logo setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:logo];
    
    title = [[UILabel alloc] initWithFrame:CGRectMake(0,delegate.headerHeight-34,delegate.screenWidth,30)];
    [title setFont:[UIFont systemFontOfSize:FONT_M]];
    [title setTextAlignment:NSTextAlignmentCenter];
    [title setTextColor:[UIColor whiteColor]];
    [self.view addSubview:title];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBackPressed) name:ON_BACK_PRESSED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideBackBtn) name:HIDE_BACK_BTN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBackBtn) name:SHOW_BACK_BTN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableBackBtn) name:DISABLE_BACK_BTN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableBackBtn) name:ENABLE_BACK_BTN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redirectBackBtn:) name:REDIRECT_BACK_BTN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreBackBtn) name:RESTORE_BACK_BTN object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTitle:) name:CHANGE_TITLE object:nil];
}
-(void) viewWillAppear:(BOOL)animated {
    [self.view setBackgroundColor:[delegate getThemeColor]];
}
-(void) redirectBackBtn:(NSNotification *)t {
    [back removeTarget:self action:@selector(onBackPressed) forControlEvents:UIControlEventAllEvents];
    if (strcmp([[t.object objectForKey:@"selector"] objCType], @encode(SEL)) == 0) {
        SEL selector;
        [[t.object objectForKey:@"selector"] getValue:&selector];
        [back addTarget:[t.object objectForKey:@"target"] action:selector forControlEvents:UIControlEventTouchUpInside];
    }

}
-(void) restoreBackBtn {
    [back removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [back addTarget:self action:@selector(onBackPressed) forControlEvents:UIControlEventTouchUpInside];

}
-(void) onBackPressed {
    if (backEnabled) {
        [parent onBackPressed];
    }
}
-(void) changeTitle:(NSNotification *)notif {
    if ([notif.object isKindOfClass:[NSString class]] && ![notif.object isEqualToString:@""]) {
        [title setText:notif.object];
        [logo removeFromSuperview];
        [self.view addSubview:title];
    } else {
        [title setText:@""];
        [title removeFromSuperview];
        [self.view addSubview:logo];
    }
}
-(void) hideBackBtn {
    [back setHidden:YES];
}
-(void) showBackBtn {
    [back setHidden:NO];
}
-(void) disableBackBtn {
    backEnabled=NO;
}
-(void) enableBackBtn {
    backEnabled=YES;
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

