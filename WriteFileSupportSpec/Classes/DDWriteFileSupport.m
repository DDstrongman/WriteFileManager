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
#import <SDWebImage/SDImageCache.h>

@implementation DDWriteFileSupport

+ (DDWriteFileSupport *) ShareInstance {
    static DDWriteFileSupport *sharedWriteFileInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedWriteFileInstance = [[self alloc] init];
    });
    return sharedWriteFileInstance;
}

#pragma 文件存储操作,documents存储常用文件，tmp存储临时文件，Library/Caches：存放缓存文件，保存应用的持久化数据
//dirName存储的文件夹名字；fileName
- (NSString *)writeFileAndReturn:(NSString *)Dirname FileName:(NSString *)fileName Contents:(UIImage *)contents {
    [self createDir:Dirname];
    NSData *pictureData = [self transformPNG:contents];
    NSString *returnString = [self createFile:fileName DirName:Dirname PictureData:pictureData];
    return returnString;
}

- (NSString *)writeImageAndReturn:(NSString *)Dirname FileName:(NSString *)fileName Contents:(NSData *)contents{
    [self createDir:Dirname];
    NSString *returnString = [self createFile:fileName DirName:Dirname PictureData:contents];
    return returnString;
}

- (NSString *)writeCacheReturn:(NSString *)firstDir SecondDir:(NSString *)secondDir ThirdDir:(NSString *)thirdDir FileName:(NSString *)fileName Contents:(UIImage *)contents {
    NSString *firstPath = firstDir;
    NSString *secondePath = [firstPath stringByAppendingPathComponent:secondDir];
    NSString *thirdPath = [secondePath stringByAppendingPathComponent:thirdDir];
    [self createDir:firstPath];
    [self createDir:secondePath];
    [self createDir:thirdPath];
    NSData *pictureData = [self transformPNG:contents];
    NSString *returnString = [self createFile:fileName DirName:thirdPath PictureData:pictureData];
    return returnString;
}

//创建文件
- (NSString *)createFile:(NSString *)FileName DirName:(NSString *)dirName PictureData:(NSData *)pictureData {
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath = testDirectory;
    NSString *filePath = [testPath stringByAppendingFormat:@"/%@.png",FileName];
    BOOL res;
    if(![fileManager fileExistsAtPath:filePath]) //如果不存在
        res = [fileManager createFileAtPath:filePath contents:pictureData attributes:nil];
    return filePath;
}

//创建文件
- (NSString *)createMP3File:(NSString *)FileName DirName:(NSString *)dirName MP3Data:(NSData *)mp3Data {
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath =testDirectory;
    BOOL res=[fileManager createFileAtPath:[testPath stringByAppendingFormat:@"/%@.mp3",FileName] contents:mp3Data attributes:nil];
    if (res) {
        
    }else {
        
    }
    return [testPath stringByAppendingFormat:@"/%@.png",FileName];
}

//创建缩略图
- (NSString *)createCropFile:(NSString *)FileName DirName:(NSString *)dirName PictureData:(NSData *)pictureData {
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath =testDirectory;
    BOOL res=[fileManager createFileAtPath:[testPath stringByAppendingFormat:@"/%@.jpg",FileName] contents:pictureData attributes:nil];
    if (res) {
        
    }else {
        
    }
    return [testPath stringByAppendingFormat:@"/%@.jpg",FileName];
}

//读取文件夹下所有图片
- (NSMutableArray *)readPicture:(NSString *)filePath {
    NSMutableArray *filePaths = [@[] mutableCopy];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    NSString *picturePath;
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:filePath error:&error];
    for(int i = 0;i < fileList.count;i++) {
        picturePath = [NSString stringWithFormat:@"%@%@%@",filePath,@"/",fileList[i]];
        [filePaths addObject:picturePath];
    }
    return filePaths;
}

- (NSArray *)readDirNames:(NSString *)dirPath {
    NSMutableArray *fileNames = [@[] mutableCopy];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:dirPath error:&error];
    return fileList;
}

- (void)removePicture:(NSString *)filePath {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *err;
    BOOL bRet = [fileMgr fileExistsAtPath:filePath];
    if (bRet) {
        [fileMgr removeItemAtPath:filePath error:&err];
    }
}

