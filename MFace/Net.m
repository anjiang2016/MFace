//
//  Net.m
//  MFace
//
//  Created by 赵明明 on 2022/5/24.
//

#import "Net.h"
#import "Conv.h"
#import "Pooling.h"
#import "RELU.h"
#import "model.h"
#import "MaxPooling.h"
#import "Layers.h"
#import "AvgPooling.h"
#import "Layer.h"
#import "Scale.h"

@implementation Net
@synthesize _conv_layer1;
@synthesize _conv_layer2;
@synthesize _conv_layer3;
@synthesize _relu_layer1;
@synthesize _relu_layer2;
@synthesize _relu_layer3;

@synthesize _pool_layer1;
@synthesize _pool_layer2;
@synthesize _pool_layer3;

@synthesize  conv1;
@synthesize  bn1;
@synthesize  layer1;
@synthesize  layer2;
@synthesize  layer3;
@synthesize  layer4;
@synthesize  fc;
@synthesize  scope;
@synthesize  model_weight;
@synthesize  model_dict;
@synthesize  middle_result;

-(Net *)init{
    
    int stride=1;
    int kernel_size=3;
    int inWidth=200;
    int inHeight=200;
    int inChannel=3;
    int outWidth=200;
    int outHeight=200;
    int outChannel=16;
    
    // first conv layer
    self._conv_layer1 = [Conv new];
    // 网络的第一层的输入和输出一定要初始化
    // 输入和输出都要先把长宽高初始化了，不然权重的随机生成部分不会工作
    float * place_holder=NULL;
    self._conv_layer1._input=[[Matrix new] init:place_holder :inWidth :inHeight :inChannel];
    self._conv_layer1._output = [[Matrix alloc] init:malloc(sizeof(float)*outWidth*outHeight*outChannel) :outWidth :outHeight :outChannel];
    self._conv_layer1 = [self._conv_layer1 init:kernel_size:stride];
    
    self._relu_layer1 = [RELU new];
    self._relu_layer1._input=self._conv_layer1._output;
    self._relu_layer1._output =[[Matrix alloc] init:malloc(sizeof(float)*outWidth*outHeight*outChannel) :outWidth :outHeight :outChannel];
    self._pool_layer1 = [Pooling new];
    self._pool_layer1._input=self._relu_layer1._output;
    [self._pool_layer1 set_stride:2];
    [self._pool_layer1 set_kernel_size:2];
    outWidth=outWidth/self._pool_layer1._stride;
    outHeight=outHeight/self._pool_layer1._stride;
    self._pool_layer1._output =[[Matrix alloc] init:malloc(sizeof(float)*outWidth*outHeight*outChannel) :outWidth :outHeight :outChannel];
    
    self._conv_layer2 = [Conv new];
    self._conv_layer2._input=self._pool_layer1._output;
    stride=1;
    kernel_size=3;
    outChannel=64;
    self._conv_layer2._output = [[Matrix alloc] init:malloc(sizeof(float)*outWidth*outHeight*outChannel) :outWidth :outHeight :outChannel];
    self._conv_layer2=[self._conv_layer2 init:kernel_size:stride];
    
    self._relu_layer2=[RELU new];
    self._relu_layer2._input=self._conv_layer2._output;
    self._relu_layer2._output =[[Matrix alloc] init:malloc(sizeof(float)*outWidth*outHeight*outChannel) :outWidth :outHeight :outChannel];
    
    self._pool_layer2 = [Pooling new];
    self._pool_layer2._input=self._relu_layer2._output;
    [self._pool_layer2 set_stride:2];
    [self._pool_layer2 set_kernel_size:2];
    outWidth=outWidth/self._pool_layer2._stride;
    outHeight=outHeight/self._pool_layer2._stride;
    self._pool_layer2._output =[[Matrix alloc] init:malloc(sizeof(float)*outWidth*outHeight*outChannel) :outWidth :outHeight :outChannel];
    
    self._conv_layer3 = [Conv new];
    self._conv_layer3._input=self._pool_layer2._output;
    stride=1;
    kernel_size=3;
    outChannel=128;
    self._conv_layer3._output = [[Matrix alloc] init:malloc(sizeof(float)*outWidth*outHeight*outChannel) :outWidth :outHeight :outChannel];
    self._conv_layer3=[self._conv_layer3 init:kernel_size:stride];
    
    self._relu_layer3 = [RELU new];
    self._relu_layer3._input=self._conv_layer3._output;
    self._relu_layer3._output =[[Matrix alloc] init:malloc(sizeof(float)*outWidth*outHeight*outChannel) :outWidth :outHeight :outChannel];
    
    self._pool_layer3 = [Pooling new];
    self._pool_layer3._input=self._relu_layer3._output;
    self._pool_layer3._kernel_size=2;
    self._pool_layer3._stride = 2;
    outWidth=outWidth/self._pool_layer3._stride;
    outHeight=outHeight/self._pool_layer3._stride;
    self._pool_layer3._output =[[Matrix alloc] init:malloc(sizeof(float)*outWidth*outHeight*outChannel) :outWidth :outHeight :outChannel];
    
    return self;
}
-(void)free{
    [self._conv_layer1 free];
    [self._relu_layer1 free];
    [self._pool_layer1 free];
    
    [self._conv_layer2 free];
    [self._relu_layer2 free];
    [self._pool_layer2 free];
    
    [self._conv_layer3 free];
    [self._relu_layer3 free];
    [self._pool_layer3 free];
    
}

