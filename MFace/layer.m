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
@synthesize  scope;
-(void)random_set:(float*)buff :(int)bufflen{
    for(int i=0;i<bufflen;i++){
        buff[i]=random()/65536.0/65536.0;
    }
}
-(void)zero_set:(float*)buff :(int)bufflen{
    for(int i=0;i<bufflen;i++){
        buff[i]=0.0;
    }
}
-(void)divice_max:(float*)buff :(int)bufflen{
    float max = 0;
    for(int i=0;i<bufflen;i++){
        if(buff[i]>max)
            max=buff[i];
    }
    for(int i=0;i<bufflen;i++){
        buff[i]/=max;
    }
}
-(void)l2_norm:(float*)buff :(int)bufflen{
    float l2= 0;
    for(int i=0;i<bufflen;i++){
        l2+=buff[i]*buff[i];
    }
    for(int i=0;i<bufflen;i++){
        buff[i]/=sqrt(l2);
    }
}
-(float )max:(float*)buff :(int)bufflen{
    float maxv= buff[0];
    for(int i=1;i<bufflen;i++){
        if(maxv<buff[i]){
            maxv=buff[i];
        }
    }
    return maxv;
}
-(float )min:(float*)buff :(int)bufflen{
    float minv= buff[0];
    for(int i=1;i<bufflen;i++){
        if(minv>buff[i]){
            minv=buff[i];
        }
    }
    return minv;
}
-(void)min_max_norm:(float*)buff :(int)bufflen :(int)norm_len{
    //int norm_len=kernel*kernel;
    for(int j=0;j<bufflen/norm_len;j++){
        float maxv = [self max:buff+j*norm_len :norm_len];
        float minv = [self min:buff+j*norm_len :norm_len];
        for(int i=0;i<norm_len;i++){
            buff[i+j*norm_len]=(buff[i+j*norm_len]-minv)/(maxv-minv);
        }
    }
}
-(float)sum:(float*)buff :(int)bufflen{
    float sum = 0;
    for(int i=0;i<bufflen;i++){
        sum=sum+buff[i];
    }
    return sum;
}

-(void)norm:(float*)buff :(int)bufflen :(int)norm_len{
    //int norm_len=kernel*kernel;
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
-(void) free{
    //[self._input free];
    [self._output free];
    
}
@end
