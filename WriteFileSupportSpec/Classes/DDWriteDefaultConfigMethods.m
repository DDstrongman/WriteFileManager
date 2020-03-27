//
//  DDWriteDefaultConfigMethods.m
//  AFNetworking
//
//  Created by DDLi on 2020/3/27.
//

#import "DDWriteDefaultConfigMethods.h"

#import "NSString+DDWriteExt.h"

#define defaultCirName @"DDWriteDefaultCirName"

@interface DDWriteDefaultConfigMethods ()

@property (nonatomic, copy, readwrite) NSString *path;

@end

@implementation DDWriteDefaultConfigMethods

+ (DDWriteDefaultConfigMethods *) ShareInstance {
    static DDWriteDefaultConfigMethods *sharedDefaultWriteFileInstance = nil;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        sharedDefaultWriteFileInstance = [[self alloc] init];
    });
    return sharedDefaultWriteFileInstance;
}

- (instancetype) init {
    return [self initWithPath:defaultCirName];
}

- (instancetype)initWithPath:(NSString *)path {
    if (path.length == 0) return nil;
    
    [[DDWriteFileSupport ShareInstance]createDir:path filed:DDFieldDocuments];
    
    self = [super init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    _path = [documentsDirectory stringByAppendingPathComponent:defaultCirName];
    return self;
}

#pragma mark - main methods
- (nullable NSString *)defaultSearchByUrl:(nonnull NSString *)url
                                  imgType:(DDImgType)type {
    if (!url)
        return nil;
    return [self defaultSearchByFileName:[self changeUrlToFileName:url imgType:type]];
}

- (nullable NSString *)defaultSearchByFileName:(nonnull NSString *)name {
    if (!name)
        return nil;
    return [_path stringByAppendingPathComponent:name];
}

#pragma mark -  ***** 获取默认文件夹下所有子文件路径或文件名 *****
- (nullable NSMutableArray <NSString *> *)searchDefaultDirFilePaths {
    return [[DDWriteFileSupport ShareInstance]readDirPath:_path];
}

- (nullable NSArray <NSString *> *)searchDefaultDirFileNames {
    return [[DDWriteFileSupport ShareInstance]readDirNames:_path];
}

#pragma mark - ***** 写入 *****
- (BOOL)directWriteFileName:(nonnull NSString *)name
                       data:(nonnull id)data {
    if (!name)
        return NO;
    return [[DDWriteFileSupport ShareInstance]directWriteFile:[_path stringByAppendingPathComponent:name] data:data];
}

- (BOOL)writeFile:(nonnull NSString *)name
             data:(nonnull id)data {
    if (!name)
        return NO;
    return [[DDWriteFileSupport ShareInstance]writeFile:[_path stringByAppendingPathComponent:name] data:data];
}

- (BOOL)directWriteImg:(nonnull NSString *)url
                   img:(nonnull UIImage *)img
             imageType:(DDImgType)imgType {
    if (!url || !img)
        return NO;
    return [[DDWriteFileSupport ShareInstance]directWriteFile:[_path stringByAppendingPathComponent:[self changeUrlToFileName:url imgType:imgType]] img:img imageType:imgType];
}

- (BOOL)writeImg:(nonnull NSString *)url
             img:(nonnull UIImage *)img
       imageType:(DDImgType)imgType {
    if (!url || !img)
        return NO;
    return [[DDWriteFileSupport ShareInstance]writeFile:[_path stringByAppendingPathComponent:[self changeUrlToFileName:url imgType:imgType]] img:img imageType:imgType];
}

#pragma mark - ***** 删除 *****
- (BOOL)removeFile:(nonnull NSString *)name {
    if (!name)
        return NO;
    return [[DDWriteFileSupport ShareInstance]removeFile:[_path stringByAppendingPathComponent:name]];
}

- (BOOL)removeImg:(nonnull NSString *)url
          imgType:(DDImgType)imgType{
    if (!url)
        return NO;
    return [[DDWriteFileSupport ShareInstance]removeFile:[_path stringByAppendingPathComponent:[self changeUrlToFileName:url imgType:imgType]]];
}
/**
 以文件夹名删除文件夹
 
 @param dirName 文件夹名
 @return 删除结果
 */
- (BOOL)removeDirFiles:(nonnull NSString *)dirName {
    if (!dirName)
        return NO;
    return [[DDWriteFileSupport ShareInstance]removeDirFiles:[_path stringByAppendingPathComponent:dirName]];
}

#pragma mark - 读取文件操作
/**
 根据name读取默认文件夹下的文件，不存在则返回nil，可选择直接返回的type,如果缓存中存在则直接返回不需要设置返回type
 
 @param name 文件名
 @param type 返回文件类型
 @return 返回文件
 */
- (nullable id)readFile:(nonnull NSString *)name
               fileType:(DDFileType)type {
    if (!name)
        return nil;
    return [[DDWriteFileSupport ShareInstance]readFile:[_path stringByAppendingPathComponent:name] fileType:type];
}
/**
 读取存储的image
 
 @param url 保存图片的url
 @return 返回文件
 */
- (nullable UIImage *)readImg:(nonnull NSString *)url
                      imgType:(DDImgType)imgType {
    if (!url)
        return nil;
    return [[DDWriteFileSupport ShareInstance]readFile:[_path stringByAppendingPathComponent:[self changeUrlToFileName:url imgType:imgType]] fileType:DDFileTypeImage];
}
/**
 删除nscache内的缓存
 */
- (void)flushCache {
    [[DDWriteFileSupport ShareInstance]flushCache];
}

#pragma mark - 计算文件或文件夹大小操作
/**
 通过获取默认存储位置的文件大小
 
 @param type 返回文件大小的计算格式，kb,mb,gb,tb
 @return 返回文件大小
 */
- (float)countSize:(DDSizeType)type {
    return [[DDWriteFileSupport ShareInstance]countDirSize:_path fileSizeType:type];
}

#pragma mark - support methods
- (NSString *)changeUrlToFileName:(NSString *)url
                          imgType:(DDImgType)type {
    NSString *imageName = @"";
    switch (type) {
        case DDImgTypePNG:
            imageName = [[url DDWrite_md5Mod16] stringByAppendingString:@".png"];
            break;
        case DDImgTypeJPEG:
            imageName = [[url DDWrite_md5Mod16] stringByAppendingString:@".jpg"];
            break;
        default:
            imageName = [[url DDWrite_md5Mod16] stringByAppendingString:@".png"];
            break;
    }
    return imageName;
}

@end
