# Mumble语音服务器端更新脚本

## 环境要求

系统要求：CentOS7（仅在CentOS7下测试过，其他系统未知）

安装要求：必须按照官方安装文档中的[教程](https://wiki.mumble.info/wiki/Install_CentOS7)进行安装，创建了`systemd`单元，服务器文件放在`/usr/local/murmur/`中

## 执行脚本

执行以下脚本一键更新即可：

```sh
wget https://github.com/FisherWY/Shell/blob/master/murmur/update_murmur.sh -O - | bash /dev/stdin
```

