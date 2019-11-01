#!/bin/bash
#Read User's name and password from standard input.
read -p "请输入用户名:"   user
read -s -p "请输入密码:"  pass
useradd "$user"
echo "$pass" | passwd --stdin "$user"