#pragma 剪切
- (UIImage *) imageByScalingProportionallyToSize:(CGSize)targetSize sourceImage:(UIImage *)sourceImage {
    UIGraphicsBeginImageContext(targetSize);
    [sourceImage drawInRect:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma 获取当前时间和设备id处理为需要的字符串
- (NSString *)getTimeAndDeviceString {
    return [self getDateTimeStr];
}

//取得当前时间字符串
- (NSString*)getDateTimeStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    
    NSDate *now = [NSDate date];
    
    NSString *theDate = [dateFormatter stringFromDate:now];
    
    return theDate;
}

#pragma 转化UIImage为NSData样例,方案废弃,改用文件存储image，数据库存储图片存储路径
#pragma PNG
- (NSData *)transformPNG:(UIImage *)image {
    NSData *insertPngImageData=UIImagePNGRepresentation(image);
    return insertPngImageData;
}

#pragma JEPG
- (NSData *)transformJEPG:(UIImage *)image {
    NSData *insertJepgImageData=UIImageJPEGRepresentation(image,1.0);
    return insertJepgImageData;
}

- (NSString *)dirDoc {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

///获取Library目录
- (void)dirLib {
    //[NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
}

///获取Cache目录
- (NSString *)dirCache {
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    return cachePath;
}

///返回Cache目录
- (NSString *)getDirCache {
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
    return cachePath;
}

///获取Tmp目录
- (void)dirTmp {
    //[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
    NSString *tmpDirectory = NSTemporaryDirectory();
}

///创建文件夹
- (void)createDir:(NSString *)DirName {
    NSString *documentsPath = [self dirDoc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:DirName];
    // 创建目录
    BOOL res = [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (res){
        
    }
    else {
        
    }
}

///写数组
- (NSString *)writeArray:(NSArray *)contents DirName:(NSString *)dirName FileName:(NSString *)fileName {
    NSString *cachePath =[self dirDoc];
    if (!_FileCache) {
        _FileCache = [[NSCache alloc]init];
    }
    NSString *testDirectory = [cachePath stringByAppendingPathComponent:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:testDirectory]) {
        [self createDir:dirName];
    }
    NSString *testPath = [testDirectory stringByAppendingPathComponent:fileName];
    BOOL res = [contents writeToFile:testPath atomically:YES];
    
    if (fileName != nil&&contents != nil) {
        [_FileCache setObject:contents forKey:fileName];
    }
    if (res) {
        
    }
    else {
        
    }
    return testPath;
}

///写字典
- (NSString *)writeDictionary:(NSDictionary *)contents DirName:(NSString *)dirName FileName:(NSString *)fileName {
    NSString *documentsPath =[self dirDoc];
    if (!_FileCache) {
        _FileCache = [[NSCache alloc]init];
    }
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:testDirectory]) {
        [self createDir:dirName];
    }
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:contents];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:fileName];
    BOOL res = [myData writeToFile:testPath atomically:YES];
    if (fileName != nil&&contents != nil) {
        [_FileCache setObject:contents forKey:fileName];
    }
    if (res) {
        
    }
    else{
        
    }
    return testPath;
}

- (NSString *)writeData:(NSData *)contents DirName:(NSString *)dirName FileName:(NSString *)fileName {
    NSString *documentsPath =[self dirDoc];
    if (!_FileCache) {
        _FileCache = [[NSCache alloc]init];
    }
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:dirName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:testDirectory]) {
        [self createDir:dirName];
    }
    NSString *testPath = [testDirectory stringByAppendingPathComponent:fileName];
    BOOL res = [contents writeToFile:testPath atomically:YES];
    if (fileName != nil && contents != nil) {
        [_FileCache setObject:contents forKey:fileName];
    }
    if (res){
        
    }
    else{
        
    }
    return testPath;
}

- (BOOL)writeData:(NSData *)contents FileName:(NSString *)fileName {
    NSString *documentsPath =[self dirDoc];
    if (!_FileCache) {
        _FileCache = [[NSCache alloc]init];
    }
    NSString *testPath = [documentsPath stringByAppendingPathComponent:fileName];
    BOOL res = [contents writeToFile:testPath atomically:YES];
    if (fileName != nil && contents != nil) {
        [_FileCache setObject:contents forKey:fileName];
    }
    if (res){
        
    }
    else{
        
    }
    return res;
}

- (UIImage *)readImg:(NSString *)filePath {
    NSData *tempData;
    BOOL isExist;
    if (!_FileCache) {
        _FileCache = [[NSCache alloc]init];
    }
    NSData *cacheData = [_FileCache objectForKey:filePath];
    if(cacheData){
        return [UIImage imageWithData:cacheData];
    }else{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        isExist = [fileManager fileExistsAtPath:filePath];
        if (isExist) {
            tempData = [NSData dataWithContentsOfFile:filePath];
            if (tempData) {
                [_FileCache setObject:tempData forKey:filePath];
            }
            return [UIImage imageWithData:tempData];
        }else{
            return nil;
        }
    }
}

