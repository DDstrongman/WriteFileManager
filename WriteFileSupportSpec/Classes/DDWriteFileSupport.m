//
//  DDWriteFileSupport.m
//  ResultContained
//
//  Created by 李胜书 on 15/8/17.
//  Copyright (c) 2015年 李胜书. All rights reserved.
//


/**
 1:Documents：应用中用户数据可以放在这里，iTunes备份和恢复的时候会包括此目录
 2:tmp：存放临时文件，iTunes不会备份和恢复此目录，此目录下文件可能会在应用退出后删除
 3:Library/Caches：存放缓存文件，iTunes不会备份此目录，此目录下文件不会在应用退出删除
 */


#import "DDWriteFileSupport.h"

#import "NSString+DDWriteExt.h"

@interface DDWriteFileSupport()

@property (nonatomic,strong) NSCache *fileCache;

@end;

@implementation DDWriteFileSupport

+ (DDWriteFileSupport *) ShareInstance {
    static DDWriteFileSupport *sharedWriteFileInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedWriteFileInstance = [[self alloc] init];
    });
    return sharedWriteFileInstance;
}
#pragma mark - Main Methods
- (nullable NSString *)searchFileByUrl:(nullable NSString *)url
                                 filed:(DDFileField)filed {
    if (!url)
        return nil;
    switch (filed) {
        case DDFieldDocuments: {
            NSString *documentPath = [self getDocPath];
            return [documentPath stringByAppendingPathComponent:[url DDWrite_md5Mod16]];
        }
            break;
        case DDFieldLibraryCaches: {
            NSString *libPath = [self getLibPath];
            return [libPath stringByAppendingPathComponent:[url DDWrite_md5Mod16]];
        }
            break;
        case DDFieldTemp: {
            NSString *tempPath = [self getTempPath];
            return [tempPath stringByAppendingPathComponent:[url DDWrite_md5Mod16]];
        }
            break;
            
        default: {
            NSString *documentPath = [self getDocPath];
            return [documentPath stringByAppendingPathComponent:[url DDWrite_md5Mod16]];
        }
            break;
    }
}

- (nullable NSString *)searchFileByUrl:(nullable NSString *)url
                               dirName:(nullable NSString *)dirName
                                 filed:(DDFileField)filed {
    if (!url)
        return nil;
    switch (filed) {
        case DDFieldDocuments: {
            NSString *documentPath = [self getDocPath];
            return [[documentPath stringByAppendingPathComponent:dirName] stringByAppendingPathComponent:[url DDWrite_md5Mod16]];
        }
            break;
        case DDFieldLibraryCaches: {
            NSString *libPath = [self getLibPath];
            return [[libPath stringByAppendingPathComponent:dirName] stringByAppendingPathComponent:[url DDWrite_md5Mod16]];
        }
            break;
        case DDFieldTemp: {
            NSString *tempPath = [self getTempPath];
            return [[tempPath stringByAppendingPathComponent:dirName] stringByAppendingPathComponent:[url DDWrite_md5Mod16]];
        }
            break;
            
        default: {
            NSString *documentPath = [self getDocPath];
            return [[documentPath stringByAppendingPathComponent:dirName] stringByAppendingPathComponent:[url DDWrite_md5Mod16]];
        }
            break;
    }
}

- (nullable NSString *)searchFileByFileName:(nullable NSString *)name
                                      filed:(DDFileField)filed {
    if (!name)
        return nil;
    switch (filed) {
        case DDFieldDocuments: {
            NSString *documentPath = [self getDocPath];
            return [documentPath stringByAppendingPathComponent:name];
        }
            break;
        case DDFieldLibraryCaches: {
            NSString *libPath = [self getLibPath];
            return [libPath stringByAppendingPathComponent:name];
        }
            break;
        case DDFieldTemp: {
            NSString *tempPath = [self getTempPath];
            return [tempPath stringByAppendingPathComponent:name];
        }
            break;
            
        default: {
            NSString *documentPath = [self getDocPath];
            return [documentPath stringByAppendingPathComponent:name];
        }
            break;
    }
}

