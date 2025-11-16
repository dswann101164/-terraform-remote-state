@echo off
echo Initializing Git repository...
git init

echo Adding all files...
git add .

echo Committing files...
git commit -m "Initial commit: Complete Terraform remote state guide and templates"

echo Adding remote...
git remote add origin https://github.com/dswann101164/-terraform-remote-state.git

echo Setting main branch...
git branch -M main

echo Pushing to GitHub...
git push -u origin main

echo.
echo Done! Check https://github.com/dswann101164/-terraform-remote-state
pause
