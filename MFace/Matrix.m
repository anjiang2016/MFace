//
//  Matrix.m
//  MFace
//
//  Created by 赵明明 on 2022/5/23.
//

#import "Matrix.h"

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

@end
