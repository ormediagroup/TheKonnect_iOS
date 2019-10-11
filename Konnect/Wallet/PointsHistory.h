//
//  PointsHistory.h
//  Konnect
//
//  Created by Jacky Mok on 8/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORTableViewController.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef enum {
    TYPE_POINTS =1,
    TYPE_TOPUP = 2
} TYPE;
@interface PointsHistory : ORTableViewController {
    TYPE type;
    UIDatePicker *datepicker;
    NSArray *dataSrc;
    NSString *startDate;
    NSString *endDate;
    NSString *income;
    NSString *expense;
    

    
}
@property TYPE type;
@end

NS_ASSUME_NONNULL_END
