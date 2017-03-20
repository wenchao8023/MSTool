//
//  CMDTestViewController.m
//  MS3Tool
//
//  Created by chao on 2017/1/16.
//  Copyright © 2017年 ibuild. All rights reserved.
//

#import "CMDTestViewController.h"

#import "GCDAysncSocketDataManager.h"



#import "MSMusicModel.h"

#import "MSMusicModel.h"




@interface CMDTestViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) GCDAsyncSocketCommunicationManager *comManager;

@property (nonatomic, strong) CMDDataConfig *cmdManager;

@end

@implementation CMDTestViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.2 green:0.1 blue:0.1 alpha:1];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"数据交互测试";
    
    self.navigationController.navigationBar.hidden = NO;
    
    [[MSFooterManager shareManager] setWindowHidden];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.


    _comManager = [GCDAsyncSocketCommunicationManager sharedInstance];
    
    _cmdManager = [CMDDataConfig shareInstance];
    
    [self addNotifycation];
    
    self.dataArray = @[@"udp连接",
                       @"发送音量大小",
                       @"上一曲",
                       @"下一曲",
                       @"播放",
                       @"暂停",
                       @"获取当前音量",
                       @"获取当前播放状态",
                       @"获取当前播放进度",
                       @"发送手机播放进度",
                       @"收藏当前播放歌曲url",
                       @"播放列表中某首歌曲",
                       @"获取播放列表 : 收藏列表",
                       @"获取当前播放音乐信息",
                       @"获取播放列表第 * 首歌的信息",
                       @"获取音箱信息",
                       @"恢复出厂设置（没有回复报文）",
                       @"获取当前播放模式",
                       @"设置播放模式 - 顺序",
                       @"设置播放模式 - 单曲",
                       @"设置播放模式 - 随机",
                       @"获取当前歌曲总时长",
                       @"取消收藏某歌曲",
                       @"APP收藏某歌曲",
                       @"播放播放列表第 * 首歌的信息",
                       @"播放收藏列表第 * 首歌的信息"
                       ];
    
    [self createUI];
}

- (void)createUI {
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, WIDTH - 40, 100)];
    
    _textView.delegate = self;
    
    _textView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    [self.view addSubview:_textView];
    
    
    UIButton *clearButton = [WenChaoControl createButtonWithFrame:CGRectMake(WIDTH - 80, 20, 60, 30) ImageName:nil Target:self Action:@selector(clearText) Title:@"clear"];
    
    [self.view addSubview:clearButton];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, SCREENW, HEIGHT - 140 - NAVIGATIONBAR_HEIGHT) style:UITableViewStyleGrouped];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

- (void)clearText {
    self.textView.text = @"";
}
- (void)setText:(NSString *)str {
    
    NSMutableString *mutStr = [NSMutableString stringWithString:self.textView.text];
    
    [mutStr appendString:[NSString stringWithFormat:@"%@\n", str]];
    
    self.textView.text = mutStr;
    
    [_textView scrollRectToVisible:CGRectMake(0, _textView.contentSize.height-15, _textView.contentSize.width, 10) animated:YES];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CMDTestViewControllerIDDDDD"];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CMDTestViewControllerIDDDDD"];
    }
    
    
    NSInteger row = indexPath.row;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld、%@", (long)row, self.dataArray[row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    [self clickRow:indexPath.row];
}


