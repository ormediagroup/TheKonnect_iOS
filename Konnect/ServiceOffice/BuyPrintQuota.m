//
//  BuyPrintQuota.m
//  Konnect
//
//  Created by Jacky Mok on 12/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "BuyPrintQuota.h"
#import "AppDelegate.h"
@implementation BuyPrintQuota
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_TOP_UP_PRINT];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    fields = @[@"1",@"5",@"20",@"50",@"100",@"300",@"500"];
    price = @[@"10",@"49",@"190",@"450",@"850",@"2250",@"4000"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return [fields count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:TEXT_TOP_UP_PRINT];
    if (indexPath.section==0) {
        [cell.textLabel setText:[NSString stringWithFormat:@"%@%@",[fields objectAtIndex:indexPath.row],TEXT_SHEET]];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@: %@",TEXT_POINTS, [price objectAtIndex:indexPath.row]]];
        
    }
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pay:[price objectAtIndex:indexPath.row] andSheet:[fields objectAtIndex:indexPath.row]];
}
-(void) pay:(NSString *) amount andSheet:(NSString *)sheets{
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-payment-token",K_API_ENDPOINT]
                                          param:[[NSDictionary alloc] initWithObjects:@[@"get-token"]
                                                                              forKeys:@[@"action"]]
     
                                     interation:0 callback:^(NSDictionary *data) {
                                         if ([[data objectForKey:@"rc"] intValue]==0) {
                                             //
                                             [[NSNotificationCenter defaultCenter] postNotificationName:RECEIVE_TRANSACTION_REQUEST object:[[NSDictionary alloc] initWithObjects:@[[data objectForKey:@"data"],amount,@"print",sheets] forKeys:@[PAYMENT_TOKEN,@"amount",@"vendorid",@"remarks"]]];
                                             
                                         } else if ([[data objectForKey:@"rc"] intValue]==2) {
                                             UIAlertController* alert = [UIAlertController alertControllerWithTitle:TEXT_TITLE_NO_PAYMENT_CODE
                                                                                                            message:TEXT_NO_PAYMENT_CODE
                                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                             
                                             UIAlertAction* setCodeAction = [UIAlertAction actionWithTitle:TEXT_SET_PAYMENT_CODE style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                 [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
                                                  [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_PAYMENT_CODE]] forKeys:@[@"type"]]];
                                             }];
                                             [alert addAction:setCodeAction];
                                             UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:TEXT_BACK style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                             }];
                                             [alert addAction:defaultAction];
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
                                             });
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                         }
                                     }];
}



@end
