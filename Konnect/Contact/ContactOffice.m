//
//  ContactOffice.m
//  Konnect
//
//  Created by Jacky Mok on 25/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ContactOffice.h"
#import "AppDelegate.h"
@interface ContactOffice ()

@end

@implementation ContactOffice
@synthesize title, inquirytype;
- (void)viewDidLoad {
    [super viewDidLoad];
    title = TEXT_CS;
    
    
    bookingName = [[UITextField alloc] initWithFrame:CGRectMake(130,00,delegate.screenWidth-SIDE_PAD_2-130,46)];
    [bookingName setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0,0,10,50)]];
    [bookingName setTextAlignment:NSTextAlignmentRight];
    [bookingName setLeftViewMode:UITextFieldViewModeAlways];
    [bookingName setPlaceholder:TEXT_BOOK_NAME];
    if ([[delegate.preferences objectForKey:K_USER_NAME] isKindOfClass:[NSString class]] && ![[delegate.preferences objectForKey:K_USER_NAME] isEqualToString:@""]) {
        [bookingName setText:[delegate.preferences objectForKey:K_USER_NAME]];
    }
    [delegate addDoneToKeyboard:bookingName];
    bookingPhone = [[UITextField alloc] initWithFrame:CGRectMake(130,00,delegate.screenWidth-SIDE_PAD_2-130,46)];
    [bookingPhone setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0,0,10,50)]];
    [bookingPhone setTextAlignment:NSTextAlignmentRight];
    [bookingPhone setLeftViewMode:UITextFieldViewModeAlways];
    [delegate addDoneToKeyboard:bookingPhone];
    [bookingPhone setKeyboardType:UIKeyboardTypePhonePad];
    [bookingPhone setPlaceholder:TEXT_BOOK_PHONE];
    if ([[delegate.preferences objectForKey:K_USER_PHONE] isKindOfClass:[NSString class]] && ![[delegate.preferences objectForKey:K_USER_PHONE] isEqualToString:@""]) {
        [bookingPhone setText:[delegate.preferences objectForKey:K_USER_PHONE]];
    }
    
    
    pickerViewToolbar = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.screenHeight)];
    UIView *touchbg = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.screenHeight)];
    [touchbg setBackgroundColor:UICOLOR_ALPHA_BACKGROUND];
    [touchbg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeToolbar)]];
    [pickerViewToolbar addSubview:touchbg];
    
    
    CGFloat top = delegate.screenHeight-360;
    
    UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(0,top,delegate.screenWidth,50)];
    [delegate setSystemBG:toolbar];
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
    [remarks setBackgroundColor:[UIColor whiteColor]];
    [remarks setTextColor:[UIColor darkTextColor]];
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
    
    
    inquirypicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,top+60,delegate.screenWidth,300)];
    [inquirypicker setBackgroundColor:[UIColor whiteColor]];
    inquirypicker.delegate = self;
    inquirypicker.dataSource = self;
    [delegate setSystemBG:inquirypicker];
    inquirypicker.tag = 1;
    if ([inquirytype isEqualToString:@""]) {
        inquirytype = TEXT_INQUIRY_GENERAL;
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    if (picker==inquirypicker) {
        inquirytype = pickerValue.text;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    }
    [pickerViewToolbar removeFromSuperview];
}
-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView==inquirypicker) {
        if (row==0) { return TEXT_INQUIRY_GENERAL;}
        else if (row==1){ return TEXT_INQUIRY_RENT;}
        else if (row==2){ return TEXT_INQUIRY_TECH;}
        else if (row==3){ return TEXT_INQUIRY_AD;}
        else if (row==4){ return TEXT_INQUIRY_BIZ;}
        else if (row==5){ return TEXT_INQUIRY_SERVICE_OFFICE_SUPPORT;}
    }
    return @"";
}
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == inquirypicker) {
        return 1;
    }
    return 0;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView==inquirypicker) {
        return 6;
    }
    return 0;
}
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView==inquirypicker) {
        if (row==0) { inquirytype= TEXT_INQUIRY_GENERAL;}
        else if (row==1){  inquirytype= TEXT_INQUIRY_RENT;}
        else if (row==2){  inquirytype= TEXT_INQUIRY_TECH;}
        else if (row==3){  inquirytype= TEXT_INQUIRY_AD;}
        else if (row==4){  inquirytype= TEXT_INQUIRY_BIZ;}
        else if (row==5){ inquirytype=TEXT_INQUIRY_SERVICE_OFFICE_SUPPORT;}
    }
    [pickerValue setText:inquirytype];
    
}
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:title];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 4;
    } else {
        return 6;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return [super tableView:tableView heightForHeaderInSection:section];
    } else {
        return LINE_HEIGHT;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) return UITableViewAutomaticDimension;
    else return delegate.footerHeight;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1 && indexPath.row==4) {
        return 100;
    } else if (indexPath.section==1 && indexPath.row==5) {
        return 50;
    }
    return UITableViewAutomaticDimension;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return [super tableView:tableView viewForHeaderInSection:section];
    } else {
        UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,LINE_HEIGHT)];        
        [h setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
        return h;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TEXT_CS];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setTextColor:UICOLOR_DARK_GREY];
    [cell.detailTextLabel setTextColor:[UIColor darkTextColor]];
    if (indexPath.section ==0) {
        if (indexPath.row==0) {
            [cell.textLabel setText:TEXT_ADDRESS];
            [cell.detailTextLabel setText:TEXT_K_ADDRESS];
        } else if (indexPath.row==1) {
            [cell.textLabel setText:TEXT_OFFICE_CS_HOURS];
            [cell.detailTextLabel setText:TEXT_K_OFFICE_HOURS];
        } else if (indexPath.row==2) {
            [cell.textLabel setText:TEXT_PHONE];
            [cell.detailTextLabel setText:TEXT_K_OFFICE_PHONE];
        } else if (indexPath.row==3) {
            [cell.textLabel setText:TEXT_EMAIL];
            [cell.detailTextLabel setText:TEXT_K_OFFICE_EMAIL];
        }
    } else if (indexPath.section==1) {
        if (indexPath.row==0) {
            [cell.textLabel setText:TEXT_BOOK_NAME];
            [cell addSubview:bookingName];
        } else if (indexPath.row==1) {
            [cell.textLabel setText:TEXT_BOOK_PHONE];
            [cell addSubview:bookingPhone];
        } else if (indexPath.row==2) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell.textLabel setText:TEXT_INQUIRY_TYPE];
            [cell.detailTextLabel setText:inquirytype];
        } else if (indexPath.row==3) {
            [cell.textLabel setText:TEXT_OTHER_MESSAGE];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } else if (indexPath.row==4) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell addSubview:remarks];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        } else if (indexPath.row==5) {
            UIView *l = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,40)];
            [l setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
            [cell addSubview:l];
            UIButton *bookNow = [UIButton buttonWithType:UIButtonTypeCustom];
            [bookNow setBackgroundColor:[delegate getThemeColor]];
            [bookNow setFrame:CGRectMake(0,20,delegate.screenWidth,50)];
            [bookNow addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
            [bookNow setTitle:TEXT_SUBMIT forState:UIControlStateNormal];
            [bookNow setTitleColor:UICOLOR_GOLD forState:UIControlStateNormal];
            [cell addSubview:bookNow];
        }
    }
    // Configure the cell...
    
    return cell;
}
-(void) send {
    if ([bookingPhone.text isEqualToString:@""] ||[bookingName.text isEqualToString:@""]) {
        [delegate raiseAlert:TEXT_INPUT_ERROR msg:TEXT_ERROR_MISSING_INFO];
        return;
    }
    [self textViewShouldEndEditing:remarks];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:TEXT_INQUIRY_CONFIRM
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:TEXT_BACK style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [alert addAction:[UIAlertAction actionWithTitle:TEXT_SUBMIT style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self->delegate startLoading];
        [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-booking",K_API_ENDPOINT] param:
         [[NSDictionary alloc] initWithObjects:@[
                                                 @"inquiry",
                                                 self->bookingName.text,
                                                 self->bookingPhone.text,
                                                 self->inquirytype,
                                                 self->remarks.text
                                                 ]
                                       forKeys:@[
                                                 @"action",
                                                 @"bookingname",
                                                 @"bookingphone",
                                                 @"inquiry",
                                                 @"remarks"
                                                 ]]
         
                                         interation:0 callback:^(NSDictionary *data) {
                                             //NSLog(@"Wallet %@",data);
                                             if ([[data objectForKey:@"rc"] intValue]==0) {
                                                 [self->delegate raiseAlert:TEXT_INQUIRY_SUCCESS msg:@""];
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
    if (indexPath.section==0) {
        if (indexPath.row==1) {
            NSString *n = TEXT_K_PHONE;
            NSString *phNo = [n stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
            if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                [[UIApplication sharedApplication] openURL:phoneUrl options:@{} completionHandler:^(BOOL success) {}];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TEXT_ERROR_NO_PHONE message:@"" delegate:nil cancelButtonTitle:TEXT_BACK otherButtonTitles: nil];
                [alert show];
                return;
            }
        }
    } else if (indexPath.section==1){
        if (indexPath.row==2) {
            [pickerViewToolbar addSubview:inquirypicker];
            [pickerValue setText:inquirytype];
            [self.view.window.rootViewController.view addSubview:pickerViewToolbar];
        } else  if (indexPath.row==3) {
            [remarks becomeFirstResponder];
        }
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

@end

