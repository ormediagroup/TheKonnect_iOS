//
//  Booking.m
//  Konnect
//
//  Created by Jacky Mok on 14/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "Booking.h"
#import "AppDelegate.h"
@interface Booking ()

@end

@implementation Booking
@synthesize facility;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    pickerViewToolbar = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.screenHeight)];
    
    UIView *touchbg = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.screenHeight)];
    [touchbg setBackgroundColor:UICOLOR_ALPHA_BACKGROUND];
    [touchbg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeToolbar)]];
    [pickerViewToolbar addSubview:touchbg];
    

    CGFloat top = delegate.screenHeight-360;
    
    UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(0,top,delegate.screenWidth,50)];
    [toolbar setBackgroundColor:[UIColor whiteColor]];
    [pickerViewToolbar addSubview:toolbar];
    
    UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
    [done setFrame:CGRectMake(delegate.screenWidth-100,0,100,50)];
    [done setTitle:TEXT_DONE forState:UIControlStateNormal];
    [done setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
    [done addTarget:self action:@selector(selectPickerValue) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:done];
    
    pickerValue = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-100-SIDE_PAD,50)];
    [pickerValue setFont:[UIFont systemFontOfSize:FONT_M]];
    [toolbar addSubview:pickerValue];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,top+50,delegate.screenWidth,10)];
    [line setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
    [pickerViewToolbar  addSubview:line];
    
    remarks = [[UITextView alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD_2,100)];
    remarks.layer.borderColor = [UICOLOR_LIGHT_GREY CGColor];
    remarks.layer.borderWidth = 0.5f;
    remarks.layer.cornerRadius =5.0f;
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(donePressed)];
    [doneBarButton setTitle:TEXT_DONE];
    [doneBarButton setTintColor:UICOLOR_GOLD];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    remarks.inputAccessoryView = keyboardToolbar;
    remarks.delegate = self;
    
    
    datepicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,top+60,delegate.screenWidth,300)];
    [datepicker setBackgroundColor:[UIColor whiteColor]];
    datepicker.delegate = self;
    datepicker.dataSource = self;
    datepicker.tag = 1;
    
    timepicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,top+60,delegate.screenWidth,300)];
    [timepicker setBackgroundColor:[UIColor whiteColor]];
    timepicker.delegate = self;
    timepicker.dataSource = self;
    timepicker.tag = 1;
    
    peoplepicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,top+60,delegate.screenWidth,300)];
    [peoplepicker setBackgroundColor:[UIColor whiteColor]];
    peoplepicker.delegate = self;
    peoplepicker.dataSource = self;
    peoplepicker.tag = 1;
    
    roompicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,top+60,delegate.screenWidth,300)];
    [roompicker setBackgroundColor:[UIColor whiteColor]];
    roompicker.delegate = self;
    roompicker.dataSource = self;
    roompicker.tag = 1;
    
    alcoholpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,top+60,delegate.screenWidth,300)];
    [alcoholpicker setBackgroundColor:[UIColor whiteColor]];
    alcoholpicker.delegate = self;
    alcoholpicker.dataSource = self;
    alcoholpicker.tag = 1;
    
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd (E)"];
    
    bookDate = [dateFormat stringFromDate:[NSDate date]];
    bookTimeHr = @"10";
    bookTimeMin = @"00";
    bookPeople = @"2";
    bookOthers = @"";
    bookingName = [[UITextField alloc] initWithFrame:CGRectMake(130,00,delegate.screenWidth-SIDE_PAD_2-130,46)];
    [bookingName setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0,0,10,50)]];
    [bookingName setTextAlignment:NSTextAlignmentRight];
    [bookingName setLeftViewMode:UITextFieldViewModeAlways];
    [bookingName setText:[delegate.preferences objectForKey:K_USER_NAME]];    
    [bookingName setPlaceholder:TEXT_BOOK_NAME];
    [delegate addDoneToKeyboard:bookingName];
    bookingPhone = [[UITextField alloc] initWithFrame:CGRectMake(130,00,delegate.screenWidth-SIDE_PAD_2-130,46)];
    [bookingPhone setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0,0,10,50)]];
    [bookingPhone setTextAlignment:NSTextAlignmentRight];
    [bookingPhone setLeftViewMode:UITextFieldViewModeAlways];
    [delegate addDoneToKeyboard:bookingPhone];
    [bookingPhone setText:[delegate.preferences objectForKey:K_USER_PHONE]];
    [bookingPhone setKeyboardType:UIKeyboardTypePhonePad];
    [bookingPhone setPlaceholder:TEXT_BOOK_PHONE];
    bookRoom = TEXT_NO;
    bookAlcohol = TEXT_NO;
    
}
-(void) viewWillAppear:(BOOL)animated {
    [self setEditing:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_BOOK_RESTAURANT];
    if ([[facility objectForKey:@"ID"] intValue] ==10 || [[facility objectForKey:@"ID"] intValue] ==11) {
        hasPrivateRoom = YES;
        hasBringAlcohol = YES;
    } else if ([[facility objectForKey:@"ID"] intValue] ==12 || [[facility objectForKey:@"ID"] intValue] ==14) {
        hasPrivateRoom = NO;
        hasBringAlcohol = YES;
    } else {
        hasPrivateRoom = NO;
        hasBringAlcohol = NO;
        bookRoom = TEXT_NO;
        bookAlcohol = TEXT_NO;
    }
    [self.tableView reloadData];
}
-(void) viewWillDisappear:(BOOL)animated {
    [self setEditing:NO];
    
}
-(void) donePressed {
    [remarks resignFirstResponder];
    [self setEditing:NO];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    CGPoint pointInTable = [textView.superview convertPoint:textView.frame.origin toView:self.tableView];
    CGPoint contentOffset = self.tableView.contentOffset;
    
    contentOffset.y = (pointInTable.y - textView.inputAccessoryView.frame.size.height)-100;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setFrame:CGRectMake(0,-1*contentOffset.y,self->delegate.screenWidth,self->delegate.screenHeight+contentOffset.y)];
    }];
    
    
    return YES;
}


