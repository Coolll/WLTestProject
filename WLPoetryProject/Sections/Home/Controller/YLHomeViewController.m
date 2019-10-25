//
//  YLHomeViewController.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/1.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "YLHomeViewController.h"
#import "WLCoreDataHelper.h"
#import "PoetryModel.h"
#import "WLHomePoetryCell.h"
#import "PoetryDetailViewController.h"
#import "WLImageCell.h"
#import "WLImageController.h"
#import "WLImageListController.h"
#import "WritePoetryController.h"
#import "NetworkHelper.h"

@interface YLHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 *  诗词列表
 **/
@property (nonatomic,strong) UITableView *mainTableView;
/**
 *  背景图片
 **/
@property (nonatomic,strong) UIImageView *mainBgView;


/**
 *  诗词数据源
 **/
@property (nonatomic,strong) NSArray *poetryArray;

/**
 *  高度数组
 **/
@property (nonatomic,strong) NSMutableArray *heightArray;
/**
 *  json是否读取的数组
 **/
@property (nonatomic,strong) NSMutableDictionary *jsonStateDic;
/**
 *  图片是否加载的数组
 **/
@property (nonatomic,strong) NSMutableDictionary *imageStateDic;

/**
 *  network
 **/
@property (nonatomic,strong) NetworkHelper *networkHelper;



@end

@implementation YLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ViewBackgroundColor;
    self.titleForNavi = @"热门推荐";
    [self loadCustomData];
    self.networkHelper = [NetworkHelper shareHelper];
//    [self checkLocalData];//加载本地数据
//    [self loadAllImageData];
    
//    [self uploadAllPoetry];
//    [self uploadAllImages];
}

- (void)uploadAllImages{
    [[AppConfig config] loadClassImageWithBlock:^(NSDictionary *dic) {
        
        NSArray *keysArray = dic.allKeys;
        for (int i = 0; i < keysArray.count; i++) {
            
            NSString *key = [keysArray objectAtIndex:i];
            NSString *url = [dic objectForKey:key];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i+1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                [param setObject:url forKey:@"image_url"];
                [param setObject:key forKey:@"class_info"];

                [self.networkHelper uploadImage:param];
            });
        }
        

    }];
}

#pragma mark - 将本地json上传到服务器

- (void)uploadAllPoetry{
    NSArray *jsonList = [NSArray array];
    jsonList = [AppConfig config].allPoetryList;
    
    for (int i = 0; i < jsonList.count ;i++) {
        
        NSArray *poetryModelArray = [self readLocalFileWithName:jsonList[i]];
        
        for (int j = 0 ; j < poetryModelArray.count;j++ ) {
            
            PoetryModel *model = poetryModelArray[j];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((j+1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:model.poetryID forKey:@"poetry_id"];
                [dic setObject:model.name forKey:@"name"];
                [dic setObject:model.author forKey:@"author"];
                [dic setObject:model.content forKey:@"content"];
                [dic setObject:model.addtionInfo forKey:@"addition_info"];
                [dic setObject:model.classInfo forKey:@"class_info"];
                if (model.classInfo.length > 8) {
                    NSLog(@"诗词:%@",model.poetryID);

                }
                [dic setObject:model.classInfoExplain forKey:@"class_info_explain"];
                [dic setObject:model.mainClass forKey:@"main_class"];
                [dic setObject:model.mainClassExplain forKey:@"main_class_explain"];
                [dic setObject:model.source forKey:@"source"];
                [dic setObject:model.sourceExplain forKey:@"source_explain"];
                [dic setObject:model.transferInfo forKey:@"transfer_info"];
                [self.networkHelper uploadPoetry:dic];
            });
            
            
        }
    
        
        
    }
}

