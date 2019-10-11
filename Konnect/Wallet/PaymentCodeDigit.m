//
//  PaymentCodeDigit.m
//  Konnect
//
//  Created by Jacky Mok on 10/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "PaymentCodeDigit.h"
#import "const.h"
@implementation PaymentCodeDigit

-(id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setFont:[UIFont boldSystemFontOfSize:(FONT_XL+10)]];
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setTextColor:[UIColor darkTextColor]];        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-20,self.frame.size.width,1)];
        [line setBackgroundColor:[UIColor darkTextColor]];
        [self addSubview:line];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
    // Drawing code
  /*  UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-1,self.frame.size.width,1)];
    [line setBackgroundColor:[UIColor darkTextColor]];
    [self addSubview:line];
   */
//}


@end