-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view setFrame:CGRectMake(0,0,self->delegate.screenWidth,self->delegate.screenHeight)];
    }];
    
    return YES;
}
-(void) removeToolbar {
    [pickerViewToolbar removeFromSuperview];
}
#pragma mark - Picker view data source
-(void) selectPickerValue {
    UIPickerView *picker = [pickerViewToolbar viewWithTag:1];
    if (picker==datepicker) {
        bookDate = pickerValue.text;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } else if (picker==timepicker){
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } else if (picker==peoplepicker){
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } else if (picker==roompicker){
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:7 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } else if (picker==alcoholpicker){
        if (hasPrivateRoom) {
            // both
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:8 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:9 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    [pickerViewToolbar removeFromSuperview];
}
-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView==datepicker) {
        NSDate *now = [NSDate date];
        NSDate *newdate = [now dateByAddingTimeInterval:row*24*60*60];
        return [dateFormat stringFromDate:newdate];
    } else if (pickerView == timepicker) {
        if (component==0) {
            return [NSString stringWithFormat:@"%02d",(int)row+9];
        } else {
            return [NSString stringWithFormat:@"%02d",(int)row*15];
        }
    } else if (pickerView==peoplepicker) {
        return [NSString stringWithFormat:@"%d",(int)row+1];
    } else if (pickerView == roompicker || pickerView == alcoholpicker) {
        if (row==0) {
            return TEXT_NO;
        } else {
            return TEXT_YES;
        }
    } else {
        return @"";
    }
}
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == timepicker) {
        return 2;
    } else {
        return 1;
    }
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView==datepicker) {
        return 30;
    } else if (pickerView == timepicker) {
        if (component==0) {
            return 12;
        } else {
            return 3;
        }
    } else if (pickerView == peoplepicker) {
        return 23;
    } else if (pickerView == roompicker || pickerView == alcoholpicker) {
        return 2;
    } else {
        return 0;
    }
}
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView==datepicker) {
        NSDate *now = [NSDate date];
        NSDate *newdate = [now dateByAddingTimeInterval:row*24*60*60];
        [pickerValue setText:[dateFormat stringFromDate:newdate]];
    } else if (pickerView == timepicker) {
        if (component==0) {
            bookTimeHr = [NSString stringWithFormat:@"%02d",(int)row+9];
        } else {
            bookTimeMin = [NSString stringWithFormat:@"%02d",(int)row*15];
        }
        [pickerValue setText:[NSString stringWithFormat:@"%@:%@",bookTimeHr,bookTimeMin]];
    } else if (pickerView==peoplepicker) {
        bookPeople = [NSString stringWithFormat:@"%d",(int)row+1];
        [pickerValue setText:[NSString stringWithFormat:@"%@%@",bookPeople,TEXT_PEOPLE]];
    } else if (pickerView==roompicker) {
        if (row==0) {
            bookRoom = TEXT_NO;
        } else {
            bookRoom = TEXT_YES;
        }
        [pickerValue setText:bookRoom];
    } else if (pickerView==alcoholpicker) {
        if (row==0) {
            bookAlcohol = TEXT_NO;
        } else {
            bookAlcohol = TEXT_YES;
        }
        [pickerValue setText:bookAlcohol];
    }
}