- (NSString*)dealPoetryClassInfoExplain:(NSString*)classInfo
{
    if([classInfo isEqualToString:@"1"]){return @"春天";}
    else if([classInfo isEqualToString:@"2"]){return @"月亮";}
    else if([classInfo isEqualToString:@"3"]){return @"夏天";}
    else if([classInfo isEqualToString:@"4"]){return @"秋天";}
    else if([classInfo isEqualToString:@"5"]){return @"冬天";}
    else if([classInfo isEqualToString:@"6"]){return @"思乡";}
    else if([classInfo isEqualToString:@"7"]){return @"离别";}
    else if([classInfo isEqualToString:@"8"]){return @"咏物";}
    else if([classInfo isEqualToString:@"9"]){return @"山水";}
    else if([classInfo isEqualToString:@"10"]){return @"重阳节";}
    else if([classInfo isEqualToString:@"11"]){return @"西湖";}
    else if([classInfo isEqualToString:@"12"]){return @"垂钓";}
    else if([classInfo isEqualToString:@"13"]){return @"友情";}
    else if([classInfo isEqualToString:@"14"]){return @"梅花";}
    else if([classInfo isEqualToString:@"15"]){return @"童趣";}
    else if([classInfo isEqualToString:@"16"]){return @"边塞";}
    else if([classInfo isEqualToString:@"17"]){return @"伤感";}
    else if([classInfo isEqualToString:@"18"]){return @"春节";}
    else if([classInfo isEqualToString:@"19"]){return @"中秋节";}
    else if([classInfo isEqualToString:@"20"]){return @"亲情";}
    else if([classInfo isEqualToString:@"21"]){return @"花";}
    else if([classInfo isEqualToString:@"22"]){return @"励志";}
    else if([classInfo isEqualToString:@"23"]){return @"竹子";}
    else if([classInfo isEqualToString:@"24"]){return @"人生哲理";}
    else if([classInfo isEqualToString:@"25"]){return @"抱负";}
    else if([classInfo isEqualToString:@"26"]){return @"雨";}
    else if([classInfo isEqualToString:@"27"]){return @"抒怀";}
    else if([classInfo isEqualToString:@"28"]){return @"游记";}
    else if([classInfo isEqualToString:@"29"]){return @"叙事";}
    else if([classInfo isEqualToString:@"30"]){return @"归隐";}
    else if([classInfo isEqualToString:@"31"]){return @"战争";}
    else if([classInfo isEqualToString:@"32"]){return @"爱国";}
    else if([classInfo isEqualToString:@"33"]){return @"怀古";}
    else if([classInfo isEqualToString:@"34"]){return @"忧国忧民";}
    else if([classInfo isEqualToString:@"35"]){return @"言志";}
    else if([classInfo isEqualToString:@"36"]){return @"豪放";}
    else if([classInfo isEqualToString:@"37"]){return @"爱情";}
    else if([classInfo isEqualToString:@"38"]){return @"忧愁";}
    else if([classInfo isEqualToString:@"39"]){return @"闺怨";}
    else if([classInfo isEqualToString:@"40"]){return @"农民生活（艰苦）";}
    else if([classInfo isEqualToString:@"41"]){return @"菊花";}
    else if([classInfo isEqualToString:@"42"]){return @"感慨盛衰";}
    else if([classInfo isEqualToString:@"43"]){return @"新婚";}
    else if([classInfo isEqualToString:@"44"]){return @"山景";}
    else if([classInfo isEqualToString:@"45"]){return @"民歌";}
    else if([classInfo isEqualToString:@"46"]){return @"音乐";}
    else if([classInfo isEqualToString:@"47"]){return @"雪景";}
    else if([classInfo isEqualToString:@"48"]){return @"怀念友人";}
    else if([classInfo isEqualToString:@"49"]){return @"宫怨";}
    else if([classInfo isEqualToString:@"50"]){return @"寻访";}
    else if([classInfo isEqualToString:@"51"]){return @"规劝";}
    else if([classInfo isEqualToString:@"52"]){return @"思念";}
    else if([classInfo isEqualToString:@"54"]){return @"喜悦";}
    else if([classInfo isEqualToString:@"55"]){return @"讽刺";}
    else if([classInfo isEqualToString:@"56"]){return @"怀才不遇";}
    else if([classInfo isEqualToString:@"57"]){return @"感慨";}
    else if([classInfo isEqualToString:@"58"]){return @"咏史";}
    else if([classInfo isEqualToString:@"59"]){return @"寒食节";}
    else if([classInfo isEqualToString:@"60"]){return @"悲凉";}
    else if([classInfo isEqualToString:@"61"]){return @"仕途坎坷";}
    else if([classInfo isEqualToString:@"62"]){return @"敬爱";}
    else if([classInfo isEqualToString:@"63"]){return @"相聚";}
    else if([classInfo isEqualToString:@"64"]){return @"悼亡";}
    else if([classInfo isEqualToString:@"65"]){return @"酬和";}
    else if([classInfo isEqualToString:@"66"]){return @"宫廷景象";}
    else if([classInfo isEqualToString:@"67"]){return @"潦倒";}
    else if([classInfo isEqualToString:@"68"]){return @"咏人";}
    else if([classInfo isEqualToString:@"69"]){return @"贬谪";}
    else if([classInfo isEqualToString:@"70"]){return @"援引（求官）";}
    else if([classInfo isEqualToString:@"71"]){return @"游历";}
    else if([classInfo isEqualToString:@"72"]){return @"慰勉";}
    else if([classInfo isEqualToString:@"73"]){return @"宴会";}
    else if([classInfo isEqualToString:@"74"]){return @"题画";}
    else if([classInfo isEqualToString:@"75"]){return @"女子";}
    else if([classInfo isEqualToString:@"76"]){return @"失意";}
    else if([classInfo isEqualToString:@"77"]){return @"将军";}
    else if([classInfo isEqualToString:@"78"]){return @"婉约";}
    else if([classInfo isEqualToString:@"79"]){return @"感悟";}
    else if([classInfo isEqualToString:@"80"]){return @"采莲";}
    else if([classInfo isEqualToString:@"81"]){return @"相思";}
    else if([classInfo isEqualToString:@"82"]){return @"少女";}
    else if([classInfo isEqualToString:@"83"]){return @"惆怅";}
    else if([classInfo isEqualToString:@"84"]){return @"追求美满生活";}
    else if([classInfo isEqualToString:@"85"]){return @"凄苦";}
    else if([classInfo isEqualToString:@"86"]){return @"哀怨";}
    else if([classInfo isEqualToString:@"87"]){return @"怀旧";}
    else if([classInfo isEqualToString:@"88"]){return @"鸟";}
    else if([classInfo isEqualToString:@"89"]){return @"怨妇";}
    else if([classInfo isEqualToString:@"90"]){return @"无奈";}
    else if([classInfo isEqualToString:@"91"]){return @"羁旅";}
    else if([classInfo isEqualToString:@"92"]){return @"伤春";}
    else if([classInfo isEqualToString:@"93"]){return @"离愁别恨";}
    else if([classInfo isEqualToString:@"94"]){return @"惜春";}
    else if([classInfo isEqualToString:@"95"]){return @"端午";}
    else if([classInfo isEqualToString:@"96"]){return @"荷花";}
    else if([classInfo isEqualToString:@"97"]){return @"元霄节";}
    else if([classInfo isEqualToString:@"98"]){return @"清明节";}
    else if([classInfo isEqualToString:@"99"]){return @"抒情";}
    else if([classInfo isEqualToString:@"100"]){return @"壮志难酬";}
    else if([classInfo isEqualToString:@"101"]){return @"写景";}
    else if([classInfo isEqualToString:@"102"]){return @"民歌";}
    else if([classInfo isEqualToString:@"103"]){return @"七夕节";}
    else if([classInfo isEqualToString:@"104"]){return @"孤独";}
    else if([classInfo isEqualToString:@"105"]){return @"母爱";}
    else if([classInfo isEqualToString:@"106"]){return @"乡村生活（和谐）";}
    else if([classInfo isEqualToString:@"107"]){return @"田园（怡然）";}
    else if([classInfo isEqualToString:@"108"]){return @"送别";}
    else if([classInfo isEqualToString:@"109"]){return @"饮酒";}
    else if([classInfo isEqualToString:@"110"]){return @"春景";}
    else if([classInfo isEqualToString:@"1001"]){return @"山村咏怀";}
    else if([classInfo isEqualToString:@"1002"]){return @"咏鹅";}
    else if([classInfo isEqualToString:@"1003"]){return @"春晓";}
    else if([classInfo isEqualToString:@"1004"]){return @"静夜思";}
    else if([classInfo isEqualToString:@"1005"]){return @"悯农";}
    else if([classInfo isEqualToString:@"1006"]){return @"池上";}
    else if([classInfo isEqualToString:@"1007"]){return @"明日歌";}
    else if([classInfo isEqualToString:@"1008"]){return @"草";}
    else if([classInfo isEqualToString:@"1009"]){return @"咏柳";}
    else if([classInfo isEqualToString:@"1010"]){return @"寻隐者不遇";}
    else if([classInfo isEqualToString:@"1011"]){return @"望庐山瀑布";}
    else if([classInfo isEqualToString:@"1012"]){return @"望天门山";}
    else if([classInfo isEqualToString:@"1013"]){return @"题西林壁";}
    else if([classInfo isEqualToString:@"1014"]){return @"夜宿山寺";}
    else if([classInfo isEqualToString:@"1015"]){return @"登鹳雀楼";}
    else if([classInfo isEqualToString:@"1016"]){return @"清明";}
    else if([classInfo isEqualToString:@"1017"]){return @"枫桥夜泊";}
    else if([classInfo isEqualToString:@"1018"]){return @"江雪";}
    else if([classInfo isEqualToString:@"1019"]){return @"绝句";}
    else if([classInfo isEqualToString:@"1020"]){return @"赠汪伦";}
    else if([classInfo isEqualToString:@"1101"]){return @"风";}
    else if([classInfo isEqualToString:@"1102"]){return @"黄鹤楼送孟浩然之广陵";}
    else if([classInfo isEqualToString:@"1103"]){return @"小儿垂钓";}
    else if([classInfo isEqualToString:@"1104"]){return @"凉州词";}
    else if([classInfo isEqualToString:@"1105"]){return @"渔歌子";}
    else if([classInfo isEqualToString:@"1106"]){return @"九月九日忆山东兄弟";}
    else if([classInfo isEqualToString:@"1107"]){return @"别董大";}
    else if([classInfo isEqualToString:@"1108"]){return @"泊船瓜洲";}
    else if([classInfo isEqualToString:@"1109"]){return @"四时田园杂兴";}
    else if([classInfo isEqualToString:@"1110"]){return @"村居";}
    else if([classInfo isEqualToString:@"1111"]){return @"所见";}
    else if([classInfo isEqualToString:@"1112"]){return @"游子吟";}
    else if([classInfo isEqualToString:@"1113"]){return @"绝句";}
    else if([classInfo isEqualToString:@"1114"]){return @"早春呈水部张十八员外";}
    else if([classInfo isEqualToString:@"1115"]){return @"送元二使安西";}
    else if([classInfo isEqualToString:@"1116"]){return @"回乡偶书";}
    else if([classInfo isEqualToString:@"1201"]){return @"苏幕遮怀旧";}
    else if([classInfo isEqualToString:@"1202"]){return @"蝶恋花";}
    else if([classInfo isEqualToString:@"1203"]){return @"蝶恋花";}
    else if([classInfo isEqualToString:@"1204"]){return @"生查子";}
    else if([classInfo isEqualToString:@"1205"]){return @"水龙吟";}
    else if([classInfo isEqualToString:@"1206"]){return @"鹊桥仙";}
    else if([classInfo isEqualToString:@"1207"]){return @"踏莎行";}
    else if([classInfo isEqualToString:@"1208"]){return @"青玉案";}
    else if([classInfo isEqualToString:@"1209"]){return @"如梦令";}
    else if([classInfo isEqualToString:@"1210"]){return @"青玉案";}
    else if([classInfo isEqualToString:@"1211"]){return @"丑奴儿";}
    else if([classInfo isEqualToString:@"1212"]){return @"扬州慢";}
    else if([classInfo isEqualToString:@"1213"]){return @"临江仙";}
    else if([classInfo isEqualToString:@"1301"]){return @"渔家傲";}
    else if([classInfo isEqualToString:@"1302"]){return @"雨霖铃";}
    else if([classInfo isEqualToString:@"1303"]){return @"浣溪沙";}
    else if([classInfo isEqualToString:@"1304"]){return @"水调歌头";}
    else if([classInfo isEqualToString:@"1305"]){return @"念奴娇";}
    else if([classInfo isEqualToString:@"1306"]){return @"定风波";}
    else if([classInfo isEqualToString:@"1307"]){return @"江城子";}
    else if([classInfo isEqualToString:@"1308"]){return @"江城子";}
    else if([classInfo isEqualToString:@"1309"]){return @"苏幕遮";}
    else if([classInfo isEqualToString:@"1310"]){return @"一剪梅";}
    else if([classInfo isEqualToString:@"1311"]){return @"醉花阴";}
    else if([classInfo isEqualToString:@"1312"]){return @"声声慢";}
    else if([classInfo isEqualToString:@"1313"]){return @"满江红";}
    else if([classInfo isEqualToString:@"1314"]){return @"破阵子";}

    return @"";
}

