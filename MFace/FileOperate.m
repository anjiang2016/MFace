//
//  FileOperate.m
//  MFace
//
//  Created by 赵明明 on 2020/11/13.
//
//文件目录
/*
        NSString *dirName = @"testDir";
        
        //创建NSFileManager实例
        NSFileManager *fm = [NSFileManager defaultManager];
        
        //获取当前目录
        NSString *path = [fm currentDirectoryPath];
        NSLog(@"Path:%@",path);
        
        //创建新目录
        [fm createDirectoryAtPath:dirName withIntermediateDirectories:YES attributes:nil error:NULL];
        
        //重命名新的目录
        [fm moveItemAtPath:dirName toPath:@"newDir" error:NULL];
        
        //更改当前目录到新的目录
        [fm changeCurrentDirectoryPath:@"newDir"];
        
        //获取当前工作目录
        path = [fm currentDirectoryPath];
        NSLog(@"Path:%@",path);

*/

#import "FileOperate.h"

@implementation FileOperate


- (void) stringArray2FloatArray :(NSString*)sarray :(float *)farray
{
    //float farray[2];
    //float fff={0.2,0.3};
    //float bias = malloc(sizeof(float));
    //NSString* newstring=@"1.1,2.2";
    NSArray  *tmp_array = [sarray componentsSeparatedByString:@","];
    NSLog(@"array=%@",tmp_array);
    NSLog(@"array[0]=%@",[tmp_array objectAtIndex:0]);
    for(int i=0;i<[tmp_array count];i++)
    {
        farray[i]=[[tmp_array objectAtIndex:i] floatValue];
        NSLog(@"farray[%d]=%f",i,farray[i]);
    }
}

- (void) read2show :(NSString * )filePath_in
{
    //创建NSFileManager实例
    NSFileManager *fm = [NSFileManager defaultManager];
            
    //获取当前目录
    NSString *path = [fm currentDirectoryPath];
    NSLog(@"Path:%@",path);
    
    
    NSArray *fileArray1 = [[NSArray alloc]init];

    fileArray1 = [fm contentsOfDirectoryAtPath:@"/usr/" error:nil];

    NSLog(@"fileArray1 = %@", fileArray1);


    
    
    
    

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"gen-rsa1024-key-test-16" ofType:@"cmd"];
    NSLog(@"filePath=[%@]",filePath);
    NSArray *fileData;
    NSError *error;
    
    //读取file文件并把内容根据换行符分割后赋值给NSArray
    fileData = [[NSString stringWithContentsOfFile:filePath
                                          encoding:NSUTF8StringEncoding
                                             error:&error]
                componentsSeparatedByString:@"\n"];
    
    
    //获取NSArray类型对象的迭代器
    NSEnumerator *arrayEnumerator = [fileData objectEnumerator];
    NSString *tempStr;
    
    while (tempStr = [arrayEnumerator nextObject]) {
        NSLog(@"%@",tempStr);
    }
}


-(void) openAssets{
    NSArray *mainpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [mainpaths objectAtIndex:0];
    NSFileManager *Filemanager = [NSFileManager defaultManager];
    NSArray *fileList = [Filemanager contentsOfDirectoryAtPath:documentsDir error:nil];
    for (NSString *s in fileList)
    {
        NSLog(@"YOu subfolder--%@", s);
        
    }
}

@end
