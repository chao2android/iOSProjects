//
//  JYFeedTableView.m
//  friendJY
//
//  Created by ouyang on 3/25/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYFeedTableView.h"
#import "JYFeedTableViewCell.h"
#import "JYFeedTextView.h"
#import <objc/runtime.h>
#import "JYShareData.h"
#import "JYProfileModel.h"

@interface JYFeedTableView ()
{
    JYFeedTableViewCell *heightCell;
    NSString *myself_uid;
    BOOL isUpList;
}
@end

@implementation JYFeedTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        static NSString *lHeight = @"lHeight";
        heightCell = [[JYFeedTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:lHeight];
        myself_uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        
    }
    
    return self;
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //当没有好友时，显示好友邀请提示
//    if (indexPath.row == GuideToAddressBookIndexpath5 && [self.data[GuideToAddressBookIndexpath5] isKindOfClass:[NSDictionary class]]) {
//        static NSString *cellIdentifier = @"guideToAddressBook";
//        self.currentRow = indexPath.row;
//        JYGuideToAddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        
//        if (cell == nil) {
//            cell = [[JYGuideToAddressBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            cell.backgroundColor = [UIColor clearColor];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        cell.aBlock = ^{
//            [self.data removeObjectAtIndex:GuideToAddressBookIndexpath5];
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        };
//        return cell;
//    }
//    else if (indexPath.row == GuideToAddressBookIndexpath15 && [self.data[GuideToAddressBookIndexpath15] isKindOfClass:[NSDictionary class]]) {
//        static NSString *cellIdentifier = @"guideToAddressBook";
//        self.currentRow = indexPath.row;
//        JYGuideToAddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        
//        if (cell == nil) {
//            cell = [[JYGuideToAddressBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            cell.backgroundColor = [UIColor clearColor];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        cell.aBlock = ^{
//            [self.data removeObjectAtIndex:GuideToAddressBookIndexpath15];
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        };
//        return cell;
//    }
//    else if (indexPath.row == GuideToAddressBookIndexpath25 && [self.data[GuideToAddressBookIndexpath25] isKindOfClass:[NSDictionary class]]) {
//        static NSString *cellIdentifier = @"guideToAddressBook";
//        self.currentRow = indexPath.row;
//        JYGuideToAddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        
//        if (cell == nil) {
//            cell = [[JYGuideToAddressBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            cell.backgroundColor = [UIColor clearColor];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        cell.aBlock = ^{
//            [self.data removeObjectAtIndex:GuideToAddressBookIndexpath25];
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        };
//        return cell;
//    }
    
    if ([self.data[indexPath.row] isKindOfClass:[NSDictionary class]]) {
        static NSString *guideToAddressBook = @"guideToAddressBook";
        self.currentRow = indexPath.row;
        JYGuideToAddressBookCell *cell = [tableView dequeueReusableCellWithIdentifier:guideToAddressBook];
        if (cell == nil) {
            cell = [[JYGuideToAddressBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:guideToAddressBook];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.aBlock = ^{
            [self.data removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        return cell;
    }
    
    
    static NSString *cellIdentifier = @"shieldCell";
    self.currentRow = indexPath.row;
    JYFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[JYFeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isMyDynamicCall = self.isMyDynamicCall;
    }
    
    JYFeedModel *model = self.data[indexPath.row];
    cell.feedModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.data[indexPath.row] isKindOfClass:[NSDictionary class]]) {
        return 50;
    }
    
    //在此使用样本Cell计算高度。
    JYFeedModel *myModel = self.data[indexPath.row];
    heightCell.feedModel = myModel;
    return [heightCell LoadContent]+10;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
