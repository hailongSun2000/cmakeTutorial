#!/bin/sh

#Specify directory
dir="/home/phoenix/work/cmake/tutorial"

for i in {1..12}
do
    #[]用于执行条件测试，例如检查文件或者目录是否存在、比较数字或字符串等。
    #()用于创建子shell或者分组(?)
    #(())用于执行算数运算
    if [ ! -d "${dir}/step${i}" ]; then
        mkdir -p "${dir}/step${i}"
        echo "Created folder step${1} in ${dir}"
    else
	echo "Folder step${1} already exists in ${dir}, skipping."
    fi
    
    if [ ! -d "${dir}/step${i}_build" ]; then
        mkdir -p "${dir}/step${i}_build"
        echo "Created folder step${1}_build in ${dir}"
    else
        echo "Folder step${1}_build already exists in ${dir}, skipping."
    fi
done
