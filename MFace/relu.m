//
//  relu.m
//  MFace
//
//  Created by 赵明明 on 2022/5/23.
//

#import "RELU.h"

@implementation RELU

- (void) forward :(float *)input :(unsigned long)input_len :(float *)output :(unsigned long) output_len{
    int i=0;
    for(i=0;i<input_len;i++){
        output[i]=0;
        if(input[i]>0){
            output[i]=input[i];
        }
    }
}

@end
