cd %1
git reflog expire --all --expire=now
git gc --prune=now --aggressive
