//
//  DDWriteDefaultConfigMethods.h
//  AFNetworking
//
//  Created by DDLi on 2020/3/27.
//

#import <Foundation/Foundation.h>
#import "DDWriteFileSupport.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDWriteDefaultConfigMethods : NSObject

/// 默认存储文件夹路径
@property (nonatomic, copy, readonly) NSString *path;

/**
 单实例化，此类为方便快速使用DDWriteFileSupport的方法，不再需要自己创建文件夹，管理路径。均使用默认配置
 
 @return 返回生成的单实例
 */
+ (nonnull DDWriteDefaultConfigMethods *)ShareInstance;

#pragma mark - ***** 获取路径 *****
/// 通过img存储时的url获取图片绝对路径，不存在则返回null
///
/// @param url 图片url,传入nil搜索无意义，故设置为nonnull
/// @param type 图片类型
- (nullable NSString *)defaultSearchByUrl:(nonnull NSString *)url
                                  imgType:(DDImgType)type;
/// 通过file文件名获取文件绝对路径，不存在则返回null
/// @param name 文件name,传入nil搜索无意义，故设置为nonnull
- (nullable NSString *)defaultSearchByFileName:(nonnull NSString *)name;

#pragma mark -  ***** 获取默认文件夹下所有子文件路径或文件名 *****
/**
 返回默认存储的文件夹路径下所有文件或文件夹路径
 
 @return 返回的文件列表数组，数组元素为子文件或子文件夹的绝对路径
 */
- (nullable NSMutableArray <NSString *> *)searchDefaultDirFilePaths;
/**
 读取默认存储的文件夹下所有文件名。包含文件夹名
 
 @return 返回的文件列表数组，数组元素为自文件或自文件夹的名字
 */
- (nullable NSArray <NSString *> *)searchDefaultDirFileNames;

#pragma mark - ***** 写入 *****
/**
 直接存储data流到本地default位置，文件名为name，不管路径上是否已存在文件
 
 @param name 文件名
 @param data 二进制流，数组或字典，图片。图片默认为png格式，如果需要写jpg图片请使用选择图片type的方法
 @return 返回写入结果
 */
- (BOOL)directWriteFileName:(nonnull NSString *)name
                       data:(nonnull id)data;
/**
 存储data流到本地default位置，文件名为name，路径上如果已存在文件则返回写入失败
 
 @param name 文件名
 @param data 二进制流，数组或字典，图片，图片默认为png格式，如果需要写jpg图片请使用选择图片type的方法
 @return 返回写入结果
 */
- (BOOL)writeFile:(nonnull NSString *)name
             data:(nonnull id)data;
/**
 直接存储图片到本地default位置，一般为存储网络图片到沙盒，不管路径上是否已存在文件
 
 @param url 图片的网络url
 @param img 图片
 @param imgType 图片类型
 @return 返回写入结果
 */
- (BOOL)directWriteImg:(nonnull NSString *)url
                   img:(nonnull UIImage *)img
             imageType:(DDImgType)imgType;
/**
 存储图片到本地default位置，一般为存储网络图片到沙盒，路径上已存在文件则返回失败
 
 @param url 图片的网络url
 @param img 图片
 @param imgType 图片类型
 @return 返回写入结果
 */
- (BOOL)writeImg:(nonnull NSString *)url
             img:(nonnull UIImage *)img
       imageType:(DDImgType)imgType;

#pragma mark - ***** 删除 *****
/**
 以文件名删除单个文件，如果不存在文件返回NO
 
 @param name 文件名
 @return 删除结果
 */
- (BOOL)removeFile:(nonnull NSString *)name;
/**
 以图片url删除单个图片，如果不存在文件返回NO
 
 @param url 图片url
 @param imgType 图片类型
 @return 删除结果
 */
- (BOOL)removeImg:(nonnull NSString *)url
          imgType:(DDImgType)imgType;
/**
 以文件夹名删除文件夹
 
 @param dirName 文件夹名
 @return 删除结果
 */
- (BOOL)removeDirFiles:(nonnull NSString *)dirName;

#pragma mark - 读取文件操作
/**
 根据name读取默认文件夹下的文件，不存在则返回nil，可选择直接返回的type,如果缓存中存在则直接返回不需要设置返回type
 
 @param name 文件名
 @param type 返回文件类型
 @return 返回文件
 */
- (nullable id)readFile:(nonnull NSString *)name
               fileType:(DDFileType)type;
/**
 读取存储的image
 
 @param url 保存图片的url
 @param imgType 图片类型
 @return 返回文件
 */
- (nullable UIImage *)readImg:(nonnull NSString *)url
                      imgType:(DDImgType)imgType;
/**
 删除nscache内的缓存
 */
- (void)flushCache;

#pragma mark - 计算文件或文件夹大小操作
/**
 通过获取默认存储位置的文件大小
 
 @param type 返回文件大小的计算格式，kb,mb,gb,tb
 @return 返回文件大小
 */
- (float)countSize:(DDSizeType)type;

@end

NS_ASSUME_NONNULL_END
