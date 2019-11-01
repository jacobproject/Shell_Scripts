#!/bin/bash
#语法格式:
#命令 << 分隔符
#内容
#分隔符
#系统会自动将两个分隔符之间的内容重定向传递给前面的命令，作为命令的输入。
#注意：分隔符是什么都可以，但前后分隔符必须一致。推荐使用EOF(end of file)
mail -s warning root@localhost << EOF
This is content.
This is a test mail for redirect.
EOF
