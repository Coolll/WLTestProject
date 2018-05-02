//
//  WLUserAgreementView.m
//  YLPokerSpeak
//
//  Created by 龙培 on 17/8/15.
//  Copyright © 2017年 龙培. All rights reserved.
//

#import "WLUserAgreementView.h"

typedef void(^UserAgreementBlock)(BOOL isAgree);

@interface WLUserAgreementView ()

/**
 *  是否同意
 **/
@property (nonatomic,copy) UserAgreementBlock userBlock;


@end

@implementation WLUserAgreementView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH, PhoneScreen_HEIGHT)];
    
    if (self) {
        
        [self loadCustomView];
    }
    
    return self;
}


- (void)loadCustomView
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PhoneScreen_WIDTH, PhoneScreen_HEIGHT)];
    bgView.backgroundColor = RGBCOLOR(10, 10, 10, 1.0);
    bgView.alpha = 0.6;
    bgView.userInteractionEnabled = YES;
    [self addSubview:bgView];
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheBackView:)];
    [bgView addGestureRecognizer:bgTap];
    
    
    CGFloat space = 22;
    CGFloat viewHeight = PhoneScreen_HEIGHT > 600 ? 500 : 460;
    
    UIScrollView *contentScrollView = [[UIScrollView alloc]init];
    contentScrollView.frame = CGRectMake(space, (PhoneScreen_HEIGHT-viewHeight)/2, PhoneScreen_WIDTH-space*2, viewHeight-60);
    contentScrollView.backgroundColor = RGBCOLOR(240, 240, 240, 1.0);
    contentScrollView.layer.cornerRadius = 6.0f;
    contentScrollView.clipsToBounds = YES;
    [self addSubview:contentScrollView];
    
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.font = [UIFont systemFontOfSize:14.0];
    contentLabel.backgroundColor = RGBCOLOR(240, 240, 240, 1.0);
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor blackColor];
    [contentScrollView addSubview:contentLabel];
    