- (nullable NSString *)searchFileByFileName:(nullable NSString *)name
                                    dirName:(nullable NSString *)dirName
                                      filed:(DDFileField)filed {
    if (!name)
        return nil;
    switch (filed) {
        case DDFieldDocuments: {
            NSString *documentPath = [self getDocPath];
            return [[documentPath stringByAppendingPathComponent:dirName] stringByAppendingPathComponent:name];
        }
            break;
        case DDFieldLibraryCaches: {
            NSString *libPath = [self getLibPath];
            return [[libPath stringByAppendingPathComponent:dirName] stringByAppendingPathComponent:name];
        }
            break;
        case DDFieldTemp: {
            NSString *tempPath = [self getTempPath];
            return [[tempPath stringByAppendingPathComponent:dirName] stringByAppendingPathComponent:name];
        }
            break;
            
        default: {
            NSString *documentPath = [self getDocPath];
            return [[documentPath stringByAppendingPathComponent:dirName] stringByAppendingPathComponent:name];
        }
            break;
    }
}

- (nullable NSMutableArray <NSString *> *)readDirPath:(nullable NSString *)dirPath {
    __block NSMutableArray *filePaths = [@[] mutableCopy];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:dirPath
                                                         error:&error];
    [fileList enumerateObjectsUsingBlock:^(NSString *path, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *picturePath = [dirPath stringByAppendingPathComponent:path];
        picturePath ? [filePaths addObject:picturePath] : nil;
    }];
    return filePaths;
}

- (nullable NSArray <NSString *> *)readDirNames:(nullable NSString *)dirPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:dirPath
                                                error:&error];
    return fileList;
}

- (BOOL)directWriteFile:(NSString *)path
                   data:(id)data {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res = NO;
    if ([data isKindOfClass:[NSDictionary class]] || [data isKindOfClass:[NSArray class]]) {
        NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:data];
        res = [fileManager createFileAtPath:path
                                   contents:myData
                                 attributes:nil];
    } else if ([data isKindOfClass:[UIImage class]]) {
        NSData *myData = [self transformPNG:data];
        res = [fileManager createFileAtPath:path
                                   contents:myData
                                 attributes:nil];
    } else {
        res = [fileManager createFileAtPath:path
                                   contents:data
                                 attributes:nil];
    }
    if (res) {
        if (!_fileCache) {
            _fileCache = [[NSCache alloc]init];
        }
        if (path) {
            [_fileCache setObject:data forKey:path];
        }
    }
    return res;
}

- (BOOL)directWriteFile:(NSString *)path
                    img:(nonnull UIImage *)img
              imageType:(DDImgType)imgType {
    NSData *imgData = [self getImageData:img
                               DDImgType:imgType];
    return [self directWriteFile:path
                            data:imgData];
}

- (BOOL)writeFile:(NSString *)path
             data:(id)data {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res = NO;
    NSData *myData;
    if(![fileManager fileExistsAtPath:path]) {
        if ([data isKindOfClass:[NSDictionary class]] || [data isKindOfClass:[NSArray class]]) {
            myData = [NSKeyedArchiver archivedDataWithRootObject:data];
            res = [fileManager createFileAtPath:path
                                       contents:myData
                                     attributes:nil];
        } else if ([data isKindOfClass:[UIImage class]]) {
            myData = [self transformPNG:data];
            res = [fileManager createFileAtPath:path
                                       contents:myData
                                     attributes:nil];
        } else {
            myData = data;
            res = [fileManager createFileAtPath:path
                                       contents:myData
                                     attributes:nil];
        }
    }
    if (res) {
        if (!_fileCache) {
            _fileCache = [[NSCache alloc]init];
        }
        if (path) {
            [_fileCache setObject:myData forKey:path];
        }
    }
    return res;
}

- (BOOL)writeFile:(NSString *)path
              img:(nonnull UIImage *)img
        imageType:(DDImgType)imgType {
    NSData *imgData = [self getImageData:img
                               DDImgType:imgType];
    return [self writeFile:path
                      data:imgData];
}

- (BOOL)directWriteFileType:(NSString *)path
                       data:(id)data
                      field:(DDFileField)field {
    NSString *finalPath = [self getAbPath:path
                                fileField:field];
    return [self directWriteFile:finalPath
                            data:data];
}

