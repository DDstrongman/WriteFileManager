//
//  WriteFileSupport.h
//  ResultContained
//
//  Created by 李胜书 on 15/8/17.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WriteFileSupport : NSObject

@property (nonatomic,strong) NSCache *FileCache;

+ (WriteFileSupport *)ShareInstance;

/**
 存储data流到本地，主要是用来写图片，存于documents路径下，但是不会主动创建文件夹
 
 @param FileName 存储文件名
 @param dirName 文件夹名
 @param pictureData 二进制流
 @return 返回的存储路径
 */
- (NSString *)createFile:(NSString *)FileName DirName:(NSString *)dirName PictureData:(NSData *)pictureData;
/**
 写图片并存在documents路径下，返回文件路径

 @param Dirname 文件夹名称
 @param fileName 文件名
 @param contents 要写的图片文件
 @return 返回的文件路径
 */
- (NSString *)writeFileAndReturn:(NSString *)Dirname FileName:(NSString *)fileName Contents:(UIImage *)contents;

/**
 写documents下的三层文件夹下的图片

 @param firstDir documents下的第一层
 @param secondDir documents下的第二层
 @param thirdDir documents下的第三层
 @param fileName 写的文件名
 @param contents 写的图片
 @return 返回写的路径
 */
- (NSString *)writeCacheReturn:(NSString *)firstDir SecondDir:(NSString *)secondDir ThirdDir:(NSString *)thirdDir FileName:(NSString *)fileName Contents:(UIImage *)contents;

/**
 存储data流到本地，主要是用来写图片，存于documents路径下，会主动创建文件夹

 @param Dirname 文件夹名
 @param fileName 文件名
 @param contents 二进制流
 @return 返回文件路径
 */
- (NSString *)writeImageAndReturn:(NSString *)Dirname FileName:(NSString *)fileName Contents:(NSData *)contents;


///获取documents路径
- (NSString *)dirDoc;
///获取Cache目录x
- (NSString *)dirCache;
/**
 创建文件夹

 @param DirName 文件夹名
 */
- (void)createDir:(NSString *)DirName;
/**
 删除文件

 @param filePath 文件路径，完全路径，没有帮拼接
 */
- (void)removePicture:(NSString *)filePath;
/**
 读取文件夹下所有图片,没有帮拼接，文件夹的完整路径

 @param filePath 文件夹的完整路径
 @return 返回文件的数组
 */
- (NSMutableArray *)readPicture:(NSString *)filePath;

/**
 读取文件夹下所有文件名。可以读取文件夹名，

 @param dirPath 要读取的文件夹名称
 @return 返回的数组
 */
- (NSArray *)readDirNames:(NSString *)dirPath;

///读取图片
- (UIImage *)getLocalMark:(NSString *)filePath;
///删除documents下所有文件
- (void)removeAllDirDocuments;
///获取cache下所有文件的大小
- (float)countAllDirCaches;
///获取documents下所有文件的大小
- (float)countAllDirDocuments;
///获取documents下单个文件夹的大小，用来建议用户是否删除缓存
- (float)countSingleDirDocuments:(NSString *)fileName;
///获取documents下单个文件的大小，用来建议用户是否删除缓存
- (float)countSingleDirFile:(NSString *)fileName;
///写数组保存
- (NSString *)writeArray:(NSArray *)contents DirName:(NSString *)dirName FileName:(NSString *)fileName;
///写字典保存
- (NSString *)writeDictionary:(NSDictionary *)contents DirName:(NSString *)dirName FileName:(NSString *)fileName;
///写二进制文件保存
- (NSString *)writeData:(NSData *)contents DirName:(NSString *)dirName FileName:(NSString *)fileName;
///写二进制文件保存,直接写在dir下
- (BOOL)writeData:(NSData *)contents FileName:(NSString *)fileName;

/**
 直接通过完整路径获取image，增加了缓存机制

 @param filePath 文件路径
 @return 返回图片   
 */
- (UIImage *)readImg:(NSString *)filePath;
///文件是否存在
- (BOOL)isFileExist:(NSString *)fileName;
///读取数组
- (NSMutableArray *)readArray:(NSString *)dirName FileName:(NSString *)fileName;
///读取字典
- (NSMutableDictionary *)readDictionary:(NSString *)dirName FileName:(NSString *)fileName;
///读取data
- (NSData *)readData:(NSString *)dirName FileName:(NSString *)fileName;
/**
清除所有Cache缓存文件,目前是清除sdwebimage的图片缓存
 */
- (void)removeAllCache;
- (void)removeCache:(NSString *)fileName;
///删除documents下文件，用以重置本地缓存
- (void)removeFile:(NSString *)fileName;
- (void)removeDirFile:(NSString *)dirName FileName:(NSString *)fileName;
///刷新nscache
- (void)flushCache;
/**
 *  清除Cache缓存文件
 */
- (void)removeCacheUnderCache:(NSString *)fileName;
///无缓存获取图片
- (UIImage *)readImgNotCache:(NSString *)fileName;

@end
