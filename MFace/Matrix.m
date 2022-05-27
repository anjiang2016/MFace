//
//  Matrix.m
//  MFace
//
//  Created by 赵明明 on 2022/5/23.
//

#import "Matrix.h"
#import "ImageProcess.h"

@implementation Matrix
@synthesize buff;
@synthesize width;
@synthesize height;
@synthesize channel;
-(Matrix *) init:(float *)feature :(int)width :(int)height :(int)channel{
    self.buff=feature;
    self.width=width;
    self.height=height;
    self.channel = channel;
    return self;
}
-(Matrix *)add:(Matrix *)input{
    int len = width*height*channel;
    for(int i=0;i<len;i++){
        buff[i]=buff[i]+input.buff[i];
    }
    return self;
}

-(void)free{
    if(self.buff != nil){
        free(self.buff);
    }

}

-(int)descartes2index:(int)in_width :(int)in_height :(int)in_channel{
    if(in_width<=width || in_height <= height || in_channel <=channel || in_width>=0 || in_height >= 0 || in_channel>=0){
        return in_channel*width*height+in_height*width+in_width;
    }
    return -1;
}
-(float)descartes:(int)in_width :(int)in_height :(int)in_channel{
    int index =[self descartes2index:in_width:in_height:in_channel];
    return buff[index];
}
-(void)descartes_set:(float)value :(int)in_width :(int)in_height :(int)in_channel{
    int index =[self descartes2index:in_width:in_height:in_channel];
    if(index>0){
        buff[index]=value;
    }
}
-(void)print{
    for(int c=0;c<channel;c++){
        NSArray *show_array = [NSArray new];
        for(int w=0;w<width;w++){
            for(int h=0;h<height;h++){
                int index =[self descartes2index:w:h:c];
                show_array = [show_array arrayByAddingObject:[NSString stringWithFormat:@"%f",buff[index]]];
            }
        }
        NSLog(@"%@",show_array);
        
    }
}
-(void)print:(int)start_c :(int)end_c :(int)start_w :(int)end_w :(int)start_h :(int)end_h{
    for(int c=start_c;c<end_c;c++){
        NSArray *show_array = [NSArray new];
        for(int h=start_h;h<end_h;h++){
            for(int w=start_w;w<end_w;w++){
                int index =[self descartes2index:w:h:c];
                show_array = [show_array arrayByAddingObject:[NSString stringWithFormat:@"%f",buff[index]]];
            }
        }
        NSLog(@"%@",show_array);
        
    }
}

-(Matrix*)reshape{
    int channel_sqrt = (int)(sqrt(channel)-0.01)+1;
    float * buff1 = malloc(sizeof(float)*channel*width*height);
    Matrix * tmp = [[Matrix new] init:buff1:width*channel_sqrt:height*channel_sqrt:1];
    for(int c=0;c<channel;c++){
        for(int h=0;h<height;h++){
            for(int w=0;w<width;w++){
                int row = c/channel_sqrt;
                int col = c%channel_sqrt;
                //[tmp descartes_set:[self descartes:w :h :c] :w+col*width :h+row*height :0];
                //float value = (c+1.0)/3.0;
                float value = [self descartes:w :h :c];
                [tmp descartes_set:value :w+col*width :h+row*height :0];
                [tmp descartes_set:0 :w+col*width :h+(row+1)*height :0];
            }
        }
    }
    return tmp;
}
-(UIImage *)show{
    ImageProcess* p=[ImageProcess new];
    int channel_sqrt = (int)sqrt(channel);
    uint32_t* res = (uint32_t*)malloc(width*height*channel_sqrt*channel_sqrt*4);
    [p F2U_channel:res :width*height :buff :0];
    
    // 如果模型有对图片大小操作，则需要将显示模版也相应变小
    CGSize smallsize = CGSizeMake(width, height);
    UIImage *image=[UIImage new];
    image = [p scaleToSize:image:smallsize];
    
    // change the uint_32 array to UIImage for show
    //image=[self array2UIImage:rgbImageBuf:image];
    image=[p array2UIImage:res :image];
    return image;
}
@end
