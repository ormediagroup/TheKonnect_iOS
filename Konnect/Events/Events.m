//
//  Events.m
//  Konnect
//
//  Created by Jacky Mok on 10/11/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "Events.h"
#import "AppDelegate.h"
#import "const.h"
@interface Events ()

@end

@implementation Events
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:TEXT_K_EVENT];
    
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-home",K_API_ENDPOINT] param:
     [[NSDictionary alloc] initWithObjects:@[
                                             @"get-events",
                                             ]
                                   forKeys:@[
                                             @"action",
                                             ]]
     
                                     interation:0 callback:^(NSDictionary *data) {
                                         //NSLog(@"Wallet %@",data);
                                         if ([[data objectForKey:@"rc"] intValue]==0) {
                                             self->datasrc = [data objectForKey:@"data"];
                                             self->kevents = [data objectForKey:@"kevents"];
                                             self->vipevents = [data objectForKey:@"vipevents"];
                                             self->otherevents = [data objectForKey:@"otherevents"];
                                             
                                             [self.tableView reloadData];
                                             
                                         } else {
                                             [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                         }
                                     }];
    [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-get-home",K_API_ENDPOINT] param:
        [[NSDictionary alloc] initWithObjects:@[
                                                @"get-past-events",
                                                ]
                                      forKeys:@[
                                                @"action",
                                                ]]
        
                                        interation:0 callback:^(NSDictionary *data) {
                                            //NSLog(@"Wallet %@",data);
                                            if ([[data objectForKey:@"rc"] intValue]==0) {
                                                self->pastevents = [data objectForKey:@"data"];
                                                [self.tableView reloadData];
                                                
                                            } else {
                                                [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"errmsg"]];
                                            }
                                        }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    rowHeight = delegate.screenWidth/3;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return [super tableView:tableView heightForHeaderInSection:0]+40;
    } else {
        return 40;
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==4) return delegate.footerHeight;
    else return 0;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==0) {
        UIView *h =  [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.headerHeight-delegate.statusBarHeight+40)];
        [h setBackgroundColor:UICOLOR_GOLD];
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,delegate.headerHeight-delegate.statusBarHeight,delegate.screenWidth-SIDE_PAD,40)];
        [v setFont:[UIFont boldSystemFontOfSize:FONT_M]];
        [v setTextColor:[UIColor whiteColor]];
        [v setText:TEXT_K_EVENT];
        [h addSubview:v];
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setTitle:[NSString stringWithFormat:TEXT_VIEW_ACTIVITIES,(int)[self->kevents count]] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];;
        b.tag = section;
        [b.titleLabel setFont:[UIFont systemFontOfSize:FONT_S]];
        [b setFrame:CGRectMake(delegate.screenWidth-100,delegate.headerHeight-delegate.statusBarHeight,100,40)];
        [b addTarget:self action:@selector(viewEvent:) forControlEvents:UIControlEventTouchUpInside];
        [h addSubview:b];
        return h;
    } else if (section>=1 && section<=4){
        UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,60)];
        [h setBackgroundColor:UICOLOR_GOLD];
        UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD,0,delegate.screenWidth-SIDE_PAD,40)];
        [v setFont:[UIFont boldSystemFontOfSize:FONT_M]];
        [v setTextColor:[UIColor whiteColor]];
        [h addSubview:v];
        
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];;
        b.tag = section;
        [b.titleLabel setFont:[UIFont systemFontOfSize:FONT_S]];
        [b setFrame:CGRectMake(delegate.screenWidth-100,0,100,40)];
        [b addTarget:self action:@selector(viewEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        if (section==1) {
            [v setText:TEXT_ALL_ACTIVITIES];
            [b setTitle:[NSString stringWithFormat:TEXT_VIEW_ACTIVITIES,(int)[self->otherevents count]] forState:UIControlStateNormal];
            [h addSubview:b];
        } else if (section==2) {
            [v setText:TEXT_VIP_ACTIVITIES];
            [b setTitle:[NSString stringWithFormat:TEXT_VIEW_ACTIVITIES,(int)[self->vipevents count]] forState:UIControlStateNormal];
            [h addSubview:b];
        }
        else if (section==3) {
            [v setText:TEXT_PAST_ACTIVITIES];
            [b setTitle:[NSString stringWithFormat:TEXT_VIEW_ACTIVITIES,(int)[self->pastevents count]] forState:UIControlStateNormal];
            [h addSubview:b];
        }
        else if (section==4) {[v setText:TEXT_RENT_K_SPACE];}
        return h;
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,UITableViewAutomaticDimension)];
    }
}
-(void) viewEvent:(UIButton *)b {
    if (b.tag == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
        [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_EVENT_LIST],kevents] forKeys:@[@"type",@"datasrc"]]];
    } else if (b.tag==1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
        [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_EVENT_LIST],otherevents] forKeys:@[@"type",@"datasrc"]]];
    } else if (b.tag==2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
        [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_EVENT_LIST],vipevents] forKeys:@[@"type",@"datasrc"]]];
    } else if (b.tag==3) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
                   [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_PAST_ACTIVITIES]] forKeys:@[@"type"]]];
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section>=0 && indexPath.section<=3) {
        return rowHeight;
    } else {
        return UITableViewAutomaticDimension;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==4) return 3;
    return 1;
    /*
    if (section==0) {
        return [datasrc count];
    } else if (section==1) {
        return 1;
    } else {
        return 3;
    }
     */
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *c = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TEXT_K_EVENT];
    [c setBackgroundColor:[UIColor whiteColor]];
    [c setSelectionStyle:UITableViewCellSelectionStyleNone];         
    if (indexPath.section==0) {
        for (int i = 0; i < 3; i++) {
            if ([kevents count] >i) {
                UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(rowHeight*i,0,rowHeight,rowHeight)];
                v.tag = i;
                UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewCurrentEvent:)];
                [v addGestureRecognizer:t];
                [v setClipsToBounds:YES];
                [v setUserInteractionEnabled:YES];
                v.layer.borderWidth=5.0f;
                v.layer.borderColor=[[UIColor whiteColor]CGColor];
                v.layer.cornerRadius = 3.0f;
                [v setContentMode:UIViewContentModeScaleAspectFill];
                [v setClipsToBounds:YES];
                [v setBackgroundColor:[UIColor whiteColor]];
                [v setImage:[delegate getImage:[[[kevents objectAtIndex:i] objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
                    [v setImage:image];
                }]];
                [c addSubview:v];
            }
        }
    } else if (indexPath.section==1) {
        for (int i = 0; i < 3; i++) {
           if ([datasrc count] >i) {
               UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(rowHeight*i,0,rowHeight,rowHeight)];
               v.tag = i;
               UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewCurrentEvent:)];
               [v addGestureRecognizer:t];
              [v setClipsToBounds:YES];
              [v setUserInteractionEnabled:YES];
              v.layer.borderWidth=5.0f;
              v.layer.borderColor=[[UIColor whiteColor]CGColor];
              v.layer.cornerRadius = 3.0f;
              [v setContentMode:UIViewContentModeScaleAspectFill];
              [v setClipsToBounds:YES];
              [v setBackgroundColor:[UIColor whiteColor]];
               [v setImage:[delegate getImage:[[[kevents objectAtIndex:i] objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
                   [v setImage:image];
               }]];
               [c addSubview:v];
           }
       }
    } else if (indexPath.section==2) {
        for (int i = 0; i < 3; i++) {
           if ([vipevents count] >i) {
               UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(rowHeight*i,0,rowHeight,rowHeight)];
               v.tag = i;
              [v setClipsToBounds:YES];
              [v setUserInteractionEnabled:YES];
              v.layer.borderWidth=5.0f;
               UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewCurrentEvent:)];
               [v addGestureRecognizer:t];
              v.layer.borderColor=[[UIColor whiteColor]CGColor];
              v.layer.cornerRadius = 3.0f;
              [v setContentMode:UIViewContentModeScaleAspectFill];
              [v setClipsToBounds:YES];
              [v setBackgroundColor:[UIColor whiteColor]];
               [v setImage:[delegate getImage:[[[kevents objectAtIndex:i] objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
                   [v setImage:image];
               }]];
               [c addSubview:v];
           }
       }
    } else if (indexPath.section==3) {
         for (int i = 0; i < 3; i++) {
            if ([pastevents count] >i) {
                UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(rowHeight*i,0,rowHeight,rowHeight)];
                v.tag = i;
               [v setClipsToBounds:YES];
               [v setUserInteractionEnabled:YES];
               v.layer.borderWidth=5.0f;
               v.layer.borderColor=[[UIColor whiteColor]CGColor];
               v.layer.cornerRadius = 3.0f;
               
                UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewPastEvent:)];
                [v addGestureRecognizer:t];
               [v setContentMode:UIViewContentModeScaleAspectFill];
               [v setClipsToBounds:YES];
               [v setBackgroundColor:[UIColor whiteColor]];
                [v setImage:[delegate getImage:[[[pastevents objectAtIndex:i] objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
                    [v setImage:image];
                }]];
                [c addSubview:v];
            }
        }
    } else if (indexPath.section==4) {
        [c setSelectionStyle:UITableViewCellSelectionStyleNone];
        [c setBackgroundColor:[UIColor whiteColor]];
        [c.textLabel setTextColor:[UIColor darkGrayColor]];
        [c setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        if (indexPath.row==0) {
            [c.textLabel setText:TEXT_RENT_POPUP];
            [c.detailTextLabel setText:@""];
        } else if (indexPath.row==1) {
            [c.textLabel setText:TEXT_RENT_EVENT_SPACE];
            [c.detailTextLabel setText:@""];
        } else {
            [c.textLabel setText:TEXT_RENT_MEETING_ROOM];
            [c.detailTextLabel setText:@""];
        }
    }
    return c;
}
/*

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TEXT_K_EVENT];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell.textLabel setTextColor:UICOLOR_DARK_GREY];
    [cell.detailTextLabel setTextColor:[UIColor darkTextColor]];
    if (indexPath.section==0) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        CGFloat w = [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:1] floatValue];
        CGFloat h = [[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:2] floatValue];
        CGFloat newg = h/w*(delegate.screenWidth-SIDE_PAD_2);
        UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD,LINE_PAD/2,delegate.screenWidth-SIDE_PAD_2,newg)];
        [v setImage:[delegate getImage:[[[datasrc objectAtIndex:indexPath.row] objectForKey:@"image"] objectAtIndex:0] callback:^(UIImage *image) {
            [v setImage:image];
        }]];
       
        [cell addSubview:v];
        return cell;
    } else if (indexPath.section==1) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.textLabel setText:TEXT_PAST_ACTIVITIES_PHOTO];
        [cell.detailTextLabel setText:@""];
    } else if (indexPath.section==2) {

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        if (indexPath.row==0) {
            [cell.textLabel setText:TEXT_RENT_POPUP];
            [cell.detailTextLabel setText:@""];
        } else if (indexPath.row==1) {
            [cell.textLabel setText:TEXT_RENT_EVENT_SPACE];
            [cell.detailTextLabel setText:@""];
        } else {
            [cell.textLabel setText:TEXT_RENT_MEETING_ROOM];
            [cell.detailTextLabel setText:@""];
        }
        return cell;
    }
    return cell;
}
 */
-(void)book:(UIButton *)b {
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
     [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_EVENT_DETAILS],[[datasrc objectAtIndex:b.tag]  objectForKey:@"ID"]] forKeys:@[@"type",@"eventID"]]];
}
-(void) viewCurrentEvent:(UITapGestureRecognizer *)t  {
  [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
   [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_EVENT_DETAILS],[[datasrc objectAtIndex:t.view.tag]  objectForKey:@"ID"]] forKeys:@[@"type",@"eventID"]]];
}
-(void) viewPastEvent:(UITapGestureRecognizer *)t  {
    [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
        [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_IMAGE_GALLERY],[[pastevents objectAtIndex:t.view.tag] objectForKey:@"album"]] forKeys:@[@"type",@"images"]]];
                
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
     
    } else if (indexPath.section==1) {
      
    } else if (indexPath.section==4) {
        if (indexPath.row==0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_FACILITY],@"60"] forKeys:@[@"type",@"facilityID"]]];
        } else if (indexPath.row==1) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
                  [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_FACILITY],@"61"] forKeys:@[@"type",@"facilityID"]]];
        } else if (indexPath.row==2) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_SEARCH_MEETING_ROOM]] forKeys:@[@"type"]]];
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

