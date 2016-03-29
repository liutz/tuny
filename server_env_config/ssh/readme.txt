###脚本说明###

1.本机与远程服务器建立信任关系
1.1 本机生成RSA公私匙证书，如果已经存在请忽略下面操作
# ssh-keygen -t rsa

注：公和私钥文件分别储存在/root/.ssh/id_rsa和/root/.ssh/id_rsa.pub文件中

2.请将公钥id_rsa.pub文件拷贝到远程服务器
# scp /root/.ssh/id_rsa.pub [Remote Server IP]:/root/.ssh/

3.将公钥内容拷贝到远程服务器/root/.ssh/authorized_keys文件末尾
