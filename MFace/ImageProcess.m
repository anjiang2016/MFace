//
//  ImageProcess.m
//  MFace
//
//  Created by 赵明明 on 2020/11/11.
//

#import "ImageProcess.h"
#import "utils.h"
@implementation ImageProcess

- (void) setBlue:(uint32_t*)rgbImageBuf :(int)pixelNum{
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] -=ptr[3]; //0~255 red
            ptr[2] -=ptr[2];//green
            ptr[1] -=0;//blue;
            ptr[0] = 255;
    }
}

- (void) setGreen:(uint32_t*)rgbImageBuf :(int)pixelNum{
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] -=ptr[3]; //0~255 red
            ptr[2] -=0;//green
            ptr[1] -=ptr[1];//blue;
            ptr[0] = 255;
    }
}

- (void) setRed:(uint32_t*)rgbImageBuf :(int)pixelNum{
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] -=0; //0~255 red
            ptr[2] -=ptr[2];//green
            ptr[1] -=ptr[1];//blue;
            ptr[0] = 255;
    }
}

- (void) U2F:(uint32_t*)rgbImageBuf :(int)pixelNum :(float*)rgbFloatBuf{
    uint32_t* pCurPtr = rgbImageBuf;
    float* fptr = rgbFloatBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++,fptr++){
        // 改成下面的代码，会将图片转成想要的颜色
        uint8_t* ptr = (uint8_t*)pCurPtr;
        //ptr[3] -=0; //0~255 red
        //ptr[2] -=ptr[2];//green
        //ptr[1] -=ptr[1];//blue;
        //ptr[0] = 255;
        float Rvalue = (float)ptr[3];
        float Gvalue = (float)ptr[2];
        float Bvalue = (float)ptr[1];
        float gray= 0.30*Rvalue+0.59*Gvalue+0.11*Bvalue;
        //memset(fptr,gray,sizeof(float));
        *fptr=(gray/255.0f);
        //0.30R+ 0.59G + 0.11B
        // rgb2gray
        //fptr[i] = (float)ptr[3];// use red channel to be the pixel's float value
    }
}


- (void) U2F_3:(uint32_t*)rgbImageBuf :(int)pixelNum :(int)in_channel :(float*)rgbFloatBuf{
    uint32_t* pCurPtr = rgbImageBuf;
    float* fptr = rgbFloatBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        // 改成下面的代码，会将图片转成想要的颜色
        uint8_t* ptr = (uint8_t*)pCurPtr;
        //ptr[3] -=0; //0~255 red
        //ptr[2] -=ptr[2];//green
        //ptr[1] -=ptr[1];//blue;
        //ptr[0] = 255;
        float Rvalue = (float)ptr[3];
        float Gvalue = (float)ptr[2];
        float Bvalue = (float)ptr[1];
        float gray= 0.30*Rvalue+0.59*Gvalue+0.11*Bvalue;
        //memset(fptr,gray,sizeof(float));
        fptr[i]=(Rvalue/255.0f);
        fptr[i+pixelNum]=(Gvalue/255.0f);
        fptr[i+pixelNum*2]=(Bvalue/255.0f);
        //printf("i=%d,%f,%f,%f\n",i,fptr[i],fptr[i+pixelNum],fptr[i+pixelNum*2]);
        
        //0.30R+ 0.59G + 0.11B
        // rgb2gray
        //fptr[i] = (float)ptr[3];// use red channel to be the pixel's float value
    }
}


- (void) F2U:(uint32_t*)rgbImageBuf :(int)pixelNum :(float*)rgbFloatBuf{
    uint32_t* pCurPtr = rgbImageBuf;
    float* fptr = rgbFloatBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++,fptr++){
        // 改成下面的代码，会将图片转成想要的颜色
        uint8_t* ptr = (uint8_t*)pCurPtr;
        uint8_t temp=0;
        float gray = *fptr;
        temp = (uint8_t)(gray*255.0f);
        //temp = (uint8_t)fptr[0];
        ptr[3] =temp; //0~255 red
        ptr[2] =temp;//green
        ptr[1] =temp;//blue;
        ptr[0] = 255;
    }
}