//    NSString *originString = @"汉皇重色思倾国，御宇多年求不得。杨家有女初长成，养在深闺人未识。天生丽质难自弃，一朝选在君王侧。回眸一笑百媚生，六宫粉黛无颜色。春寒赐浴华清池，温泉水滑洗凝脂。侍儿扶起娇无力，始是新承恩泽时。云鬓花颜金步摇，芙蓉帐暖度春宵。春宵苦短日高起，从此君王不早朝。承欢侍宴无闲暇，春从春游夜专夜。后宫佳丽三千人，三千宠爱在一身。金屋妆成娇侍夜，玉楼宴罢醉和春。姊妹弟兄皆列土，可怜光彩生门户。遂令天下父母心，不重生男重生女。骊宫高处入青云，仙乐风飘处处闻。缓歌慢舞凝丝竹，尽日君王看不足。渔阳鼙鼓动地来，惊破霓裳羽衣曲。九重城阙烟尘生，千乘万骑西南行。翠华摇摇行复止，西出都门百余里。六军不发无奈何，宛转蛾眉马前死。花钿委地无人收，翠翘金雀玉搔头。君王掩面救不得，回看血泪相和流。黄埃散漫风萧索，云栈萦纡登剑阁。峨嵋山下少人行，旌旗无光日色薄。蜀江水碧蜀山青，圣主朝朝暮暮情。行宫见月伤心色，夜雨闻铃肠断声。天旋地转回龙驭，到此踌躇不能去。马嵬坡下泥土中，不见玉颜空死处。君臣相顾尽沾衣，东望都门信马归。归来池苑皆依旧，太液芙蓉未央柳。芙蓉如面柳如眉，对此如何不泪垂。春风桃李花开日，秋雨梧桐叶落时。西宫南内多秋草，落叶满阶红不扫。梨园弟子白发新，椒房阿监青娥老。夕殿萤飞思悄然，孤灯挑尽未成眠。迟迟钟鼓初长夜，耿耿星河欲曙天。鸳鸯瓦冷霜华重，翡翠衾寒谁与共。悠悠生死别经年，魂魄不曾来入梦。临邛道士鸿都客，能以精诚致魂魄。为感君王辗转思，遂教方士殷勤觅。排空驭气奔如电，升天入地求之遍。上穷碧落下黄泉，两处茫茫皆不见。忽闻海上有仙山，山在虚无缥渺间。楼阁玲珑五云起，其中绰约多仙子。中有一人字太真，雪肤花貌参差是。金阙西厢叩玉扃，转教小玉报双成。闻道汉家天子使，九华帐里梦魂惊。揽衣推枕起徘徊，珠箔银屏迤逦开。云鬓半偏新睡觉，花冠不整下堂来。风吹仙袂飘飘举，犹似霓裳羽衣舞。玉容寂寞泪阑干，梨花一枝春带雨。含情凝睇谢君王，一别音容两渺茫。昭阳殿里恩爱绝，蓬莱宫中日月长。回头下望人寰处，不见长安见尘雾。惟将旧物表深情，钿合金钗寄将去。钗留一股合一扇，钗擘黄金合分钿。但教心似金钿坚，天上人间会相见。临别殷勤重寄词，词中有誓两心知。七月七日长生殿，夜半无人私语时。在天愿作比翼鸟，在地愿为连理枝。天长地久有时尽，此恨绵绵无绝期。";
    NSString *originString = @"用户注册协议\n\n在您注册成为”扑客说”的会员之前，请您认真阅读本用户注册协议。 您必须完全同意以下所有条款，方能成为”扑客说”的会员。\n\n第一条 会员服务条款的确认和接纳\n\n  “扑客说”在线服务涉及的”扑客说”在线产品的所有权以及相关软件的知识产权归”扑客说” 所有。 本服务条款的效力范围及于”扑客说”的一切产品和服务， 用户在享受”扑客说”任何单项服务时，应当受本服务条款的约束。用户通过进入注册程序并点击“我接受”按钮，即表示用户与”扑客说”已达成协议，自愿接受本服务条款的所有内容。当用户使用”扑客说”各单项服务时， 用户的使用行为视为其对该单项服务的服务条款以及“扑客说”在该单项服务中发出的各类公告表示同意。\n\n第二条 网站服务简介\n\n  “扑客说”运用自己的操作系统通过国际互联网为用户提供各项服务。用户必须：\n\n（1）提供设备，包括个人计算机、调制解调器等上网装置。\n\n（2）个人承担个人上网而产生的通讯费用。\n\n考虑到”扑客说”产品服务的重要性，用户同意：\n\n（1）提供及时、详尽及准确的个人资料。\n\n（2）不断更新注册资料，符合及时、详尽准确的要求。所有原始键入的资料将引用为注册资料。另外，”扑客说”不能擅自公开用户的姓名、住址、出件地址、电子邮箱、账号。除非：\n\n（1）用户要求”扑客说”或授权某人通过电子邮件服务透露这些信息。\n\n（2）用户个人在”扑客说”论坛或者其他公共媒体自主发布或者透露这些信息。（3）相应的法律、法规要求及程序服务需要”扑客说”提供用户的个人资料。\n\n  如果用户提供的资料不准确、 不真实、 不合法有效， “扑客说”保留结束用户使用”扑客说”各项服务的权利。用户在享用”扑客说”各项服务的同时，同意接受”扑客说”提供的各类信息服务。\n\n第三条 会员条款的修改\n\n  “扑客说”有权在必要时修改本会员条款以及各单项服务的相关条款。 用户在享受单项服务时，应当及时查阅了解修改的内容，并自觉遵守本服务条款以及该单项服务的相关条款。\n\n第四条 服务修订\n\n  “扑客说”保留随时修改或中断服务而不需通知用户的权利。 用户接受”扑客说”行使修改或中断服务的权利，”扑客说”不需对用户或第三方负责。\n\n第五条 用户隐私制度\n\n  我们承诺： 对您的个人信息的隐私和安全将给予特别保护。 访问这些个人信息的权限仅限于需要进行此类访问以完成其工作的人员。在未经访问者授权同意的情况下， “扑客说”不会将访问者的个人资料泄露给第三方。 但以下情况除外，且”扑客说”不承担任何法律责任：\n\n（1）根据执法单位之要求或为公共之目的向相关单位提供个人资料。\n\n（2）由于您将用户密码告知他人或与他人共享注册账户，由此导致的任何个人资料泄露。\n\n（3）由于计算机 2000 年问题、黑客攻击、计算机病毒侵入或发作、因政府管制而造成的暂时性关闭等影响网络正常经营之不可抗力而造成的个人资料泄露、 丢失、被盗用或被篡改等。\n\n（4）由于与”扑客说”链接的其他网站造成之个人资料泄露及由此而导致的任何法律争议和后果。\n\n（5）为免除访问者在生命、身体或财产方面之急迫危险。\n\n（6）”扑客说”会与其他网站链接，但不对其他网站的隐私政策及内容负责。\n\n此外，用户同意若发现任何非法使用用户账号或安全漏洞的情况，立即通告”扑客说”。\n\n第六条 拒绝提供担保和免责声明\n\n  用户明确同意使用”扑客说”服务的风险由用户个人承担。 “扑客说”明确表示不提供任何类型的担保， 不论是明确的或隐含的， 但是对商业性的隐含担保， 特定目的和不违反规定的适当担保除外。 “扑客说”不担保服务一定能满足用户的要求， 也不担保服务不会中断， 对服务的及时性、安全性、真实性、出错发生都不做担保。”扑客说”拒绝提供任何担保，包括信息能否准确、 及时、 顺利地传送。 用户理解并接受下载或通过”扑客说”产品服务取得的任何信息资料取决于用户自己，并由其承担系统受损、资料丢失以及其他任何风险。\n\n第七条 有限责任\n\n  “扑客说”对直接、间接、偶然、特殊及继起的损害不负责任，这些损害来自：不正当使用产品服务， 在网上购买商品或类似服务， 在网上进行交易， 非法使用服务或用户传送的信息有所变动。这些损害会导致”扑客说”形象受损，所以”扑客说”早已提出这种损害的可能性。\n\n第八条 “扑客说”论坛信息的储存及限制\n\n  “扑客说”不对用户所发布信息的删除或储存失败负责。 “扑客说”保留判定用户的行为是否符合”扑客说”服务条款的要求和精神的权利， 如果用户违背了服务条款的规定，则”扑客说”可以中断服务账号。 在”扑客说”论坛内， 无论是用户原创或是用户得到著作权人授权转载的作品， 用户上载的行为即意味着用户或用户代理的著作权人授权”扑客说”对上载作品享有不可撤销的永久的使用权和收益权， 同时”扑客说”对用户上传的资料的知识产权问题引发的任何不良后果不承担责任，由用户个人负责。\n\n第九条 用户管理\n\n  用户单独承担发布内容的责任。用户对服务的使用是根据所有适用于服务的地方法律、国家法律和国际法律标准的。用户承诺：\n\n1．在”扑客说”的网页上发布信息或者利用”扑客说”的服务时必须符合中国有关法规，不得在”扑客说”的网页上或者利用”扑客说”的服务制作、复制、发布、传播以下信息：\n\n（1）反对宪法所确定的基本原则的。\n\n（2）危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的。\n\n（3）损害国家荣誉和利益的。\n\n（4）煽动民族仇恨、民族歧视，破坏民族团结的。\n\n（5）破坏国家宗教政策，宣扬邪教和封建迷信的。\n\n（6）散布谣言，扰乱社会秩序，破坏社会稳定的。\n\n（7）散布淫秽、色情、赌博、暴力、凶杀、恐怖内容或者教唆犯罪的。\n\n（8）侮辱或者诽谤他人，侵害他人合法权益的。\n\n（9）含有法律、行政法规禁止的其他内容的。\n\n2．在”扑客说”的网页上发布信息或者利用”扑客说”的服务时，还必须符合其他有关国家和地区的法律规定以及国际法的有关规定。\n\n3．不利用”扑客说”的服务从事以下活动：\n\n（1）未经允许，进入计算机信息网络或者使用计算机信息网络资源的。\n\n（2）未经允许，对计算机信息网络功能进行删除、修改或者增加的。\n\n（3）未经允许，对进入计算机信息网络中存储、处理或者传输的数据和应用程序进行删除、修改或者增加的。\n\n（4）故意制作、传播计算机病毒等破坏性程序的。（5）其他危害计算机信息网络安全的行为。\n\n4．不以任何方式干扰”扑客说”的服务。\n\n5．遵守”扑客说”的其他规定和程序。\n\n  用户须对自己在使用”扑客说”服务过程中的行为承担法律责任。 用户承担法律责任的形式包括但不限于： 对受到侵害者进行赔偿， 在”扑客说”首先承担了因用户行为导致的行政处罚或侵权损害赔偿责任后， 用户应给予”扑客说”等额赔偿。 用户理解， 如果”扑客说”发现其网站传输的信息明显属于第九条第一款所列内容之一，依据中国法律，”扑客说”有义务立即停止传输保存有关记录，向国家有关机关报告，并且删除含有该内容的地址、目录或关闭服务器。\n\n  用户使用”扑客说”论坛服务进行信息发布条件的行为，也须遵守本条的规定。\n\n  若用户的行为不符合以上提到的服务条款， “扑客说”将作出独立判断立即取消用户服务账号。\n\n第十条 结束服务\n\n  用户或”扑客说”可随时根据实际情况中断服务。 “扑客说”有权单方不经通知终止向用户提供某一项或多项服务； 用户有权单方不经通知终止接受”扑客说”的服务。 如用户选择成为”扑客说” 的VIP 会员，则服务的延续或者终止根据用户接受的专门服务协议来进行。结束用户服务后， 用户使用”扑客说”服务的权利立即终止。 从那时起， “扑客说”不再对用户承担任何义务。\n\n第十一条 通知\n\n  所有发给用户的通知都可通过电子邮件、 常规信件或在网站显著位置公告的方式进行传送。 “扑客说”将通过上述方法之一将消息传递给用户， 告知他们服务条款的修改、 服务变更或其他重要事情。\n\n第十二条 参与广告策划\n\n  在”扑客说”许可下用户可在他们发表的信息中加入宣传资料或参与广告策划， 在”扑客说”各项服务上展示他们的产品。任何这类促销方法，包括运输货物、付款、服务、商业条件、担保及与广告有关的描述都只是在相应的用户和广告销售商之间发生，”扑客说”不承担任何责任，”扑客说”没有义务为这类广告销售负任何一部分的责任。\n\n第十三条 内容的所有权\n\n  内容的定义包括：文字、软件、声音、相片、录像、图表；在广告中的全部内容；电子邮件系统的全部内容； “扑客说”论坛为用户提供的商业信息。 所有这些内容均属于”扑客说”， 并受版权、商标、标签和其他财产所有权法律的保护。所以，用户只能在”扑客说”授权下才能使用这些内容，而不能擅自复制、再造这些内容或创造与这些内容有关的派生产品。\n\n第十四条 法律\n\n  用户和”扑客说”一致同意有关本协议以及使用”扑客说”的服务产生的争议交由仲裁解决， 但是”扑客说”有权选择采取诉讼方式， 并有权选择受理该诉讼的有管辖权的法院。若有任何服务条款与法律相抵触， 这些条款将按尽可能接近的方法重新解析， 而其他条款则保持对用户产生法律效力和影响。\n\n第十五条 “扑客说”会员所含服务的信息储存及安全\n\n  “扑客说”将尽力维护其会员所享有服务的安全性及方便性， 但对服务中出现的信息删除或储存失败不承担任何责任。 另外， 我们保留判定用户的行为是否符合”扑客说”服务条款的要求的权利，如果用户违背了会员服务条款的规定，将会中断其会员服务账号。\n\n第十六条 青少年用户特别提示\n\n  青少年用户必须遵守全国青少年网络文明公约： 要善于网上学习， 不浏览不良信息； 要诚实友好交流，不侮辱欺诈他人；要增强自护意识，不随意约会网友；要维护网络安全，不破坏网络秩序；要有益身心健康，不沉溺虚拟时空。您必须完全同意并接受以上所有条款。";
    
    CGFloat contentSpace = 19;
    CGFloat width = PhoneScreen_WIDTH-space*2-contentSpace*2;
    
    CGFloat textHeight = [self heightForString:originString fontSize:14.0 andWidth:width];
    
    if (PhoneScreen_HEIGHT < 650) {
        textHeight -= 180;
    }else if(PhoneScreen_HEIGHT < 700){
        textHeight -= 80;
    }
    
    contentScrollView.showsHorizontalScrollIndicator = NO;
    contentLabel.text = originString;
    contentLabel.textColor = RGBCOLOR(160, 160, 160, 1.0);
    contentLabel.frame = CGRectMake(contentSpace, contentSpace, PhoneScreen_WIDTH-space*2-contentSpace*2, textHeight);
    contentScrollView.contentSize = CGSizeMake(width+contentSpace*2, textHeight+contentSpace*2);

    CGFloat labelTop = 10;
    CGFloat labelHeight = 50;
    
