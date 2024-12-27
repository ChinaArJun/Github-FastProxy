#!/bin/bash

function purple() {
  printf "\033[0;35m%s\n\033[0m" "$1"
}

function downloadDependencies() {
  read -r -p "是否需要下载相关依赖? (y/N):" confirm
  if [[ $confirm =~ ^[Yy]$ ]]; then
    purple "下载相关依赖..."
    bash debian_initialize.sh
    if [ $? -eq 0 ]; then
      purple "下载依赖完成"
    else
      purple "下载依赖失败"
      exit 1
    fi
  else
    purple "跳过依赖下载"
  fi

}

function setDomain() {
  domain=""
  files=(
  'v2fly4.vless-vmess-trojan/nginx/nginx.conf' 'v2fly4.vless-vmess-trojan/trojan/config.json'
  'v2fly5.vmess-trojan-shadowsocks/nginx/nginx.conf' 'v2fly5.vmess-trojan-shadowsocks/nginx/conf.d/ssl.conf'
  'cert.sh')
  read -r -p "请输入域名：" domain
  purple "替换配置文件中的默认域名 (toloveshop.com)"
  for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            sed -i.bak "s/toloveshop.com/$domain/g" "$file"
        else
            purple "文件 $file 不存在"
        fi
  done
  purple "申请证书"
  bash cert.sh
  if [ $? -eq 0 ]; then
    purple "证书申请成功"
  else
    purple "证书申请失败"
    exit 1
  fi
}

function setUser() {
  user=""
  files=('v2fly4.vless-vmess-trojan/v2fly_vless/config.json' 'v2fly4.vless-vmess-trojan/v2fly_vmess/config.json'
  'v2fly4.vless-vmess-trojan-shadowsocks/v2fly/config.json' 'v2fly5.vmess-trojan-shadowsocks/v2fly/config.json')
    read -r -p "请输入 vmess 和 vless 协议中的用户ID (需要是 UUID)：" user
    purple "替换配置文件中的预置用户"
    for file in "${files[@]}"; do
      if [ -f "$file" ]; then
        sed -i.bak "s/2a41fd04-ba17-4d59-8084-9ba4b04c587a/$user/g" "$file"
      else
        purple "文件 $file 不存在"
      fi
    done
}

function setPassword() {
  password=""
  files=('v2fly4.vless-vmess-trojan/trojan/config.json' 'v2fly4.vless-vmess-trojan-shadowsocks/v2fly/config.json' 'v2fly5.vmess-trojan-shadowsocks/v2fly/config.json')
  read -r -p "请输入 shadowsocks 和 trojan 协议中的密码：" password
  purple "替换配置文件中的预置密码"
  for file in "${files[@]}"; do
    if [ -f "$file" ]; then
      sed -i.bak "s/your password/$password/g" "$file"
    else
      purple "文件 $file 不存在"
    fi
  done
}


downloadDependencies
setDomain
setUser
setPassword
