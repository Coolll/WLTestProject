//
//  BackupHelper.m
//  WLPoetryProject
//
//  Created by 变啦 on 2019/10/29.
//  Copyright © 2019 龙培. All rights reserved.
//

#import "BackupHelper.h"
#import "NetworkHelper.h"
#import "PoetryModel.h"

@interface BackupHelper()
/**
 *  network
 **/
@property (nonatomic,strong) NetworkHelper *networkHelper;
/**
 *  诗词的条数
 **/
@property (nonatomic,assign) NSInteger poetryCount;


@end
@implementation BackupHelper
+ (BackupHelper *)shareInstance{
    static BackupHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[BackupHelper alloc] init];
        helper.networkHelper = [NetworkHelper shareHelper];
    });
    return helper;
}

- (void)uploadAllImages{
//    [[AppConfig config] loadClassImageWithBlock:^(NSDictionary *dic) {
//
//        NSArray *keysArray = dic.allKeys;
//        for (int i = 0; i < keysArray.count; i++) {
//
//            NSString *key = [keysArray objectAtIndex:i];
//            NSString *url = [dic objectForKey:key];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i+1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                NSMutableDictionary *param = [NSMutableDictionary dictionary];
//                [param setObject:url forKey:@"image_url"];
//                [param setObject:key forKey:@"class_info"];
//
//                [self.networkHelper uploadImage:param];
//            });
//        }
//
//
//    }];
}

#pragma mark - 将本地json上传到服务器

- (void)updateAllPoetry{
    NSArray *jsonList = [NSArray array];
    jsonList = [AppConfig config].allPoetryList;
   
    [self updatePoetryWithFileArray:jsonList withCurrentJsonIndex:0 withCurrentIndex:0];
}

- (void)updateRecommendPoetry{
    NSArray *poetryModelArray = [self readLocalFileWithName:@"recommendPoetrySix"];

    NSInteger time = 0;
    for (NSInteger i = poetryModelArray.count-1; i >= 0; i--) {
        time +=3 ;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PoetryModel *model = poetryModelArray[i];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:model.poetryID forKey:@"poetry_id"];
            [dic setObject:model.name forKey:@"name"];
            [dic setObject:model.author forKey:@"author"];
            [dic setObject:model.content forKey:@"content"];
            [dic setObject:model.addtionInfo forKey:@"addition_info"];
            [dic setObject:model.classInfo forKey:@"class_info"];
            [dic setObject:model.classInfoExplain forKey:@"class_info_explain"];
            [dic setObject:model.mainClass forKey:@"main_class"];
            [dic setObject:model.mainClassExplain forKey:@"main_class_explain"];
            [dic setObject:model.source forKey:@"source"];
            [dic setObject:model.sourceExplain forKey:@"source_explain"];
            [dic setObject:model.transferInfo forKey:@"transfer_info"];
            [dic setObject:model.analysesInfo forKey:@"analyses_info"];
            [dic setObject:model.backgroundInfo forKey:@"background_info"];
            [dic setObject:[NSNumber numberWithInteger:model.likes] forKey:@"likes"];

            [self.networkHelper updateOrInsertPoetry:dic];

        });
    }
}



- (void)updatePoetryWithFileArray:(NSArray*)jsonList withCurrentJsonIndex:(NSInteger)currentJsonIndex withCurrentIndex:(NSInteger)currentIndex{
    if (currentJsonIndex >= jsonList.count) {
        return;
    }
    NSString *jsonName = [jsonList objectAtIndex:currentJsonIndex];

    NSArray *poetryModelArray = [self readLocalFileWithName:jsonName];
    NSLog(@"jsonName:%@ count:%ld",jsonName,poetryModelArray.count);

    if (currentIndex < poetryModelArray.count) {
        PoetryModel *model = poetryModelArray[currentIndex];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:model.poetryID forKey:@"poetry_id"];
        [dic setObject:model.name forKey:@"name"];
        [dic setObject:model.author forKey:@"author"];
        [dic setObject:model.content forKey:@"content"];
        [dic setObject:model.addtionInfo forKey:@"addition_info"];
        [dic setObject:model.classInfo forKey:@"class_info"];
        [dic setObject:model.classInfoExplain forKey:@"class_info_explain"];
        [dic setObject:model.mainClass forKey:@"main_class"];
        [dic setObject:model.mainClassExplain forKey:@"main_class_explain"];
        [dic setObject:model.source forKey:@"source"];
        [dic setObject:model.sourceExplain forKey:@"source_explain"];
        [dic setObject:model.transferInfo forKey:@"transfer_info"];
        [dic setObject:model.analysesInfo forKey:@"analyses_info"];
        [dic setObject:model.backgroundInfo forKey:@"background_info"];
        [dic setObject:[NSNumber numberWithInteger:model.likes] forKey:@"likes"];


        [self.networkHelper updatePoetry:dic];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updatePoetryWithFileArray:jsonList withCurrentJsonIndex:currentJsonIndex withCurrentIndex:(currentIndex+1)];
        });
    }else{
        [self updatePoetryWithFileArray:jsonList withCurrentJsonIndex:(currentJsonIndex+1) withCurrentIndex:0];
    }

}


