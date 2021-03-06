//
//  Invoices.m
//  Konnect
//
//  Created by Jacky Mok on 8/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "Invoices.h"
#import "AppDelegate.h"
#import "const.h"
@interface Invoices ()

@end

@implementation Invoices
@synthesize invoicetype;
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_INVOICE];
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-service-office",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[
                                             @"get-invoices",
                                             invoicetype
                                             ]
                                   forKeys:@[
                                             @"action",
                                             @"status"
                                             ]]
     
                                     interation:0 callback:^(NSDictionary *data) {
                                         //NSLog(@"Wallet %@",data);
                                         if ([[data objectForKey:@"rc"] intValue]==0) {
                                             self->datasrc = data;
                                             self->invoices = [data objectForKey:@"data"];
                                             self->invIDs = [data objectForKey:@"invoiceIDs"];
                                             [self.tableView reloadData];
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                         }
                                     }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    invoicetype = TEXT_INVOICE_TYPE_PENDING;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    } else if (section==1 || section==3){
        return 1;
    } else if (section==2) {
        return MAX(1,[invoices count]);
    } else if (section==3) {
        return 1;
    }
    return 0;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        if ([[datasrc objectForKey:@"pendingamount"] floatValue]>0) {
            [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-payment-token",K_API_ENDPOINT]
                                              param:[[NSDictionary alloc] initWithObjects:@[@"get-token"]
                                                                                  forKeys:@[@"action"]]
         
                                         interation:0 callback:^(NSDictionary *data) {
                                             if ([[data objectForKey:@"rc"] intValue]==0) {
                                                 //
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVE_TRANSACTION_REQUEST object:[[NSDictionary alloc] initWithObjects:@[[data objectForKey:@"data"],[self->datasrc objectForKey:@"pendingamount"],@"current",self->invIDs] forKeys:@[PAYMENT_TOKEN,@"amount",@"vendorid",@"remarks"]]];
                                                 
                                             } else if ([[data objectForKey:@"rc"] intValue]==2) {
                                                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:TEXT_TITLE_NO_PAYMENT_CODE
                                                                                                                message:TEXT_NO_PAYMENT_CODE
                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                 
                                                 UIAlertAction* setCodeAction = [UIAlertAction actionWithTitle:TEXT_SET_PAYMENT_CODE style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
                                                      [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_PAYMENT_CODE]] forKeys:@[@"type"]]];
                                                     [self dismissViewControllerAnimated:YES
                                                                              completion:^{}];
                                                 }];
                                                 [alert addAction:setCodeAction];
                                                 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:TEXT_BACK style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                     [self dismissViewControllerAnimated:YES
                                                                              completion:^{
                                                                              }];
                                                 }];
                                                 [alert addAction:defaultAction];
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     [self presentViewController:alert animated:YES completion:nil];
                                                 });
                                             } else {
                                                 [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                             }
                                         }];
        }
    } else if (indexPath.section==3) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_PAST_INVOICES]] forKeys:@[@"type"]]];
    } else if (indexPath.section==2) {
        if ([invoices count] > indexPath.row) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_INVOICE],[[invoices objectAtIndex:indexPath.row] objectForKey:@"ID"]] forKeys:@[@"type",@"invoiceID"]]];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:TEXT_INVOICE];
    // Configure the cell...
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setTextColor:UICOLOR_DARK_GREY];
    [cell.detailTextLabel setTextColor:[UIColor darkTextColor]];
    if (indexPath.section==1) {
        [cell.textLabel setText:TEXT_INVOICE_TOTAL_PENDING];
        if ([[datasrc objectForKey:@"pendingamount"] floatValue]>0) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"$%@ (%@)",[datasrc objectForKey:@"pendingamount"],TEXT_PAY_NOW]];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"$%@",[datasrc objectForKey:@"pendingamount"]]];
        }
    } else if (indexPath.section==2) {
        if ([invoices count]==0) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.textLabel setText:TEXT_NO_PENDING_INVOICE];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell.textLabel setText:[[invoices objectAtIndex:indexPath.row] objectForKey:@"invoice_no"]];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"$%@",[[invoices objectAtIndex:indexPath.row] objectForKey:@"amount"]]];
        }
    } else if (indexPath.section==3) {
        [cell.textLabel setText:TEXT_BROWSE_PAST_INVOICE];
    }
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return delegate.headerHeight-delegate.statusBarHeight;
    } else if (section==1) {
        return LINE_HEIGHT;
    } else if (section==2) {
        return LINE_HEIGHT;
    } else if (section==3) {
        return LINE_HEIGHT;
    } else {
        return 0;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==3) {
        return delegate.footerHeight;
    }
    return 0;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.headerHeight-delegate.statusBarHeight)];
    } else if (section==1|| section==2){
        UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,LINE_HEIGHT)];
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD,LINE_HEIGHT)];
        [v setFont:[UIFont boldSystemFontOfSize:FONT_XS]];
        [v setTextColor:[UIColor lightGrayColor]];
        if (section==1) {
            [v setText:TEXT_SHOULD_PAY];
        } else if (section==2) {
            [v setText:TEXT_INVOICE];
        }
        [h addSubview:v];
        return h;
    } else if (section==3) {
        UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,LINE_PAD)];
        [h setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
        return h;
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,LINE_PAD)];
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
