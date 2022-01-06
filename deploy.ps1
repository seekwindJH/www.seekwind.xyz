git add .
git commit -m "SeekWind Commit"
git push

# Generate Hugo Static File
hugo

scp -r ./* root@seekwind.xyz:/root/App/www.seekwind.xyz/


IF (TEST-PATH .\public\) {
    Remove-Item -Force -Recurse .\public\
    "'.\public\' Dictory is removed."
}
ELSE {
    "'.\public\' Dictory not existed, continue."
}

"Deploy Successfully!"