- (BOOL)directWriteFileType:(NSString *)path
                        img:(nonnull UIImage *)img
                  imageType:(DDImgType)imgType
                      field:(DDFileField)field {
    NSData *imgData = [self getImageData:img
                               DDImgType:imgType];
    return [self directWriteFileType:path
                                data:imgData
                               field:field];
}

- (BOOL)writeFileType:(NSString *)path
                 data:(id)data
                field:(DDFileField)field {
    NSString *finalPath = [self getAbPath:path
                                fileField:field];
    return [self writeFile:finalPath
                      data:data];
}

- (BOOL)writeFileType:(NSString *)path
                  img:(nonnull UIImage *)img
            imageType:(DDImgType)imgType
                field:(DDFileField)field {
    NSData *imgData = [self getImageData:img
                               DDImgType:imgType];
    return [self writeFileType:path
                          data:imgData
                         field:field];
}

- (BOOL)createDir:(NSString *)dirName
            filed:(DDFileField)field {
    NSString *finalPath = [self getAbPath:dirName
                                fileField:field];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL res = [fileManager createDirectoryAtPath:finalPath
                      withIntermediateDirectories:YES
                                       attributes:nil
                                            error:nil];
    return res;
}

- (BOOL)removeFile:(NSString *)filePath {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *err;
    BOOL result = NO;
    BOOL bRet = [fileMgr fileExistsAtPath:filePath];
    if (bRet)
        result = [fileMgr removeItemAtPath:filePath
                                     error:&err];
    if (result) {
        if (!_fileCache) {
            _fileCache = [[NSCache alloc]init];
        }
        if (filePath) {
            [_fileCache removeObjectForKey:filePath];
        }
    }
    return result;
}

- (BOOL)removeDirFiles:(NSString *)dirPath {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *filePaths = [self readDirPath:dirPath];
    __block BOOL result = NO;
    if (filePaths.count > 0) {
        result = YES;
    }
    [filePaths enumerateObjectsUsingBlock:^(NSString *filePath, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL bRet = [fileMgr fileExistsAtPath:filePath];
        BOOL removeResult = NO;
        NSError *err;
        if (bRet)
            removeResult = [fileMgr removeItemAtPath:filePath
                                               error:&err];
        if (!removeResult) {
            result = NO;
            *stop = YES;
        }
    }];
    return result;
}

- (id)readFile:(NSString *)filePath
      fileType:(DDFileType)type {
    BOOL isExist;
    if (!_fileCache) {
        _fileCache = [[NSCache alloc]init];
    }
    if ([_fileCache objectForKey:filePath]) {
        NSData *tempData = [_fileCache objectForKey:filePath];
        switch (type) {
            case DDFileTypeImage: {
                UIImage *fileImg = [UIImage imageWithData:tempData];
                return fileImg;
            }
            case DDFileTypeArray: {
                NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
                return array;
            }
            case DDFileTypeDictionary: {
                NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
                return dictionary;
            }
            case DDFileTypeData: {
                return tempData;
            }
            default: {
                return tempData;
            }
        }
    } else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        isExist = [fileManager fileExistsAtPath:filePath];
        if (isExist) {
            NSData *tempData = [NSData dataWithContentsOfFile:filePath];
            switch (type) {
                case DDFileTypeImage: {
                    UIImage *fileImg = [UIImage imageWithData:tempData];
                    [_fileCache setObject:fileImg forKey:filePath];
                    return fileImg;
                }
                case DDFileTypeArray: {
                    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
                    [_fileCache setObject:array forKey:filePath];
                    return array;
                }
                case DDFileTypeDictionary: {
                    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:tempData];
                    [_fileCache setObject:dictionary forKey:filePath];
                    return dictionary;
                }
                case DDFileTypeData: {
                    [_fileCache setObject:tempData forKey:filePath];
                    return tempData;
                }
                default: {
                    [_fileCache setObject:tempData forKey:filePath];
                    return tempData;
                }
            }
        } else {
            return nil;
        }
    }
}

- (id)readFile:(NSString *)filePath
      fileType:(DDFileType)type
     fileField:(DDFileField)field {
    NSString *finalPath = [self getAbPath:filePath
                                fileField:field];
    return [self readFile:finalPath
                 fileType:type];
}

