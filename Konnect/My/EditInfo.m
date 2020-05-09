//
//  EditInfo.m
//  Konnect
//
//  Created by Jacky Mok on 4/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "EditInfo.h"
#import "AppDelegate.h"
#include <unicode/utf8.h>

@interface EditInfo ()

@end

@implementation EditInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    fields = @[@"帳戶（不可更改）",TEXT_NICKNAME,TEXT_GENDER,@"聯絡電郵",TEXT_BIRTHDAY];
    emailAlertController = [UIAlertController alertControllerWithTitle: @"請輸入你的電郵"
                                                                              message:@""
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [emailAlertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"稱呼";
        textField.textColor = [UIColor darkGrayColor];
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.delegate = self;
    }];
    [emailAlertController addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = self->emailAlertController.textFields;
        UITextField * namefield = textfields[0];
        [self->delegate.preferences setObject:namefield.text
                                       forKey:K_USER_EMAIL];
        self->edited = YES;
        [self->delegate.preferences synchronize];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0] ] withRowAnimation:UITableViewRowAnimationAutomatic];
       
    }]];
    [emailAlertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    
    
    pickerViewToolbar = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.screenHeight)];
    
    UIView *touchbg = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.screenHeight)];
    [touchbg setBackgroundColor:UICOLOR_ALPHA_BACKGROUND];
    [touchbg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeToolbar)]];
    [pickerViewToolbar addSubview:touchbg];
    
    
    CGFloat top = delegate.screenHeight-360;
    
    UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(0,top,delegate.screenWidth,50)];
    [toolbar setBackgroundColor:[UIColor whiteColor]];
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
    
    bday = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,top+60,delegate.screenWidth,300)];
    [bday setBackgroundColor:[UIColor whiteColor]];
    [bday setDatePickerMode:UIDatePickerModeDate];
    bday.tag = 1;
    [delegate setSystemBG:bday];
    [bday addTarget:self action:@selector(bdayselect:) forControlEvents:UIControlEventValueChanged];
    bdate = [delegate.preferences objectForKey:K_USER_BDAY];
    if (!bdate) {
        bdate=@"";
        [delegate.preferences setObject:@"" forKey:K_USER_BDAY];
        [delegate.preferences synchronize];
    }
}
-(void) bdayselect:(UIDatePicker *)p {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"yyyy-MM-dd";
    [pickerValue setText:[f stringFromDate:bday.date]];
}
-(void) removeToolbar {
    [pickerViewToolbar removeFromSuperview];
}
-(void) selectPickerValue {
    UIDatePicker *picker = [pickerViewToolbar viewWithTag:1];
    if (picker==bday) {
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        f.dateFormat = @"yyyy-MM-dd";
        bdate = [f stringFromDate:bday.date];
        [delegate.preferences setObject:bdate forKey:K_USER_BDAY];
        [delegate.preferences synchronize];
        self->edited = YES;
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    [pickerViewToolbar removeFromSuperview];
}
#pragma mark - Table view data source
-(void) viewWillAppear:(BOOL)animated {
    edited = NO;
    [super viewWillAppear:animated];
}
-(void) viewWillDisappear:(BOOL)animated {
    if (edited) {
        [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-reg-user",K_API_ENDPOINT] param:
                                        [[NSDictionary alloc] initWithObjects:@[
                                                                                @"update-user-info",
                                                                                [delegate.preferences objectForKey:K_USER_NAME],
                                                                                [delegate.preferences objectForKey:K_USER_GENDER],
                                                                                [delegate.preferences objectForKey:K_USER_EMAIL],[delegate.preferences objectForKey:K_USER_BDAY]
                                                                                ]
                                                                      forKeys:@[
                                                                                @"action",
                                                                                @"username",
                                                                                @"usergender",
                                                                                @"useremail",
                                                                                @"userbday"]]
         
                                         interation:0 callback:^(NSDictionary *data) {
                                   //          NSLog(@"%@",[delegate.preferences objectForKey:K_USER_NAME]);
                                         }];

    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LINE_HEIGHT+LINE_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"editinfo"];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.textLabel setText:[fields objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setTextColor:UICOLOR_DARK_GREY];
    [cell.detailTextLabel setTextColor:[UIColor darkTextColor]];
    [cell setBackgroundColor:[UIColor whiteColor]];
    // Configure the cell...
    
    if (indexPath.row ==0) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell.detailTextLabel setText:[delegate.preferences objectForKey:K_USER_PHONE]];
    } else if (indexPath.row==1) {
        [cell.detailTextLabel setText:[delegate.preferences objectForKey:K_USER_NAME]];
    } else if (indexPath.row==2) {
        [cell.detailTextLabel setText:[delegate.preferences objectForKey:K_USER_GENDER]];
    } else if (indexPath.row==3) {
        [cell.detailTextLabel setText:[delegate.preferences objectForKey:K_USER_EMAIL]];
    } else if (indexPath.row==4) {
        [cell.detailTextLabel setText:bdate];
    }
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==1) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"請輸入你的稱呼"
                                                                                  message:@""
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = TEXT_NICKNAME;
            textField.textColor = [UIColor darkGrayColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:TEXT_UPDATE style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSArray * textfields = alertController.textFields;
            UITextField * namefield = textfields[0];
            if ([namefield.text isEqualToString:@""]) {
                [self->delegate.preferences setObject:[self->delegate.preferences objectForKey:K_USER_PHONE]
                                         forKey:K_USER_NAME];
            } else {
               // NSLog(@"Edit Info: %@ %@",namefield.text, [self stringByRemovingEmoji:namefield.text]);
                [self->delegate.preferences setObject:[self stringByRemovingEmoji:namefield.text]
                                         forKey:K_USER_NAME];
            }
            self->edited = YES;
            [self->delegate.preferences synchronize];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:TEXT_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (indexPath.row==2) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"請選擇你的性別"
                                                                                  message:@""
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
           
            [self->delegate.preferences setObject:@"男" forKey:K_USER_GENDER];
            self->edited = YES;
            [self->delegate.preferences synchronize];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self->delegate.preferences setObject:@"女" forKey:K_USER_GENDER];
            self->edited = YES;
            [self->delegate.preferences synchronize];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"未提供" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self->delegate.preferences setObject:@"" forKey:K_USER_GENDER];
            self->edited = YES;
            [self->delegate.preferences synchronize];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:TEXT_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (indexPath.row==3) {
        [self presentViewController:emailAlertController animated:YES completion:nil];
        if ([emailAlertController.textFields[0].text isEqualToString:@""] || [self validateEmailWithString:emailAlertController.textFields[0].text]) {
            [emailAlertController.actions[0] setEnabled:YES];
        } else {
            [emailAlertController.actions[0] setEnabled:NO];
        }
    } else if (indexPath.row==4) {
        [pickerViewToolbar addSubview:bday];
        [pickerValue setText:bdate];        
        [self.view.window.rootViewController.view addSubview:pickerViewToolbar];
    }
}
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([searchStr isEqualToString:@""] || [self validateEmailWithString:searchStr]) {
        [emailAlertController.actions[0] setEnabled:YES];
    } else {
        [emailAlertController.actions[0] setEnabled:NO];
    }
    return true;
}
- (BOOL)validateEmailWithString:(NSString*)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
                                    
- (NSString *)stringByRemovingEmoji:(NSString *)text {
    NSData *d = [text dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    if(!d) return nil;
    const char *buf = d.bytes;
    unsigned int len = [d length];
    char *s = (char *)malloc(len);
    unsigned int ii = 0, oi = 0; // in index, out index
    UChar32 uc;
    while (ii < len) {
        U8_NEXT_UNSAFE(buf, ii, uc);
        if(0x2100 <= uc && uc <= 0x26ff) continue;
        if(0x1d000 <= uc && uc <= 0x1f77f) continue;
        U8_APPEND_UNSAFE(s, oi, uc);
    }
    return [[NSString alloc] initWithBytesNoCopy:s length:oi encoding:NSUTF8StringEncoding freeWhenDone:YES];
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

