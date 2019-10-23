# Pathfind文件查找工具

## 介绍

一个用于在指定目录中查找文件的小脚本，遵循Posix标准，支持正则表达式匹配查找，其功能类似于Unix中的find工具，原版源码来源于《Shell脚本学习指南》一书中的第七章。在此处我对该脚本做出小小的修改，原书中的脚本只能对指定环境变量中的目录进行查找，我将其修改为可以指定任意目录查找。

## 主要用法

```sh
./pathfind.sh [--all] [--?] [--help] [--version] envvar pattern(s)
```

|    参数    |                             说明                             |
| :--------: | :----------------------------------------------------------: |
|    all     | 查找该目录下匹配于pattern(s)的所有文件。如不加该参数，脚本将会在查找到第一个匹配文件后停止查找。 |
|     ?      |                         显示脚本帮助                         |
|    help    |                         显示脚本帮助                         |
|  version   |                       输出脚本版本信息                       |
|   envvar   | 指定查找目录。如果为空，脚本将不会输出任何信息。建议此处使用绝对路径，否则查找结果路径会出现问题，但不影响正常查找。 |
| pattern(s) | 要查找的一个或多个文件名称，查找多个文件用空格分开，支持正则表达式匹配查找。 |

## 脚本输出

脚本正常退出的状态码为0，终端将会把查找结果的路径输出

```sh
$ ./pathfind.sh /folder file.md
/folder/file.md
$ echo $?
0
```

如果脚本找不到该文件，则输出警告信息，状态码为找不到的文件个数，状态码的上限为125

```sh
$ ./pathfind.sh /folder file.md
file.md: not found
$ echo $?
1
```

如果没有指定查找目录和要查找的文件，则输出错误信息，状态码为1

```sh
$ ./pathfind.sh
Environment variable missing or empty
Usage: pathfind.sh [--all] [--?] [--help] [--version] envvar pattern(s)
$ echo $?
1
```