//    UIView *whiteView = [[UIView alloc]init];
//    whiteView.backgroundColor = [UIColor blackColor];
//    whiteView.frame = CGRectMake(space, PhoneScreen_HEIGHT-bottom+labelTop, width, labelHeight);
//    [bgView addSubview:whiteView];
    
    UILabel *disagreeLabel = [[UILabel alloc]init];
    disagreeLabel.frame = CGRectMake(space, contentScrollView.frame.origin.y+contentScrollView.frame.size.height+labelTop, width/2+contentSpace, labelHeight);
    disagreeLabel.text = @"不同意";
    disagreeLabel.font = [UIFont systemFontOfSize:16.0];
    disagreeLabel.textColor = RGBCOLOR(156, 156, 156, 1.0);
    disagreeLabel.textAlignment = NSTextAlignmentCenter;
    disagreeLabel.backgroundColor = [UIColor whiteColor];
    disagreeLabel.userInteractionEnabled = YES;
    [bgView addSubview:disagreeLabel];
    
    UITapGestureRecognizer *disagreeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheDisagreeView:)];
    [disagreeLabel addGestureRecognizer:disagreeTap];
    
    
    [[WLPublicTool shareTool] addCornerForView:disagreeLabel withTopLeft:YES withTopRight:NO withBottomLeft:YES withBottomRight:NO withCornerRadius:5.0];
    
    
    UILabel *agreeLabel = [[UILabel alloc]init];
    agreeLabel.frame = CGRectMake(space+width/2, contentScrollView.frame.origin.y+contentScrollView.frame.size.height+labelTop, width/2+contentSpace, labelHeight);
    agreeLabel.backgroundColor = RGBCOLOR(40, 170, 240, 1.0);
    agreeLabel.textAlignment = NSTextAlignmentCenter;
    agreeLabel.text = @"同意";
    agreeLabel.alpha = 1.0;
    agreeLabel.font = [UIFont systemFontOfSize:16.0];
    agreeLabel.textColor = [UIColor whiteColor];
    agreeLabel.userInteractionEnabled = YES;
    [bgView addSubview:agreeLabel];
    
    UITapGestureRecognizer *agreeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTheAgreeView:)];
    [agreeLabel addGestureRecognizer:agreeTap];
    
    [[WLPublicTool shareTool] addCornerForView:agreeLabel withTopLeft:NO withTopRight:YES withBottomLeft:NO withBottomRight:YES withCornerRadius:5.0];
    
    
}