- (NSString*)dealMainClassExplain:(NSString*)mainClass
{
    if ([mainClass isEqualToString:@"1"]) {return @"小学一年级";}
    else if ([mainClass isEqualToString:@"2"]){return @"小学二年级";}
    else if ([mainClass isEqualToString:@"3"]){return @"小学三年级";}
    else if ([mainClass isEqualToString:@"4"]){return @"小学四年级";}
    else if ([mainClass isEqualToString:@"5"]){return @"小学五年级";}
    else if ([mainClass isEqualToString:@"6"]){return @"小学六年级";}
    else if ([mainClass isEqualToString:@"7"]){return @"七年级上";}
    else if ([mainClass isEqualToString:@"7.5"]){return @"七年级下";}
    else if ([mainClass isEqualToString:@"8"]){return @"八年级上";}
    else if ([mainClass isEqualToString:@"8.5"]){return @"八年级下";}
    else if ([mainClass isEqualToString:@"9"]){return @"九年级";}
    else if ([mainClass isEqualToString:@"9.5"]){return @"九年级下";}
    else if ([mainClass isEqualToString:@"10"]){return @"唐诗-卷一";}
    else if ([mainClass isEqualToString:@"11"]){return @"唐诗-卷二";}
    else if ([mainClass isEqualToString:@"12"]){return @"唐诗-卷三";}
    else if ([mainClass isEqualToString:@"13"]){return @"唐诗-卷四";}
    else if ([mainClass isEqualToString:@"14"]){return @"唐诗-卷五";}
    else if ([mainClass isEqualToString:@"15"]){return @"唐诗-卷六";}
    else if ([mainClass isEqualToString:@"16"]){return @"唐诗-卷七";}
    else if ([mainClass isEqualToString:@"17"]){return @"宋词-卷一";}
    else if ([mainClass isEqualToString:@"18"]){return @"宋词-卷二";}
    else if ([mainClass isEqualToString:@"19"]){return @"宋词-卷三";}
    else if ([mainClass isEqualToString:@"20"]){return @"宋词-卷四";}
    else if ([mainClass isEqualToString:@"21"]){return @"宋词-卷五";}
    else if ([mainClass isEqualToString:@"22"]){return @"宋词-卷六";}
    else if ([mainClass isEqualToString:@"23"]){return @"宋词-卷七";}
    else if ([mainClass isEqualToString:@"24"]){return @"宋词-卷八";}
    else if ([mainClass isEqualToString:@"25"]){return @"宋词-卷九";}
    else if ([mainClass isEqualToString:@"26"]){return @"宋词-卷十";}
    else if ([mainClass isEqualToString:@"27"]){return @"高一";}
    else if ([mainClass isEqualToString:@"28"]){return @"高二";}
    else if ([mainClass isEqualToString:@"29"]){return @"高三";}
    else if ([mainClass isEqualToString:@"30"]){return @"学前必背";}
    else if ([mainClass isEqualToString:@"31"]){return @"学前必读";}
    else if ([mainClass isEqualToString:@"32"]){return @"宋词必读";}
    else if ([mainClass isEqualToString:@"33"]){return @"宋词必背";}
    else if ([mainClass isEqualToString:@"34"]){return @"论语-卷一";}
    else if ([mainClass isEqualToString:@"35"]){return @"论语-卷二";}
    else if ([mainClass isEqualToString:@"36"]){return @"论语-卷三";}
    else if ([mainClass isEqualToString:@"99"]){return @"推荐";}

    
    return @"";

}

