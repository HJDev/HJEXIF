//
//  ViewController.m
//  HJEXIF
//
//  Created by 何军 on 01/08/2017.
//  Copyright © 2017 何军. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *fileDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    fileDir = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [fileDir stringByAppendingPathComponent:@"/Resource.bundle/webp.png"];
    
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    
    NSString *imageType = [self typeForImageData:imageData];
    NSLog(@"%@", imageType);
    
}

/**
 *
 * 根据图片数据获取图片的原始类型
 *
 * @param data 图片的二进制数据
 * @return 图片的实际格式
 */
- (NSString *)typeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x52: {
            //R as RIFF for WEBP
            if (data.length < 12) {
                return nil;
            }
            NSString *identifierTypeStr = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([identifierTypeStr hasPrefix:@"RIFF"] && [identifierTypeStr hasSuffix:@"WEBP"]) {
                return @"image/webp";
            }
            return nil;
        }
            
        default:
            break;
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
