for /f "skip=1" %%x in ('wmic os get localdatetime') do if not defined MyDate set MyDate=%%x
set today=%MyDate:~0,4%-%MyDate:~4,2%-%MyDate:~6,2%
set commitMessage="site rebuild: %today%"
echo %commitMessage%
echo "Removing the old website"
pushd public
git pull
git rm -rf *
popd

echo "Building the website"
hugo --minify

echo "Pushing the updated \`public\` folder to the \`master\` branch"
pushd public
git add *
git commit -m %commitMessage%
git push
popd
