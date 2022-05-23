//
//  ViewController.m
//  Bilibili
//
//  Created by 赵明明 on 2020/11/11.
// 之后大部分代码需要写在这个文件里

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "ImageProcess.h"
#import "FileOperate.h"
#import "model.h"

//@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button_file;

@property (weak, nonatomic) IBOutlet UITextView *v_textview;
@property (weak, nonatomic) IBOutlet UITextField *status_text;

@property (weak, nonatomic) IBOutlet UIButton *useModel;
@property (weak, nonatomic) IBOutlet UIImageView *image_1;
@property (weak, nonatomic) IBOutlet UIButton *get_image_button;

@property (weak, nonatomic) IBOutlet UIButton *button_getimage;
@property (weak, nonatomic) IBOutlet UITextField *textarea;
@property (nonatomic) UIImagePickerController *camera;
-(void) switchMOVtoMP:(NSURL *)inputURL;
+(NSString*)getCurrentTimes;

-(void)deleteVideo:(NSString *)path;
-(void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL outputURL:(NSURL*)outputURL;

- (void)calulateImageFileSize:(UIImage *)image;
// camera 拍照
- (void)takePhoto;
@property (weak, nonatomic) IBOutlet UIImageView *v_imageview;
// 从相册读取
- (void)selectPhoto;
@end

@implementation ViewController

- (IBAction)action_file:(id)sender {
    //创建NSFileManager实例
    NSFileManager *fm = [NSFileManager defaultManager];
    //获取当前目录
    //NSString *path = [fm currentDirectoryPath];
    //self.status_text.text=@"/";
    NSLog(@"staus_text = %@", self.status_text.text);
    
    NSArray *fileArray1 = [[NSArray alloc]init];
    fileArray1 = [fm contentsOfDirectoryAtPath:self.status_text.text error:nil];
    if([fileArray1 count]>0){
        NSLog(@"fileArray1 = %@", fileArray1);
        self.v_textview.text = [self.v_textview.text stringByAppendingString:[fileArray1 componentsJoinedByString:@"\n,"]];
    }
    
    //NSDirectoryEnumerator *directoryEnum = [fm enumeratorAtPath:self.status_text.text];
    //NSString *filePath;

    
    //模型文件的路径
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"w2.pth" ofType:nil];
        NSLog(@"path1 = %@", path1);
    path1 = [[NSBundle mainBundle] pathForResource:@"w2.txt" ofType:nil];
        NSLog(@"path1 = %@", path1);
    
    //录制mp4所在路径，可以用于跟踪
    NSArray *mainpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [mainpaths objectAtIndex:0];
    NSArray *fileList = [fm contentsOfDirectoryAtPath:documentsDir error:nil];
    if([fileList count]>0){
        NSLog(@"fileList = %@", fileList);
    }
    
   
    
}

// 按钮 使用模型
- (IBAction)useModel:(id)sender {
    
    self.v_textview.layoutManager.allowsNonContiguousLayout = false;
    //let allStrCount = self.v_textview.text.characters.count; //获取总文字个数
    //self.v_textview.scrollRangeToVisible(NSMakeRange(0, allStrCount));//把光标位置移到最后
    //使用可放在你的自定义方法或者UITextViewDelegate方法里面使用，比如文本变更时候 - textViewDidChange
    
    
    NSLog(@"use model to process image");
    self.v_textview.text = [self.v_textview.text stringByAppendingString:@"\n正在处理..."];

    UIImage *image = self.image_1.image;
    [self calulateImageFileSize:image];
    
    ImageProcess *p = [ImageProcess new];
    //testImageView.image=[p imageBlackToTransparent:testImageView.image:255:128:128];
    CGSize smallsize = CGSizeMake(200, 200);
    image=[p scaleToSize:image:smallsize];
    //self.image_1.image = [p imageBlackToTransparent:image:255:128:128];
    //self.image_1.image=image;
    float* bias =(float*)malloc(1);
    /*
    float weightsarray[3*3*3*4];
    for(int i = 0;i<3*3*3*4;i++)
    {
        //手动设定中值滤波
        //weightsarray[i]=1.0f/(3.0f*3.0f*3.0f);
        //随机数
        float tmp=(float)(arc4random()%101)/50.0;
        weightsarray[i]= (tmp-1.0)/(3.0f*3.0f);
    }
    */
    //model * Md = [model new];
    float weightsarray[3*64*7*7];
    //NSString* filename_tmp = [Md getModel:weightsarray];
    
    
    int in_channel=3;
    int out_channel=64;
    [self insert2TextView:[NSString stringWithFormat:@"\n weightsarray[0]=%f",weightsarray[0]]];
    [self insert2TextView:[NSString stringWithFormat:@"\n weightsarray[6]=%f",weightsarray[6]]];
    
    memset(bias,0.0,1*sizeof(*bias));
    int padding=0;
    int stride=0;
    int kernel_size=7;
    
    //(UIImage* )passlayer:(UIImage*)image :(float*)weightsarray :(int)kernel_size :(int)bias :(int)padding :(int)stride
    //p.passlayer(image,weightsarray,kernel_size)
    self.image_1.image=[p passlayer:image:weightsarray:kernel_size:bias:padding:stride:in_channel:out_channel];
    //self useModel setBackgroundImage:slef.image_1.image];
    [self.useModel setBackgroundImage:self.image_1.image forState:UIControlStateNormal];
    [self insert2TextView:[NSString stringWithFormat:@"\n--feature map:(%f,%f)",self.image_1.image.size.width,self.image_1.image.size.height]];
    self.v_textview.text = [self.v_textview.text stringByAppendingString:@"\n已经处理完。"];
}