- (UIImage *)readImgNotCache:(NSString *)fileName {
    NSData *tempData;
    BOOL isExist;
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:fileName];
    NSData *cacheData;
    if(cacheData){
        return [UIImage imageWithData:cacheData];
    }else{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        isExist = [fileManager fileExistsAtPath:testDirectory];
        if (isExist) {
            tempData = [NSData dataWithContentsOfFile:testDirectory];
            return [UIImage imageWithData:tempData];
        }else{
            return nil;
        }
    }
}

- (BOOL)isFileExist:(NSString *)fileName{
    BOOL isExist;
    NSString *documentsPath =[self dirDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    isExist = [fileManager fileExistsAtPath:testDirectory];
    return isExist;
}

- (NSMutableArray *)readArray:(NSString *)dirName FileName:(NSString *)fileName {
    NSMutableArray *tempArray = [NSMutableArray array];
    BOOL isExist;
    NSString *documentsPath =[self dirDoc];
    if (!_FileCache) {
        _FileCache = [[NSCache alloc]init];
    }
    NSString *tempPath = [documentsPath stringByAppendingPathComponent:dirName];
    NSString *testDirectory = [tempPath stringByAppendingPathComponent:fileName];
    
    NSMutableArray *cacheData = [_FileCache objectForKey:fileName];
    if(cacheData) {
        return cacheData;
    }else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        isExist = [fileManager fileExistsAtPath:testDirectory];
        if (isExist) {
            tempArray = [NSMutableArray arrayWithContentsOfFile:testDirectory];
            [_FileCache setObject:tempArray forKey:fileName];
            return tempArray;
        }else{
            return nil;
        }
    }
}

- (NSMutableDictionary *)readDictionary:(NSString *)dirName FileName:(NSString *)fileName {
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    BOOL isExist;
    NSString *documentsPath =[self dirDoc];
    if (!_FileCache) {
        _FileCache = [[NSCache alloc]init];
    }
    NSString *tempPath = [documentsPath stringByAppendingPathComponent:dirName];
    NSString *testDirectory = [tempPath stringByAppendingPathComponent:fileName];
    
    NSMutableDictionary *cacheData = [_FileCache objectForKey:fileName];
    if(cacheData){
        return cacheData;
    }else{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        isExist = [fileManager fileExistsAtPath:testDirectory];
        if (isExist) {
            tempDic = (NSMutableDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfFile:testDirectory]];
            [_FileCache setObject:tempDic forKey:fileName];
            return tempDic;
        }else{
            return nil;
        }
    }
}

- (NSData *)readData:(NSString *)dirName FileName:(NSString *)fileName {
    NSData *tempData;
    BOOL isExist;
    NSString *documentsPath =[self dirDoc];
    if (!_FileCache) {
        _FileCache = [[NSCache alloc]init];
    }
    NSString *tempPath = [documentsPath stringByAppendingPathComponent:dirName];
    NSString *testDirectory = [tempPath stringByAppendingPathComponent:fileName];
    NSData *cacheData = [_FileCache objectForKey:fileName];
    if(cacheData){
        return cacheData;
    }else{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        isExist = [fileManager fileExistsAtPath:testDirectory];
        if (isExist) {
            tempData = [NSData dataWithContentsOfFile:testDirectory];
            [_FileCache setObject:tempData forKey:fileName];
            return tempData;
        }else{
            return nil;
        }
    }
}

- (void)flushCache{
    [_FileCache removeAllObjects];
}

- (void)removeFile:(NSString *)fileName {
    BOOL isExist;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [self dirDoc];
    NSString *finalPath = [documentsPath stringByAppendingPathComponent:fileName];
    isExist = [fileManager fileExistsAtPath:finalPath];
    if (isExist)
        [fileManager removeItemAtPath:finalPath error:NULL];
}

- (void)removeDirFile:(NSString *)dirName FileName:(NSString *)fileName {
    BOOL isExist;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [self dirDoc];
    NSString *tempPath = [documentsPath stringByAppendingPathComponent:dirName];
    NSString *finalPath = [tempPath stringByAppendingPathComponent:fileName];
    isExist = [fileManager fileExistsAtPath:finalPath];
    if (isExist)
        [fileManager removeItemAtPath:finalPath error:NULL];
}

