#!/bin/bash

# 定义变量
CERT_CHAIN_FILE="fullchain.pem"   # 包含服务器证书和中间证书的文件
KEY_FILE="privkey.pem"            # 私钥文件路径
PASSWD_FILE="passwd.txt"          # 保存密码的文件名

# 提示用户输入输出文件名
read -p "请输入输出的 PFX 文件名（不包括扩展名）: " output_filename

# 确保文件名以 .pfx 结尾
if [[ "$output_filename" != *.pfx ]]; then
    output_filename="$output_filename.pfx"
fi

# 生成随机10位数字和字母的密码
passwd=$(openssl rand -base64 6 | tr -dc 'A-Za-z0-9' | head -c 10)

# 保存密码到 passwd.txt
echo "随机生成的密码: $passwd" > "$PASSWD_FILE"
echo "密码已保存到 $PASSWD_FILE"

# 将 Nginx 证书转换为 PFX 格式
if [[ -f "$CERT_CHAIN_FILE" && -f "$KEY_FILE" ]]; then
    openssl pkcs12 -export -out "$output_filename" -inkey "$KEY_FILE" -in "$CERT_CHAIN_FILE" -password pass:"$passwd"
    if [[ $? -eq 0 ]]; then
        echo "证书转换成功！PFX 文件已保存为 $output_filename"
        
        # 检查 PFX 文件是否存在且大小大于 0
        if [[ -f "$output_filename" && $(stat -c %s "$output_filename") -gt 0 ]]; then
            echo "PFX 文件已生成，开始进行验证..."

            # 尝试读取 PFX 文件内容来验证其有效性
            openssl pkcs12 -info -in "$output_filename" -password pass:"$passwd" > /dev/null 2>&1
            if [[ $? -eq 0 ]]; then
                echo "验证成功：PFX 文件有效且包含证书和私钥。"
            else
                echo "验证失败：PFX 文件无效或内容错误。"
            fi
        else
            echo "错误：PFX 文件不存在或文件大小为 0，可能转换失败。"
        fi
    else
        echo "证书转换失败，请检查输入文件是否正确"
    fi
else
    echo "错误：没有找到 $CERT_CHAIN_FILE 或 $KEY_FILE 文件，请确保这两个文件在当前目录中"
fi

# 打包生成的 PFX 和密码文件到 zip 包
zip_filename="${output_filename%.pfx}.zip"
zip "$zip_filename" "$output_filename" "$PASSWD_FILE"

if [[ $? -eq 0 ]]; then
    echo "打包成功：$zip_filename"
else
    echo "打包失败，请检查 zip 命令是否可用"
fi
