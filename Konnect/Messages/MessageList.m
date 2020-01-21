//
//  MessageList.m
//  Konnect
//
//  Created by Jacky Mok on 3/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "MessageList.h"
#import "const.h"
#import "AppDelegate.h"
@interface MessageList ()

@end

@implementation MessageList
- (void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:@"消息中心"];
    
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-message",K_API_ENDPOINT]  param:
     @{
       @"action":@"",
       @"ap":[NSNumber numberWithInteger:0]
       } interation:0 callback:^(NSDictionary *data) {
           if ([[data objectForKey:@"errcode"] intValue]==0) {
               if ([[data objectForKey:@"rc"] intValue]==0) {
                   self->datasrc = [[data objectForKey:@"data"] mutableCopy];
                   self->loadingMore = NO;
                   [self.tableView reloadData];
               }
           } else {
               [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
           }
       }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = TEXT_OTHER_MESSAGE;
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBounces:NO];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];

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
    return MAX([datasrc count],1);
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return delegate.headerHeight-delegate.statusBarHeight;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.headerHeight-delegate.statusBarHeight)];
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return delegate.footerHeight;
}
-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.footerHeight)];
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([datasrc count] >  indexPath.row) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
         [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_MESSAGE_DETAIL],[[datasrc objectAtIndex:indexPath.row] objectForKey:@"ID"]] forKeys:@[@"type",@"messageID"]]];
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([datasrc count]==0) {
        return delegate.screenHeight-delegate.headerHeight-delegate.statusBarHeight-delegate.footerHeight;
    } else {
        CGFloat y = 77;
        
        return y;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"message"];
    //if (!cell) {
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"message"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setTextColor:[UIColor darkTextColor]];
    //}
    if ([datasrc count]==0) {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth, delegate.screenHeight-delegate.headerHeight-delegate.statusBarHeight-delegate.footerHeight)];
        [l setText:@"暫時沒有任何訊息或通知"];
        [l setFont:[UIFont systemFontOfSize:FONT_L]];
        [l setTextColor:UICOLOR_LIGHT_GREY];
        [l setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:l];
    } else {
        UIView *holder = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth-SIDE_PAD-20,1)];
        [cell addSubview:holder];
        int y = 5;
        UILabel *ts = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1,1)];
        [ts setBackgroundColor:[UIColor whiteColor]];
        [ts setTextAlignment:NSTextAlignmentRight];
        [ts setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"timestamp"]];
        [ts setTextColor:UICOLOR_LIGHT_GREY];
        [ts sizeToFit];
        [ts setFont:[UIFont systemFontOfSize:FONT_XS]];
        [ts setFrame:CGRectMake(holder.frame.size.width-ts.frame.size.width,y,ts.frame.size.width,ts.frame.size.height)];
        [holder addSubview:ts];
                       
        CGFloat titleWidth = ts.frame.origin.x;
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, y, titleWidth,24)];
        [title setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"title"]];
        [title setTextColor:[UIColor blackColor]];
        [title setNumberOfLines:1];
        [title setFont:[UIFont boldSystemFontOfSize:FONT_S]];
        [holder addSubview:title];
        
        y+= title.frame.size.height;
        
        UILabel *body = [[UILabel alloc] initWithFrame:CGRectMake(0, y, holder.frame.size.width, 24)];
        [body setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"excerpt"]];
        [body setFont:[UIFont systemFontOfSize:FONT_XS]];
        [body setTextColor:UICOLOR_DARK_GREY];
        [body setNumberOfLines:2];
        [holder addSubview:body];
        y+=body.frame.size.height+LINE_PAD;
        
        [holder setFrame:CGRectMake(20,0,delegate.screenWidth-SIDE_PAD-20, y)];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0,y,delegate.screenWidth,1)];
        [holder addSubview:line];
        [line setBackgroundColor:UICOLOR_VERY_LIGHT_GREY_BORDER];
        
        if ([[[datasrc objectAtIndex:indexPath.row] objectForKey:@"opened"] isEqualToString:@"0"]) {
            UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(4,12,10,10)];
            [dot setBackgroundColor:UICOLOR_BLUE];
            [dot.layer setCornerRadius:5.0f];
            [cell addSubview:dot];
        }
        
    }
    
    // Configure the cell...    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    float reload_distance = -60;
    if ([datasrc count]>=10 && !loadingMore) {
        loadingMore = YES;
         NSLog(@"loading more %f %f",y,h);
        if(h > 0 && y > h + reload_distance) {
          //  NSLog(@"startloading more");
            [delegate startLoading];
            [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-message",K_API_ENDPOINT]  param:
             @{
               @"action":@"getmessages",
               @"ap":[NSNumber numberWithInteger:[datasrc count]]
               } interation:0 callback:^(NSDictionary *data) {
                   if ([[data objectForKey:@"errcode"] intValue]==0) {
                       if ([[data objectForKey:@"rc"] intValue]==0) {
                           NSMutableArray *append = [[data objectForKey:@"data"] mutableCopy];
                           if (self->datasrc ==nil) {
                               self->datasrc = append;
                               [self.tableView reloadData];
                           } else {
                               if ([append count]>0) {
                                   [self->datasrc addObjectsFromArray:append];
                                   [self.tableView reloadData];
                               }
                           }
                           [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
                               self->loadingMore = NO;
                        //       NSLog(@"Loading no more 3");
                           }];
                       
                       }
                   } else {
                       [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                   }
               }];
           
        } else if (offset.y < -80) {
            [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
                 self->loadingMore = NO;
               // NSLog(@"Loading no more 1 ");
            }];
        } else {
            [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
                self->loadingMore = NO;
               // NSLog(@"Loading no more 2");
            }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
