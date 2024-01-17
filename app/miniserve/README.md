# miniserve 使用说明

```shell
用法: miniserve [OPTIONS] [PATH]
参数:
  [PATH]
          服务的路径
          [env: MINISERVE_PATH=]
选项:
  -v, --verbose
          详细，包括发出访问日志
          [env: MINISERVE_VERBOSE=]
      --index <INDEX>
          要服务的目录索引文件的名称，如 "index.html"
          通常，当 miniserve 服务于一个目录时，它会为该目录创建一个清单。但是，如果一个目录包含这个文件，miniserve 将替代该文件提供服务。
          [env: MINISERVE_INDEX=]
      --spa
          激活 SPA (单页应用程序)模式
          这将导致 --index 给出的文件被用于所有不存在的文件路径。实际上，每当出现404时，这将为索引文件提供服务，从而允许 SPA 路由器处理请求。
          [env: MINISERVE_SPA=]
      --pretty-urls
          激活漂亮URL模式
          这将导致服务器提供由路径指示的等效`.html`文件。`/about`会尝试找到`about.html`并提供服务。
          [env: MINISERVE_PRETTY_URLS=]
  -p, --port <PORT>
          要使用的端口
          [env: MINISERVE_PORT=]
          [默认: 8080]
  -i, --interfaces <INTERFACES>
          要监听的接口
          [env: MINISERVE_INTERFACE=]
  -a, --auth <AUTH>
          设置身份验证
          目前支持的格式：
          username:password, username:sha256:hash, username:sha512:hash
          (例如, joe:123, joe:sha256:a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3)
          [env: MINISERVE_AUTH=]
      --auth-file <AUTH_FILE>
          从文件中读取身份验证值
          文件内容示例：
          joe:123
          bob:sha256:a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3
          bill:
          [env: MINISERVE_AUTH_FILE=]
      --route-prefix <ROUTE_PREFIX>
          使用特定的路由前缀
          [env: MINISERVE_ROUTE_PREFIX=]
      --random-route
          生成一个随机的6位数字路由
          [env: MINISERVE_RANDOM_ROUTE=]
  -P, --no-symlinks
          隐藏列表中的符号链接并防止它们被跟踪
          [env: MINISERVE_NO_SYMLINKS=]
  -H, --hidden
          显示隐藏文件
          [env: MINISERVE_HIDDEN=]
  -c, --color-scheme <COLOR_SCHEME>
          默认配色方案
          [env: MINISERVE_COLOR_SCHEME=]
          [默认: squirrel]
          [可选值: squirrel, archlinux, zenburn, monokai]
  -d, --color-scheme-dark <COLOR_SCHEME_DARK>
          默认配色方案
          [env: MINISERVE_COLOR_SCHEME_DARK=]
          [默认: archlinux]
          [可选值: squirrel, archlinux, zenburn, monokai]
  -q, --qrcode
          启用二维码显示
          [env: MINISERVE_QRCODE=]
  -u, --upload-files [<ALLOWED_UPLOAD_DIR>]
          启用文件上传（并可选择指定哪个目录）
          [env: MINISERVE_ALLOWED_UPLOAD_DIR=]
  -U, --mkdir
          启用创建目录
          [env: MINISERVE_MKDIR_ENABLED=]
  -m, --media-type <MEDIA_TYPE>
          指定可上传的媒体类型
          [env: MINISERVE_MEDIA_TYPE=]
          [可选值: image, audio, video]
  -M, --raw-media-type <MEDIA_TYPE_RAW>
          直接指定可上传媒体类型表达式
          [env: MINISERVE_RAW_MEDIA_TYPE=]
  -o, --overwrite-files
          在文件上传期间启用覆盖现有文件
          [env: OVERWRITE_FILES=]
  -r, --enable-tar
          启用未压缩的 tar 归档生成
          [env: MINISERVE_ENABLE_TAR=]
  -g, --enable-tar-gz
          启用 gz-compressed 压缩的 tar 存档生成
          [env: MINISERVE_ENABLE_TAR_GZ=]
  -z, --enable-zip
          启用 zip 存档生成
          警告: 压缩大目录可能导致内存不足异常，因为压缩是在内存中完成的，不能动态发送
          [env: MINISERVE_ENABLE_ZIP=]
  -D, --dirs-first
          先列出目录
          [env: MINISERVE_DIRS_FIRST=]
  -t, --title <TITLE>
          在页面标题和标题中显示的标题，而不是主机/IP
          [env: MINISERVE_TITLE=]
      --header <HEADER>
          设置响应的自定义标头
          [env: MINISERVE_HEADER=]
  -l, --show-symlink-info
          在目录列表中可视化符号链接
          [env: MINISERVE_SHOW_SYMLINK_INFO=]
  -F, --hide-version-footer
          隐藏版本页脚
          [env: MINISERVE_HIDE_VERSION_FOOTER=]
      --hide-theme-selector
          隐藏主题选择器
          [env: MINISERVE_HIDE_THEME_SELECTOR=]
  -W, --show-wget-footer
          如果启用，显示一个 wget 命令来递归地下载工作目录
          [env: MINISERVE_SHOW_WGET_FOOTER=]
      --print-completions <shell>
          为 shell 生成完成文件
          [可能的值: bash, elvish, fish, powershell, zsh]
      --print-manpage
          生成手册页
      --tls-cert <TLS_CERT>
          要使用的 TLS 证书
          [env: MINISERVE_TLS_CERT=]
      --tls-key <TLS_KEY>
          要使用的 TLS 私钥
          [env: MINISERVE_TLS_KEY=]
      --readme
          在目录中启用 README.md 呈现
          [env: MINISERVE_README=]
  -h, --help
          打印帮助(请参阅使用’-h’的摘要)
  -V, --version
          打印版本
```
