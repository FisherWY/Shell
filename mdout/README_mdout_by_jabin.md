# mdout

一个Go语言实现的Markdown转PDF命令行工具，基于headless chrome，简单，易用，易拓展，人性化，可定制化。

## 获取和安装

mdout同时支持windows，linux，macOS，但目前只支持64位的系统

### 脚本安装

> 非常感谢Fisher的脚本支持! [自己日用的脚本](https://github.com/FisherWY/Shell)

linux && macOS推荐使用脚本安装

- curl方式

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/FisherWY/Shell/master/mdout/install_mdout.sh)"
```

- wget方式

```shell
sh -c "$(wget https://raw.githubusercontent.com/FisherWY/Shell/master/mdout/install_mdout.sh -O -)"
```

### 手动安装

这里提供下载连接，但系统暂时只支持64位

- linux：[mdout.linux.x86-64.tar.gz](http://112.74.177.253:8000/f/edcb3b9e460d4d18ab3f/?dl=1)
- macOS：[mdout.macOS.x86-64.tar.gz](http://112.74.177.253:8000/f/100873c74622474da4d9/?dl=1)
- windows：[mdout_windows_x86-64.zip](http://112.74.177.253:8000/f/574b3d14ffe04bb1880b/?dl=1)

下载后解压缩，你会得到一个mdout可执行文件

#### windows

##### 放置软件

将`mdout.exe`可执行文件放置平时放软件的地方，比如`D:\mdout`这个文件夹里面，此时你的`mdout.exe`的全路径应该是`D:\mdout\mdout.exe`

##### 设置环境变量

如果不设置环境变量也可以使用，但是缺点是你需要使用cmd，powershell或者gitbash手动进入`D:\mdout`才能使用`mdout`命令

确定路径
![1](../images/mdout_1.png)

设置环境变量，右键我的电脑 -> 选择属性 -> 左边的高级系统设置
![2](../images/mdout_2.png)

选择高级 -> 点击环境变量
![3](../images/mdout_3.png)

找到下半部分的系统变量，双击`Path`行
![4](../images/mdout_4.png)

在弹出来的窗口选择新建
![5](../images/mdout_5.png)

填入`D:\mdout`，然后一定要连续点完三个确定
![6](../images/mdout_6.png)

##### 检验

打开cmd，或者powershell，或者你有gitbash都ok（推荐使用命令行的windows用户都装一个gitbash），输入`mdout`，看到如下输出就是成功了

![7](../images/mdout_7.png)

#### linux

##### 将软件放入可执行文件库

打开终端，定位到刚刚下载的文件所在路径，然后执行

```cmd
sudo mv ./mdout /usr/local/bin
```

输入密码就可以了

##### 检验是否成功

输入`mdout --version`，看到版本号输出就是成功了

#### macOS

##### 将软件移动到可执行文件库

打开终端，定位到刚刚下载的文件所在路径，然后执行

```cmd
mv ./mdout /usr/local/bin
```

##### 检验是否成功移动

输入`mdout --version`，看到版本号输出就是成功了

## 使用说明

### 使用前提

mdout依赖于chrome浏览器，如果你的电脑已经安装了新版的chrome浏览器，无需更多配置，可以直接运行mdout，如果是旧版的chrome浏览器，建议进行升级后使用，如果还未安装chrome浏览器，请安装后再使用mdout

### 进行系统初始化

因此如果你不是使用脚本安装的，或者脚本安装不完全成功的，需要手动执行初始化，如果脚本安装成功，则跳过这一步

mdout依赖于html、css、js的模板，但是模板没有打包进程序，这是出于自定义化的考虑，执行初始化命令，程序会自动下载需要的文件到配置文件路径，至于这个路径在哪，在后面会提到，同时初始化程序执行结束后也会输出这个路径，请记住这个路径，在一些自定义和设置默认值时会使用到

```cmd
mdout install
```

### 最简单的示例

```cmd
mdout 文件路径
```

#### 文件路径可以是相对路径

##### 文件在当前目录

```cmd
mdout yourfile.md
```

##### 或文件在上级目录

```cmd
mdout ../yourfile.md
```

#### 文件路径也可以是绝对路径

```cmd
mdout /tmp/markdown/yourfile.md
```

### 帮助文档

每个命令行程序都有帮助文档，mdout也不例外

```cmd
mdout -h
mdout --help
```

### 输入文件类型

mdout支持许多输入类型，其中最普遍的就是markdown，但同样也支持html输入，url输入，但是注意，如果输入是url，不要忘记带上`http:://`

