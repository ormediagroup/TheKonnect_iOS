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
                                             [self.tableView reloadData];
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setTextColor:UICOLOR_DARK_GREY];
    [cell.detailTextLabel setTextColor:[UIColor darkTextColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    int y = LINE_PAD;
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth,LINE_HEIGHT)];
    [l setFont:[UIFont systemFontOfSize:FONT_M]];
    [l setTextColor:[UIColor darkTextColor]];
    [l setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"title"]];
    [l sizeToFit];
    [cell addSubview:l];
    y+=l.frame.size.height;
    
    UILabel *m = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth,LINE_HEIGHT)];
    [m setFont:[UIFont systemFontOfSize:FONT_S]];
    [m setTextColor:UICOLOR_LIGHT_GREY];
    [m setText:[[datasrc objectAtIndex:indexPath.row] objectForKey:@"modified"]];
    [m sizeToFit];
    [cell addSubview:m];
    y+=m.frame.size.height + LINE_PAD;
    
    CGFloat w = [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:1] floatValue];
    CGFloat h = [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:2] floatValue];
    CGFloat newg = h/w*(delegate.screenWidth-SIDE_PAD_2);
    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD,y,delegate.screenWidth-SIDE_PAD_2,newg)];
    [v setImage:[delegate getImage:[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
        [v setImage:image];
    }]];
    [cell addSubview:v];
    
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