- (void)flushCache {
    [_fileCache removeAllObjects];
}

- (float)countFileSize:(NSString *)filePath
          fileSizeType:(DDSizeType)type {
    NSFileManager *manager = [NSFileManager defaultManager];
    float size = 0;
    if ([manager fileExistsAtPath:filePath]) {
        size = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    switch (type) {
        case DDSizeTypeKB:
            size = size/1024.0;
            break;
        case DDSizeTypeMB:
            size = size/(1024.0*1024.0);
            break;
        case DDSizeTypeGB:
            size = size/(1024.0*1024.0*1024.0);
            break;
        case DDSizeTypeTB:
            size = size/(1024.0*1024.0*1024.0*1024.0);
            break;
        default:
            size = size/1024.0;
            break;
    }
    return size;
}

- (float)countFileSize:(NSString *)filePath
                 field:(DDFileField)field
          fileSizeType:(DDSizeType)type {
    NSString *finalPath = [self getAbPath:filePath
                                fileField:field];
    return [self countFileSize:finalPath
                  fileSizeType:type];
}

- (float)countDirSize:(NSString *)dirPath
         fileSizeType:(DDSizeType)type {
    __block float size = 0;
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:dirPath]) {
        NSArray *dirArr = [self readDirPath:dirPath];
        [dirArr enumerateObjectsUsingBlock:^(NSString *file, NSUInteger idx, BOOL * _Nonnull stop) {
            size += [self countFileSize:file
                           fileSizeType:type];
        }];
    }
    return size;
}

- (float)countDirSize:(NSString *)dirPath
                field:(DDFileField)field
         fileSizeType:(DDSizeType)type {
    NSString *finalPath = [self getAbPath:dirPath
                                fileField:field];
    return [self countDirSize:finalPath
                 fileSizeType:type];
}
#pragma mark - Support Methods
/**
 通过选择的相对位置获取绝对路径
 
 @param filePath 相对路径
 @param field 选择位置
 @return 返回绝对路径
 */
- (NSString *)getAbPath:(NSString *)filePath
              fileField:(DDFileField)field {
    ///选择的路径位置
    NSString *typePath;
    switch (field) {
        case DDFieldDocuments: {
            typePath = [self getDocPath];
        }
            break;
        case DDFieldLibraryCaches: {
            typePath = [self getCachePath];
        }
            break;
        case DDFieldTemp: {
            typePath = [self getTempPath];
        }
            break;
        default:
            break;
    }
    NSString *finalPath = [typePath stringByAppendingPathComponent:filePath];
    return finalPath;
}

- (NSData *)getImageData:(UIImage *)image
               DDImgType:(DDImgType)imgType {
    NSData *imgData;
    switch (imgType) {
        case DDImgTypePNG:
            imgData = [self transformPNG:image];
            break;
        case DDImgTypeJPEG:
            imgData = [self transformJEPG:image];
            break;
        default:
            imgData = [self transformPNG:image];
            break;
    }
    return imgData;
}
/**
 剪切图片为目标size
 
 @param targetSize 目标size
 @param sourceImage 源图片
 @return 返回剪切后的图片
 */
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize
                                    sourceImage:(UIImage *)sourceImage {
    UIGraphicsBeginImageContext(targetSize);
    [sourceImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
///PNG to Data
- (NSData *)transformPNG:(UIImage *)image {
    NSData *insertPngImageData = UIImagePNGRepresentation(image);
    return insertPngImageData;
}
///JEPG to Data
- (NSData *)transformJEPG:(UIImage *)image {
    NSData *insertJepgImageData = UIImageJPEGRepresentation(image,1.0);
    return insertJepgImageData;
}
///获取documents路径
- (NSString *)getDocPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}
///获取Library目录
- (NSString *)getLibPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    return libraryDirectory;
}
///获取Cache目录
- (NSString *)getCachePath {
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    return cachePath;
}
///获取Tmp目录
- (NSString *)getTempPath {
    NSString *tmpDirectory = NSTemporaryDirectory();
    return tmpDirectory;
}

@end
