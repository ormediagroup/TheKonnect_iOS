//
//  Invoice
//  Konnect
//
//  Created by Jacky Mok on 8/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "Invoice.h"
#import "AppDelegate.h"
#import "const.h"
@interface Invoice ()

@end

@implementation Invoice
@synthesize invoiceID;
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:[NSString stringWithFormat:@"%@: %@",TEXT_INVOICE, @"" ]];
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-service-office",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[
                                             @"get-invoice",
                                             invoiceID
                                             ]
                                   forKeys:@[
                                             @"action",
                                             @"invoiceID"
                                             ]]
     
                                     interation:0 callback:^(NSDictionary *data) {
                                         //NSLog(@"Wallet %@",data);
                                         if ([[data objectForKey:@"rc"] intValue]==0) {
                                             self->datasrc = [data objectForKey:@"data"];
                                             [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:[NSString stringWithFormat:@"%@: %@",TEXT_INVOICE, [self->datasrc objectForKey:@"invoice_no"] ]];
                                             [self.tableView reloadData];
                                         } else if ([[data objectForKey:@"rc"] intValue]==0) {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                             [[NSNotificationCenter defaultCenter] postNotificationName:ON_BACK_PRESSED object:nil];
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                         }
                                     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    fields = @[TEXT_INVOICE_NO,TEXT_INVOICE_DATE,TEXT_INVOICE_AMOUNT,TEXT_INVOICE_STATUS];
    map = @[@"invoice_no",@"invoice_date",@"amount",@"status"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return [fields count]+1;
    } else {
        if (![[datasrc objectForKey:@"details"] isKindOfClass:[NSArray class]]) {
            return 0;
        }
        return [[datasrc objectForKey:@"details"] count];
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==[fields count]){
            if ([[datasrc objectForKey:@"status"] isEqualToString:TEXT_INVOICE_TYPE_PENDING]) {
                return 60;
            }
        }
    }
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:TEXT_INVOICE];
    if (indexPath.section==0) {
        if (indexPath.row==[fields count]){
            if ([[datasrc objectForKey:@"status"] isEqualToString:TEXT_INVOICE_TYPE_PENDING]) {
                UIButton *payment = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [payment setTitle:TEXT_PAY forState:UIControlStateNormal];
                [payment setFrame:CGRectMake(0,0,delegate.screenWidth,60)];
                [cell addSubview:payment];
            } else {
                [cell.textLabel setText:TEXT_INVOICE_SETTLE_DATE];
                [cell.detailTextLabel setText:[datasrc objectForKey:@"settlement_date"]];
            }
        } else {
            [cell.textLabel setText:[fields objectAtIndex:indexPath.row]];
            [cell.detailTextLabel setText:[datasrc objectForKey:[map objectAtIndex:indexPath.row]]];
        }
    } else if (indexPath.section==1) {
        /* TODO: Create per item details */
    }
    
    return cell;
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