- (NSString*)dealSourceExplain:(NSString*)source{
    //1为古诗三百首 2为唐诗三百首 3为宋词三百首 4诗经 10为早教古诗100首 11为小学古诗 12初中古诗 13近代诗词 14高中古诗 15高中文言 16楚辞 17学前必背诗词 18学前必读诗词
    //source 论语 100学而篇 101为政篇 102八佾篇 103里仁篇 104公冶长篇 105雍也篇 106述而篇 107泰伯篇 108子罕篇 109乡党篇 110先进篇 111颜渊篇 112子路篇 113宪问篇 114卫灵公篇 115季氏篇 116阳货篇 117微子篇 118子张篇 119尧曰篇
    if ([source isEqualToString:@"1"]) {return @"古诗三百首";}
    else if ([source isEqualToString:@"2"]){return @"唐诗三百首";}
    else if ([source isEqualToString:@"3"]){return @"宋词三百首";}
    else if ([source isEqualToString:@"4"]){return @"诗经";}
    else if ([source isEqualToString:@"10"]){return @"早教古诗100首";}
    else if ([source isEqualToString:@"11"]){return @"小学古诗";}
    else if ([source isEqualToString:@"12"]){return @"初中古诗";}
    else if ([source isEqualToString:@"13"]){return @"g近代诗词";}
    else if ([source isEqualToString:@"14"]){return @"高中古诗";}
    else if ([source isEqualToString:@"15"]){return @"高中文言";}
    else if ([source isEqualToString:@"16"]){return @"楚辞";}
    else if ([source isEqualToString:@"17"]){return @"学前必背诗词";}
    else if ([source isEqualToString:@"18"]){return @"学前必读诗词";}
    else if ([source isEqualToString:@"100"]){return @"学而篇";}
    else if ([source isEqualToString:@"101"]){return @"为政篇";}
    else if ([source isEqualToString:@"102"]){return @"八佾篇";}
    else if ([source isEqualToString:@"103"]){return @"里仁篇";}
    else if ([source isEqualToString:@"104"]){return @"公冶长篇";}
    else if ([source isEqualToString:@"105"]){return @"雍也篇";}
    else if ([source isEqualToString:@"106"]){return @"述而篇";}
    else if ([source isEqualToString:@"107"]){return @"泰伯篇";}
    else if ([source isEqualToString:@"108"]){return @"子罕篇";}
    else if ([source isEqualToString:@"109"]){return @"乡党篇";}
    else if ([source isEqualToString:@"110"]){return @"先进篇";}
    else if ([source isEqualToString:@"111"]){return @"颜渊篇";}
    else if ([source isEqualToString:@"112"]){return @"子路篇";}
    else if ([source isEqualToString:@"113"]){return @"宪问篇";}
    else if ([source isEqualToString:@"114"]){return @"卫灵公篇";}
    else if ([source isEqualToString:@"115"]){return @"季氏篇";}
    else if ([source isEqualToString:@"116"]){return @"阳货篇";}
    else if ([source isEqualToString:@"117"]){return @"微子篇";}
    else if ([source isEqualToString:@"118"]){return @"子张篇";}
    else if ([source isEqualToString:@"119"]){return @"尧曰篇";}
   
    return @"";
}





