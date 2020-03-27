# WriteFileSupportSpec

<!--[![CI Status](http://img.shields.io/travis/DDStrongman/WriteFileSupportSpec.svg?style=flat)](https://travis-ci.org/DDStrongman/WriteFileSupportSpec)-->
<!--[![Version](https://img.shields.io/cocoapods/v/WriteFileSupportSpec.svg?style=flat)](http://cocoapods.org/pods/WriteFileSupportSpec)-->
<!--[![License](https://img.shields.io/cocoapods/l/WriteFileSupportSpec.svg?style=flat)](http://cocoapods.org/pods/WriteFileSupportSpec)-->
<!--[![Platform](https://img.shields.io/cocoapods/p/WriteFileSupportSpec.svg?style=flat)](http://cocoapods.org/pods/WriteFileSupportSpec)-->

## Example
**1.3.0**版本进一步优化了代码，并且加入了DDWriteDefaultConfigMethods类，提供更简易api<br>

所有函数进一步优化，并加入了更多新的简易实用的api<br>

```
/**
 直接存储data流到本地default位置，文件名为name，不管路径上是否已存在文件
 
 @param name 文件名
 @param data 二进制流，数组或字典，图片。图片默认为png格式，如果需要写jpg图片请使用选择图片type的方法
 @return 返回写入结果
 */
- (BOOL)directWriteFileName:(nonnull NSString *)name
                       data:(nonnull id)data;
                       
/// 通过img存储时的url获取图片绝对路径，不存在则返回null
///
/// @param url 图片url,传入nil搜索无意义，故设置为nonnull
/// @param type 图片类型
- (nullable NSString *)defaultSearchByUrl:(nonnull NSString *)url
                                  imgType:(DDImgType)type;
                                  
/**
 返回默认存储的文件夹路径下所有文件或文件夹路径
 
 @return 返回的文件列表数组，数组元素为子文件或子文件夹的绝对路径
 */
- (nullable NSMutableArray <NSString *> *)searchDefaultDirFilePaths
```

**集成了目前为止项目里用到的所有沙盒操作，并用了NSCache缓存，举个栗子:**<br>
写文件函数 <br>

```


/** 
自定义操作
存储data流到本地，相对路径为path，路径上已存在文件则返回失败，可通过参数选择三处位置 

@param path 文件相对路径，如果直接给文件名则直接写 
@param data 二进制流，数组或字典 
@param field 选择type 
@return 返回写入结果 
*/ 
 - (BOOL)writeFileType:(NSString *)path 
                  data:(id)data 
                 field:(DDFileField)field  
```
**具体内容请参考.h文件内说明**

## Requirements

## Installation

WriteFileSupportSpec is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DDWriteFileManager"
```

## Author

DDStrongman, lishengshu232@gmail.com

## License

WriteFileSupportSpec is available under the MIT license. See the LICENSE file for more info.