- (Matrix *)passlayer:(Matrix * )input{
    self._conv_layer1._input = input;
    [self._conv_layer1 forward];
    [self._relu_layer1 forward];
    [self._pool_layer1 forward];
   
    [self._conv_layer2 forward];
    [self._relu_layer2 forward];
    [self._pool_layer2 forward];
    
    [self._conv_layer3 forward];
    [self._relu_layer3 forward];
    [self._pool_layer3 forward];
    
    //return [[self _conv_layer1] _output];
    return self._pool_layer3._output;
}

- (UIImage* )forward:(UIImage*)image{
    
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbIntBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    
    // UIImage 2 uint32 image
    ImageProcess * p = [ImageProcess new];
    //change the UIImage to uint_32
    [p UIImage2array:image :rgbIntBuf];
    
    // uint32 image 2 float image
    int in_channel=3;
    int pixNumber = (uint32_t)imageWidth*(uint32_t)imageHeight;
    float* rgbFloatBuf = (float*)malloc(pixNumber*in_channel*sizeof(float));
    [p U2F_3 :rgbIntBuf :pixNumber :in_channel :rgbFloatBuf];
    //float * rgbFloatBuf1 = (float*)malloc(256*256*3*sizeof(float));
    //rgbFloatBuf1= [[model new] pth2fload:rgbFloatBuf1:[NSString stringWithFormat:@"anc_img.txt"]];
    Matrix * input = [[Matrix alloc] init:rgbFloatBuf :256 :256 :3];
    
    // forward the net
    //Matrix * result = [self passlayer:input];
    Matrix * result = [self torch_passlayer:input];
    
    // show result
    // float 2 RGBA
    int out_width=result.width;
    int out_height=result.height;
    uint32_t* res = (uint32_t*)malloc(4*out_width*out_height);
    [p F2U_channel:res :out_width*out_height :result.buff :0];
    
    // 如果模型有对图片大小操作，则需要将显示模版也相应变小
    CGSize smallsize = CGSizeMake(out_width, out_height);
    image=[p scaleToSize:image:smallsize];
    
    // change the uint_32 array to UIImage for show
    //image=[self array2UIImage:rgbImageBuf:image];
    image=[p array2UIImage:res :image];
    
    free(rgbFloatBuf);
    free(res);
    free(rgbIntBuf);
    return image;
    //return rgbImageBuf;
}
-(void)load_weights{
    
    [self load_pth:[NSString stringWithFormat:@"model_resnet18_triplet_epoch_586.txt"]];
    [conv1 load_weights:model_weight :model_dict];
    [bn1 load_weights:model_weight :model_dict];
    [layer1 load_weights:model_weight :model_dict];
    [layer2 load_weights:model_weight :model_dict];
    [layer3 load_weights:model_weight :model_dict];
    [layer4 load_weights:model_weight :model_dict];
    [fc load_weights:model_weight :model_dict];
    NSLog(@"load weigths done...");
}
-(Net *)torch_init{
    self.scope=[NSString stringWithFormat:@"model"];
    //torch_Conv2d:(int)inChannel :(int)outChannel :(int)kernel_size :(int)stride :(int)padding :(int)dilation :(int)groups
    self.conv1 =[[Conv new] torch_Conv2d:3:64:7:2:3:0:1:scope:1];
    self.bn1 = [[Bn new] torch_bn:64:scope:1];
    self.layer1 = [[Layers new] torch_layers:64:64:scope:1];
    self.layer2 = [[Layers new] torch_layers:64:128:scope:2];
    self.layer3 = [[Layers new] torch_layers:128:256:scope:3];
    self.layer4 = [[Layers new] torch_layers:256:512:scope:4];
    self.fc = [[Fc new] torch_fc:512:128:scope:1];
    return self;
}
- (Matrix *)torch_passlayer:(Matrix * )input{
    //(Matrix *) torch_forward:(Matrix *)input
    //return input;
    //Matrix* y = [input reshape];
    
    Matrix * x=nil;
    x = [self.conv1 torch_forward_gpu:input];
    Matrix * weight = [[Matrix new ] init:self.conv1._filter:7:7:64*3];
    [weight print:0:1:0:7:0:7];
    [weight print:1:2:0:7:0:7];
    [weight print:2:3:0:7:0:7];
    [x print:0:1:0:5:0:5];
    [x print:63:64:125:128:125:128];

    //Matrix *y= [x reshape];
    x = [self.bn1 torch_forward:x];
    weight = [[Matrix new ] init:self.bn1.weight:1:1:64];
    [weight print:0:64:0:1:0:1];
    weight = [[Matrix new ] init:self.bn1.bias:1:1:64];
    [weight print:0:64:0:1:0:1];
    weight = [[Matrix new ] init:self.bn1.running_mean:1:1:64];
    [weight print:0:64:0:1:0:1];
    weight = [[Matrix new ] init:self.bn1.running_var:1:1:64];
    [weight print:0:64:0:1:0:1];
    [x print:0:1:0:5:0:5];
    [x print:63:64:125:128:125:128];
    
    x=[[RELU new] torch_forward:x];
    [x print:0:1:0:5:0:5];
    [x print:63:64:125:128:125:128];
    
    //torch_forward:(Matrix *) input :(int)kernel :(int)padding :(int)stride
    x=[[MaxPooling new] torch_forward:x :3 :1 :2];
    [x print:0:1:0:5:0:5];
    [x print:63:64:59:64:59:64];
    
    x= [layer1 torch_forward:x];
    //x = [self.layer1 torch_forw￼ard:x];
    Matrix *y= [x reshape];
    x = [self.layer2 torch_forward:x];
    //Matrix *y= [x reshape];
    
    x = [self.layer3 torch_forward:x];
    //Matrix *y= [x reshape];
    
    x = [self.layer4 torch_forward:x];
    //Matrix *y= [x reshape];
    
    x=[[AvgPooling new] torch_forward:x :1];
    [x print:0:5:0:1:0:1];
    
    x = [self.fc torch_forward:x];
    weight = [[Matrix new ] init:self.fc._filter :512:128:1];
    [weight print:0:1:0:5:0:5];
    weight = [[Matrix new ] init:self.fc._bias :1:1:128];
    [weight print:0:1:0:1:0:128];
    [[Layer new] l2_norm:x.buff :x.width*x.height*x.channel];
    [x print:0:10:0:1:0:1];
    [x print:x.channel-10:x.channel:0:1:0:1];
    x=[[Scale new] torch_forward:x :10.0];
    [x print:0:10:0:1:0:1];
    [x print:x.channel-10:x.channel:0:1:0:1];
    x.width=x.channel;
    x.channel=1;
    [x print];
    middle_result=@{
          @"faceID" : x,
       @"conv1" : y
   };
    return y;
}
-(NSString*)load_pth:(NSString *)model_path
{
    
    //模型文件的路径
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"w2.pth" ofType:nil];
    NSString *path = [[NSBundle mainBundle] pathForResource:model_path ofType:nil];
    NSLog(@"path = %@,%s", path,__FILE__);
    
    NSArray *fileData;
    NSError *error;
        
    //读取file文件并把内容根据换行符分割后赋值给NSArray
    fileData = [[NSString stringWithContentsOfFile:path
                                              encoding:NSUTF8StringEncoding
                                                 error:&error]
                    componentsSeparatedByString:@" "]; // 分割符为空格
        
    //NSLog(@"fileData = %@", fileData);
    // fileData.count();
    unsigned long  count = [fileData count]-1;
    model_weight = malloc(sizeof(float)*count);
    NSArray * keys=[NSArray new];
    NSArray * values=[NSArray new];
    for(int i=0;i<count;i++){
        model_weight[i]=[[fileData objectAtIndex:i] floatValue];
    }
    for(int i=0;i<count;i++)
    {
        NSString *tmp = [fileData objectAtIndex:i];
        //NSLog([fileData objectAtIndex:i]);
        keys = [keys arrayByAddingObject:tmp];
        //NSLog(@"%d",[[fileData objectAtIndex:i+1] intValue]);
        
        NSRange theRange;
        theRange.location = i+2;
        theRange.length =[[fileData objectAtIndex:i+1] intValue];
        NSArray * weightArray = [fileData subarrayWithRange:theRange];
        //values = [values arrayByAddingObject:weightArray];
        values = [values arrayByAddingObject:[NSString stringWithFormat:@"%d",i+2]];
        i=i+1+[[fileData objectAtIndex:i+1] floatValue];
    }
    model_dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    return path;
}
@end
