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
    
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd (E)"];
    
    bookDate = [dateFormat stringFromDate:[NSDate date]];
    bookTimeHr = @"10";
    bookTimeMin = @"00";
    bookPeople = @"2";
    bookOthers = @"";
}
-(void) viewWillAppear:(BOOL)animated {
    [self setEditing:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_BOOK_RESTAURANT];
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
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } else if (picker==timepicker){
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    } else if (picker==peoplepicker){
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
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
    }
    
}

#pragma mark - Table view data source
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return delegate.headerHeight-delegate.statusBarHeight+200;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat y = delegate.headerHeight-delegate.statusBarHeight;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,delegate.headerHeight-delegate.statusBarHeight,delegate.screenWidth,delegate.headerHeight-delegate.statusBarHeight+200)];
    [v setBackgroundColor:UICOLOR_PURPLE];
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
    return 6;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==4) {
        return remarks.frame.size.height;
    } else if (indexPath.row==5) {
        return 90;
    } else {
        return UITableViewAutomaticDimension;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TEXT_BOOK_RESTAURANT];
    
    // Configure the cell...
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    if (indexPath.row==0) {
        [cell.textLabel setText:TEXT_BOOK_FB_DATE];
        [cell.detailTextLabel setText:bookDate];
    } else if (indexPath.row==1) {
        [cell.textLabel setText:TEXT_BOOK_FB_START_TIME];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@:%@",bookTimeHr,bookTimeMin]];
    } else if (indexPath.row==2) {
        [cell.textLabel setText:TEXT_BOOK_FB_NUMBER_PEOPLE];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@%@",bookPeople,TEXT_PEOPLE]];
    } else if (indexPath.row==3) {
        [cell.textLabel setText:TEXT_OTHER_MESSAGE];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else if (indexPath.row==4) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell addSubview:remarks];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    } else if (indexPath.row==5) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        UIView *l = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,40)];
        [l setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
        [cell addSubview:l];
        bookNow = [UIButton buttonWithType:UIButtonTypeCustom];
        [bookNow setBackgroundColor:UICOLOR_PURPLE];
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
                                                 self->bookDate,
                                                 [NSString stringWithFormat:@"%@:%@",self->bookTimeHr,self->bookTimeMin],
                                                 self->bookPeople,
                                                 self->remarks.text
                                                 ]
                                       forKeys:@[
                                                 @"action",
                                                 @"vendor_id",
                                                 @"bookingdate",
                                                 @"bookingtime",
                                                 @"bookingpeople",
                                                 @"remarks"
                                                 ]]
         
                                         interation:0 callback:^(NSDictionary *data) {
                                             //NSLog(@"Wallet %@",data);
                                             [self->delegate stopLoading];
                                             if ([[data objectForKey:@"rc"] intValue]==0) {
                                                 [self->delegate raiseAlert:TEXT_BOOK_FB_SUCCESS msg:[NSString stringWithFormat:@"%@ %@ %@:%@ %@%@",[self->facility objectForKey:@"name_zh"],self->bookDate, self->bookTimeHr, self->bookTimeMin, self->bookPeople, TEXT_PEOPLE]];
                                                 [remarks setText:@""];
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
    if (indexPath.row==0) {
        [pickerViewToolbar addSubview:datepicker];
        [pickerValue setText:bookDate];
        [self.view.window.rootViewController.view addSubview:pickerViewToolbar];
    } else if (indexPath.row==1) {
        [pickerViewToolbar addSubview:timepicker];
        [pickerValue setText:[NSString stringWithFormat:@"%@:%@",bookTimeHr,bookTimeMin]];
        [self.view.window.rootViewController.view addSubview:pickerViewToolbar];
    } else if (indexPath.row==2) {
        [pickerViewToolbar addSubview:peoplepicker];
        [pickerValue setText:[NSString stringWithFormat:@"%@%@",bookPeople,TEXT_PEOPLE]];
        [self.view.window.rootViewController.view addSubview:pickerViewToolbar];
    } else if (indexPath.row==3) {
        [remarks becomeFirstResponder];
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
