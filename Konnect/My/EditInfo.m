//
//  EditInfo.m
//  Konnect
//
//  Created by Jacky Mok on 4/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "EditInfo.h"
#import "AppDelegate.h"
@interface EditInfo ()

@end

@implementation EditInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    fields = @[@"帳戶（不可更改）",@"如何稱呼你",@"性別",@"聯絡電郵"];
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
}

#pragma mark - Table view data source
-(void) viewWillAppear:(BOOL)animated {
    edited = NO;
}
-(void) viewWillDisappear:(BOOL)animated {
    if (edited) {
        [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-reg-user",K_API_ENDPOINT] param:
                                        [[NSDictionary alloc] initWithObjects:@[
                                                                                @"update-user-info",
                                                                                [delegate.preferences objectForKey:K_USER_NAME],
                                                                                [delegate.preferences objectForKey:K_USER_GENDER],
                                                                                [delegate.preferences objectForKey:K_USER_EMAIL]                                                                    
                                                                                ]
                                                                      forKeys:@[
                                                                                @"action",
                                                                                @"username",
                                                                                @"usergender",
                                                                                @"useremail"]]
         
                                         interation:0 callback:^(NSDictionary *data) {
                                             
                                         }];

    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 4;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LINE_HEIGHT+LINE_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"editinfo"];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.textLabel setText:[fields objectAtIndex:indexPath.row]];
    
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
    }
    
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==1) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"請輸入你的稱呼"
                                                                                  message:@""
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"稱呼";
            textField.textColor = [UIColor darkGrayColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSArray * textfields = alertController.textFields;
            UITextField * namefield = textfields[0];
            if ([namefield.text isEqualToString:@""]) {
                [self->delegate.preferences setObject:[self->delegate.preferences objectForKey:K_USER_PHONE]
                                         forKey:K_USER_NAME];
            } else {
                [self->delegate.preferences setObject:namefield.text
                                         forKey:K_USER_NAME];
            }
            self->edited = YES;
            [self->delegate.preferences synchronize];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
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
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (indexPath.row==3) {
        [self presentViewController:emailAlertController animated:YES completion:nil];
        if ([emailAlertController.textFields[0].text isEqualToString:@""] || [self validateEmailWithString:emailAlertController.textFields[0].text]) {
            [emailAlertController.actions[0] setEnabled:YES];
        } else {
            [emailAlertController.actions[0] setEnabled:NO];
        }
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

