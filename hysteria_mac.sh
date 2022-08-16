#!/bin/bash
#check and update hysteria to the latest
#authro: Mrxn
#github: https://github.com/Mr-xn

#github_latest_version
git_v=`wget -qO- -t1 -T2 "https://api.github.com/repos/HyNetwork/hysteria/releases/latest" | grep "tag_name" | head -n 1 | awk -F ":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g'`

#check file
check_file(){
    files=`ls $HOME/path/to/hysteria/hysteria* | grep "hysteria-" | head -n 1`
    if [ -f "$files" ]  #如果存在文件
    then
        #fix x Permission
        chmod +x $(ls $HOME/path/to/hysteria/hysteria-* | head -n 1)
        #local_version
        local_v=`$HOME/path/to/hysteria/hysteria-* -v | head -n 1 | awk -F " " '{print $3}'`
        echo "found local version: $local_v";
        compare_version
    else
        echo "file loss";
        download_latest_version
    fi
}

#compare version
compare_version(){
    echo "compare version with github"
    if [ "$local_v" != "$git_v" ]
    then
        echo "new version found. updating...";
        echo "backup old $local_v ";
        mv $HOME/path/to/hysteria/hysteria-* $HOME/path/to/hysteria/hysteria_$local_v;
        echo "backup file: $HOME/path/to/hysteria/hysteria_$local_v";
        download_latest_version
    else
        echo "no latest version"
        run
    fi
}

#download_latest_version
download_latest_version(){
    latest_file=`wget -qO- -t1 -T2 "https://api.github.com/repos/HyNetwork/hysteria/releases/latest" | grep "darwin-amd64" | tail -n 1 | awk -F "\":" '{print $2}' | sed 's/\"//g;s/,//g;s/ //g'`
    path=$HOME/path/to/hysteria/
    newfile=$path'hysteria-darwin-amd64'
    echo "downloading latest version from github to $path";
    echo "downlaoding url: $latest_file";
    #download
    wget -c -t1 -T2  $latest_file -O $newfile;
    #fix x Permission
    chmod +x $newfile && $newfile -v;
    echo "delete the old version: hysteria_$local_v";
    rm $HOME/path/to/hysteria/hysteria_$local_v;
    ls -lh $path;
    run
}

#start
run(){
    echo "begain start hysteria...";
    # settings log level:panic, fatal, error, warn, info, debug, trace
    export LOGGING_LEVEL=info && $HOME/path/to/hysteria/hysteria-darwin-amd64 -c $HOME/path/to/hysteria/hk-config.json;
}

check_file