// 拍摄照片，等着稍后对照片进行识别：
- (void)takePhoto{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    imagePickerController.delegate  = self;
    imagePickerController.allowsEditing=YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}


// 功能：读取相册
- (void)selectPhoto{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing= YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


- (IBAction)button_getimage:(id)sender {
    [self takePhoto];
}
- (IBAction)button_getAlbum:(id)sender {
    [self insert2TextView:@"\n>>>正在选图片"];
    [self selectPhoto];
}

// 取消图片选择调用此方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"didCance.@%s,%d,%s",__FILE__,__LINE__,__func__);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)calulateImageFileSize:(UIImage *)image {
    
    NSData *data = UIImagePNGRepresentation(image);
    if (!data) {
        data = UIImageJPEGRepresentation(image, 0.5);//需要改成0.5才接近原图片大小，原因请看下文
    }
    double dataLength = [data length] * 1.0;
    NSArray *typeArray = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB",@"ZB",@"YB"];
    NSInteger index = 0;
    while (dataLength > 1024) {
        dataLength /= 1024.0;
        index ++;
    }
    NSLog(@"image = %.3f %@",dataLength,typeArray[index]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        //纯用代码写出一个控件
        /*
        UIButton *btn=[UIButton new];
        [btn setTitle:@"start test" forState:UIControlStateNormal];
        [btn setBackgroundColor:UIColor.redColor];
        [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        btn.translatesAutoresizingMaskIntoConstraints=false;
        [self.view addSubview:btn];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:146]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:46]];
        [btn addTarget:nil action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
        */
        // 设置主页控件的背景颜色
    self.v_textview.backgroundColor = [UIColor grayColor];
    self.v_imageview.backgroundColor = [UIColor grayColor];
    
}

- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}


