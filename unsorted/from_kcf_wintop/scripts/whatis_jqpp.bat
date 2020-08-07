@echo off
echo.
echo jq -C -R -r ". as $line | try  ( fromjson | . ) catch $line"