- (NSArray*)readLocalFileWithName:(NSString*)fileName
{
    //从本地读取文件
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    //转为dic
    NSDictionary *poetryDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    NSInteger baseId = [[NSString stringWithFormat:@"%@",[poetryDic objectForKey:@"baseID"]]integerValue];
    
    //获取到诗词列表
    NSArray *poetryArr = [poetryDic objectForKey:@"poetryList"];
    NSString *poetryMainClass = [poetryDic objectForKey:@"mainClass"];
    
    NSMutableArray *modelArray = [NSMutableArray array];
    //将诗词model化
    for (int i = 0; i<poetryArr.count; i++) {
        NSDictionary *itemDic = [poetryArr objectAtIndex:i];
        PoetryModel *model = [[PoetryModel alloc]initModelWithDictionary:itemDic];
        model.mainClass = poetryMainClass;
        model.poetryID = [NSString stringWithFormat:@"%ld",(unsigned long)([model.poetryID integerValue]+baseId)];
        model.mainClassExplain = [self dealMainClassExplain:model.mainClass];
        model.sourceExplain = [self dealSourceExplain:model.source];
        model.classInfoExplain = [self dealPoetryClassInfoExplain:model.classInfo];
        [modelArray addObject:model];
    }
    
    return modelArray;
    
}


