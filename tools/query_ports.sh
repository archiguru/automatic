#!/bin/bash

# 打印表头
printf "%-32s %-10s %-16s\n" "进程名" "端口" "PID"

# 定义函数来获取macOS上的端口信息，并按端口排序
list_ports() {
    lsof +c 0 -nP -iTCP -sTCP:LISTEN | awk 'NR>1 {print $1, $9, $2}' | sort -k2,2 -t: -n |
        awk '{
        if (!seen[$1]++) {
            proc[$1]=$1; port[$1]=$2; pid[$1]=$3
        } else {
            port[$1]=port[$1]","$2; pid[$1]=pid[$1]","$3
        }
    }
    END {
        for (p in proc) {
            printf "%-32s %-10s %-16s\n", proc[p], port[p], pid[p]
        }
    }'
}

# 检测操作系统并调用相应函数
case "$(uname)" in
"Linux")
    list_ports
    exit 0
    ;;
"Darwin")
    list_ports
    exit 0
    ;;
*)
    echo "不支持的操作系统。"
    exit 1
    ;;
esac
