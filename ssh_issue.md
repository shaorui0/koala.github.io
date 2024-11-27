## github issue

## 
ssh-keygen -t ed25519 -C "sr1054461216@163.com"
git remote set-url origin git@github.com:shaorui0/shaorui0.github.io.git

cat ~/.ssh/id_ed25519.pub
 
# TODO append to github `https://github.com/settings/keys`

ssh -T git@github.com

deploy:
  type: git
  repo: git@github.com:shaorui0/shaorui0.github.io.git
  branch: main # or the appropriate branch

git config --global --unset http.proxy
git config --global --unset https.proxy


hexo clean
hexo deploy

GIT_CURL_VERBOSE=1 GIT_TRACE=1 hexo deploy
