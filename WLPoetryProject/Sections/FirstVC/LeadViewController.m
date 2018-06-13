//
//  LeadViewController.m
//  Shuangrenduobao
//
//  Created by 龙培 on 17/8/4.
//  Copyright © 2017年 daiqile_ningbo. All rights reserved.
//

#import "LeadViewController.h"
#import "AppDelegate.h"

static const NSInteger imageCount = 3;

@interface LeadViewController ()<UIScrollViewDelegate>
/**
 *  主滑动View
 **/
@property (nonatomic,strong) UIScrollView *mainScrollView;

/**
 *  图片数组
 **/
@property (nonatomic,strong) NSMutableArray *imageArray;



@end

@implementation LeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.backgroundColor = [UIColor lightGrayColor];
    [self loadCustomView];
}

- (void)loadCustomView
{
    self.mainScrollView = [[UIScrollView alloc]init];
    self.mainScrollView.frame = CGRectMake(0, 0, PhoneScreen_WIDTH, PhoneScreen_HEIGHT);
    self.mainScrollView.contentSize = CGSizeMake(PhoneScreen_WIDTH*imageCount, PhoneScreen_HEIGHT);
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    self.mainScrollView.pagingEnabled = YES;
    [self.view addSubview:self.mainScrollView];
    
    
    
    for (int i = 0; i< imageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake(i*PhoneScreen_WIDTH, 0, PhoneScreen_WIDTH, PhoneScreen_HEIGHT);
        imageView.backgroundColor = RGBCOLOR(i*50, i*60, i*80, 1.0);
        [self.mainScrollView addSubview:imageView];
        
        if (i < self.imageArray.count) {
            NSString *imageName = self.imageArray[i];
            imageView.image = [UIImage imageNamed:imageName];
        }
        CGFloat skipW = 50;
        CGFloat skipH = 30;
        UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        skipBtn.frame = CGRectMake((PhoneScreen_WIDTH-skipW)/2, PhoneScreen_HEIGHT-30-skipH, skipW, skipH);
        skipBtn.backgroundColor = [UIColor clearColor];
        [skipBtn addTarget:self action:@selector(customButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        imageView.userInteractionEnabled = YES;
        [imageView addSubview:skipBtn];
        
    }
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnWidth = 200;
    CGFloat btnHeight = 64;
    
    CGFloat bottomSpace = PhoneScreen_HEIGHT>600?100:80;
    
    CGFloat xPoint = (PhoneScreen_WIDTH-btnWidth)/2+PhoneScreen_WIDTH*2;
    CGFloat yPoint = PhoneScreen_HEIGHT-bottomSpace-btnHeight;
    clearBtn.frame = CGRectMake(xPoint, yPoint, btnWidth, btnHeight);
    clearBtn.backgroundColor = [UIColor clearColor];
    [clearBtn addTarget:self action:@selector(customButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:clearBtn];
    
    
    
}

- (void)customButtonAction:(UIButton*)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self dismissViewControllerAnimated:NO completion:nil];
}


- (NSMutableArray*)imageArray
{
    if (!_imageArray) {
        
        _imageArray = [NSMutableArray array];
        
        NSString *imageOne = @"leadOne";
        NSString *imageTwo = @"leadTwo";
        NSString *imageThree = @"leadThree";
        
        [_imageArray addObject:imageOne];
        [_imageArray addObject:imageTwo];
        [_imageArray addObject:imageThree];
        
    }
    
    return _imageArray;
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