#pragma mark - 图片处理

- (void)loadAllImageData
{
    //本地已加载的图片状态
    self.imageStateDic = [WLSaveLocalHelper loadObjectForKey:@"AllImageStateDic"];
    //如果不存在，则创建一个
    if(!self.imageStateDic){
        [WLSaveLocalHelper saveObject:[NSDictionary dictionary] forKey:@"AllImageStateDic"];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        //空数组，用来加载网络上的图片URL
        NSMutableArray *arr = [NSMutableArray array];
        
        [[AppConfig config] loadClassImageWithBlock:^(NSDictionary *dic) {
            //添加图片url
            [arr addObjectsFromArray:dic.allValues];
            //需要额外加载的图片URL数组
            NSMutableArray *mutArray = [NSMutableArray array];
            
            for (NSInteger i = 0; i<arr.count; i++) {
                //拿到图片URL
                NSString *urlString = [arr objectAtIndex:i];
                //获取本地加载过的状态字符串，如果找到了状态字符串，且为1，则无需再加载
                NSString *stateString = [NSString stringWithFormat:@"%@",[self.imageStateDic valueForKey:urlString]];
                if(![stateString isEqualToString:@"1"]){
                    //如果没有加载过，或者没有成功加载，则需要加载
                    [mutArray addObject:urlString];
                }
                
            }
            
            //如果全部图片都加载过，则返回
            if(mutArray.count == 0){return;}
            
            UIImageView *view = [[UIImageView alloc]init];
            //递归，加载图片
            [self loadImageWithArray:mutArray withCurrentIndex:0 withImageView:view withStatusDic:[NSMutableDictionary dictionary]];

            }];
            
    });
    
}

- (void)loadImageWithArray:(NSArray*)imageArray withCurrentIndex:(NSInteger)index withImageView:(UIImageView*)imageView withStatusDic:(NSMutableDictionary*)dic
{
    if(index < imageArray.count){
        [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:index]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            
            NSDictionary *dict = [WLSaveLocalHelper loadObjectForKey:@"AllImageStateDic"];
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dict];
            if(image){
                [mutDic setObject:@"1" forKey:imageURL.absoluteString];
            }else{
                [mutDic setObject:@"0" forKey:imageURL.absoluteString];
            }
            //此张图片完成加载后，保存到本地
            [WLSaveLocalHelper saveObject:[mutDic copy] forKey:@"AllImageStateDic"];

            [self loadImageWithArray:imageArray withCurrentIndex:(index+1) withImageView:imageView withStatusDic:dic];

        }];
    }
}


- (void)loadCustomData
{
    self.heightArray = [NSMutableArray array];
    
    self.poetryArray = [[WLCoreDataHelper shareHelper] fetchPoetryWithMainClass:@"99"];

    if (self.poetryArray.count == 0) {
        //从本地读取文件
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"recommendPoetry" ofType:@"json"]];
        //转为dic
        NSDictionary *poetryDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
        //获取到诗词列表
        NSArray *poetryArr = [poetryDic objectForKey:@"poetryList"];
        NSString *poetryMainClass = [poetryDic objectForKey:@"mainClass"];

        NSMutableArray *modelArray = [NSMutableArray array];
        //将诗词model化
        for (int i = 0; i<poetryArr.count; i++) {
            NSDictionary *itemDic = [poetryArr objectAtIndex:i];
            PoetryModel *model = [[PoetryModel alloc]initModelWithDictionary:itemDic];
            model.mainClass = poetryMainClass;
            [modelArray addObject:model];
        }
        
        //存储到本地数据库
        [[WLCoreDataHelper shareHelper]saveInBackgroundWithPeotryModelArray:modelArray withResult:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //存储成功后读取然后展示
                [self fetchPoetryAndShowView];
                
            }
        }];
    }else{
        
        //直接展示数据
        [self loadCustomView];
    }
    
    
}

- (void)fetchPoetryAndShowView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.poetryArray = [[WLCoreDataHelper shareHelper] fetchPoetryWithMainClass:@"99"];
        [self loadCustomView];
    });
   
}

- (void)readSoure
{
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"file" ofType:@".txt"];
    NSString *testSource = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *poetryArr = [testSource componentsSeparatedByString:@"======"];
    
    NSMutableArray *modelArray = [NSMutableArray array];
    for (int i = 0; i<poetryArr.count; i++) {
        NSArray *items = [[NSString stringWithFormat:@"%@",[poetryArr objectAtIndex:i]] componentsSeparatedByString:@"&&&"];
        PoetryModel *model = [[PoetryModel alloc]init];
        model.name = [items objectAtIndex:0];
        model.author = [items objectAtIndex:1];
        model.content = [items objectAtIndex:2];
        [modelArray addObject:model];
    }
    
    [[WLCoreDataHelper shareHelper]saveInBackgroundWithPeotryModelArray:modelArray withResult:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            
            
        }
    }];
    
    self.poetryArray = [[WLCoreDataHelper shareHelper] fetchAllPoetry];
    
    [self loadCustomView];
    
}