- markdown  

    ```cmd
    mdout yourfile.md
    ````

- html  

    ```cmd
    mdout yourfile.html
    ```

- url

    ```cmd
    mdout http://www.baidu.com
    ````

### 输出文件类型

对于markdown输入，mdout支持输出中间过程的结果。但对于html输入或者url输入，它们的唯一输出结果就是pdf文件了

- markdown输出pdf（输出pdf为默认选项)

    ```cmd
    mdout youtfile.md -t pdf  
    mdout yourfile.md
    ```

- markdown输出解析后html标签（这个选项可以得到markdown解析器的解析结果）

    ```cmd
    mdout youtfile.md -t tag
    ```

- markdown输出经过处理后的完整html文件（常常用来调试主题）

    ```cmd
    mdout youtfile.md -t html
    ```

### 输出路径

mdout支持指定输出路径，输出文件名

#### 你可以使用`-o`来指定输出路径

`-o`选项同样做了防呆设计，你可以指定路径但不带文件名，mdout会自动识别你输入文件的文件名和你指定的输出类型为你设置名称，但你同样可以指定路径+文件名

指定输出到上级文件夹，自动命名

```cmd
mdout yourfile.md -o ../
```

指定输出到`/tmp/markdown`文件夹，自动命名

```cmd
mdout yourfile.md -o /tmp/markdown
```

指定输出到当前文件夹下的`badoutput.name`

```cmd
mdout yourfile.md -o badoutput.name
```

千万不要这么干，尽管程序不会阻止你设置你的文件名，但是使用规范的后缀是个好习惯。

指定输出到当前文件夹下的`goodname.pdf`

```cmd
mdout yourfile.md -o goodname.pdf
```

### 指定主题

> 主题系统只对markdown输入有效

mdout有着方便易用的主题系统，你可以很自由地自定义主题，mdout预设了三套主题

- 默认主题：`default`
- 数学公式拓展主题：`mathjax`
- github风格主题：`github`

#### 你可以使用`-e`选项来指定主题

- 指定为github主题

    ```cmd
    mdout yourfile.md -e github
    ```

- 指定为数学公式拓展主题

    ```cmd
    mdout yourfile.md -e mathjax
    ```

> 指定主题后上面提到的输出选项依旧可用，可以配合`-t html`选项输出中间的html文件，这样可以调试主题效果，详细的说明将在自定义章节中提到

`default`和`mathjax`这两套主题的配色是一模一样的，区别在于`mathjax`是同时支持代码语法高亮和数学公式渲染的，而`default`只支持代码语法高亮

`mathjax`可以渲染类似这样的公式

```
$$\Gamma(z) = \int_0^\infty t^{z-1}e^{-t}dt\,.$$
```

我可以将`mathjax`设为默认主题并删除`default`，但是我没有那么做，因为`default`可以作为一个能满足代码语法高亮的最小模板 *（当然你可能不需要代码语法高亮，这样的话`default`并不能算最小模板）* ，基于`default`模板进行自定义主题将变得非常简单

至于自定义主题的教程，将在后面提到

### 打印页面设置

> 此项仅在输出pdf时有效

#### 打印页面大小设置

mdout预设了8种页面大小，如果有更多需求，可以在issues提出

- A1 - A5
- Legal
- Letter
- Tabloid

A4为默认输出页面大小，你可以使用`-f`来指定输出页面的大小。同时做了防呆设计，如果你一不小心打成了大写、小写，甚至你手抽打成了大小写混合，都是可以正常识别的。可惜，防呆不防傻，你把字母都打错了就不能怪我了

##### 你可以使用`-f`指令来指定页面大小格式

指定输出pdf页面格式为A4（闲着没事干敲着玩）

```cmd
mdout yourfile.md -f a4
```

指定输出pdf页面格式为Tabloid

```cmd
mdout yourfile.md -f tabloid
```

#### 打印页面方向设置

mdout只支持两种方向

- 纵向：`portrait`
- 横向：`landscape`

