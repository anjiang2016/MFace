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
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    uint32_t* res = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // UIImage 2 uint32 image
    ImageProcess * p = [ImageProcess new];
    //change the UIImage to uint_32
    [p UIImage2array:image :rgbImageBuf];
    
    // uint32 image 2 float image
    int in_channel=3;
    int pixNumber = (uint32_t)imageWidth*(uint32_t)imageHeight;
    float* rgbFloatBuf = (float*)malloc(pixNumber*in_channel*sizeof(float));
    float* rgbFloatBuf1 = (float*)malloc(pixNumber*in_channel*sizeof(float));
    
    [p U2F_3 :rgbImageBuf :pixNumber :in_channel :rgbFloatBuf];
    [p U2F_3 :rgbImageBuf :pixNumber :in_channel :rgbFloatBuf1];
    
    /*
    Scale  *scale_layer = [Scale new];
    scale_layer._scale = 0.9;
    scale_layer._input = [[Matrix alloc] init:poolingFloat :width/2 :height/2 :out_channel];
    scale_layer._output = [[Matrix new] init:poolingFloat :width/2 :height/2 :out_channel];
    //[scale_layer forward];
    */
    
    int out_channel=1;
    Conv *conv_layer = [Conv new];
    conv_layer._input = [[Matrix alloc] init:rgbFloatBuf :imageWidth :imageHeight :in_channel];
    
    int outWidth=imageWidth/1;
    int outHeight=imageHeight/1;
    float * resFloat_2 = malloc(sizeof(float)*outWidth*outHeight*out_channel);
    conv_layer._output = [[Matrix alloc] init:resFloat_2 :outWidth :outHeight :out_channel];
    conv_layer = [conv_layer init:7 :1];
    [conv_layer forward];
    
    RELU * relu_layer = [RELU new];
    relu_layer._input = conv_layer._output;
    relu_layer._output = conv_layer._output;
    [relu_layer forward];
    
    Pooling  *pool_layer = [Pooling new];
    pool_layer._stride=2;
    outWidth=outWidth/pool_layer._stride;
    outHeight=outHeight/pool_layer._stride;
    pool_layer._kernel_size=2;
    pool_layer._input = conv_layer._output;
    float * poolingFloat_3 = malloc(sizeof(float)*outWidth*outHeight*out_channel);
    pool_layer._output = [[Matrix alloc] init:poolingFloat_3 :outWidth :outHeight :out_channel];
    [pool_layer forward];
    
    
    Conv *conv_layer2 = [Conv new];
    conv_layer2._input = pool_layer._output;
    int kernel_size=7;
    int stride = 1;
    outWidth=outWidth/stride;
    outHeight=outHeight/stride;
    float * conv_out_2 = malloc(sizeof(float)*outWidth*outHeight*out_channel);
    conv_layer2._output = [[Matrix alloc] init:conv_out_2 :outWidth :outHeight :out_channel];
    conv_layer2 = [conv_layer2 init:kernel_size :stride];// 随机初始化当前层的参数
    [conv_layer2 forward];
    
    relu_layer._input = conv_layer2._output;
    relu_layer._output = conv_layer2._output;
    [relu_layer forward];
    pool_layer._input  = relu_layer._output;
    
    outWidth=outWidth/pool_layer._stride;
    outHeight=outHeight/pool_layer._stride;
    pool_layer._input = conv_layer2._output;
    free(pool_layer._output.buff);
    float * pool_out = malloc(sizeof(float)*outWidth*outHeight*out_channel);
    pool_layer._output = [[Matrix alloc] init:pool_out :outWidth :outHeight :out_channel];
    [pool_layer forward];
   
    
    /*
    outWidth=outWidth/pool_layer._stride;
    outHeight=outHeight/pool_layer._stride;
    pool_layer._input = pool_layer._output;
    free(pool_layer._output.buff);
    pool_out = malloc(sizeof(float)*outWidth*outHeight*out_channel);
    pool_layer._output = [[Matrix alloc] init:pool_out :outWidth :outHeight :out_channel];
    [pool_layer forward];
    */
    
    
    Matrix * input = [[Matrix alloc] init:rgbFloatBuf1 :imageWidth :imageHeight :in_channel];
    Matrix * result = [self passlayer:input];
    // float 2 RGBA
    
    //[self F2U_channel:res :conv_layer._output.width*conv_layer._output.height :resFloat_2 :0];
    //[p F2U_channel:res :pool_layer._output.width*pool_layer._output.height :pool_layer._output.buff :0];
    //[p F2U_channel:res :result.width*result.height :result.buff :0];
    //[p F2U_channel:res :imageWidth*imageHeight :rgbFloatBuf :0];
    outWidth=result.width;
    outHeight=result.height;
    [p F2U_channel:res :outWidth*outHeight :result.buff :0];
    
    // 如果模型有对图片大小操作，则需要将显示模版也相应变小
    CGSize smallsize = CGSizeMake(outWidth, outHeight);
    image=[p scaleToSize:image:smallsize];
    
    // change the uint_32 array to UIImage for show
    //image=[self array2UIImage:rgbImageBuf:image];
    image=[p array2UIImage:res :image];
    
    //free((void*)rgbImageBuf);
    free(res);
    free(rgbImageBuf);
    free(resFloat_2);
    [conv_layer free];
    free(pool_layer._output.buff);
    return image;
    //return rgbImageBuf;
}
@end
