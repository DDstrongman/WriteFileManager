# WriteFileSupportSpec

<!--[![CI Status](http://img.shields.io/travis/DDStrongman/WriteFileSupportSpec.svg?style=flat)](https://travis-ci.org/DDStrongman/WriteFileSupportSpec)-->
<!--[![Version](https://img.shields.io/cocoapods/v/WriteFileSupportSpec.svg?style=flat)](http://cocoapods.org/pods/WriteFileSupportSpec)-->
<!--[![License](https://img.shields.io/cocoapods/l/WriteFileSupportSpec.svg?style=flat)](http://cocoapods.org/pods/WriteFileSupportSpec)-->
<!--[![Platform](https://img.shields.io/cocoapods/p/WriteFileSupportSpec.svg?style=flat)](http://cocoapods.org/pods/WriteFileSupportSpec)-->

## Example
**集成了目前为止项目里用到的所有沙盒操作，并用了NSCache缓存，之后可能会改成YYCache来缓存，举个栗子:**<br>
写文件函数 <br>
```
/** 
存储data流到本地，相对路径为path，路径上已存在文件则返回失败，可通过参数选择三处位置 

@param path 文件相对路径，如果直接给文件名则直接写 
@param data 二进制流，数组或字典 
@param field 选择type 
@return 返回写入结果 
*/ 
 -- (BOOL)writeFileType:(NSString *)path 
                   Data:(id)data 
                  Field:(DDFileField)field  
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
