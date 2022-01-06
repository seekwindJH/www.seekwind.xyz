# Generate Hugo Static File
hugo

scp -r ./* root@seekwind.xyz:/root/App/www.seekwind.xyz/


Set-Location public

# Upload TO seekwind.xyz
scp -r ./* root@seekwind.xyz:/data/nginx/html/

# Upload TO github.com
git init
git add -A
git commit -m "seekwind update"
git branch -M main
git remote add origin git@github.com:seekwindJH/seekwindJH.github.io.git
git push -f origin main

Set-Location ..

IF (TEST-PATH .\public\) {
    Remove-Item -Force -Recurse .\public\
    "'.\public\' Dictory is removed."
}
ELSE {
    "'.\public\' Dictory not existed, continue."
}

"Deploy Successfully!"