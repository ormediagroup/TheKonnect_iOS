//
//  Company.m
//  Konnect
//
//  Created by Jacky Mok on 9/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "Company.h"
#import "AppDelegate.h"
@interface Company ()

@end

@implementation Company
@synthesize companyID;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:scroll];
}
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:@""];
    
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-service-office",K_API_ENDPOINT]
                                          param:[[NSDictionary alloc] initWithObjects:@[@"get-company",companyID]
                                                                              forKeys:@[@"action",@"companyID"]]
     
                                     interation:0 callback:^(NSDictionary *data) {
                                         if ([[data objectForKey:@"rc"] intValue]==0) {
                                             [self loadData:[data objectForKey:@"data"]];
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                         }
                                     }
     ];
                                         
}
-(void) loadData:(NSDictionary *)d {
    for (UIView *v in scroll.subviews) {
        [v removeFromSuperview];
    }
    
    
    int y = LINE_PAD;
    if ([[d objectForKey:@"logo"] isKindOfClass:[NSString class]] && ![[d objectForKey:@"logo"] isEqualToString:@""]) {
        UIImageView *l = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,80)];
        [l setContentMode:UIViewContentModeScaleAspectFit];
        [l setImage:[delegate getImage:[d objectForKey:@"logo"] callback:^(UIImage *image) {
            [l setImage:image];
        }]];
        [scroll addSubview:l];
        
    }
    y+=80+LINE_PAD;
    {
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [t setText:TEXT_COMPANY];
        [t setFont:[UIFont systemFontOfSize:FONT_S]];
        [t setTextColor:[UIColor lightGrayColor]];
        [t sizeToFit];
        [scroll addSubview:t];
        y+=t.frame.size.height;
        
        
        UILabel *n = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [n setText:[d objectForKey:@"company_zh"]];
        [n setFont:[UIFont systemFontOfSize:FONT_M]];
        [n setTextColor:[UIColor darkTextColor]];
        [n sizeToFit];
        [scroll addSubview:n];
        y+=n.frame.size.height;
        
        UILabel *e = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [e setText:[d objectForKey:@"company_en"]];
        [e setFont:[UIFont systemFontOfSize:FONT_M]];
        [e setTextColor:[UIColor darkTextColor]];
        [e sizeToFit];
        [scroll addSubview:e];
        y+=e.frame.size.height;
    }
    y+=LINE_PAD;
    {
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [t setText:TEXT_ADDRESS];
        [t setFont:[UIFont systemFontOfSize:FONT_S]];
        [t setTextColor:[UIColor lightGrayColor]];
        [t sizeToFit];
        [scroll addSubview:t];
        y+=t.frame.size.height;
        
        
        UILabel *n = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [n setText:[d objectForKey:@"address_zh"]];
        [n setFont:[UIFont systemFontOfSize:FONT_M]];
        [n setTextColor:[UIColor darkTextColor]];
        [n sizeToFit];
        [scroll addSubview:n];
        y+=n.frame.size.height;
        
        UILabel *e = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [e setText:[d objectForKey:@"address_en"]];
        [e setFont:[UIFont systemFontOfSize:FONT_M]];
        [e setTextColor:[UIColor darkTextColor]];
        [e sizeToFit];
        [scroll addSubview:e];
        y+=e.frame.size.height;
    }
    y+=LINE_PAD;
    {
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [t setText:TEXT_PHONE];
        [t setFont:[UIFont systemFontOfSize:FONT_S]];
        [t setTextColor:[UIColor lightGrayColor]];
        [t sizeToFit];
        [scroll addSubview:t];
        y+=t.frame.size.height;
        
        
        UILabel *n = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [n setText:[d objectForKey:@"phone_1"]];
        [n setFont:[UIFont systemFontOfSize:FONT_M]];
        [n setTextColor:[UIColor darkTextColor]];
        [n sizeToFit];
        [scroll addSubview:n];
        y+=n.frame.size.height;
        
        UILabel *e = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [e setText:[d objectForKey:@"phone_2"]];
        [e setFont:[UIFont systemFontOfSize:FONT_M]];
        [e setTextColor:[UIColor darkTextColor]];
        [e sizeToFit];
        [scroll addSubview:e];
        y+=e.frame.size.height;
    }
    y+=LINE_PAD;
    {
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [t setText:TEXT_WEBSITE];
        [t setFont:[UIFont systemFontOfSize:FONT_S]];
        [t setTextColor:[UIColor lightGrayColor]];
        [t sizeToFit];
        [scroll addSubview:t];
        y+=t.frame.size.height;
        
        
        UILabel *n = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [n setText:[d objectForKey:@"website"]];
        [n setFont:[UIFont systemFontOfSize:FONT_M]];
        [n setTextColor:[UIColor darkTextColor]];
        [n sizeToFit];
        [scroll addSubview:n];
        y+=n.frame.size.height;
    }
    y+=LINE_PAD;
    {
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [t setText:TEXT_EMAIL];
        [t setFont:[UIFont systemFontOfSize:FONT_S]];
        [t setTextColor:[UIColor lightGrayColor]];
        [t sizeToFit];
        [scroll addSubview:t];
        y+=t.frame.size.height;
        
        
        UILabel *n = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
        [n setText:[d objectForKey:@"email"]];
        [n setFont:[UIFont systemFontOfSize:FONT_M]];
        [n setTextColor:[UIColor darkTextColor]];
        [n sizeToFit];
        [scroll addSubview:n];
        y+=n.frame.size.height;
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