// 功能： 录像视频
-(void)btnclick
{
    printf("button click\n");
    _textarea.text=@"asdfsadf";
    
    bool canUse= [self isCameraAvailable];
        if(canUse)
        {
            NSLog(@"camera is availiable ");
            self.camera=[[UIImagePickerController alloc]init];
            
            self.camera.sourceType=UIImagePickerControllerSourceTypeCamera;
            self.camera.showsCameraControls=true;
            self.camera.mediaTypes=@[(NSString *)kUTTypeMovie];//typemovie with voice
            self.camera.allowsEditing=true;
          
            /*
             设置视频长度
             */
            self.camera.videoMaximumDuration=5;//seconds
         
            /*
             设置视频质量
             UIImagePickerControllerQualityTypeHigh = 0,       // highest quality
             UIImagePickerControllerQualityTypeMedium = 1,     // medium quality, suitable for transmission via Wi-Fi
             UIImagePickerControllerQualityTypeLow = 2,         // lowest quality, suitable for tranmission via cellular network
             UIImagePickerControllerQualityType640x480 NS_ENUM_AVAILABLE_IOS(4_0) = 3,    // VGA quality
             UIImagePickerControllerQualityTypeIFrame1280x720 NS_ENUM_AVAILABLE_IOS(5_0) = 4,
             UIImagePickerControllerQualityTypeIFrame960x540 NS_ENUM_AVAILABLE_IOS(5_0) = 5,
             */
            
            self.camera.videoQuality= UIImagePickerControllerQualityType640x480;
            
            
            
    //        CGFloat camScaleup=1.8;
    //        self.camera.cameraViewTransform=CGAffineTransformScale(self.camera.cameraViewTransform, camScaleup, camScaleup);
            
            self.camera.delegate=self;
            self.view.backgroundColor=UIColor.lightGrayColor;
            
            if(self.navigationController)
            {
                NSLog(@"have navigation");
                [self.navigationController presentViewController:self.camera animated:true completion:^(){}];
            }
            else{
                NSLog(@"no navigation");
                [self presentViewController:self.camera animated:true completion:nil];
            }
        }else{
            NSLog(@"can not use camera");
            
            
        }
        
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    
    
    [picker dismissViewControllerAnimated:true completion:nil];
    NSLog(@"didFinish.@%s,%d,%s",__FILE__,__LINE__,__func__);
    
    //拿到图片，可以进行任意处理。
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.image_1.image=image;
    [self.button_getimage setBackgroundImage:image forState:UIControlStateNormal];
    [self.get_image_button setBackgroundImage:image forState:UIControlStateNormal];
    
    
    //NSString *urlStr =[NSString stringWithFormat:@"%@", [info objectForKey:UIImagePickerControllerMediaURL]];
    
    
    NSString *documentsDirPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSURL *documentsDirUrl = [NSURL fileURLWithPath:documentsDirPath isDirectory:YES];
    
    NSString *temp=[ViewController getCurrentTimes];
    NSString *outputName=[temp stringByAppendingString:@".mp4"];
    NSURL *saveMovieFile = [NSURL URLWithString:outputName relativeToURL:documentsDirUrl];
    NSLog(@"saveMovieFile=%@",saveMovieFile);
    //[self convertVideoToLowQuailtyWithInputURL:[[NSURL alloc]initWithString:urlStr] outputURL:saveMovieFile];
    
}

