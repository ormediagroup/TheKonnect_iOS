//
//  ConceirgeService.m
//  Konnect
//
//  Created by Jacky Mok on 25/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "ConceirgeService.h"
#import "AppDelegate.h"
#import "ORCarousel.h"
#define CONCEIRGE_CAROUSEL_HEIGHT 260
@interface ConceirgeService ()

@end

@implementation ConceirgeService
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_KONNECT_CONCERIGE];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    desc = @"";
    carousel = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,CONCEIRGE_CAROUSEL_HEIGHT)];
    oc = [[ORCarousel alloc] initWithNibName:nil bundle:nil withFrame:CGRectMake(0, 0, self->delegate.screenWidth, CONCEIRGE_CAROUSEL_HEIGHT)];
    [carousel addSubview:oc.view];
    
    
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
    
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-home",K_API_ENDPOINT]
                                          param:[[NSDictionary alloc] initWithObjects:@[@"get-conceirge"] forKeys:@[@"action"]]
                                     interation:0 callback:^(NSDictionary *data) {
        if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"rc"] intValue]==0) {
            if ([[data objectForKey:@"data"] isKindOfClass:[NSDictionary class]] &&
                [[[data objectForKey:@"data"] objectForKey:@"images"] isKindOfClass:[NSArray class]]
                ) {
                [self->oc pack:[[data objectForKey:@"data"] objectForKey:@"images"]];
                self->desc = [[data objectForKey:@"data"] objectForKey:@"post_content"];
                [self.tableView reloadData];
            }
        } else {
            [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:@""];
        }
    }];
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    } else if (section==1) {
        return 3;
    } else {
        return 5;
    }
    
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
                                                 @"Conceirge Service",
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
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return delegate.headerHeight-delegate.statusBarHeight;
    } else {
        return 0;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==2) {
        return delegate.footerHeight;
    }
    return 0;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.headerHeight-delegate.statusBarHeight)];
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,UITableViewAutomaticDimension)];
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return CONCEIRGE_CAROUSEL_HEIGHT;
    } else if (indexPath.section==1) {
        if (indexPath.row==0) {
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
            [l setNumberOfLines:-1];
            NSAttributedString *hS = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"<html><body style='font-size:%dpx;font-color:#333;font-family:Arial'>%@</body></html>",FONT_S,desc] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            [l setAttributedText:hS];
            [l sizeToFit];
            return l.frame.size.height+LINE_PAD+LINE_PAD;
        } else  if (indexPath.row==1 || indexPath.row==2){
             if ([[delegate.preferences objectForKey:K_USER_TIER]  isKindOfClass:[NSString class]] && ![[delegate.preferences objectForKey:K_USER_TIER] isEqualToString:TEXT_MEMBERTIER_MEMBER]) {
                 return UITableViewAutomaticDimension;
             } else {
                 return 0;
             }
        } else {
            return UITableViewAutomaticDimension;
        }
    } else {
        if (indexPath.row==3) {
            return 100;
        }
        return UITableViewAutomaticDimension;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:@"ServiceOffice"];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setTextColor:UICOLOR_DARK_GREY];
    [cell.detailTextLabel setTextColor:[UIColor darkTextColor]];
    if (indexPath.section==0) {
        [cell addSubview:carousel];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else if (indexPath.section==1) {
        if (indexPath.row==0) {
            UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,LINE_PAD,delegate.screenWidth-SIDE_PAD_2,LINE_HEIGHT)];
            [l setNumberOfLines:-1];
            NSAttributedString *hS = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"<html><body style='font-size:%dpx;font-color:#333;font-family:Arial'>%@</body></html>",FONT_S,desc] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            [l setAttributedText:hS];
            [l sizeToFit];
            [cell addSubview:l];
        } else if (indexPath.row==1) {
            if ([[delegate.preferences objectForKey:K_USER_TIER]  isKindOfClass:[NSString class]] && ![[delegate.preferences objectForKey:K_USER_TIER] isEqualToString:TEXT_MEMBERTIER_MEMBER]) {
                [cell.textLabel setText:TEXT_PHONE];
                [cell.detailTextLabel setText:TEXT_K_CON_PHONE];
            }
        } else if (indexPath.row==2) {
            if ([[delegate.preferences objectForKey:K_USER_TIER]  isKindOfClass:[NSString class]] && ![[delegate.preferences objectForKey:K_USER_TIER] isEqualToString:TEXT_MEMBERTIER_MEMBER]) {

                [cell.textLabel setText:TEXT_EMAIL];
                [cell.detailTextLabel setText:TEXT_K_CON_EMAIL];
            }
        }
    } else {
        if (indexPath.row==0) {
            [cell.textLabel setText:TEXT_BOOK_NAME];
            [cell addSubview:bookingName];
        } else if (indexPath.row==1) {
            [cell.textLabel setText:TEXT_BOOK_PHONE];
            [cell addSubview:bookingPhone];
        } else if (indexPath.row==2) {
            [cell.textLabel setText:TEXT_OTHER_MESSAGE];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } else if (indexPath.row==3) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell addSubview:remarks];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        } else if (indexPath.row==4) {
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
    return cell;
    
    
    // Configure the cell...
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1 && indexPath.row==1) {
        NSString *n = TEXT_K_CON_PHONE;
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
}

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