- (void)tapTheBackView:(UITapGestureRecognizer*)tap
{
    [UIView animateWithDuration:0.35 animations:^{
       
        self.hidden = YES;
    }];
}

- (void)showAgreementView
{
    [UIView animateWithDuration:0.35 animations:^{
        
        self.hidden = NO;
    }];
}


- (void)tapTheAgreeView:(UITapGestureRecognizer*)tap
{
    if (self.userBlock) {
        self.userBlock(YES);
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        
        self.hidden = YES;
    }];
}

- (void)tapTheDisagreeView:(UITapGestureRecognizer*)tap
{
    if (self.userBlock) {
        self.userBlock(NO);
    }
    [UIView animateWithDuration:0.35 animations:^{
        
        self.hidden = YES;
    }];
}

//画圆角
- (void)addCornerForView:(UIView*)view withTopLeft:(BOOL)topLeft withTopRight:(BOOL)topRight withBottomLeft:(BOOL)bottomLeft withBottomRight:(BOOL)bottomRight withCornerRadius:(CGFloat)cornerR
{
    CGFloat viewWidth = view.frame.size.width;
    CGFloat viewHeight = view.frame.size.height;
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    [path moveToPoint:CGPointMake(0, viewHeight-cornerR)];
    if (topLeft) {
        [path addLineToPoint:CGPointMake(0, cornerR)];
        [path addQuadCurveToPoint:CGPointMake(cornerR, 0) controlPoint:CGPointMake(0, 0)];
    }else{
        [path addLineToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(cornerR, 0)];
    }
    
    [path addLineToPoint:CGPointMake(viewWidth-cornerR, 0)];
    
    if (topRight) {
        [path addQuadCurveToPoint:CGPointMake(viewWidth, cornerR) controlPoint:CGPointMake(viewWidth, 0)];
    }else{
        [path addLineToPoint:CGPointMake(viewWidth, 0)];
        [path addLineToPoint:CGPointMake(viewWidth, cornerR)];
    }
    
    
    [path addLineToPoint:CGPointMake(viewWidth, viewHeight-cornerR)];
    
    if (bottomRight) {
        [path addQuadCurveToPoint:CGPointMake(viewWidth-cornerR, viewHeight) controlPoint:CGPointMake(viewWidth, viewHeight)];
    }else{
        [path addLineToPoint:CGPointMake(viewWidth, viewHeight)];
        [path addLineToPoint:CGPointMake(viewWidth-cornerR, viewHeight)];
    }
    
    [path addLineToPoint:CGPointMake(cornerR, viewHeight)];
    
    if (bottomLeft) {
        [path addQuadCurveToPoint:CGPointMake(0, viewHeight-cornerR) controlPoint:CGPointMake(0, viewHeight)];
    }else{
        [path addLineToPoint:CGPointMake(0, viewHeight)];
        [path addLineToPoint:CGPointMake(0, viewHeight-cornerR)];
    }
    
    
    
    //构建图形
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    //这里的frame要注意
    maskLayer.frame = view.bounds;
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    view.layer.mask = maskLayer;
    
}


//计算textView的高度方法
-(CGFloat) heightForString:(NSString *)valueString fontSize:(float)fontSize andWidth:(float)width
{
    UITextView *detailTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    detailTextView.font = [UIFont systemFontOfSize:fontSize];
    detailTextView.text = valueString;
    CGSize bestSize = [detailTextView sizeThatFits:CGSizeMake(width,CGFLOAT_MAX)];
    return bestSize.height;
}


- (void)clickButtonWithBlock:(void(^)(BOOL isAgree))block
{
    if (block) {
        self.userBlock = block;
        
    }
}


@end
