//
//  model.m
//  MFace
//
//  Created by 赵明明 on 2020/11/13.
//

#import "model.h"

@implementation model

-(NSString*)getModel :(float*)farray
{
    //模型文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"w2.pth" ofType:nil];
        NSLog(@"path = %@,%s", path,__FILE__);
    
    NSArray *fileData;
    NSError *error;
        
    //读取file文件并把内容根据换行符分割后赋值给NSArray
    fileData = [[NSString stringWithContentsOfFile:path
                                              encoding:NSUTF8StringEncoding
                                                 error:&error]
                    componentsSeparatedByString:@"\n"];
        
    //NSLog(@"fileData = %@", fileData);
    // fileData.count();
    unsigned long  count = [fileData count];
    // 因为文件还有最后一行，所以这里把行数减1
    count = count -1;
    for(int i=0;i<count;i++)
    {
        farray[i]=[[fileData objectAtIndex:i] floatValue];
        //[[fileData objectAtIndex:i] floatValue];
        //NSLog(@"farray[%d]=%@",i,[fileData objectAtIndex:i]);
    }
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

@end
