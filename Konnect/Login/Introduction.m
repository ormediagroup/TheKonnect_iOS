//
//  LoginController.m
//  Konnect
//
//  Created by Jacky Mok on 5/9/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "Introduction.h"
#import "AppDelegate.h"
#import "LoginOrReg.h"
#define DOT_SIZE 30
#define PAGES 4
@interface Introduction ()

@end

@implementation Introduction

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,-STATUS_BAR_HEIGHT,delegate.screenWidth,delegate.screenHeight+STATUS_BAR_HEIGHT)];
     scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
    [scroll setClipsToBounds:YES];
    [scroll setBackgroundColor:[UIColor redColor]];
    [scroll setBounces:NO];
    [self.view setBackgroundColor:[UIColor yellowColor]];
    CGFloat left = delegate.screenWidth/2-158;
    
    UIImageView *red = [[UIImageView alloc] initWithFrame:CGRectMake(0,-STATUS_BAR_HEIGHT,scroll.frame.size.width,scroll.frame.size.height+STATUS_BAR_HEIGHT)];
    {
        [red setContentMode:UIViewContentModeScaleAspectFill];
        [red setImage:[UIImage imageNamed:@"intro1.png"]];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(left, 170,316,40)];
        [title setText:@"GEOGRAPHIC LOCATION"];
        [title setTextColor: UICOLOR_GOLD];
        [title setFont:[UIFont boldSystemFontOfSize:FONT_L]];
        [red addSubview:title];
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(left, 210, 316, 300)];
        [desc setNumberOfLines:-1];
        [desc setTextAlignment:NSTextAlignmentJustified];
        [desc setTextColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
        [desc setText:@"The property is located in the heart of Hong Kong in the city's busting Wan Chai district. This district is located in Hong Kong's CBD, and is considered part of the city's Greater Central area, a thriving commercial hub that encompasses global corporate headquarters and creative co-working spaces."];
        [desc setFont:[UIFont systemFontOfSize:FONT_S]];
        [desc sizeToFit];
        [red addSubview:desc];
        
    }
    
    UIImageView *blue = [[UIImageView alloc] initWithFrame:CGRectMake(delegate.screenWidth,-STATUS_BAR_HEIGHT,delegate.screenWidth,delegate.screenHeight+STATUS_BAR_HEIGHT)];
    [blue setImage:[UIImage imageNamed:@"intro2.png"]];
    {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(left, 170,316,40)];
        [title setText:@"GREAT SHOPS"];
        [title setTextColor: UICOLOR_GOLD];
        [title setFont:[UIFont boldSystemFontOfSize:FONT_L]];
        [blue addSubview:title];
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(left, 210, 316, 300)];
        [desc setNumberOfLines:-1];
        [desc setTextAlignment:NSTextAlignmentJustified];
        [desc setTextColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
        [desc setText:@"Fast food shop for local who is concerned about health and fitness. Varieties of healty ingredients, freshly handmade concept will be implemented and welcome to eat in or take out."];
        [desc setFont:[UIFont systemFontOfSize:FONT_S]];
        [desc sizeToFit];
        [blue addSubview:desc];
        
    }
    
    UIImageView *green = [[UIImageView alloc] initWithFrame:CGRectMake(delegate.screenWidth*2,-STATUS_BAR_HEIGHT,delegate.screenWidth,delegate.screenHeight+STATUS_BAR_HEIGHT)];
    [green setImage:[UIImage imageNamed:@"intro3.png"]];;
    {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(left, 170,316,40)];
        [title setText:@"CORPORATES"];
        [title setTextColor: UICOLOR_GOLD];
        [title setFont:[UIFont boldSystemFontOfSize:FONT_L]];
        [green addSubview:title];
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(left, 210, 316, 300)];
        [desc setNumberOfLines:-1];
        [desc setTextAlignment:NSTextAlignmentJustified];
        [desc setTextColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
        [desc setText:@"We provide space for any cooperate and chamber training, team building. It provides specialised courses that place equal emphasis on theory and practice for individuals, government departments financial institutions and enterprises."];
        [desc setFont:[UIFont systemFontOfSize:FONT_S]];
        [desc sizeToFit];
        [green addSubview:desc];
        
    }
    
    
    UIImageView *black = [[UIImageView alloc] initWithFrame:CGRectMake(delegate.screenWidth*3,-STATUS_BAR_HEIGHT,delegate.screenWidth,delegate.screenHeight+STATUS_BAR_HEIGHT)];
    [black setImage:[UIImage imageNamed:@"intro4.png"]];;
    {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(left, 170,316,40)];
        [title setText:@"BECOME A MEMBER"];
        [title setTextColor: UICOLOR_GOLD];
        [title setFont:[UIFont boldSystemFontOfSize:FONT_L]];
        [black addSubview:title];
        
        UIImageView *aicon = [[UIImageView alloc] initWithFrame:CGRectMake(left,230,36,36)];
        [aicon setImage:[UIImage imageNamed:@"addricon"]];
        [black addSubview:aicon];
        
        UILabel *addr = [[UILabel alloc] initWithFrame:CGRectMake(left+50, 230, 266, 300)];
        [addr setNumberOfLines:-1];
        [addr setTextAlignment:NSTextAlignmentJustified];
        [addr setTextColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
        [addr setText:@"297-305, Jaffe Road, Wan Chai, Hong Kong"];
        [addr setFont:[UIFont systemFontOfSize:FONT_S]];
        [addr sizeToFit];
        [black addSubview:addr];
        
        
        
        UIImageView *picon = [[UIImageView alloc] initWithFrame:CGRectMake(left,290,36,36)];
        [picon setImage:[UIImage imageNamed:@"phoneicon.png"]];
        [black addSubview:picon];
        
        UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(left+50, 300, 266, 300)];
        [phone setNumberOfLines:-1];

        [phone setTextAlignment:NSTextAlignmentJustified];
        [phone setTextColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
        [phone setText:@"(852) 1111 2222"];
        [phone setFont:[UIFont systemFontOfSize:FONT_S]];
        [phone sizeToFit];
        [black addSubview:phone];
        
    }
    
    index=1;
   
    indicators = [[UIView alloc] initWithFrame:CGRectMake(delegate.screenWidth/2-(DOT_SIZE*PAGES/2),delegate.screenHeight-40,DOT_SIZE*PAGES,DOT_SIZE)];
    [indicators addSubview:[self createDot:CGRectMake(0,0,DOT_SIZE,DOT_SIZE) withTag:0]];
    [indicators addSubview:[self createDot:CGRectMake(DOT_SIZE,0,DOT_SIZE,DOT_SIZE) withTag:1]];
    [indicators addSubview:[self createDot:CGRectMake(DOT_SIZE*2,0,DOT_SIZE,DOT_SIZE) withTag:2]];
    [indicators addSubview:[self createDot:CGRectMake(DOT_SIZE*3,0,DOT_SIZE,DOT_SIZE) withTag:3]];
    
    [scroll setContentSize:CGSizeMake(delegate.screenWidth*PAGES,1)];
    [scroll setDelegate:self];
    [scroll setPagingEnabled:YES];
     
    [scroll addSubview:red];
    [scroll addSubview:blue];
    [scroll addSubview:green];
    [scroll addSubview:black];
    [self.view addSubview:scroll];
    [self setDot:0];

    [self.view addSubview:indicators];
    
    login = [UIButton buttonWithType:UIButtonTypeCustom];
    [login setImage:[UIImage imageNamed:@"goldbutton.png"] forState:UIControlStateNormal];
    [login setFrame:CGRectMake(delegate.screenWidth/2-158, delegate.screenHeight-120, 316, 44)];
    [login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *btnLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,login.frame.size.width, login.frame.size.height)];
    [btnLbl setText:TEXT_LOGIN];
    [btnLbl setTextColor:UICOLOR_DARK_GREY];
    [btnLbl setFont:[UIFont boldSystemFontOfSize:FONT_L]];
    [login addSubview:btnLbl];
    [btnLbl setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:login];
    
    
    UIImageView *logo =[[UIImageView alloc] initWithFrame:CGRectMake(delegate.screenWidth/2-158,80,207,48)];
    [logo setImage:[UIImage imageNamed:@"logo.png"]];
    [self.view addSubview:logo];
    

    loginVC = [[LoginOrReg alloc]initWithNibName:nil bundle:nil];
    loginVC.parent = self;

 
    [self.navigationController setToolbarHidden:YES];
    [self.navigationController setNavigationBarHidden:YES];
   
}
-(void) viewWillAppear:(BOOL)animated {
    [scroll scrollRectToVisible:CGRectMake(0,delegate.screenHeight+10,1,1) animated:NO];
}

