//
//  MaxPooling.m
//  MFace
//
//  Created by 赵明明 on 2022/5/26.
//

#import "MaxPooling.h"
#import "ImageProcess.h"
#import "Matrix.h"
@implementation MaxPooling
- (Matrix *) torch_forward:(Matrix *) input :(int)kernel :(int)padding :(int)stride{
    int out_width = (input.width-kernel+2*padding)/stride+1;
    int out_height = (input.height-kernel+2*padding)/stride+1;
    int out_channel = input.channel;
    //-(void)torch_max_pooling:(int)kernel :(int)padding :(int)stride :(float*)input :(int)in_width :(int)in_height :(int)in_channel :(float*)output
    Matrix * output = [[Matrix new] init:malloc(sizeof(double)*out_width*out_height*out_channel) :out_width :out_height :out_channel];
    [[ImageProcess new] torch_max_pooling:kernel :padding :stride :input.buff :input.width :input.height :input.channel :output.buff];
    if(input.buff!=NULL){free(input.buff);input.buff=NULL;}
    return output;
}
@end
