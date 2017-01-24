# mypassword
Save all my passwords anywhere I like with AES256.

## How to use mypassword?
1. Edit "mypassword.sh" file, replace "passSalt" and "passPath";
2. `sudo ln -s mypassword.sh /usr/local/bin/mypassword`;
3. `mypassword`, input "PWD" (Master password should to remember);
4. Input "W" to add a new password or input the name of the password you had added;
5. Get your password;

## Require
openssl

## How it works?
Only you know your master password, so only you can access your information in your encrypted vault - not even mypassword can. All of your data is sealed with AES-256 bit encryption, salted hashing.

## License
mypassword is provided under the MIT license. See LICENSE file for details.

## Changelog
2017-01-24
  v0.2.0 add remove password; show all password; change PWD; check PWD;
  !ATTENTION!: update v0.1.0 to v0.2.0, you need add the postfix ".pwd" to your password file.
  
  
  
-------

# mypassword
用 AES256 加密方式保存你的密码，并安全存放到你想放的任何地方。

## 如何使用 mypassword？
1. 编辑 “mypassword.sh” 文件， 替换变量 “passSalt” 和 “passPath”；
2. `sudo ln -s mypassword.sh /usr/local/bin/mypassword`；
3. `mypassword`， 输入 “PWD” （要牢牢记住这个主密码,这是开启所以密码的钥匙）；
4. 输入 “W” 来创建新密码或者输入你已经创建过的密码名称；
5. 获得密码明文；

## 环境需要
openssl

## 工作原理？
只有你自己知道主密码是什么，所以只有你能解开密码库里的密码。
然后你可以把加密后的文件存到 iCloud 或者 github 或者其他的什么地方都可以咯！
“mypassword” 程序只能接触到通过AES256加密后的字符串，不信你自己去看源码好了。

## 许可协议
mypassword 使用 MIT 许可协议，详情见 LICENSE 文件。

## 更新日志
2017-01-24
  v0.2.0 增加删除密码; 显示全部密码; 修改主密码; 检查主密码;
  !注意!: 从 v0.1.0 升级到 v0.2.0,  需要给之前的密码文件添加后缀".pwd"。
