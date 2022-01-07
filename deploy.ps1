git add .
git commit -m "SeekWind Commit"
git push


# Generate Hugo Static File

hugo


scp -r ./public/* root@seekwind.xyz:/data/nginx/html

$ret = $? # 上一条命令的返回值

IF (TEST-PATH .\public\) {
    Remove-Item -Force -Recurse .\public\
    "'.\public\' Dictory is removed."
}
ELSE {
    "'.\public\' Dictory not existed, continue."
}

# 象征性的打印successfully，并不是说一定就成功了
"Deploy Successfully!"