//-(void) switchMOVtoMP:(NSString *)inputStr
-(void) switchMOVtoMP:(NSURL *)inputUrl
{
//    NSURL *inputUrl = [[NSURL alloc]initWithString:inputStr];
    NSLog(@"mov转mp4 ==》%@",inputUrl);
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputUrl options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];

    NSString *documentsDirPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSURL *documentsDirUrl = [NSURL fileURLWithPath:documentsDirPath isDirectory:YES];

    NSString *temp=[ViewController getCurrentTimes];
    NSString *outputName=[temp stringByAppendingString:@".mp4"];

    NSURL *saveMovieFile = [NSURL URLWithString:outputName relativeToURL:documentsDirUrl];
    exportSession.outputURL =saveMovieFile;
    exportSession.outputFileType =AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(){
        int exportStatus = exportSession.status;
        switch (exportStatus) {
            case AVAssetExportSessionStatusFailed: {
                    NSError *exportError = exportSession.error;
                    NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                    break;
                    }
                case AVAssetExportSessionStatusCompleted: {
                NSLog(@"视频转码成功");
                }
                
        }
   
    }];
    
}
+(NSString*)getCurrentTimes{
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];

    currentTimeString=[currentTimeString stringByReplacingOccurrencesOfString:@"-"withString:@""];
    currentTimeString=[currentTimeString stringByReplacingOccurrencesOfString:@" "withString:@""];
    currentTimeString=[currentTimeString stringByReplacingOccurrencesOfString:@":"withString:@""];
    return currentTimeString;
    
}
-(void)deleteVideo:(NSString *)path;
{
    
}
-(void)convertVideoToLowQuailtyWithInputURL:(NSURL*)inputURL
                                   outputURL:(NSURL*)outputURL
{
    
    //setup video writer
    AVAsset *videoAsset = [[AVURLAsset alloc] initWithURL:inputURL options:nil];
    
    AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
   
    CGSize videoSize = videoTrack.naturalSize;
    //1250000
    NSDictionary *videoWriterCompressionSettings =  [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:440000], AVVideoAverageBitRateKey,
                                                     [NSNumber numberWithInt:20],AVVideoMaxKeyFrameIntervalKey,
                                                     AVVideoProfileLevelH264Baseline30,AVVideoProfileLevelKey, //标清AVVideoProfileLevelH264Baseline30
                                                     [NSNumber numberWithInt:34],AVVideoExpectedSourceFrameRateKey,
                                                     nil];
    
    
    NSDictionary *videoWriterSettings;
    if (@available(iOS 11.0, *)) {
        videoWriterSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecTypeH264, AVVideoCodecKey, videoWriterCompressionSettings, AVVideoCompressionPropertiesKey, [NSNumber numberWithFloat:videoSize.width], AVVideoWidthKey, [NSNumber numberWithFloat:videoSize.height], AVVideoHeightKey, nil];
        
      
    } else {
        // Fallback on earlier versions
         videoWriterSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey, videoWriterCompressionSettings, AVVideoCompressionPropertiesKey, [NSNumber numberWithFloat:videoSize.width], AVVideoWidthKey, [NSNumber numberWithFloat:videoSize.height], AVVideoHeightKey, nil];
        
    }
    AVAssetWriterInput* videoWriterInput = [AVAssetWriterInput
                                            assetWriterInputWithMediaType:AVMediaTypeVideo
                                            outputSettings:videoWriterSettings];
    
    videoWriterInput.expectsMediaDataInRealTime = YES;
    
    videoWriterInput.transform = videoTrack.preferredTransform;
    
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:outputURL fileType:AVFileTypeQuickTimeMovie error:nil];
    
    [videoWriter addInput:videoWriterInput];
    
    //setup video reader
    NSDictionary *videoReaderSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    AVAssetReaderTrackOutput *videoReaderOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:videoReaderSettings];
    
    AVAssetReader *videoReader = [[AVAssetReader alloc] initWithAsset:videoAsset error:nil];
    
    [videoReader addOutput:videoReaderOutput];
    
    //setup audio writer
    AVAssetWriterInput* audioWriterInput = [AVAssetWriterInput
                                            assetWriterInputWithMediaType:AVMediaTypeAudio
                                            outputSettings:nil];
    
    audioWriterInput.expectsMediaDataInRealTime = NO;
    
    [videoWriter addInput:audioWriterInput];
    
    //setup audio reader
    AVAssetTrack* audioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    AVAssetReaderOutput *audioReaderOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack outputSettings:nil];
    
    AVAssetReader *audioReader = [AVAssetReader assetReaderWithAsset:videoAsset error:nil];
    
    [audioReader addOutput:audioReaderOutput];
    
    [videoWriter startWriting];
    
    //start writing from video reader
    [videoReader startReading];
    
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    dispatch_queue_t processingQueue = dispatch_queue_create("processingQueue1", NULL);
    
    [videoWriterInput requestMediaDataWhenReadyOnQueue:processingQueue usingBlock:
     ^{
         
         while ([videoWriterInput isReadyForMoreMediaData]) {
             
             CMSampleBufferRef sampleBuffer;
             
             if ([videoReader status] == AVAssetReaderStatusReading &&
                 (sampleBuffer = [videoReaderOutput copyNextSampleBuffer])) {
                 
                 [videoWriterInput appendSampleBuffer:sampleBuffer];
                 CFRelease(sampleBuffer);
             }
             
             else {
                 
                 [videoWriterInput markAsFinished];
                 
                 if ([videoReader status] == AVAssetReaderStatusCompleted) {
                     
                     //start writing from audio reader
                     [audioReader startReading];
                     
                     [videoWriter startSessionAtSourceTime:kCMTimeZero];
                     
                     dispatch_queue_t processingQueue = dispatch_queue_create("processingQueue2", NULL);
                     
                     [audioWriterInput requestMediaDataWhenReadyOnQueue:processingQueue usingBlock:^{
                         
                         while (audioWriterInput.readyForMoreMediaData) {
                             
                             CMSampleBufferRef sampleBuffer;
                             
                             if ([audioReader status] == AVAssetReaderStatusReading &&
                                 (sampleBuffer = [audioReaderOutput copyNextSampleBuffer])) {
                                 
                                 [audioWriterInput appendSampleBuffer:sampleBuffer];
                                 CFRelease(sampleBuffer);
                             }
                             
                             else {
                                 
                                 [audioWriterInput markAsFinished];
                                 
                                 if ([audioReader status] == AVAssetReaderStatusCompleted) {
                                     
                                     [videoWriter finishWritingWithCompletionHandler:^(){

                                         
//                                          [self switchMOVtoMP:outputURL];
                                     }];
                                     
                                 }
                             }
                         }
                         
                     }
                      ];
                 }
             }
         }
     }
     ];
}


-(void) insert2TextView:(NSString *)str_message{
    self.v_textview.text = [str_message stringByAppendingString:self.v_textview.text];
}

@end