- (void) F2U_3:(uint32_t*)rgbImageBuf :(int)pixelNum :(float*)rgbFloatBuf{
    uint32_t* pCurPtr = rgbImageBuf;
    float* fptr = rgbFloatBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++,fptr++){
        // 改成下面的代码，会将图片转成想要的颜色
        uint8_t* ptr = (uint8_t*)pCurPtr;
        uint8_t temp=0;
        float rvalue = fptr[0];
        float gvalue = fptr[0+pixelNum];
        float bvalue = fptr[0+2*pixelNum];
        
        temp = (uint8_t)(rvalue*255.0f);
        ptr[3] =temp; //0~255 red
        
        temp = (uint8_t)(gvalue*255.0f);
        ptr[2] =temp;//green
        
        temp = (uint8_t)(bvalue*255.0f);
        ptr[1] =temp;//blue;
        ptr[0] = 255;
    }
}



- (void) conv2d:(uint32_t*)rgbImageBuf :(uint32_t*)res :(int)width :(int)height :(float*)weightsarray :(int)kernel_size :(float*)bias :(int)padding :(int)stride :(int)in_channel :(int)out_channel{
    
    uint32_t* pCurPtr = rgbImageBuf;
    int pixNumber = width*height;
    float* rgbFloatBuf = (float*)malloc(width*height*sizeof(float));
    float* resFloat = (float*)malloc((width+kernel_size)*(height+kernel_size)*sizeof(float));
    
    [self U2F:rgbImageBuf:pixNumber:rgbFloatBuf];
    [self U2F:res:pixNumber:resFloat];
    
    [self conv2:(float*)weightsarray:(float *)bias:(float*)rgbFloatBuf:(float*)resFloat:kernel_size:kernel_size:width:height:in_channel:out_channel];
    [self F2U:res:pixNumber:resFloat];
    /*
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] -=0; //0~255 red
            ptr[2] -=ptr[2];//green
            ptr[1] -=ptr[1];//blue;
            ptr[0] = 255;
    }
    */
}


- (void) conv2:(float*)filter :(float*)bias :(float*)arr :(float*)res :(int)filterW :(int)filterH :(int)arrW :(int)arrH :(int)in_channel :(int)out_channel
{
    float temp;
    int radus = (int)((float)filterW/2.0f);
    for (int i=-radus; i<arrH+radus; i++)
    {
        for (int j=-radus; j<arrW+radus; j++)
        {
            temp = 0;
            for (int m=0; m<filterH; m++)
            {
                for (int n=0; n<filterW; n++)
                {
                    
                    if ((i+m-radus)>=0 && (i+m-radus)<arrH && (j+n-radus)>=0 && (j+n-radus)<arrW)
                    {
                        //temp += filter[m][n]*arr[i-m][j-n];
                        temp += filter[m*filterW+n]*arr[(i+m-radus)*arrW+(j+n-radus)];
                        //filter[0][0];
                    }
                }
            }
            if((i>-1 && i<arrH)&&(j>-1 && j<arrW))
            {
                res[i*arrW+j]=temp;
            }
        }
        //printf("i=%d\n",i);
    }

}

// filter : k,k,in_c,out_c
// arr: w,h,in_c
// res: w,h out_c

