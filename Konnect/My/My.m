//
//  My.m
//  Konnect
//
//  Created by Jacky Mok on 4/10/2019.
//  Copyright © 2019 Jacky Mok. All rights reserved.
//

#import "My.h"
#import "AppDelegate.h"
#define AVATAR_SIZE 80
@interface My ()

@end

@implementation My

- (void)viewDidLoad {
    [super viewDidLoad];
    delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [self.tableView setBackgroundColor:UICOLOR_VERY_LIGHT_GREY];
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAvatar:) name:CHANGE_AVATAR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:LOGIN_SUCCESS object:nil];
    labels = @[@"我的資料",@"我的錢包",@"積分記錄",@"預約記錄",TEXT_COUPON,TEXT_SERVICE_OFFICE,TEXT_REFERRAL_QR];
    iconsrc = @[@"editinfo.png",@"waller.png",@"pointshistory.png",@"appointments.png",@"coupons.png",@"office.png",@"referral.png"];
    
    avatar = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD,SIDE_PAD,AVATAR_SIZE,AVATAR_SIZE)];
    avatar.layer.cornerRadius = 10.0f;
    [avatar setContentMode:UIViewContentModeScaleAspectFit];
    [avatar setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeAvatar)];
    [avatar addGestureRecognizer:tap];
    [avatar setBackgroundColor:UICOLOR_LIGHT_GREY];
    avatar.tag =0;
    NSLog(@"My : %@",[delegate.preferences objectForKey:K_USER_AVATAR] );
    if ([[delegate.preferences objectForKey:K_USER_AVATAR] isKindOfClass:[NSString class]] && [[delegate.preferences objectForKey:K_USER_AVATAR] length]>0) {
        avatar.tag = 1;
        [avatar setBackgroundColor:[UIColor clearColor]];
        [avatar setImage:[delegate getImage:[delegate.preferences objectForKey:K_USER_AVATAR] callback:^(UIImage *image) {
            [self->avatar setImage:image];
        }]];
    }
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void) login {
    [avatar setImage:[delegate getImage:[delegate.preferences objectForKey:K_USER_AVATAR] callback:^(UIImage *image) {
        [self->avatar setImage:image];
        [self->avatar setBackgroundColor:[UIColor clearColor]];
        self->avatar.tag =1;
    }]];
}
-(void) changeAvatar:(NSNotification*)notif {
    if ([notif.object isKindOfClass:[NSString class]] && ![notif.object isEqualToString:@""]) {
        [avatar setImage:[delegate getImage:notif.object callback:^(UIImage *image) {
            [self->avatar setImage:image];
            self->avatar.tag =1;
            [self->avatar setBackgroundColor:[UIColor clearColor]];
        }]];
    } else {
        [avatar setImage:nil];
        avatar.tag = 0;
        [avatar setBackgroundColor:UICOLOR_LIGHT_GREY];
    }
}
-(void) viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_TITLE object:@"我的"];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [super viewWillAppear:animated];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) return 8;
    else if (section==1) return 0;
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return delegate.headerHeight-delegate.statusBarHeight;
    } else {
        return LINE_PAD;
    }
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.headerHeight-delegate.statusBarHeight)];
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==2) {
        return delegate.footerHeight+LINE_PAD;
    } else {
        return 0;
    }
}
-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,delegate.footerHeight)];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 && indexPath.row==0) {
        return AVATAR_SIZE+SIDE_PAD_2;
    } else {
        return LINE_HEIGHT+LINE_HEIGHT;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"my"];
    [cell setBackgroundColor:[UIColor whiteColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.section==0 && indexPath.row==0) {
        CGFloat l =SIDE_PAD_2+AVATAR_SIZE;
        CGFloat w =delegate.screenWidth-SIDE_PAD_2-SIDE_PAD-AVATAR_SIZE;
        UIView *p = [[UIView alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,50+delegate.statusBarHeight)];
        [p setBackgroundColor:UICOLOR_PURPLE];
        [cell addSubview:p];
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(SIDE_PAD,0, delegate.screenWidth-SIDE_PAD, AVATAR_SIZE + SIDE_PAD_2)];
        [bg setContentMode:UIViewContentModeScaleAspectFill];
        [bg setClipsToBounds:YES];
        [bg setUserInteractionEnabled:YES];
        [bg setImage:[UIImage imageNamed:@"GoldBg.png"]];
        [cell addSubview:bg];
        

        [bg addSubview:avatar];
        
        int y = SIDE_PAD;
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(l,y,w,LINE_HEIGHT)];
        [name setTextColor:[UIColor darkTextColor]];
        [name setText:[delegate.preferences objectForKey:K_USER_NAME]];
        [name setFont:[UIFont systemFontOfSize:FONT_M]];
        [bg addSubview:name];
        y+=LINE_HEIGHT+4;
        
        //207 x 52
        UIImageView *badge = [[UIImageView alloc] initWithFrame:CGRectMake(l,y,69,18)];
        [badge setImage:[UIImage imageNamed:@"normalmember.png"]];
        [badge setContentMode:UIViewContentModeScaleAspectFit];
        [bg addSubview:badge];
        y+=22;
        
        UILabel *memberno = [[UILabel alloc] initWithFrame:CGRectMake(l,y,w,LINE_HEIGHT)];
        [memberno setTextColor:[UIColor darkGrayColor]];
        [memberno setFont:[UIFont systemFontOfSize:FONT_XS]];
        [memberno setText:[NSString stringWithFormat:@"%@: %@",TEXT_MEMBER_NO,[delegate.preferences objectForKey:K_USER_NO]]];
        [bg addSubview:memberno];
        y+=SIDE_PAD+LINE_HEIGHT;
        
    } else if (indexPath.section==0 && indexPath.row>0) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(SIDE_PAD+50,0,delegate.screenWidth-50-SIDE_PAD_2,LINE_HEIGHT+LINE_HEIGHT)];
        [title setText:[labels objectAtIndex:(indexPath.row-1)]];
        [title setTextColor:[UIColor darkGrayColor]];
        [cell addSubview:title];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconsrc objectAtIndex:(indexPath.row-1)]]];
        [icon setFrame:CGRectMake(SIDE_PAD,0,30,title.frame.size.height)];
        [icon setContentMode:UIViewContentModeScaleAspectFit];
        [cell addSubview:icon];
        
    } else if (indexPath.section==2) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0,0,delegate.screenWidth,LINE_HEIGHT+LINE_HEIGHT)];
        [title setText:@"退出登錄"];
        [title setTextAlignment:NSTextAlignmentCenter];
        [title setFont:[UIFont systemFontOfSize:FONT_L]];
        [title setTextColor:UICOLOR_GOLD];
        [cell addSubview:title];
        
    }
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_MY_EDITINFO]] forKeys:@[@"type"]]];
        } else if (indexPath.row==2) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_MY_WALLET]] forKeys:@[@"type"]]];
        } else if (indexPath.row==3) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_POINT_HISTORY]] forKeys:@[@"type"]]];
        } else if (indexPath.row==4) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_RESERVATIONS]] forKeys:@[@"type"]]];
        } else if (indexPath.row==5) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_COUPON]] forKeys:@[@"type"]]];
        } else if (indexPath.row==6) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_SERVICE_OFFICE]] forKeys:@[@"type"]]];
        } else if (indexPath.row==7) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GO_SLIDE object:
             [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:VC_TYPE_REFERER_QR]] forKeys:@[@"type"]]];
        }
        
    } if (indexPath.section==2) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"你確定要退出登錄?"
                                                                       message:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        UIAlertAction* logout = [UIAlertAction actionWithTitle:@"退出登錄" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            [self->delegate logout];
        }];
        [alert addAction:logout];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view.window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
        
    }
}
-(void) chooseFromAlbum {
    imgpicker = [[UIImagePickerController alloc] init];
    imgpicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [imgpicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [delegate.window.rootViewController presentViewController:imgpicker animated:YES completion:^{
            
        }];
        
    }
}
-(void) changeAvatar {
    if (avatar.tag==0) {
        [self chooseFromAlbum];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:TEXT_CHANGE_AVATAR
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction: [UIAlertAction actionWithTitle:TEXT_SELECT_AVATAR style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self chooseFromAlbum];
        }]];
        [alert addAction: [UIAlertAction actionWithTitle:TEXT_DELETE_AVATAR style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [[KApiManager sharedManager] getResultAsync:[NSString stringWithFormat:@"%@app-upload-image",K_API_ENDPOINT] param:[[NSDictionary alloc] initWithObjects:@[@"deleteavatar"] forKeys:@[@"action"]] interation:0 callback:^(NSDictionary *data) {
                if ([[data objectForKey:@"rc"] intValue]==0) {
                    [self->delegate raiseAlert:TEXT_DELETE_AVATAR msg:TEXT_SAVE_SUCCESS];
                    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_AVATAR object:@""];
                } else {
                    [self->delegate raiseAlert:TEXT_NETWORK_ERROR msg:[data objectForKey:@"msg"]];
                }
            }];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:TEXT_CANCEL style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
        });
    }
    
}
#pragma mark Take Photo Delegates
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    [delegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}
// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    if ([info objectForKey:@"UIImagePickerControllerOriginalImage"]!=nil) {
        // add params (all params are strings)
        UIImage* uimg =[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [delegate startLoading:delegate.window.rootViewController];
        id result = [[KApiManager sharedManager] uploadImage:uimg];
        [delegate stopLoading];
        if ([result isKindOfClass:[NSDictionary class]] && [[result objectForKey:@"image"] isKindOfClass:[NSString class]]) {
            [delegate raiseAlert:TEXT_SAVE_SUCCESS msg:@"" inViewController:imgpicker];
            [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_AVATAR object:[result objectForKey:@"image"]];
            [delegate.preferences setObject:[result objectForKey:@"image"] forKey:K_USER_AVATAR];
            [delegate.preferences synchronize];
            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        } else if ([result isKindOfClass:[NSError class]]) {
            NSError *r = result;
            if ([[r.userInfo objectForKey:@"rc"]intValue]==1) {
                [delegate raiseAlert:TEXT_INPUT_ERROR msg:[r.userInfo objectForKey:@"msg"] inViewController:imgpicker];
            }
        } else {
            [delegate raiseAlert:TEXT_INPUT_ERROR msg:@"" inViewController:imgpicker];
        }
        //        CGFloat h = uimg.size.height / uimg.size.width * 800;
        // UIImageWriteToSavedPhotosAlbum(uimg, nil,nil,nil);
    }
    [delegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
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
