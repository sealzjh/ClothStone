ClothStone
==========

description : some prod problem detect

### 部署方式

在用户主目录下创建目录`potter`作为仓库目录: 

```
$ mkdir -p ~/potter
```

部署crontab，执行频率为1分钟一次

```
*/1 * * * * bash ~/potter/listen_httpcode.sh >> /tmp/listen_httpcode.log
```
