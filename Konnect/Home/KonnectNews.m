//
//  KonnectNews.m
//  Konnect
//
//  Created by Jacky Mok on 10/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "KonnectNews.h"
#import "AppDelegate.h"
@interface KonnectNews ()

@end

@implementation KonnectNews
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_K_NEWS];
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-home",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[@"get-news"]
                                   forKeys:@[@"action"]]
                                     interation:0 callback:^(NSDictionary *data) {
                                         if ([data isKindOfClass:[NSDictionary class]] && [[data objectForKey:@"rc"] intValue]==0) {
                                             self->datasrc = [data objectForKey:@"data"];
                                             self->images = [[NSMutableArray alloc] init];
                                             int __block j = 0;
                                             for (int i = 0;i < [self->datasrc count]; i++) {
                                                 [self->images setObject:[[UIImage alloc] init] atIndexedSubscript:i];
                                                 [self->delegate getImage:[[[self->datasrc objectAtIndex:i] objectForKey:@"thumbnail"] objectAtIndex:0] callback:^(UIImage *image) {
                                                     [self->images setObject:image atIndexedSubscript:i];
                                                     j++;
                                                     if (j == [self->datasrc count]) {
                                                         [self.tableView reloadData];
                                                     }
                                                 }];
                                             }
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                         }
                                     }];
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

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [datasrc count];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    CGFloat w = [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:1] floatValue];
    CGFloat h = [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:2] floatValue];
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth,LINE_HEIGHT)];
    [l setFont:[UIFont systemFontOfSize:FONT_M]];
    [l setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"title"]];
    [l sizeToFit];
    UILabel *m = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth,LINE_HEIGHT)];
    [m setFont:[UIFont systemFontOfSize:FONT_S]];
    [m setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"modified"]];
    [m sizeToFit];
    CGFloat newg = h/w*(delegate.screenWidth-SIDE_PAD_2);
    return l.frame.size.height + m.frame.size.height + newg + LINE_PAD+LINE_PAD+LINE_PAD;
     */
    //return UITableViewAutomaticDimension;
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setTextColor:UICOLOR_DARK_GREY];
    [cell.detailTextLabel setTextColor:[UIColor darkTextColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell.imageView setImage:[images objectAtIndex:indexPath.row]];
    [cell.textLabel setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"title"]];
    // [cell.detailTextLabel setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"modified"]];
        
    
    UILabel *m = [[UILabel alloc] initWithFrame:CGRectMake(0,4,delegate.screenWidth-SIDE_PAD,LINE_HEIGHT)];
    [m setFont:[UIFont systemFontOfSize:FONT_S]];
    [m setTextColor:UICOLOR_LIGHT_GREY];
    [m setTextAlignment:NSTextAlignmentRight];
    [m setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"modified"]];
    [cell addSubview:m];
    
    /*
     
    int y = LINE_PAD;
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth,LINE_HEIGHT)];
    [l setFont:[UIFont systemFontOfSize:FONT_M]];
    [l setTextColor:[UIColor darkTextColor]];
    [l setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"title"]];
    [l sizeToFit];
    [cell addSubview:l];
    y+=l.frame.size.height;
    
    
    y+=m.frame.size.height + LINE_PAD;
    
    CGFloat w = [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:1] floatValue];
    CGFloat h = [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:2] floatValue];
    CGFloat newg = h/w*(delegate.screenWidth-SIDE_PAD_2);
    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,newg)];
    [v setImage:[delegate getImage:[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
        [v setImage:image];
    }]];
    [cell addSubview:v];
    */
    // Configure the cell...
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
            [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_NEWS_DETAILS], [[datasrc objectAtIndex:indexPath.row] objectForKey:@"ID"]] forKeys:@[@"type",@"messageID"]]];
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