- (void)uploadAllPoetry{
    NSArray *jsonList = [NSArray array];
    jsonList = [AppConfig config].allPoetryList;
    
    for (int i = 0; i < jsonList.count ;i++) {
        
        NSArray *poetryModelArray = [self readLocalFileWithName:jsonList[i]];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((i+1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        for (int j = 0 ; j < poetryModelArray.count;j++ ) {
            
            PoetryModel *model = poetryModelArray[j];
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
                [dic setObject:[NSNumber numberWithInteger:model.likes] forKey:@"likes"];
                [self.networkHelper uploadPoetry:dic];
            }
        
        });

        
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
    else if([classInfo isEqualToString:@"111"]){return @"自然风光";}
    else if([classInfo isEqualToString:@"112"]){return @"安慰他人";}
    else if([classInfo isEqualToString:@"113"]){return @"轻松愉悦";}
    else if([classInfo isEqualToString:@"114"]){return @"潇洒飘逸";}
    else if([classInfo isEqualToString:@"115"]){return @"豪情壮志";}
    else if([classInfo isEqualToString:@"116"]){return @"孤寂";}
    else if([classInfo isEqualToString:@"117"]){return @"豪迈不羁";}
    else if([classInfo isEqualToString:@"118"]){return @"孤芳自赏";}
    else if([classInfo isEqualToString:@"119"]){return @"得意";}
    else if([classInfo isEqualToString:@"120"]){return @"勉励";}
    else if([classInfo isEqualToString:@"121"]){return @"高风亮节";}
    else if([classInfo isEqualToString:@"122"]){return @"批判";}
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
    else if([classInfo isEqualToString:@"1400"]){return @"论语";}
    else if([classInfo isEqualToString:@"1501"]){return @"登科后";}
    else if([classInfo isEqualToString:@"1502"]){return @"离思 其四";}
    else if([classInfo isEqualToString:@"1503"]){return @"逢雪宿芙蓉山";}
    else if([classInfo isEqualToString:@"1504"]){return @"白头吟";}
    else if([classInfo isEqualToString:@"1505"]){return @"山园小梅";}
    else if([classInfo isEqualToString:@"1506"]){return @"寒菊";}
    else if([classInfo isEqualToString:@"1507"]){return @"雪梅";}
    else if([classInfo isEqualToString:@"1508"]){return @"登乐游原";}
    else if([classInfo isEqualToString:@"1509"]){return @"春日";}
    else if([classInfo isEqualToString:@"1510"]){return @"清平乐 六盘山";}
    else if([classInfo isEqualToString:@"1511"]){return @"望江南 超然台作";}
    else if([classInfo isEqualToString:@"1512"]){return @"赠花卿";}
    else if([classInfo isEqualToString:@"1513"]){return @"陋室铭";}
    else if([classInfo isEqualToString:@"1514"]){return @"浪淘沙";}
    else if([classInfo isEqualToString:@"1515"]){return @"南陵别儿童入京";}
    else if([classInfo isEqualToString:@"1516"]){return @"木兰花·拟古决绝词柬友";}
    else if([classInfo isEqualToString:@"1517"]){return @"冬夜读书示子聿";}
    else if([classInfo isEqualToString:@"1518"]){return @"山亭夏日";}
    else if([classInfo isEqualToString:@"1519"]){return @"上堂开示颂";}
    else if([classInfo isEqualToString:@"1520"]){return @"浣溪沙·细雨斜风作晓寒";}
    else if([classInfo isEqualToString:@"1521"]){return @"题菊花";}
    else if([classInfo isEqualToString:@"1522"]){return @"春江花月夜";}
    else if([classInfo isEqualToString:@"1523"]){return @"蝶恋花·阅尽天涯离别苦";}
    else if([classInfo isEqualToString:@"1524"]){return @"春雪";}
    else if([classInfo isEqualToString:@"1525"]){return @"采桑子·而今才道当时错";}
    else if([classInfo isEqualToString:@"1526"]){return @"南歌子词二首";}
    else if([classInfo isEqualToString:@"1527"]){return @"临江仙·送钱穆父";}
    else if([classInfo isEqualToString:@"1528"]){return @"寄黄几复";}
    else if([classInfo isEqualToString:@"1529"]){return @"宿骆氏亭寄怀崔雍崔衮";}
//    else if([classInfo isEqualToString:@"<##>"]){return @"<##>";}

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
    //1为古诗三百首 2为唐诗三百首 3为宋词三百首 4诗经 10为早教古诗100首 11为小学古诗 12初中古诗 13近代诗词 14高中古诗 15高中文言 16楚辞 17学前必背诗词 18学前必读诗词 20经典诗词 21唐诗 22宋词 23宋诗
    //source 论语 100学而篇 101为政篇 102八佾篇 103里仁篇 104公冶长篇 105雍也篇 106述而篇 107泰伯篇 108子罕篇 109乡党篇 110先进篇 111颜渊篇 112子路篇 113宪问篇 114卫灵公篇 115季氏篇 116阳货篇 117微子篇 118子张篇 119尧曰篇
    if ([source isEqualToString:@"1"]) {return @"古诗三百首";}
    else if ([source isEqualToString:@"2"]){return @"唐诗三百首";}
    else if ([source isEqualToString:@"3"]){return @"宋词三百首";}
    else if ([source isEqualToString:@"4"]){return @"诗经";}
    else if ([source isEqualToString:@"10"]){return @"早教古诗100首";}
    else if ([source isEqualToString:@"11"]){return @"小学古诗";}
    else if ([source isEqualToString:@"12"]){return @"初中古诗";}
    else if ([source isEqualToString:@"13"]){return @"近代诗词";}
    else if ([source isEqualToString:@"14"]){return @"高中古诗";}
    else if ([source isEqualToString:@"15"]){return @"高中文言";}
    else if ([source isEqualToString:@"16"]){return @"楚辞";}
    else if ([source isEqualToString:@"17"]){return @"学前必背诗词";}
    else if ([source isEqualToString:@"18"]){return @"学前必读诗词";}
    else if ([source isEqualToString:@"19"]){return @"飞花令";}
    else if ([source isEqualToString:@"20"]){return @"经典诗词";}
    else if ([source isEqualToString:@"21"]){return @"唐诗";}
    else if ([source isEqualToString:@"22"]){return @"宋词";}
    else if ([source isEqualToString:@"23"]){return @"宋诗";}
    else if ([source isEqualToString:@"24"]){return @"元曲";}
    else if ([source isEqualToString:@"25"]){return @"清代诗词";}
    else if ([source isEqualToString:@"26"]){return @"明诗";}
    else if ([source isEqualToString:@"27"]){return @"古代词";}
    else if ([source isEqualToString:@"28"]){return @"明词";}
    else if ([source isEqualToString:@"99"]){return @"其他";}
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

- (NSInteger)dealLikesWithSource:(NSString*)source{
    //1为古诗三百首 2为唐诗三百首 3为宋词三百首 4诗经 10为早教古诗100首 11为小学古诗 12初中古诗 13近代诗词 14高中古诗 15高中文言 16楚辞 17学前必背诗词 18学前必读诗词
    //source 论语 100学而篇 101为政篇 102八佾篇 103里仁篇 104公冶长篇 105雍也篇 106述而篇 107泰伯篇 108子罕篇 109乡党篇 110先进篇 111颜渊篇 112子路篇 113宪问篇 114卫灵公篇 115季氏篇 116阳货篇 117微子篇 118子张篇 119尧曰篇
    if ([source isEqualToString:@"1"]) {return [self randomNumberBetween:15 to:240];}
    else if ([source isEqualToString:@"2"]){return [self randomNumberBetween:15 to:600];}
    else if ([source isEqualToString:@"3"]){return [self randomNumberBetween:20 to:300];}
    else if ([source isEqualToString:@"4"]){return [self randomNumberBetween:6 to:120];}
    else if ([source isEqualToString:@"10"]){return [self randomNumberBetween:10 to:300];}
    else if ([source isEqualToString:@"11"]){return [self randomNumberBetween:3 to:280];}
    else if ([source isEqualToString:@"12"]){return [self randomNumberBetween:40 to:400];}
    else if ([source isEqualToString:@"13"]){return [self randomNumberBetween:40 to:200];}
    else if ([source isEqualToString:@"14"]){return [self randomNumberBetween:10 to:500];}
    else if ([source isEqualToString:@"15"]){return [self randomNumberBetween:5 to:200];}
    else if ([source isEqualToString:@"16"]){return [self randomNumberBetween:5 to:50];}
    else if ([source isEqualToString:@"17"]){return [self randomNumberBetween:5 to:200];}
    else if ([source isEqualToString:@"18"]){return [self randomNumberBetween:5 to:100];}
    else if ([source isEqualToString:@"19"]){return [self randomNumberBetween:5 to:100];}
    else if ([source isEqualToString:@"20"]){return [self randomNumberBetween:500 to:620];}
    else if ([source isEqualToString:@"100"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"101"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"102"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"103"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"104"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"105"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"106"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"107"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"108"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"109"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"110"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"111"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"112"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"113"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"114"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"115"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"116"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"117"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"118"]){return [self randomNumberBetween:1 to:99];}
    else if ([source isEqualToString:@"119"]){return [self randomNumberBetween:1 to:99];}
    
    return [self randomNumberBetween:0 to:999];
}


- (NSInteger)randomNumberBetween:(NSInteger)from to:(NSInteger)to{
    return (from + (arc4random()%(to-from)));
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
        NSString *likes = [itemDic objectForKey:@"likes"];
        if (!likes || likes.length == 0) {
            model.likes = [self dealLikesWithSource:model.source];
        }else{
            model.likes = [likes integerValue];
        }
        [modelArray addObject:model];
    }
    
    return modelArray;
    
}


@end
