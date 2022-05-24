//
//  layer.m
//  MFace
//
//  Created by 赵明明 on 2022/5/23.
//

#import "Layer.h"

@implementation Layer
//(float*)arr :(float*)res :(int)filterW :(int)filterH :(int)arrW :(int)arrH :(int)in_channel :(int)out_channel
@synthesize _input;
@synthesize _output;
-(void)random_set:(float*)buff :(int)bufflen{
    for(int i=0;i<bufflen;i++){
        buff[i]=random()/65536.0/65536.0;
    }
}
-(float)sum:(float*)buff :(int)bufflen{
    float sum = 0;
    for(int i=0;i<bufflen;i++){
        sum=sum+buff[i];
    }
    return sum;
}

-(void)norm:(float*)buff :(int)bufflen :(int)kernel{
    int norm_len=kernel*kernel;
    for(int j=0;j<bufflen/norm_len;j++){
        float sum = [self sum:buff+j*norm_len :norm_len];
        for(int i=0;i<norm_len;i++){
            buff[i+j*norm_len]=buff[i+j*norm_len]/sum;
        }
    }
}


- (void) forward{
    int i=0;
    int input_len =self._input.width*self._input.width*self._input.channel;
    for(i=0;i<input_len;i++){
        self._output.buff[i]=self._input.buff[i]*2;
    }
}
@end