- (void)clickRow:(NSInteger)row {
    
    NSData *data;

    switch (row) {
        case 0:
        {        
            [_comManager udpBroadcast];
            
            [self setText:@"广播服务"];
        }
            break;
        case 1:
        {
            int value = [self.textView.text intValue];
            
            [[VoicePlayer shareInstace] VPSetVolume:value];
            
            [self setText:[NSString stringWithFormat:@"设置音量大小为: %d", value]];
        }
            break;
        case 2:
        {
            [[VoicePlayer shareInstace] VPlayLastSong];
            
            [self setText:@"上一曲"];
        }
            break;
            
        case 3:
        {
            [[VoicePlayer shareInstace] VPlayNextSong];
            
            [self setText:@"下一曲"];
        }
            break;
            
        case 4:
        {
            [[VoicePlayer shareInstace] VPlay];
            
            [self setText:@"播放"];
        }
            break;
            
        case 5:
        {
            [[VoicePlayer shareInstace] VPause];
            
            [self setText:@"暂停"];
        }
            break;
            
        case 6:
        {
            [[VoicePlayer shareInstace] VPGetVolume];
            
            [self setText:@"获取当前音量"];
        }
            break;
        case 7:
        {
            [[VoicePlayer shareInstace] VPGetPlayStatu];
            
            [self setText:@"获取当前播放状态"];
        }
            break;
        case 8:
        {
            [[VoicePlayer shareInstace] VPGetCurrentProgress];
            
            [self setText:@"获取当前播放进度"];
        }
            break;
        case 9:
        {
            int value = [self.textView.text intValue];
            
            [[VoicePlayer shareInstace] VPSetProgress:value];
            
            [self setText:[NSString stringWithFormat:@"设置播放进度: %d", value]];
        }
            break;
        case 10:
        {
            [[VoicePlayer shareInstace] VPSetCollectMusic];
            
            [self setText:@"提示音箱收藏当前播放的url，做完这个操作后重新获取收藏列表"];
        }
            break;
        case 11:
        {
            int value = [self.textView.text intValue];
            
            [[VoicePlayer shareInstace] VPGetPlayMusicInAlbum:value];
            
            [self setText:[NSString stringWithFormat:@"获取播放列表中的第- %d -首歌曲", value]];
        }
            break;
        case 12:
        {
            int value = [self.textView.text intValue];
            
            [[VoicePlayer shareInstace] VPGetPlayAlbum_begin:value];
            
            NSString *str = value == 0 ? @"播放列表" : @"收藏列表";
            
            [self setText:str];
        }
            break;
        case 13:
        {
            [[VoicePlayer shareInstace] VPGetPlayMusicInfo];
            
            [self setText:@"获取当前播放音乐的信息"];
        }
            break;
        case 14:
        {
            int value = [self.textView.text intValue];
            
            [[VoicePlayer shareInstace] VPGetPlayMusicInAlbum:value];
            
            [self setText:[NSString stringWithFormat:@"获取播放列表第- %d -首歌的信息", value]];
        }
            break;
        case 15:
        {
            data = [self.comManager.dataManager getGetReturnHeadDataWithCMD:CMD_GET_voiceboxInfo];
            
            [self.comManager socketWriteDataWithData:data andTag:0];
            
            [self setText:@"获取音箱信息"];
        }
            break;
        case 16:
        {
            data = [self.comManager.dataManager getGetReturnHeadDataWithCMD:CMD_SET_resetFactory];
            
            [self setText:@"恢复出厂设置"];
            
            [self.comManager socketWriteDataWithData:data andTag:0];
        }
            break;
        case 17:
        {
            [[VoicePlayer shareInstace] VPGetPlayType];
            
            [self setText:@"获取当前播放模式"];
        }
            break;
        case 18:
        {
            [[VoicePlayer shareInstace] VPSetPlayType:0];
            
            [self setText:@"设置播放模式 - 顺序"];
        }
            break;
        case 19:
        {
            [[VoicePlayer shareInstace] VPSetPlayType:1];
            
            [self setText:@"设置播放模式 - 单曲"];
        }
            break;
        case 20:
        {
            [[VoicePlayer shareInstace] VPSetPlayType:2];
            
            [self setText:@"设置播放模式 - 随机"];
        }
            break;
        case 21:
        {
            [[VoicePlayer shareInstace] VPGetDuration];
            
            [self setText:@"获取当前歌曲总时长"];
        }
            break;
        case 22:
        {
            int value = [self.textView.text intValue];
            
            [[VoicePlayer shareInstace] VPSetCancelCollectMusicIndex:value];
            
            [self setText:@"取消收藏某歌曲"];
        }
            break;
        case 23:
        {
            NSDictionary *dataDic = @{@"musicName" : @"喜马拉雅测试歌曲",
                                      @"musicUrl" : @"http://fdfs.xmcdn.com/group24/M07/A6/92/wKgJMFh-HO3gN79GAKDQZ4QBgAM552.mp3",
                                      @"musicImgUrl" : @"",
                                      @"albumsName" : @"",
                                      @"artistsName" : @""};

            data = [self.comManager.dataManager getReturnAPPCollectMusicWithCMD:CMD_SET_APPCollectMusic dataDic:dataDic];
          
            [self.comManager socketWriteDataWithData:data andTag:0];
          
            [self setText:@"音箱收藏歌曲"];
        }
            break;
        case 24:
        {
            int value = [self.textView.text intValue];
            
//            [[VoicePlayer shareInstace] VPSetPlayMusicInAlbum:AlbumType_playAlbum index:value];
            
            [self setText:[NSString stringWithFormat:@"播放播放列表中的第- %d -首歌曲", value]];
        }
            break;
        case 25:
        {
            int value = [self.textView.text intValue];
            
//            [[VoicePlayer shareInstace] VPSetPlayMusicInAlbum:AlbumType_collectAlbum index:value];
            
            [self setText:[NSString stringWithFormat:@"播放收藏列表中的第- %d -首歌曲", value]];
        }
            break;

        default:
            break;
    }
}

#pragma mark - addNotifycation
-(void)addNotifycation {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCMDData) name:NOTIFY_CMDDATARETURN object:nil];
}

- (void)getCMDData {
    
    NSLog(@"cmd in config is : %d,\tvalue is : %@", self.cmdManager.getCMD, [self.cmdManager.cmdDic objectForKey:[NSString stringWithFormat:@"%d", self.cmdManager.getCMD]]);
}
- (NSDictionary *)musicInfo:(MSMusicModel *)model {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [self setNonnullObj:model.songName key:@"musicName" inDic:dic];
    [self setNonnullObj:model.playUrl key:@"musicUrl" inDic:dic];
    [self setNonnullObj:model.coverImgLarge key:@"musicImgUrl" inDic:dic];
    [self setNonnullObj:model.albumName key:@"albumsName" inDic:dic];
    [self setNonnullObj:model.singerName key:@"artistsName" inDic:dic];
    
    return (NSDictionary *)dic;
}

- (void)setNonnullObj:(NSString *)obj key:(NSString *)key inDic:(NSMutableDictionary *)dic {
    
    if (obj) {
        
        [dic setObject:obj forKey:key];
        
    } else {
        
        [dic setObject:@"" forKey:key];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CMDDATARETURN object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