默认打印页面方向为纵向

##### 你可以使用`-r`指令来指定页面方向格式

指定输出pdf页面格式为横向

```cmd
mdout yourfile.md -r landscape
```

#### 打印页面边距设置

mdout支持你自定义页面边距，以英尺为单位，默认为0.4英寸

- 0.4英寸 ≈ 10cm

##### 你可以使用`-m`指令来指定页面边距大小

指定打印边距为0.2英寸

```cmd
mdout yourfile.md -m0.2
```

去除页面边距

```cmd
mdout yourfile.md -m0
```

### 自定义配置文件

在配置文件安装目录下面

- macOS : /Users/你的用户名/binmdout  
- linux: /home/你的用户名/binmdout
- windows: /c/users/你的用户名/binmdout

有一个`conf.json`文件

```json
{
    
    "Out":"",

    "Type":"pdf",

    "Theme":"default",

    "PageFormat":"a4",

    "PageOrientation":"portrait",

    "PageMargin":"0.4"
    
}
```

包含了以上所有的可选设置，直接修改配置文件可以作为每次使用mdout的默认参数值

### 自定义配色

mdout有着简单易用的主题系统，跟着下面的步骤来，你可以很轻松的添加自己的自定义效果

首先打开你的配置文件所在的文件夹

在你的配置包里面会有一个`conf.json`文件和`theme`主题文件夹，其中`conf.json`文件是用来更改默认参数的，`theme`存放了你的主题包。

进入`theme`主题包，你可以看到默认的三个主题包

- `default`
- `mathjax`
- `github`

假设你现在需要自定义你的页面配色，大小，语法高亮等一切和css有关的内容，并且你想要为你的主题起名为`mytheme`

首先你需要完整复制`default`的所有内容，到`default`文件夹所在的目录并重命名为`mytheme`，此时你的`theme`文件夹里有三个文件夹：

- `default`
- `mathjax`
- `mytheme`

然后你需要找到一个测试用例比如说这样一个markdown文件

```md
# 测试标题

## 测试二级标题

### 测试三级标题

#### 测试四级标题

- 测试无序列表1
- 测试无序列表2

1. 测试有序列表1
2. 测试有序列表2

- 测试嵌套
    1. 测试嵌套第二次
        - 测试嵌套第三层


> 测试引用

测试表格

| 标题1 | 标题2 | 标题3 |
| ----- | ---- | ---- |
| 文本1 | 文本2 | 文本3 |
| 文本4 | 文本5 | 文本6 |

**这是加粗的文字**  
*这是倾斜的文字*  
***这是斜体加粗的文字***  
~~这是加删除线的文字~~

![百度图片](https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo_top_86d58ae1.png)

[测试超链接](https://github.com/JabinGP/mdout)

`测试代码段高亮`

测试代码块高亮

    package main

    import (
        "fmt"
    )

    func main() {
        fmt.Println("Hello Mdout")
    }
```

紧接着使用`mdout yourfile.md -e mytheme -t html`来获取这个markdown文件指定mytheme主题的html输出结果，用编辑器打开html文件，同时用chrome打开html文件，可以看到，页面已经自动引入了你刚刚创建的自定义主题包css

```html
<!-- 添加页面样式 -->
<link rel="stylesheet" href="/Users/jabin/binmdout/theme/mytheme/css/page.css"/>
<!-- 添加hljs样式 -->
<link rel="stylesheet" href="/Users/jabin/binmdout/theme/mytheme/css/hljs.css"/>
```

主题配色分为两个文件，一个是页面配色css文件，一个是代码高亮的css文件

如果你要修改页面配色，只需要一边开着浏览器，一遍打开刚刚主题包里面的
`mytheme`->`css`->`page.css`修改，然后刷新浏览器查看结果

或者你想更改语法高亮的配色，由于mdout依赖于hljs，你只需要去hljs官网下载你喜欢的主题包，然后替换`mytheme`->`css`->`hljs.css`里的内容就可以了

如果你完成了你的主题修改，你可以将刚刚生成的html删除，或者你想留做自己动手的纪念也是可以的

最后，你可以使用`mdout yourfile.md -e mytheme`来指定使用你的自定义主题啦，或者你可以在前面提到过的`conf.json`里面配置默认使用你的`mytheme`主题