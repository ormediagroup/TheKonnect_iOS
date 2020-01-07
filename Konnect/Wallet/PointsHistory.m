//
//  PointsHistory.m
//  Konnect
//
//  Created by Jacky Mok on 8/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "PointsHistory.h"
#import "AppDelegate.h"
@interface PointsHistory ()

@end

@implementation PointsHistory
@synthesize type;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *now = [NSDate date];
    
    startDate = [dateFormat stringFromDate:[now dateByAddingTimeInterval:-30*24*60*60]];
    endDate = [dateFormat stringFromDate:now];
    income = @"0.00";
    expense = @"0.00";
    
    datepicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,delegate.screenHeight-300,delegate.screenWidth,300)];
    [datepicker setBackgroundColor:[UIColor whiteColor]];
    datepicker.datePickerMode = UIDatePickerModeDate;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:10];
    [comps setYear:2019];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    [datepicker setMaximumDate:[NSDate date]];
    [datepicker setMinimumDate:date];    
    [datepicker addTarget:self action:@selector(selectedDate:) forControlEvents:UIControlEventValueChanged];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void) changeDate:(UIButton *)b{
    datepicker.tag = b.tag;
    [self.view addSubview:datepicker];
    
        
}
-(void) selectedDate:(UIDatePicker*) p {
    [p removeFromSuperview];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    if (p.tag==0) {
        startDate = [dateFormat stringFromDate:p.date];
    } else {
        endDate = [dateFormat stringFromDate:p.date];
    }
    [self reloadTransaction];
}
-(void) reloadTransaction {
    NSString *stype = @"";
    if (self.type==TYPE_TOPUP) {
        stype = @"income";
    }
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-transaction",K_API_ENDPOINT]
                                          param:[[NSDictionary alloc] initWithObjects:@[@"get-transaction",startDate,endDate,stype]
                                                                              forKeys:@[@"action",@"startDate",@"endDate",@"type"]]
     
     
     
                                     interation:0 callback:^(NSDictionary *data) {
                                         if ([[data objectForKey:@"rc"] intValue]==0) {
                                             self->dataSrc = [data objectForKey:@"data"];
                                             self->income = [data objectForKey:@"income"];
                                             self->expense = [data objectForKey:@"expense"];
                                             [self.tableView reloadData];
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                         }
                                     }];
}
#pragma mark - Table view data source
-(void) viewWillAppear:(BOOL)animated {
    if (type==TYPE_POINTS) {
        [[NSNotificationCenter defaultCenter]postNotificationName:CHANGE_TITLE object:@"積分記錄"];
        [self reloadTransaction];
    } else {
        [[NSNotificationCenter defaultCenter]postNotificationName:CHANGE_TITLE object:@"充值記錄"];
    }
    [super viewWillAppear:animated];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        if (type==TYPE_POINTS) {
            return 2;
        } else {
            return 1;
        }
    } else {
        return [dataSrc count];
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return delegate.headerHeight-delegate.statusBarHeight+80;
    } else {
        return LINE_PAD;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    if (section==0) {
        [v setFrame:CGRectMake(0,0, delegate.screenWidth, delegate.headerHeight-delegate.statusBarHeight+80)];
        [v setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
        UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [b1 setFrame:CGRectMake(0,delegate.headerHeight-delegate.statusBarHeight,delegate.screenWidth/2,60)];
        [b1 setBackgroundColor:[UIColor whiteColor]];
        b1.tag = 0;
        [b1 addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:b1];
        
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0,4,b1.frame.size.width,20)];
        [t setText:[NSString stringWithFormat:@"開始時間 %@",SMALL_DOWN_ARROW]];
        [t setTextColor:[UIColor darkTextColor]];
        [t setFont:[UIFont systemFontOfSize:FONT_XS]];
        [t setTextAlignment:NSTextAlignmentCenter];
        [b1 addSubview:t];
        
        UILabel *sd = [[UILabel alloc] initWithFrame:CGRectMake(0,20,b1.frame.size.width,40)];
        [sd setText:startDate];
        [sd setTextColor:UICOLOR_GOLD];
        [sd setFont:[UIFont systemFontOfSize:FONT_XL]];
        [sd setTextAlignment:NSTextAlignmentCenter];
        [b1 addSubview:sd];
        
        UIButton *b2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [b2 setFrame:CGRectMake(delegate.screenWidth/2,delegate.headerHeight-delegate.statusBarHeight,delegate.screenWidth/2,60)];
        [b2 setBackgroundColor:[UIColor whiteColor]];
        b2.tag = 1;
        [b2 addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:b2];
        
        UILabel *t2 = [[UILabel alloc] initWithFrame:CGRectMake(0,4,b1.frame.size.width,20)];
        [t2 setText:[NSString stringWithFormat:@"結束時間 %@",SMALL_DOWN_ARROW]];
        [t2 setTextColor:[UIColor darkTextColor]];
        [t2 setFont:[UIFont systemFontOfSize:FONT_XS]];
        [t2 setTextAlignment:NSTextAlignmentCenter];
        [b2 addSubview:t2];
        
        UILabel *sd2 = [[UILabel alloc] initWithFrame:CGRectMake(0,20,b2.frame.size.width,40)];
        [sd2 setText:endDate];
        [sd2 setTextColor:UICOLOR_GOLD];
        [sd2 setFont:[UIFont systemFontOfSize:FONT_XL]];
        [sd2 setTextAlignment:NSTextAlignmentCenter];
        [b2 addSubview:sd2];
    } else {
        [v setFrame:CGRectMake(0,0,delegate.screenWidth,20)];
        [v setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
    }
    return v;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 60;
    } else {
        return 60;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    } else {
        return [super tableView:tableView heightForFooterInSection:section];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"points"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setTextColor:[UIColor darkTextColor]];
    if (indexPath.section==0) {
        UILabel *t2 = [[UILabel alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth-SIDE_PAD,60)];
        [t2 setText:[NSString stringWithFormat:@"結束時間 %@",SMALL_DOWN_ARROW]];
        [t2 setTextColor:UICOLOR_GOLD];
        [t2 setFont:[UIFont systemFontOfSize:FONT_XL]];
        [t2 setTextAlignment:NSTextAlignmentRight];
        [cell addSubview:t2];
        if (indexPath.row==0) {
            [cell.textLabel setText:@"充值"];
            [t2 setText:income];
        } else {
            [cell.textLabel setText:@"支付"];
            [t2 setText:expense];
        }
    } else {
        [cell setBackgroundColor:[UIColor whiteColor]];
        // Configure the cell...
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD_2,30)];
        [title setFont:[UIFont systemFontOfSize:FONT_M]];
        [title setTextColor:[UIColor darkTextColor]];
        [title setTextAlignment:NSTextAlignmentLeft];
        [title setText:[[dataSrc objectAtIndex:indexPath.row] objectForKey:@"name_zh"]];
        [cell addSubview:title];
        UILabel *ts = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,30,delegate.screenWidth-SIDE_PAD_2,20)];
        [ts setFont:[UIFont systemFontOfSize:FONT_S]];
        [ts setTextColor:UICOLOR_LIGHT_GREY];
        [ts setTextAlignment:NSTextAlignmentLeft];
        [ts setText:[[dataSrc objectAtIndex:indexPath.row] objectForKey:@"transaction_time"]];
        [cell addSubview:ts];
        
        
        UILabel *amount = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD_2,50)];
        [amount setFont:[UIFont systemFontOfSize:FONT_XL]];
        [amount setTextColor:UICOLOR_GOLD];
        [amount setTextAlignment:NSTextAlignmentRight];
        [amount setText:[NSString stringWithFormat:@"%.02f",[[[dataSrc objectAtIndex:indexPath.row] objectForKey:@"amount"] floatValue]]];
        [cell addSubview:amount];
    }
    
    // Configure the cell...
    
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