#pragma mark - Table view data source
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return delegate.headerHeight-delegate.statusBarHeight+200;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat y = delegate.headerHeight-delegate.statusBarHeight;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,delegate.headerHeight-delegate.statusBarHeight,delegate.screenWidth,delegate.headerHeight-delegate.statusBarHeight+200)];
    [v setBackgroundColor:[delegate getThemeColor]];
    [v setClipsToBounds:YES];
    
    UIView *whiteBadge = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD,y+SIDE_PAD,delegate.screenWidth-SIDE_PAD_2,v.frame.size.height)];
    whiteBadge.layer.cornerRadius =10.f;
    [whiteBadge setBackgroundColor:[UIColor whiteColor]];
    [v addSubview:whiteBadge];
    CGFloat contentHeight = whiteBadge.frame.size.height - SIDE_PAD_2-SIDE_PAD_2-SIDE_PAD_2;
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD,SIDE_PAD,contentHeight,contentHeight)];
    [logo setImage:[delegate getImage:[facility objectForKey:@"images"] callback:^(UIImage *image) {
        [logo setImage:image];
    }]];
    [logo setClipsToBounds:YES];
    [logo setContentMode:UIViewContentModeScaleAspectFill];
    [whiteBadge addSubview:logo];
    
    UILabel *name_zh = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                 SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                 SIDE_PAD,
                                                                 whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                 contentHeight
                                                                 )];
    [name_zh setText:[facility objectForKey:@"name_zh"]];
    [name_zh setFont:[UIFont systemFontOfSize:FONT_M]];
    [name_zh setTextColor:[UIColor darkTextColor]];    
    [name_zh setNumberOfLines:-1];
    [name_zh sizeToFit];
    [whiteBadge addSubview:name_zh];
    
    UILabel *name_en = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                 SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                 name_zh.frame.origin.y + name_zh.frame.size.height+4,
                                                                 whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                 contentHeight-(name_zh.frame.origin.y+name_zh.frame.size.height+4)
                                                                 )];
    [name_en setText:[facility objectForKey:@"name_en"]];
    [name_en setFont:[UIFont systemFontOfSize:FONT_M]];
    [name_en setTextColor:[UIColor darkTextColor]];
    [name_en setNumberOfLines:-1];
    [name_en sizeToFit];
    [whiteBadge addSubview:name_en];
    
    UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                 SIDE_PAD + logo.frame.origin.x + logo.frame.size.width,
                                                                 contentHeight,
                                                                 whiteBadge.frame.size.width-SIDE_PAD_2-(SIDE_PAD+logo.frame.origin.x + logo.frame.size.width),
                                                                 30
                                                                 )];
    [phone setText:[facility objectForKey:@"phone_1"]];
    [phone setFont:[UIFont systemFontOfSize:FONT_S]];
    [phone setTextColor:UICOLOR_GOLD];
    [phone setNumberOfLines:-1];
    [phone sizeToFit];
    [whiteBadge addSubview:phone];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,v.frame.size.height-20,delegate.screenWidth,20)];
    [line setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
    [v addSubview:line];
    
    
    return v;
    /*
    UIView *purple = [[UIView alloc] initWithFrame:CGRectMake(0,delegate.headerHeight-delegate.statusBarHeight,delegate.screenWidth,safeHeight)];
    
    [purple setClipsToBounds:YES];
    [v addSubview:purple];
    
    UIView *badge = [[UIView alloc] initWithFrame:CGRectMake(SIDE_PAD,10,delegate.screenWidth-SIDE_PAD_2,purple.frame.size.height)];
    [badge setBackgroundColor:[UIColor whiteColor]];
    badge.layer.cornerRadius = 5.0f;
    [purple addSubview:badge];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,v.frame.size.height-20,delegate.screenWidth,20)];
    [line setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
    [v addSubview:line];
    return v;*/
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return delegate.footerHeight;
}
-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.footerHeight)];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (hasPrivateRoom && hasBringAlcohol) {
        return 10;
    } else if (hasPrivateRoom || hasBringAlcohol) {
        return 9;
    } else {
        return 8;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // return 90 if
    // at 5 oif no both
    // at 6 if one of them
    // at 8 if both of them
    if (indexPath.row==6) {
        return remarks.frame.size.height;
    } else if (indexPath.row==5 && !hasPrivateRoom && !hasBringAlcohol) {
        return 90;
    } else if (indexPath.row==6 && (hasPrivateRoom || hasBringAlcohol)) {
        return 90;
    } else if (indexPath.row==7 && (hasPrivateRoom && hasBringAlcohol)) {
        return 90;
    } else {
        if (indexPath.row>=5) {
            return 90;
        }
        return UITableViewAutomaticDimension;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TEXT_BOOK_RESTAURANT];
    
    // Configure the cell...
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    if (indexPath.row==0) {
        [cell.textLabel setText:TEXT_BOOK_NAME];
        [cell addSubview:bookingName];
    } else if (indexPath.row==1) {
        [cell.textLabel setText:TEXT_BOOK_PHONE];
        [cell addSubview:bookingPhone];
    } else if (indexPath.row==2) {
        [cell.textLabel setText:TEXT_BOOK_FB_DATE];
        [cell.detailTextLabel setText:bookDate];
    } else if (indexPath.row==3) {
        [cell.textLabel setText:TEXT_BOOK_FB_START_TIME];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@:%@",bookTimeHr,bookTimeMin]];
    } else if (indexPath.row==4) {
        [cell.textLabel setText:TEXT_BOOK_FB_NUMBER_PEOPLE];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@%@",bookPeople,TEXT_PEOPLE]];
    } else if (indexPath.row==5) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.textLabel setText:TEXT_OTHER_MESSAGE];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else if (indexPath.row==6) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell addSubview:remarks];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    } else if (indexPath.row==7) {
        if (hasPrivateRoom ) {
            if ([[facility objectForKey:@"mincharge"]intValue]>0) {
                [cell.textLabel setText:[NSString stringWithFormat:TEXT_NEED_ROOM_MIN_PAY,[[facility objectForKey:@"mincharge"]intValue]]];
            } else {
                [cell.textLabel setText:TEXT_NEED_ROOM_NO_MIN_PAY];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.detailTextLabel setText:bookRoom];
        } else if (hasBringAlcohol) {
            [cell.textLabel setText:TEXT_BYOB];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.detailTextLabel setText:bookAlcohol];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            UIView *l = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,40)];
            [l setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
            [cell addSubview:l];
            bookNow = [UIButton buttonWithType:UIButtonTypeCustom];
            [bookNow setBackgroundColor:[delegate getThemeColor]];
            [bookNow setFrame:CGRectMake(0,20,delegate.screenWidth,50)];
            [bookNow addTarget:self action:@selector(book) forControlEvents:UIControlEventTouchUpInside];
            [bookNow setTitle:TEXT_BOOK_RESTAURANT forState:UIControlStateNormal];
            [bookNow setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
            [cell addSubview:bookNow];
        }
    } else if (indexPath.row==8) {
        if (hasPrivateRoom && hasBringAlcohol) {
            [cell.textLabel setText:TEXT_BYOB];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.detailTextLabel setText:bookAlcohol];
        } else {
            UIView *l = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,40)];
            [l setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
            [cell addSubview:l];
            bookNow = [UIButton buttonWithType:UIButtonTypeCustom];
            [bookNow setBackgroundColor:[delegate getThemeColor]];
            [bookNow setFrame:CGRectMake(0,20,delegate.screenWidth,50)];
            [bookNow addTarget:self action:@selector(book) forControlEvents:UIControlEventTouchUpInside];
            [bookNow setTitle:TEXT_BOOK_RESTAURANT_NOW forState:UIControlStateNormal];
            [bookNow setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
            [cell addSubview:bookNow];
        }
    } else {
        UIView *l = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,40)];
        [l setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
        [cell addSubview:l];
        bookNow = [UIButton buttonWithType:UIButtonTypeCustom];
        [bookNow setBackgroundColor:[delegate getThemeColor]];
        [bookNow setFrame:CGRectMake(0,20,delegate.screenWidth,50)];
        [bookNow addTarget:self action:@selector(book) forControlEvents:UIControlEventTouchUpInside];
        [bookNow setTitle:TEXT_BOOK_RESTAURANT forState:UIControlStateNormal];
        [bookNow setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
        [cell addSubview:bookNow];
    }
    
    // Configure the cell...
        
    return cell;
}
-(void) book {
    if ([bookingPhone.text isEqualToString:@""] ||[bookingName.text isEqualToString:@""]) {
        [delegate raiseAlert:TEXT_INPUT_ERROR msg:TEXT_ERROR_MISSING_INFO];
        return;
    }
    [self textViewShouldEndEditing:remarks];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:TEXT_BOOK_FB_CONFIRM
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:TEXT_BACK style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [alert addAction:[UIAlertAction actionWithTitle:TEXT_BOOK_RESTAURANT style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self->delegate startLoading];
        [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-booking",K_API_ENDPOINT] param:
         [[NSDictionary alloc] initWithObjects:@[
                                                 @"book",
                                                 [self->facility objectForKey:@"ID"],
                                                 self->bookingName.text,
                                                 self->bookingPhone.text,
                                                 self->bookDate,
                                                 [NSString stringWithFormat:@"%@:%@",self->bookTimeHr,self->bookTimeMin],
                                                 self->bookPeople,
                                                 self->remarks.text,
                                                 self->bookAlcohol,
                                                 self->bookRoom
                                                 ]
                                       forKeys:@[
                                                         @"action",
                                                         @"vendor_id",
                                                         @"bookingname",
                                                         @"bookingphone",
                                                         @"bookingdate",
                                                         @"bookingtime",
                                                         @"bookingpeople",
                                                         @"remarks",
                                                         @"bookingalcohol",
                                                         @"bookingroom"
                                                 ]]
         
                                         interation:0 callback:^(NSDictionary *data) {
                                             //NSLog(@"Wallet %@",data);
                                             if ([[data objectForKey:@"rc"] intValue]==0) {
                                                 [self->delegate raiseAlert:TEXT_BOOK_FB_SUCCESS msg:[NSString stringWithFormat:@"%@ %@ %@:%@ %@%@",[self->facility objectForKey:@"name_zh"],self->bookDate, self->bookTimeHr, self->bookTimeMin, self->bookPeople, TEXT_PEOPLE]];
                                                 [self->remarks setText:@""];
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:ON_BACK_PRESSED object:nil];
                                             } else {
                                                 [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                             }
                                         }];
        
        
        
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [datepicker removeFromSuperview];
    [timepicker removeFromSuperview];
    [peoplepicker removeFromSuperview];
    [alcoholpicker removeFromSuperview];
    [roompicker removeFromSuperview];
    if (indexPath.row==0) {
        [bookingName becomeFirstResponder];
    } else if (indexPath.row==1) {
        [bookingPhone becomeFirstResponder];
    } else if (indexPath.row==2) {
        [pickerViewToolbar addSubview:datepicker];
        [pickerValue setText:bookDate];
        [self.view.window.rootViewController.view addSubview:pickerViewToolbar];
    } else if (indexPath.row==3) {
        [pickerViewToolbar addSubview:timepicker];
        [pickerValue setText:[NSString stringWithFormat:@"%@:%@",bookTimeHr,bookTimeMin]];
        [self.view.window.rootViewController.view addSubview:pickerViewToolbar];
    } else if (indexPath.row==4) {
        [pickerViewToolbar addSubview:peoplepicker];
        [pickerValue setText:[NSString stringWithFormat:@"%@%@",bookPeople,TEXT_PEOPLE]];
        [self.view.window.rootViewController.view addSubview:pickerViewToolbar];
    } else if (indexPath.row==5) {
        [remarks becomeFirstResponder];
    } else if (indexPath.row==7 && hasPrivateRoom) {
        [pickerViewToolbar addSubview:roompicker];
        [pickerValue setText:bookRoom];
        [self.view.window.rootViewController.view addSubview:pickerViewToolbar];
    } else if (indexPath.row==7 && hasBringAlcohol) {
        [pickerViewToolbar addSubview:alcoholpicker];
        [pickerValue setText:bookAlcohol];
        [self.view.window.rootViewController.view addSubview:pickerViewToolbar];
    } else if (indexPath.row==8 && hasBringAlcohol && hasPrivateRoom) {
        [pickerViewToolbar addSubview:alcoholpicker];
        [pickerValue setText:bookAlcohol];
        [self.view.window.rootViewController.view addSubview:pickerViewToolbar];
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