#pragma 读取文件
- (UIImage *)getLocalMark:(NSString *)filePath {
    UIImage *returnImage;
    returnImage = [UIImage imageNamed:filePath];
    return returnImage;
}

//删除所有documents下文件用以重置用户信息
- (void)removeAllDirDocuments {
    NSString *documentsDirectory = [self dirDoc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject])) {
        NSString *temp = [documentsDirectory stringByAppendingPathComponent:filename];
        [fileManager removeItemAtPath:temp error:NULL];
    }
}

//计算缓存大小，之前是计算整个文件夹大小，现在改为计算图片的大小，并在删除缓存的时候也是对应的删除这部分计算大小文件的缓存
- (float)countAllDirCaches {
    NSString *documentsDirectory = [self dirCache];
//    NSString *finalPath = [[documentsDirectory stringByAppendingPathComponent:@"default"] stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"];
    NSString *tempPath = [documentsDirectory stringByAppendingPathComponent:@"default"];
    NSFileManager* manager = [NSFileManager defaultManager];
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:tempPath] objectEnumerator];
    NSString *fileName;
    NSString *finalPath;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        finalPath = [tempPath stringByAppendingPathComponent:fileName];
        break;
    }
    float size = [self folderSizeAtPath:finalPath];
    return size;
}


//计算缓存大小
- (float)countAllDirDocuments {
    NSString *documentsDirectory = [self dirDoc];
    float size = [self folderSizeAtPath:documentsDirectory];
    return size;
}

- (float)countSingleDirDocuments:(NSString *)fileName {
    NSString *documentsDirectory = [self dirDoc];
    NSString *temp = [documentsDirectory stringByAppendingPathComponent:fileName];
    float size = [self folderSizeAtPath:temp];
    return size;
}

- (float)countSingleDirFile:(NSString *)fileName {
    NSString *documentsDirectory = [self dirDoc];
    NSString *temp = [documentsDirectory stringByAppendingPathComponent:fileName];
    float size = [self fileSizeAtPath:temp];
    return size/(1024.0*1024.0);
}

//清除dir缓存文件
- (void)removeCache:(NSString *)fileName {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *err;
    NSString *documentsDirectory = [self dirDoc];
    NSString *temp = [documentsDirectory stringByAppendingPathComponent:fileName];
    BOOL bRet = [fileMgr fileExistsAtPath:temp];
    if (bRet){
        [fileMgr removeItemAtPath:temp error:&err];
    }
}

/**
 *  清除Cache缓存文件下某个文件
 */
- (void)removeCacheUnderCache:(NSString *)fileName {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSError *err;
    NSString *documentsDirectory = [self getDirCache];
    NSString *temp = [documentsDirectory stringByAppendingPathComponent:fileName];
    BOOL bRet = [fileMgr fileExistsAtPath:temp];
    if (bRet){
        [fileMgr removeItemAtPath:temp error:&err];
    }
}

/**
 *  清除所有Cache缓存文件,目前是清除sdwebimage的图片缓存
 */
- (void)removeAllCache {
    NSString *documentsDirectory = [self getDirCache];
    NSString *tempPath = [documentsDirectory stringByAppendingPathComponent:@"default"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSEnumerator *childFilesEnumerator = [[fileManager subpathsAtPath:tempPath] objectEnumerator];
    NSString *fileName;
    NSString *finalPath;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        finalPath = [tempPath stringByAppendingPathComponent:fileName];
        break;
    }
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:finalPath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *tempFilename;
    while ((tempFilename = [e nextObject])) {
        NSString *temp = [finalPath stringByAppendingPathComponent:tempFilename];
        [fileManager removeItemAtPath:temp error:NULL];
    }
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
- (float )folderSizeAtPath:(NSString*) folderPath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

#pragma mark - 2017-04-13

/// 整个caches文件夹大小
- (float)tt_cachesFolderSize {
    return [self tt_folderSizeAtPath:[self getDirCache]];
}

/// 计算整个文件夹大小
- (float)tt_folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize += [[SDImageCache sharedImageCache] getSize] ;
        return folderSize / 1024.0 / 1024.0;
    }
    return 0;
}

/// 计算单个文件大小
- (float)tt_fileSizeAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return (size / 1024.0 / 1024.0);
    }
    return 0;
}

- (void)tt_cleanCaches {
    [self cleanCaches:[self getDirCache]];
}

- (void)cleanCaches:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
}

@end
