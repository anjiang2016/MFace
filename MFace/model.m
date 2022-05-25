//
//  model.m
//  MFace
//
//  Created by 赵明明 on 2020/11/13.
//

#import "model.h"


@implementation model
// 模式初始化的时候要用
-(NSString*)getModel :(float*)farray :(NSString *)model_path :(Net * )net
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
    unsigned long  count = [fileData count];
    // 因为文件还有最后一行，所以这里把行数减1
    count = count -1;
    NSArray * keys=[NSArray new];
    NSArray * values=[NSArray new];
    for(int i=0;i<count;i++){
        farray[i]=[[fileData objectAtIndex:i] floatValue];
    }
    for(int i=0;i<count;i++)
    {
        farray[i]=[[fileData objectAtIndex:i] floatValue];
        NSString *tmp = [fileData objectAtIndex:i];
        NSLog([fileData objectAtIndex:i]);
        keys = [keys arrayByAddingObject:tmp];
        NSLog(@"%d",[[fileData objectAtIndex:i+1] intValue]);
        
        NSRange theRange;
         
        theRange.location = i+2;
        theRange.length =[[fileData objectAtIndex:i+1] intValue];
         
        NSArray * weightArray = [fileData subarrayWithRange:theRange];
        //values = [values arrayByAddingObject:weightArray];
        values = [values arrayByAddingObject:[NSString stringWithFormat:@"%d",i+2]];
        //[NSString stringWithFormat:@"model_resnet18_triplet_epoch_586.txt"]
        //[[fileData objectAtIndex:i] floatValue];
        //NSLog(@"farray[%d]=%@",i,[fileData objectAtIndex:i]);
        net._conv_layer1._filter=farray+2;
        net._conv_layer1._kernel_size=7;
        net._conv_layer1._input.channel=3;
        net._conv_layer1._output.channel=64;
        i=i+1+[[fileData objectAtIndex:i+1] floatValue];
        
        
    }
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    NSLog(@"get dict %@:%@",@"model.bn1.running_var",dict[@"model.bn1.running_var"]);
    [net torch_init];
    net.conv1._filter=farray+[dict[@"model.conv1.weight"] intValue];
    net.conv1._bias=farray+[dict[@"model.conv1.bias"] intValue];
    
    net.bn1.weight =  farray + [dict[@"model.bn1.weigth"] intValue];
    net.bn1.bias =  farray + [dict[@"model.bn1.bias"] intValue];
    net.bn1.running_mean =farray[[dict[@"model.bn1.running_mean"] intValue]];
    net.bn1.running_var =farray[[dict[@"model.bn1.running_var"] intValue]];
    
    net.layer1.b0.conv1._filter=farray+[dict[@"model.layer1.b0.conv1.weight"] intValue];
    
    NSArray *bn1_bias = [NSArray new];
    for(int i=0;i<64;i++){
        bn1_bias = [bn1_bias arrayByAddingObject:[NSString stringWithFormat:@"%f",net.bn1.bias[i]]];
    }
    NSLog(@"bn1.bias %@",bn1_bias);
    /*
    //获取NSArray类型对象的迭代器
    NSEnumerator *arrayEnumerator = [fileData objectEnumerator];
    NSString *tempStr;
    
    while (tempStr = [arrayEnumerator nextObject]) {
        NSLog(@"linedata = %@",tempStr);
    }
    NSLog(@"%d",[fileData count]);
    */
    return path;
}
-(void)pth2array :(NSArray*)array :(NSString *)model_path
{
    //模型文件的路径
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"w2.pth" ofType:nil];
    NSString *path = [[NSBundle mainBundle] pathForResource:model_path ofType:nil];
    NSLog(@"path = %@,%s", path,__FILE__);
    NSError *error;
    //读取file文件并把内容根据换行符分割后赋值给NSArray
    array = [[NSString stringWithContentsOfFile:path
                                              encoding:NSUTF8StringEncoding
                                                 error:&error]
                    componentsSeparatedByString:@" "]; // 分割符为空格
}
@end
