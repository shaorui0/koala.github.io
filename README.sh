1. two branchs: 
    - hexo: source branch
    - main: static pages branch
2. commands:    
    hexo deploy:
    ```bash
    hexo clean && hexo generate && hexo deploy
    ```

    write blogs and update to hexo branch:
    ```
    git clone https://github.com/shaorui0/shaorui0.github.io.git
    cd shaorui0.github.io
    git checkout -b hexo

    echo "TODO write blogs"
    # Commit and push changes to main branch
    git add .
    git commit -m "wrote a blog"
    git push origin hexo
    ```