- (void) conv4d:(uint32_t*)rgbImageBuf :(uint32_t*)res :(int)width :(int)height :(float*)weightsarray :(int)kernel_size :(float*)bias :(int)padding :(int)stride :(int)in_channel :(int)out_channel{
    
    uint32_t* pCurPtr = rgbImageBuf;
    int pixNumber = width*height;
    float* rgbFloatBuf = (float*)malloc(width*height*in_channel*sizeof(float));
    float* resFloat = (float*)malloc((width+kernel_size)*(height+kernel_size)*(out_channel)*sizeof(float));
    
    [self U2F_3:rgbImageBuf:width*height:in_channel:rgbFloatBuf];
    //[self U2F:res:width*height*out_channel:resFloat];
    
    [self conv4:(float*)weightsarray:(float *)bias:(float*)rgbFloatBuf:(float*)resFloat:kernel_size:kernel_size:width:height:in_channel:out_channel];
    [self F2U_3:res:pixNumber:resFloat];
    /*
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] -=0; //0~255 red
            ptr[2] -=ptr[2];//green
            ptr[1] -=ptr[1];//blue;
            ptr[0] = 255;
    }
    */
}
- (void) display:(float*)array :(int)num{
    for(int i=0;i<num;i++)
    {
        printf("%f,",array[i]);
    }
}
- (void) conv4:(float*)filter :(float*)bias :(float*)arr :(float*)res :(int)filterW :(int)filterH :(int)arrW :(int)arrH :(int)in_channel :(int)out_channel
{
    float temp;
    int radus = (int)((float)filterW/2.0f);
    
    //[self display:filter:3*3*3*4];
    //[self display:arr:3*25];
    //[self display:arr:3*25];
    
    for (int oc=0;oc<out_channel;oc++)
    {
        // do one channel convolution
        for (int i=-radus; i<arrH+radus; i++)
        {
            for (int j=-radus; j<arrW+radus; j++)
            {
                temp=0;
                for(int ic=0;ic<in_channel;ic++)
                {
                    
                    for (int m=0; m<filterH; m++)
                    {
                        for (int n=0; n<filterW; n++)
                        {
                            
                            if ((i+m-radus)>=0 && (i+m-radus)<arrH && (j+n-radus)>=0 && (j+n-radus)<arrW)
                            {
                                //temp += filter[m][n]*arr[i-m][j-n];
                                temp += filter[(oc*in_channel+ic)*filterW*filterH+m*filterW+n]*arr[ic*arrW*arrH+(i+m-radus)*arrW+(j+n-radus)];
                                float weight=filter[(oc*in_channel+ic)*filterW*filterH+m*filterW+n];
                                int index =ic*arrW*arrH+(i+m-radus)*arrW+(j+n-radus);
                                float pix=arr[ic*arrW*arrH+(i+m-radus)*arrW+(j+n-radus)];
                                int index_weight=(oc*in_channel+ic)*filterW*filterH+m*filterW+n;
                                //printf("index=%d,weight_index=%d\n",index,index_weight);
                                //filter[0][0];
                            }
                        }
                    }
                }
                if((i>-1 && i<arrH)&&(j>-1 && j<arrW))
                {
                    res[oc*arrW*arrH+i*arrW+j]=temp;
                    //printf("[%d,%d,%d]=%f\n",i,j,oc,temp);
                }
            }
                //printf("i=%d\n",i);
        }
            // done
            
    }
    
    
    

}

- (UIImage* )passlayer:(UIImage*)image :(float*)weightsarray :(int)kernel_size :(int)bias :(int)padding :(int)stride :(int)in_channel :(int)out_channel{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    uint32_t* res = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    
    
    //change the UIImage to uint_32
    [self UIImage2array:image:rgbImageBuf];
    
    // do some imageprocess
    int pixelNum = imageWidth * imageHeight;
    //[self setBlue:rgbImageBuf:pixelNum];
    
    
    //二维卷积，输入1通道，输出1通道
    //[self conv2d:(uint32_t*)rgbImageBuf :(uint32_t*)res :(int)imageWidth :(int)imageHeight :weightsarray :kernel_size :bias :padding :stride :in_channel :out_channel];
    
    // 4维度，输入3通道，输出4通道
    [self conv4d:(uint32_t*)rgbImageBuf :(uint32_t*)res :(int)imageWidth :(int)imageHeight :weightsarray :kernel_size :bias :padding :stride :in_channel :out_channel];
    
    
    
    
    // change the uint_32 array to UIImage for show
    //image=[self array2UIImage:rgbImageBuf:image];
    image=[self array2UIImage:res:image];
    
    
    //free((void*)rgbImageBuf);
    
    return image;
    //return rgbImageBuf;
}


- (UIImage *)scaleToSize:(UIImage *)img :(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (void)UIImage2array:(UIImage*)image :(uint32_t*)rgbImageBuf{
//- UIImage* transimg(UIImage* image,uint8_t red,uint8_t green,uint8_t blue){
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    //uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    //rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
}

- (UIImage* )array2UIImage:(uint32_t*)rgbImageBuf :(UIImage*)image{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 输出图片
    utils *p = [utils new];
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, NULL);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    image = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    return image;
}


- (UIImage*)imageBlackToTransparent:(UIImage*)image :(CGFloat)red :(CGFloat)green :(CGFloat)blue{
//- UIImage* transimg(UIImage* image,uint8_t red,uint8_t green,uint8_t blue){
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){

        if ((*pCurPtr & 0xFFFFFF00) < 0x82828200)    // 将像素值进行判断
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = 255-ptr[3]; //0~255 red
            ptr[2] = 255-ptr[2];//green
            ptr[1] = 255-ptr[1];//blue;
            ptr[0] = 255;
//            ptr[0] = 0;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }

    }
       
    // 输出图片
    utils *p = [utils new];
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, NULL);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

@end
