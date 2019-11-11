//
//  SearchMeetingRoom.h
//  Konnect
//
//  Created by Jacky Mok on 9/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ORTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    ROOM_STATUS_TYPE_AVAIL = 1,
    ROOM_STATUS_TYPE_PARTIAL = 2,
    ROOM_STATUS_TYPE_NONE = 3
} ROOM_STATUS_TYPE;
@interface SearchMeetingRoom : ORTableViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
    NSArray *datasrc;
    NSString *bookDate;
    NSString *bookStartTimeHr,*bookStartTimeMin,*bookEndTimeHr,*bookEndTimeMin ;
    CGFloat startTime, endTime;
    UIPickerView *datepicker,*starttimepicker,*endtimepicker;
    NSDateFormatter *dateFormat;
    UIView *pickerViewToolbar;
    UILabel *pickerValue;
    ROOM_STATUS_TYPE status;
    NSArray *bookedrooms;
}

@end

NS_ASSUME_NONNULL_END
