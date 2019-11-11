//
//  ContactUs.h
//  Konnect
//
//  Created by Jacky Mok on 8/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORTableViewController.h"
#import "AppDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface ContactUs : ORTableViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate>{
    NSString *title;
    UIPickerView *inquirypicker;
    NSString *inquirytype;
    UIView *pickerViewToolbar;
    UITextField *bookingName, *bookingPhone;
    UILabel *pickerValue;
    UITextView *remarks;
}
@property NSString *title;
@property NSString *inquirytype;
@end

NS_ASSUME_NONNULL_END
