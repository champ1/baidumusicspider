#!/bin/bash
Author:Geekwolf

#获取频道列表url
getlisturl='http://fm.baidu.com/dev/api/?tn=playlist&format=json&id='

#获取歌曲地址url
getmusicrealurl='http://music.baidu.com/data/music/fmlink?type=mp3&rate=320&songIds='

channel_id=`curl -s http://fm.baidu.com/|grep rawChannelList|awk -F "=" '{print $2}'|jq .|grep channel_id|awk  -F '"' '{print $4}'`

channel_name=(`curl -s http://fm.baidu.com/|grep rawChannelList|awk -F "=" '{print $2}'|jq .|grep channel_name|awk  -F '"' '{print $4}'`)
count=-1
for i in $channel_id
do
     let count++
     mkdir -p ~/baidumusic/${channel_name[${count}]}
list_id=`curl -s ${getlisturl}${i}|jq .|grep '"id"'|awk '{print $NF}'`
	for j in $list_id
	
	do 
	   song_NFL=(`curl -s ${getmusicrealurl}${j} |jq .|grep -E "(songName|format|songLink)"|awk -F '"' '{print $4 }'`)
	   /usr/bin/wget -q -c ${song_NFL[2]}  -O ~/baidumusic/${channel_name[${count}]}/${song_NFL[1]}.${song_NFL[0]}
	done
done
