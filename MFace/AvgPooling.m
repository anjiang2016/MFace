//
//  AvgPooling.m
//  MFace
//
//  Created by 赵明明 on 2022/5/26.
//

#import "AvgPooling.h"
#import "ImageProcess.h"

@implementation AvgPooling
- (Matrix *) torch_forward:(Matrix *) input :(int)out_size{
    int out_width = out_size;
    int out_height = out_size;
    int out_channel = input.channel;
    //-(void)torch_max_pooling:(int)kernel :(int)padding :(int)stride :(float*)input :(int)in_width :(int)in_height :(int)in_channel :(float*)output
    Matrix * output = [[Matrix new] init:malloc(sizeof(double)*out_width*out_height*out_channel) :out_width :out_height :out_channel];
    int kernel=input.width/out_size;
    int stride = kernel;
    int padding=0;
    [[ImageProcess new] torch_avg_pooling:kernel :padding :stride :input.buff :input.width :input.height :input.channel :output.buff];
    [input free];
    return output;
}
@end
