//
//  RankAlbumTableView.m
//  sdkTest
//
//  Created by chao on 2016/11/4.
//  Copyright © 2016年 nali. All rights reserved.
//

#import "RankAlbumTableView.h"
#import "RankAlbumCell.h"
#import "XMDataManager.h"
#import "XMSDK.h"

@interface RankAlbumTableView ()


@property (nonatomic, strong) XMDataManager *dataManager;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation RankAlbumTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    
}

-(void)loadData {
    _dataArray = [NSMutableArray array];
    
    self.dataManager = [XMDataManager shareInstance];
   
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:self.rankKey forKey:@"rank_key"];
    [requestDic setObject:@1 forKey:@"page"];
    [requestDic setObject:@20 forKey:@"count"];
    [self.dataManager loadDataWithDic:requestDic andXMReqType:XMReqType_RankAlbum];
    
    __weak __typeof(&*self) sself = self;
    self.dataManager.dataBlock = ^(NSDictionary *dataDic) {
        NSArray *tempArr = [NSArray arrayWithArray:[[dataDic objectForKey:@"data"] objectForKey:@"albums"]];
        if (tempArr.count) {
            for (id obj in tempArr) {
                XMAlbum *album = [[XMAlbum alloc] initWithDictionary:obj];
                NSLog(@"coverImage: %@", album.coverUrlMiddle);
                [sself.dataArray addObject:album];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [sself.tableView reloadData];
            });
            
            NSMutableString *mutString = [NSMutableString string];
           
            for (int i = 0; i < sself.dataArray.count; i++) {
                XMAlbum *album = sself.dataArray[i];
                [mutString appendString:[NSString stringWithFormat:@"%ld,", (long)album.albumId]];
                if (i == sself.dataArray.count) {
                    [mutString appendString:[NSString stringWithFormat:@"%ld", (long)album.albumId]];
                    break;
                }
            }
            
            NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
            [requestDic setObject:mutString forKey:@"ids"];
            [sself.dataManager loadDataWithDic:requestDic andXMReqType:XMReqType_TracksBatch];
            
            sself.dataManager.dataBlock = ^(NSDictionary *dataDic) {
//                NSArray *tempArr = [NSArray arrayWithArray:[dataDic objectForKey:@"data"]];
                
            };
        }
    };
    
    /*
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:self.rankKey forKey:@"rank_key"];
    [requestDic setObject:@1 forKey:@"page"];
    [requestDic setObject:@20 forKey:@"count"];
    [self.dataManager loadDataWithDic:requestDic andXMReqType:XMReqType_RankTrack];
    
    __weak __typeof(&*self) sself = self;
    self.dataManager.dataBlock = ^(NSDictionary *dataDic) {
        NSArray *tempArr = [NSArray arrayWithArray:[[dataDic objectForKey:@"data"] objectForKey:@"tracks"]];
        if (tempArr.count) {
            for (id obj in tempArr) {
                XMTrack *track = [[XMTrack alloc] initWithDictionary:obj];
                NSLog(@"coverImage: %@", track.coverUrlSmall);
                [sself.dataArray addObject:track];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [sself.tableView reloadData];
            });
        }
    };
    */
}


#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataArray) {
        return _dataArray.count;
    }
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ///*
    RankAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RankAlbumCellID"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RankAlbumCell" owner:self options:nil] firstObject];
    }
    if (_dataArray.count) {
        XMAlbum *album = _dataArray[indexPath.row];
        [cell config:album andIndex:indexPath.row];
    }
    //*/
    
    /*
    static NSString *cID = @"RankCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cID];
    }
    if (_dataArray.count) {
        XMTrack *track = _dataArray[indexPath.row];
        cell.textLabel.text = track.trackTitle;
        cell.detailTextLabel.text = track.playUrl24M4a;
        cell.imageView.image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:track.coverUrlSmall]]];
    }
     */
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
