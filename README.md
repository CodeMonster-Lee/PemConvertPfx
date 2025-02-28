bash convert.sh，设置输出证书名称(不含后缀名)，查看生成的password.txt文件密码，输入三次密码验证证书

其他相关：
查看证书有效期
root@dandy:~/ssl# openssl pkcs12 -in zhbdgps.com.pfx -clcerts -nokeys | openssl x509 -text -noout，输入密码
Enter Import Password:
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            04:3e:46:06:25:4a:9b:16:c9:93:64:9a:7b:61:c6:36:ef:70
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C = US, O = Let's Encrypt, CN = R11
        Validity
            Not Before: Feb 11 00:39:38 2025 GMT
            Not After : May 12 00:39:37 2025 GMT
        Subject: CN = zhbdgps.com