#pragma mark - 加载视图
- (void)loadCustomView
{
    self.mainTableView.backgroundColor = RGBCOLOR(246, 246, 246, 1.0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return self.poetryArray.count;
    }
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    }
    return 0.01;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        //第二个section为热门诗词
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH, 30)];
        headerView.backgroundColor = RGBCOLOR(246, 246, 246, 1.0);
        
        UILabel *poetryTipLabel = [[UILabel alloc]init];
        poetryTipLabel.text = @"热门·诗词";
        poetryTipLabel.font = [UIFont systemFontOfSize:14.f];
        poetryTipLabel.textColor = RGBCOLOR(100, 100, 100, 1.0);
        [headerView addSubview:poetryTipLabel];
        //元素的布局
        [poetryTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(headerView.mas_leading).offset(15);
            make.top.equalTo(headerView.mas_top).offset(5);
            make.trailing.equalTo(headerView.mas_trailing).offset(-15);
            make.height.mas_equalTo(20);
            
        }];
        
//        UIImageView *writeImage = [[UIImageView alloc]init];
//        writeImage.image = [UIImage imageNamed:@"writePoetry"];
//        [headerView addSubview:writeImage];
//        //元素的布局
//        [writeImage mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.equalTo(headerView.mas_top).offset(6);
//            make.trailing.equalTo(headerView.mas_trailing).offset(-60);
//            make.width.mas_equalTo(18);
//            make.height.mas_equalTo(18);
//
//        }];
//
//        UILabel *writeLabel = [[UILabel alloc]init];
//        writeLabel.text = @"创作";
//        writeLabel.font = [UIFont systemFontOfSize:14.f];
//        writeLabel.textColor = RGBCOLOR(100, 100, 100, 1.0);
//        [headerView addSubview:writeLabel];
//        //元素的布局
//        [writeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.leading.equalTo(writeImage.mas_trailing).offset(5);
//            make.top.equalTo(headerView.mas_top).offset(0);
//            make.bottom.equalTo(headerView.mas_bottom).offset(0);
//            make.trailing.equalTo(headerView.mas_trailing).offset(-15);
//
//        }];
//
//        UIButton *writeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [writeBtn addTarget:self action:@selector(writePoetryAction:) forControlEvents:UIControlEventTouchUpInside];
//        [headerView addSubview:writeBtn];
//        //元素的布局
//        [writeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.leading.equalTo(writeImage.mas_leading).offset(-10);
//            make.top.equalTo(headerView.mas_top).offset(0);
//            make.bottom.equalTo(headerView.mas_bottom).offset(-0);
//            make.trailing.equalTo(headerView.mas_trailing).offset(0);
//
//
//        }];
        
        return headerView;
        
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0) {
        //图片的高度
        CGFloat imageW = PhoneScreen_WIDTH-30;
        CGFloat imageH = imageW/2.88;//图片的比例是750：260
        //10 20 5 image 5 20
        return imageH+40;
        
        
    }else if (section == 1){
        
        //如果有缓存的高度，则不计算了
        
            //没有缓存的高度，则需要计算
            if (self.poetryArray.count > indexPath.row) {
                PoetryModel *model = [self.poetryArray objectAtIndex:indexPath.row];
                
                if (model.heightForCell > 0) {
                    return model.heightForCell;
                }
                
                if (indexPath.row == self.poetryArray.count-1) {
                    //最后一行需要调整一下间距
                    CGFloat cellHeight = [WLHomePoetryCell heightForLastCell:[self.poetryArray objectAtIndex:indexPath.row]];
                    model.heightForCell = cellHeight;
                    return cellHeight;
                }else{
                    CGFloat cellHeight = [WLHomePoetryCell heightForFirstLine:[self.poetryArray objectAtIndex:indexPath.row]];
                    
                    if (indexPath.row == 0) {
                        cellHeight -= 25;
                    }
                    model.heightForCell = cellHeight;
                    return cellHeight;
                }
            }

    }
    
    return 0.001;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0) {
        
        WLImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLImageCell"];
        if (!cell) {
            cell = [[WLImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WLImageCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = RGBCOLOR(246, 246, 246, 1.0);
        }
        [cell touchImageWithBlock:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self tapTheImage];
            });
        }];
        
        [cell loadCustomView];
        return cell;
        
    }else if (section == 1){
        PoetryModel *model = [self.poetryArray objectAtIndex:indexPath.row];
        WLHomePoetryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WLHomePoetryCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGBCOLOR(246, 246, 246, 1.0);
        if (!cell) {
            cell = [[WLHomePoetryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WLHomePoetryCell"];
            
            NSLog(@"====index:%ld %@",indexPath.row,cell);
        }
        if (indexPath.row == self.poetryArray.count-1) {
            cell.isLast = YES;
        }else{
            cell.isLast = NO;
        }
        if (indexPath.row == 0) {
            cell.isFirst = YES;
        }else{
            cell.isFirst = NO;
        }
        cell.dataModel = model;
        return cell;
    }
    
    
    return [[UITableViewCell alloc]init];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;

    if (section == 1) {
        //选中诗词的时候，跳转到详情
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.row < self.poetryArray.count) {
            
            PoetryDetailViewController *detailVC = [[PoetryDetailViewController alloc]init];
            detailVC.dataModel = self.poetryArray[indexPath.row];
            detailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
   
}
#pragma mark - 点击事件
- (void)writePoetryAction:(UIButton*)sender
{
    WritePoetryController *vc = [[WritePoetryController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)tapTheImage
{
    WLImageListController *vc = [[WLImageListController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 后台进程，添加所有的数据
- (void)checkLocalData
{
    NSArray *jsonList = [NSArray array];
    jsonList = [AppConfig config].allPoetryList;
    
    NSDictionary *jsonStateDic = [WLSaveLocalHelper loadObjectForKey:@"PoetryJsonStateDic"];
    self.jsonStateDic = [NSMutableDictionary dictionary];
    
    if (jsonStateDic && [jsonStateDic isKindOfClass:[NSDictionary class]] && jsonStateDic.allKeys.count == jsonList.count ) {
        
        self.jsonStateDic = [jsonStateDic mutableCopy];
        
        for (int i = 0; i < jsonStateDic.allKeys.count ;i++) {
            NSString *state = jsonStateDic.allValues[i];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                if (![state isEqualToString:@"1"]) {
                    [self readLocalFileWithName:jsonList[i] withKey:jsonStateDic.allKeys[i]];
                }
            });
            
            
        }
        
    }else{
        
        for (int i =0 ; i < jsonList.count; i++) {
            NSString *key = [NSString stringWithFormat:@"%@",jsonList[i]];
            [self.jsonStateDic setObject:@"0" forKey:key];
        }
        
        for (int i = 0; i < self.jsonStateDic.allValues.count ;i++) {
            NSString *state = self.jsonStateDic.allValues[i];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                if (![state isEqualToString:@"1"]) {
                    [self readLocalFileWithName:jsonList[i] withKey:self.jsonStateDic.allKeys[i]];
                }
                
            });
            
        }
        
        
        
    }
}

- (void)readLocalFileWithName:(NSString*)fileName withKey:(NSString*)key
{
    //从本地读取文件
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"]];
    //转为dic
    NSDictionary *poetryDic = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    NSInteger baseId = [[NSString stringWithFormat:@"%@",[poetryDic objectForKey:@"baseID"]]integerValue];
    
    //获取到诗词列表
    NSArray *poetryArr = [poetryDic objectForKey:@"poetryList"];
    NSString *poetryMainClass = [poetryDic objectForKey:@"mainClass"];
    
    NSMutableArray *modelArray = [NSMutableArray array];
    //将诗词model化
    for (int i = 0; i<poetryArr.count; i++) {
        NSDictionary *itemDic = [poetryArr objectAtIndex:i];
        PoetryModel *model = [[PoetryModel alloc]initModelWithDictionary:itemDic];
        model.mainClass = poetryMainClass;
        model.poetryID = [NSString stringWithFormat:@"%ld",(unsigned long)([model.poetryID integerValue]+baseId)];
        [modelArray addObject:model];
    }
    
    //存储到本地数据库
    [[WLCoreDataHelper shareHelper]saveInBackgroundWithPeotryModelArray:modelArray withResult:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //存储成功后更新状态
            [self.jsonStateDic setObject:@"1" forKey:key];
            [WLSaveLocalHelper saveObject:[self.jsonStateDic copy] forKey:@"PoetryJsonStateDic"];
            
        }
    }];
    
}

- (UIImageView*)mainBgView
{
    if (!_mainBgView) {
        _mainBgView = [[UIImageView alloc]init];
        _mainBgView.alpha = 0.5;
        _mainBgView.contentMode = UIViewContentModeScaleAspectFill;
        _mainBgView.clipsToBounds = YES;
        [self.view addSubview:_mainBgView];
        //元素的布局
        [_mainBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view.mas_leading).offset(0);
            make.top.equalTo(self.naviView.mas_bottom).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
            make.trailing.equalTo(self.view.mas_trailing).offset(0);
            
        }];
    }
    return _mainBgView;
}

- (UITableView*)mainTableView
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mainTableView registerClass:[WLHomePoetryCell class] forCellReuseIdentifier:@"WLHomePoetryCell"];
        [self.view addSubview:_mainTableView];
        

        //元素的布局
        [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view.mas_leading).offset(0);
            make.top.equalTo(self.naviView.mas_bottom).offset(0);
            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
            make.trailing.equalTo(self.view.mas_trailing).offset(0);
            
        }];
    }
    return _mainTableView;
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
