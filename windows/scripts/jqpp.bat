@echo off
jq -C -R -r ". as $line | try ( fromjson | . ) catch $line"
