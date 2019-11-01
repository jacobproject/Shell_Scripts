#!/bin/bash

#不能屏蔽Tab键,缩进将作为内容的一部分被输出
#注意hello和world前面是tab键
cat << EOF
	hello
	world
EOF

#Tab键将被忽略,仅输出数据内容
cat <<- EOF
	hello
	world
EOF
