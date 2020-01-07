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
#define PAGES 5
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
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 30.f;
    style.maximumLineHeight = 30.f;
    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
    
    UIImageView *red = [[UIImageView alloc] initWithFrame:CGRectMake(0,-STATUS_BAR_HEIGHT,scroll.frame.size.width,scroll.frame.size.height+STATUS_BAR_HEIGHT)];
    {
        [red setContentMode:UIViewContentModeScaleAspectFill];
        [red setImage:[UIImage imageNamed:@"intro1.png"]];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(left, 170,316,40)];
        [title setText:@"商業與生活之融合"];
        [title setTextColor: UICOLOR_GOLD];
        [title setFont:[UIFont boldSystemFontOfSize:FONT_L]];
        [red addSubview:title];
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(left, 210, 316, 300)];
        [desc setNumberOfLines:0];
        [desc setTextAlignment:NSTextAlignmentJustified];
        [desc setTextColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
        NSString* string = @"位於繁華的灣仔區，現代化的24層商業中心，提供一系列專用頂級服務和設施，滿足不同的業務需求，獲得與來自頂尖繁盛行業的商界精英交流的機會。無論是享受美食、在歡樂時光放鬆心情、舉辦任何形式的商務會議、還是享受一天的工作和休閒的樂趣，KONNECT都能把您所渴望的生活方式融合於其中。";
        desc.attributedText = [[NSAttributedString alloc] initWithString:string
                                                                 attributes:attributtes];
        [desc sizeToFit];
        [desc setFont:[UIFont systemFontOfSize:FONT_S]];
        //[desc sizeToFit];
        [red addSubview:desc];
        
    }
    
    UIImageView *blue = [[UIImageView alloc] initWithFrame:CGRectMake(delegate.screenWidth,-STATUS_BAR_HEIGHT,delegate.screenWidth,delegate.screenHeight+STATUS_BAR_HEIGHT)];
    [blue setImage:[UIImage imageNamed:@"intro2.png"]];
    {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(left, 170,316,40)];
        [title setText:@"服務式辦公室"];
        [title setTextColor: UICOLOR_GOLD];
        [title setFont:[UIFont boldSystemFontOfSize:FONT_L]];
        [blue addSubview:title];
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(left, 210, 316, 300)];
        [desc setNumberOfLines:0];
        [desc setTextAlignment:NSTextAlignmentJustified];
        [desc setTextColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
        NSString *string = @"KONNECT位於香港最繁華的中心地帶，旨在實現最大舒適度和生產力，擁有設備齊全的服務式辦公室，是建立和經營不同業務的絕佳地點。";
        desc.attributedText = [[NSAttributedString alloc] initWithString:string
                                                              attributes:attributtes];
        [desc setFont:[UIFont systemFontOfSize:FONT_S]];
        [desc sizeToFit];
        [blue addSubview:desc];
        
    }
    
    UIImageView *green = [[UIImageView alloc] initWithFrame:CGRectMake(delegate.screenWidth*2,-STATUS_BAR_HEIGHT,delegate.screenWidth,delegate.screenHeight+STATUS_BAR_HEIGHT)];
    [green setImage:[UIImage imageNamed:@"intro3.png"]];;
    {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(left, 170,316,40)];
        [title setText:@"餐飲"];
        [title setTextColor: UICOLOR_GOLD];
        [title setFont:[UIFont boldSystemFontOfSize:FONT_L]];
        [green addSubview:title];
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(left, 210, 316, 300)];
        [desc setNumberOfLines:0];
        [desc setTextAlignment:NSTextAlignmentJustified];
        [desc setTextColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
        NSString *string =@"盡情享受我們尊貴會員餐廳的美食。在舒適和安靜的環境中，我們供應中西美食，享受商務、社交和家庭用饍的新熱點。";
        desc.attributedText = [[NSAttributedString alloc] initWithString:string
                                                              attributes:attributtes];
        [desc setFont:[UIFont systemFontOfSize:FONT_S]];
        [desc sizeToFit];
        [green addSubview:desc];
        
    }
    
    UIImageView *i4 = [[UIImageView alloc] initWithFrame:CGRectMake(delegate.screenWidth*3,-STATUS_BAR_HEIGHT,delegate.screenWidth,delegate.screenHeight+STATUS_BAR_HEIGHT)];
    [i4 setImage:[UIImage imageNamed:@"intro4.png"]];;
    {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(left, 170,316,40)];
        [title setText:@"活動空間"];
        [title setTextColor: UICOLOR_GOLD];
        [title setFont:[UIFont boldSystemFontOfSize:FONT_L]];
        [i4 addSubview:title];
        
        UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(left, 210, 316, 300)];
        [desc setNumberOfLines:0];
        [desc setTextAlignment:NSTextAlignmentJustified];
        [desc setTextColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
        NSString *string =@"為了滿足各行業的商業活動需求，所有活動空間以高度標準去設計和製作，從視聽設備、專業活動管理服務，至獨特靈活的場地構造，您將能透過活動把寶貴的經驗及訊息帶給您的尊貴來賓。";
        desc.attributedText = [[NSAttributedString alloc] initWithString:string
                                                              attributes:attributtes];
        [desc setFont:[UIFont systemFontOfSize:FONT_S]];
        [desc sizeToFit];
        [i4 addSubview:desc];
        
    }
    
    UIImageView *black = [[UIImageView alloc] initWithFrame:CGRectMake(delegate.screenWidth*4,-STATUS_BAR_HEIGHT,delegate.screenWidth,delegate.screenHeight+STATUS_BAR_HEIGHT)];
    [black setImage:[UIImage imageNamed:@"intro5.png"]];;
    {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(left, 170,316,40)];
        [title setText:@"Become a member！"];
        [title setTextColor: UICOLOR_GOLD];
        [title setFont:[UIFont boldSystemFontOfSize:FONT_L]];
        [black addSubview:title];
        
        UIImageView *aicon = [[UIImageView alloc] initWithFrame:CGRectMake(left,230,36,36)];
        [aicon setImage:[UIImage imageNamed:@"addricon"]];
        [black addSubview:aicon];
        
        UILabel *addr = [[UILabel alloc] initWithFrame:CGRectMake(left+50, 234, 266, 300)];
        [addr setNumberOfLines:-1];
        [addr setTextAlignment:NSTextAlignmentJustified];
        [addr setTextColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
        [addr setText:@"地址: 香港灣仔謝斐道303號"];
        [addr setFont:[UIFont systemFontOfSize:FONT_S]];
        [addr sizeToFit];
        [black addSubview:addr];
        
        
        
        UIImageView *picon = [[UIImageView alloc] initWithFrame:CGRectMake(left,290,36,36)];
        [picon setImage:[UIImage imageNamed:@"phoneicon.png"]];
        [black addSubview:picon];
        
        UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(left+50, 298, 266, 300)];
        [phone setNumberOfLines:-1];

        [phone setTextAlignment:NSTextAlignmentJustified];
        [phone setTextColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
        [phone setText:@"聯繫電話: (852) 2272-3456"];
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
    [indicators addSubview:[self createDot:CGRectMake(DOT_SIZE*4,0,DOT_SIZE,DOT_SIZE) withTag:4]];
    
    [scroll setContentSize:CGSizeMake(delegate.screenWidth*PAGES,1)];
    [scroll setDelegate:self];
    [scroll setPagingEnabled:YES];
     
    [scroll addSubview:red];
    [scroll addSubview:blue];
    [scroll addSubview:green];
    [scroll addSubview:i4];
    [scroll addSubview:black];
    [self.view addSubview:scroll];
    [self setDot:0];

    [self.view addSubview:indicators];
    
    login = [UIButton buttonWithType:UIButtonTypeCustom];
    [login setImage:[UIImage imageNamed:@"goldbutton.png"] forState:UIControlStateNormal];
    [login setFrame:CGRectMake(delegate.screenWidth/2-158, delegate.screenHeight-140, 316, 44)];
    [login addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *btnLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,login.frame.size.width, login.frame.size.height)];
    [btnLbl setText:TEXT_LOGIN_OR_REG];
    [btnLbl setTextColor:UICOLOR_DARK_GREY];
    [btnLbl setFont:[UIFont boldSystemFontOfSize:FONT_L]];
    [login addSubview:btnLbl];
    [btnLbl setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:login];
    
    UIButton *skip = [UIButton buttonWithType:UIButtonTypeCustom];
    [skip setTitle:TEXT_GO_HOMEPAGE forState:UIControlStateNormal];
    [skip setFrame:CGRectMake(delegate.screenWidth/2-158, delegate.screenHeight-90, 316, 44)];
    [skip setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
    [self.view addSubview:skip];
    [skip addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
    
    
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
-(void) skip {
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS object:nil];

}
-(void) login {
    [self.navigationController pushViewController:loginVC animated:NO];
    /*
    [self presentViewController:loginVC animated:YES completion:^{
        
    }];
     */
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
    } else if (targetContentOffset->x<(delegate.screenWidth*5)) {
        [self setDot:4];
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