-(void) backToIntro {
    
    //[self.navigationController popToViewController:scrollc animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
    /*
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
     */
}
-(void) login {
    [self.navigationController pushViewController:loginVC animated:YES];
    /*[self presentViewController:loginVC animated:YES completion:^{
        
    }];*/
}
-(UIView *) createDot:(CGRect)f withTag:(int)t{
    UIView *v = [[UIView alloc] initWithFrame:f];
    v.tag = t;
    UIView *d = [[UIView alloc] initWithFrame:CGRectMake(DOT_SIZE/2-3,DOT_SIZE/2-3,6,6)];
    [d setTag:99];
    d.layer.borderWidth = 1.0f;
    d.layer.borderColor = [UICOLOR_GOLD CGColor];
    [d.layer setCornerRadius:5.0f];
    [v addSubview:d];
    return v;
}
-(void) setDot:(int)index {
    for (UIView *v in indicators.subviews) {
        if (v.tag==index) {
            [[v viewWithTag:99] setBackgroundColor:UICOLOR_GOLD];
        } else {
            [[v viewWithTag:99] setBackgroundColor:[UIColor clearColor]];
        }
    }
}
-(void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (targetContentOffset->x <delegate.screenWidth) {
        [self setDot:0];
    } else if (targetContentOffset->x<(delegate.screenWidth*2)) {
        [self setDot:1];
    } else if (targetContentOffset->x<(delegate.screenWidth*3)) {
        [self setDot:2];
    } else if (targetContentOffset->x<(delegate.screenWidth*4)) {
        [self setDot:3];
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
