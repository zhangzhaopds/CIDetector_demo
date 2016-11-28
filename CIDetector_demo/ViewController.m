//
//  ViewController.m
//  CIDetector_demo
//
//  Created by 张昭 on 28/11/2016.
//  Copyright © 2016 张昭. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self detectorFace];
    
}

// 人脸识别
- (void)detectorFace {
    // 上下文
    CIContext *content = [CIContext contextWithOptions:nil];
    
    // 参数
    /*
     1、识别精度 Detector Accuracy
     
        key: CIDetectorAccuracy
        value: CIDetectorAccuracyLow    低精度识别速度快
               CIDetectorAccuracyHigh   高精度识别速度慢
     */
    /*
     2、识别类型 Detector Types
     
        CIDetectorTypeFace      面部识别
        CIDetectorTypeRectangle 矩形识别
        CIDetectorTypeQRCode    条码识别
        CIDetectorTypeText      文本识别
     */
    /*
     3、 具体特征 Feature Detection
     
        CIDetectorImageOrientation  图片方向
        CIDetectorEyeBlink          识别眨眼（closed eyes）
        CIDetectorSmile             笑脸
        CIDetectorFocalLength       焦距
        CIDetectorAspectRatio       矩形宽高比
        CIDetectorReturnSubFeatures 是否检测子特征
     */
    
    // 配置识别质量
    NSDictionary *param = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy];
    
    // 创建人脸识别器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:content options:param];
    
    // 识别图片
    CIImage *ciImg = [CIImage imageWithCGImage:_myImageView.image.CGImage];
    
    // 识别特征: 这里添加了眨眼和微笑
    // CIDetectorSmile 眼部的识别效果很差，很难识别出来
    NSDictionary *featuresParam = @{CIDetectorSmile: [NSNumber numberWithBool:true],
                                    CIDetectorEyeBlink: [NSNumber numberWithBool:true]};
    
    // 获取识别结果
    NSArray *resultArr = [detector featuresInImage:ciImg options:featuresParam];
    
    UIView *resultView = [[UIView alloc] initWithFrame:_myImageView.frame];
    [self.view addSubview:resultView];
    
    for (CIFaceFeature *feature in resultArr) {
        
        NSLog(@"微笑：%d", feature.hasSmile);
        NSLog(@"右眼：%d", feature.rightEyeClosed);
        NSLog(@"左眼：%d", feature.leftEyeClosed);
        NSLog(@"脸框：%d", feature.hasFaceAngle);
        NSLog(@"嘴：%d", feature.hasMouthPosition);
        
        /* 
         关于feature中的position需要注意的是:
            position是以所要识别图像的原始尺寸为标准；
            因此，
            如果装载图片的UIImageView的尺寸与图片原始尺寸不一样的话，会出现识别的位置有偏差。
         */
        UIView *faceView = [[UIView alloc] initWithFrame:feature.bounds];
        faceView.layer.borderColor = [UIColor redColor].CGColor;
        faceView.layer.borderWidth = 1;
        [resultView addSubview:faceView];
        
        // 坐标系的转换
        [resultView setTransform:CGAffineTransformMakeScale(1, -1)];
        
        // 左眼
        if (feature.hasLeftEyePosition) {
            UIView * leftEyeView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 20, 20)];
            [leftEyeView setCenter:feature.leftEyePosition];
            leftEyeView.layer.borderWidth = 1;
            leftEyeView.layer.borderColor = [UIColor greenColor].CGColor;
            [resultView addSubview:leftEyeView];
        }
        
        // 右眼
        if (feature.hasRightEyePosition) {
            UIView * rightEyeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            [rightEyeView setCenter:feature.rightEyePosition];
            rightEyeView.layer.borderWidth = 1;
            rightEyeView.layer.borderColor = [UIColor redColor].CGColor;
            [resultView addSubview:rightEyeView];
        }
        
        // 嘴部
        if (feature.hasMouthPosition) {
            UIView * mouthView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            [mouthView setCenter:feature.mouthPosition];
            mouthView.layer.borderWidth = 1;
            mouthView.layer.borderColor = [UIColor redColor].CGColor;
            [resultView addSubview:mouthView];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
