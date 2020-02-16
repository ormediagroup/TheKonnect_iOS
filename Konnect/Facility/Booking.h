//
//  Booking.h
//  Konnect
//
//  Created by Jacky Mok on 14/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Booking : ORTableViewController <UIPickerViewDelegate, UIPickerViewDataSource ,UITextViewDelegate> {
    NSDictionary *facility;
    NSArray *labels;
    NSString *bookDate;
    NSString *bookTimeHr, *bookTimeMin;
    NSString *bookPeople;
    NSString *bookOthers;
    NSString *bookRoom;
    NSString *bookAlcohol;
    UITextField *bookingName, *bookingPhone, *bookingPhone2;
    UIPickerView *datepicker,*timepicker,*peoplepicker, *roompicker, *alcoholpicker;
    NSDateFormatter *dateFormat;
    UIView *pickerViewToolbar;
    UILabel *pickerValue;
    UITextView *remarks;
    UIButton *bookNow;
    BOOL hasPrivateRoom, hasBringAlcohol;
}
@property NSDictionary *facility;
@end

NS_ASSUME_NONNULL_END
