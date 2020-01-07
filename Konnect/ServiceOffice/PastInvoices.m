//
//  PastInvoices.m
//  Konnect
//
//  Created by Jacky Mok on 8/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "PastInvoices.h"
#import "AppDelegate.h"
#import "const.h"
@interface PastInvoices ()

@end

@implementation PastInvoices
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_PAST_INVOICE];
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-service-office",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[
                                             @"get-invoices",
                                             TEXT_INVOICE_TYPE_PAID
                                             ]
                                   forKeys:@[
                                             @"action",
                                             @"status"
                                             ]]
     
                                     interation:0 callback:^(NSDictionary *data) {
                                         //NSLog(@"Wallet %@",data);
                                         if ([[data objectForKey:@"rc"] intValue]==0) {
                                             self->datasrc = [data objectForKey:@"data"];
                                             [self.tableView reloadData];
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                         }
                                     }];
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return delegate.headerHeight-delegate.statusBarHeight;
    } else if (section==1) {
        return 50;
    }
    return 0;
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==1) {
        return delegate.footerHeight;
    }
    return 0;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.headerHeight-delegate.statusBarHeight)];
    } else if (section==1) {
        UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,30)];
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,LINE_PAD,delegate.screenWidth-SIDE_PAD,30)];
        [v setFont:[UIFont boldSystemFontOfSize:FONT_XS]];
        [v setTextColor:[UIColor lightGrayColor]];
        [v setText:TEXT_ONLY_SHOW_PAST_6_MONTHS_BILL];
        [h addSubview:v];
        return h;
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,UITableViewAutomaticDimension)];
    }
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_INVOICE],[[datasrc objectAtIndex:indexPath.row] objectForKey:@"ID"]] forKeys:@[@"type",@"invoiceID"]]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    if (section==0) return 0;
    return MAX([datasrc count],1);
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:TEXT_INVOICE];
    [cell setBackgroundColor:[UIColor whiteColor]];
    if ([datasrc count]==0) {
        [cell.textLabel setText:TEXT_NO_INVOICE];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UILabel *inv = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD_2,40)];
        [inv setFont:[UIFont systemFontOfSize:FONT_L]];
        [inv setTextColor:[UIColor darkTextColor]];
        [inv setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"invoice_no"]];
        [cell addSubview:inv];
      
        UILabel *amt = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,00,delegate.screenWidth-SIDE_PAD_2-50,40)];
        [amt setFont:[UIFont systemFontOfSize:FONT_L]];
        [amt setTextAlignment:NSTextAlignmentRight];
        [amt setText:[NSString stringWithFormat:@"$%@",[[datasrc objectAtIndex:indexPath.row] objectForKey:@"amount"]]];
        [amt setTextColor:[UIColor darkTextColor]];
        [cell addSubview:amt];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,40,delegate.screenWidth-SIDE_PAD_2,16)];
        [l setFont:[UIFont systemFontOfSize:FONT_XS]];
        [l setText:[NSString stringWithFormat:@"%@: %@ [%@ %@ %@]",
                    TEXT_INVOICE_DATE,
                    [[datasrc objectAtIndex:indexPath.row] objectForKey:@"invoice_date"],
                    TEXT_ALREADY,
                    [[datasrc objectAtIndex:indexPath.row] objectForKey:@"settlement_date"],
                    TEXT_PAY
                    ]];
        [l setTextColor:[UIColor darkTextColor]];
        [cell addSubview:l];
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
