//
//  Wallet.m
//  Konnect
//
//  Created by Jacky Mok on 6/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "Wallet.h"
#import "AppDelegate.h"
#import "PaymentQR.h"
@interface Wallet ()

@end

@implementation Wallet

- (void)viewDidLoad {
    [super viewDidLoad];
    dataSrc = @[TEXT_COUPON,TEXT_INVOICE];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorStyle= UITableViewCellSeparatorStyleSingleLine;
    
}

#pragma mark - Table view data source
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_MY_WALLET];
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-transaction",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[
                                             @"get-balance"
                                             ]
                                   forKeys:@[
                                             @"action"
                                            ]]
     
                                     interation:0 callback:^(NSDictionary *data) {
                                         //NSLog(@"Wallet %@",data);
                                         if ([[data objectForKey:@"rc"] intValue]==0) {
                                             self->balance = [[data objectForKey:@"balance"] floatValue];
                                             [self.tableView reloadData];
                                              [super viewWillAppear:animated];
                                         } else if ([[data objectForKey:@"rc"] intValue]==1) {
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                         }
                                     }];
   
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSrc count];
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 250;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,250)];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,170)];
    [bg setBackgroundColor:[delegate getThemeColor]];
    
    UIImageView *gold = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD,20,delegate.screenWidth-SIDE_PAD_2,150)];
    [gold setImage:[UIImage imageNamed:@"300goldbg.png"]];
    [gold setClipsToBounds:YES];
    [gold setContentMode:UIViewContentModeScaleAspectFill];
    [bg addSubview:gold];
    [gold setUserInteractionEnabled:YES];
    [v addSubview:bg];
    
    
    UILabel *pttitle = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,46,gold.frame.size.width-SIDE_PAD_2,14)];
    [pttitle setFont:[UIFont systemFontOfSize:FONT_M]];
    [pttitle setTextColor:[UIColor whiteColor]];
    [pttitle setText:TEXT_MY_POINTS];
    [pttitle setTextAlignment:NSTextAlignmentLeft];
    [gold addSubview:pttitle];
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    
    UILabel *points = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,50,gold.frame.size.width-SIDE_PAD_2,100)];
    [points setFont:[UIFont boldSystemFontOfSize:46]];
    [points setTextColor:[UIColor whiteColor]];
    [points setTextAlignment:NSTextAlignmentLeft];
    [points setText:[numberFormatter stringFromNumber:[NSNumber numberWithFloat:balance]]];
    [gold addSubview:points];
    /*
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b setFrame:CGRectMake(gold.frame.size.width-SIDE_PAD-90,85,90,30)];
    [b setTitle:TEXT_TOP_UP_POINTS forState:UIControlStateNormal];
    [b.titleLabel setFont:[UIFont systemFontOfSize:FONT_S]];
    [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    b.layer.borderWidth=2.0f;
    [b addTarget:self action:@selector(topup) forControlEvents:UIControlEventTouchUpInside];
    [b.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [b.layer setCornerRadius:3.0f];
    [gold addSubview:b];
     */
    {
        UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [b1 setFrame:CGRectMake(0,v.frame.size.height-80,delegate.screenWidth/2,60)];
        [b1 setBackgroundColor:[UIColor whiteColor]];
        [b1 addTarget:self action:@selector(genQR) forControlEvents:UIControlEventTouchUpInside];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(b1.frame.size.width/2-10,0,gold.frame.size.width/2,b1.frame.size.height)];
        [title setFont:[UIFont systemFontOfSize:FONT_S]];
        [title setTextColor:[UIColor darkTextColor]];
        [title setTextAlignment:NSTextAlignmentLeft];
        [title setText:@"積分付款"];
        [b1 addSubview:title];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(title.frame.origin.x-40,15,30,30)];
        [icon setContentMode:UIViewContentModeScaleAspectFit];
        [icon setImage:[UIImage imageNamed:@"barcode.png"]];
        [b1 addSubview:icon];
        [v addSubview:b1];
        
    }
    {
        UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [b1 setFrame:CGRectMake(delegate.screenWidth/2,v.frame.size.height-80,delegate.screenWidth/2,60)];
        [b1 setBackgroundColor:[UIColor whiteColor]];
        [b1 addTarget:self action:@selector(goPointsHistory) forControlEvents:UIControlEventTouchUpInside];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(b1.frame.size.width/2-10,0,gold.frame.size.width/2,b1.frame.size.height)];
        [title setFont:[UIFont systemFontOfSize:FONT_S]];
        [title setTextColor:[UIColor darkTextColor]];
        [title setTextAlignment:NSTextAlignmentLeft];
        [title setText:@"積分記錄"];
        [b1 addSubview:title];
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(title.frame.origin.x-40,15,30,30)];
        [icon setContentMode:UIViewContentModeScaleAspectFit];
        [icon setImage:[UIImage imageNamed:@"dollaricon.png"]];
        [b1 addSubview:icon];
        [v addSubview:b1];
        
    }
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0,v.frame.size.height-20,delegate.screenWidth,20)];
    [line setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
    [v addSubview:line];
    return v;
}
-(void) genQR {
    PaymentQR *p = [[PaymentQR alloc] initWithNibName:nil bundle:nil];
    [self.view.window.rootViewController presentViewController:p animated:YES completion:^{
        
    }];
}
-(void) topup {
    
    return;
    /*
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_TOP_UP]] forKeys:@[@"type"]]];
     */
}
-(void) goPointsHistory {
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_POINT_HISTORY]] forKeys:@[@"type"]]];
}
    
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"wallet"];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setTextColor:[UIColor darkTextColor]];
    [cell.textLabel setText:[dataSrc objectAtIndex:indexPath.row]];
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_COUPON]] forKeys:@[@"type"]]];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_INVOICES],TEXT_INVOICE_TYPE_PENDING] forKeys:@[@"type",@"status"]]];
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
