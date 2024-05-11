# Study Flutter

## Brief

该项目为学习 Flutter 而创建，当前的 `main` 分支提供了基本的项目结构。

学习内容共有 8 个 `Issue`，每个 `Issue` 将会在一个独立分支中进行开发。

请切换分支查看所有 `Issue`。

## Issues

### 作业 1. 创建一个简单的计数器应用程序，当您按下按钮时，该应用程序会进行计数

1. 利用 StatefulWidget 的功能
2. 不要使用 Riverpod
3. 期限: 2 小时

### 作业 2. 创建一个简单的待办事项列表应用程序，显示在文本字段中输入的字符串

1. 利用 StatefulWidget 的功能
2. 不要使用 Riverpod
3. 能够添加、删除和编辑
4. 显示列表的能力
5. 不能使用相同的标题（用 Form 的 Validator 控制）
6. 期限：6 小时

### 作业 3. 创建一个可以使用秒表功能的应用程序

1. 利用 StatefulWidget 的功能
2. 不要使用 Riverpod
3. 可以以毫秒为单位进行显示
4. 能够启动、停止和重置
5. 期限：6 小时

### 作业 4.扫描一本书的条形码并根据 ISBN 值显示 Amazon 产品页面

1. 利用 StatefulWidget 的功能
2. 不要使用 Riverpod
3. 使用开源软件 特指扫描和 webview 表示
4. 应使用 WebView 创建产品页面
5. 使用 https://www.amazon.co.jp/dp/${ISBN} 关于 ISBN，有两种：ISBN-10 和 ISBN-13。 亚马逊使用 ISBN10（https://www.amazon.co.jp/dp/4860639782/）。 需要转换 ISBN13--->ISBN10
6. 期限：8 小时

### 作业 5. 创建一个应用程序，使用 GitHub API 检索有关指定代码库的信息并以列表格式显示它

1. 利用 StatefulWidget 的功能
2. 不要使用 Riverpod
3. https://docs.github.com/ja/rest?apiVersion=2022-11-28
4. 需要搜索 并列出搜索结果
5. 点击搜索结果 需要显示仓库的详细内容
6. 期限：12 小时

### 作业 6. 创建一个使用新闻 API 显示最新新闻的应用程序

1. 显示列表
2. 增加更新功能
3. 添加收藏功能（添加/删除）使用 json 文件来完成持久化
4. https://newsapi.org/
   1. 这个 url 现在打不开使用 `assets` 目录中 `news.json` 来作为数据源进行开发
5. 不要使用 Freezed
6. 使用 json_serialized 可以使用@immutable、copyWith 等 7.期限：16h

### 作业 7. 创建一个使用新闻 API 显示最新新闻的应用程序

1. 使用 riverpod
2. 使用 riverpod generator
3. 创建一个使用 News API 显示最新新闻的应用程序
4. 允许用户选择自己喜欢的新闻类别
5. 实现搜索功能，可以通过关键词搜索新闻
6. 显示新闻详细信息，可以阅读全文
7. 允许用户为感兴趣的文章添加书签（持久化）
8. 不要使用 Freezed
9. 使用 json_serialized，可以使用@immutable、copyWith 等
10. https://newsapi.org/
    1. 这个 url 现在打不开使用 `assets` 目录中 `news.json` 来作为数据源进行开发
11. 使用 json 文件持久管理收藏夹 12.期限： 20h

### 作业 8. 创建任务管理应用程序

1. 使用 riverpod
2. 使用 riverpod generator
3. 创建一个允许用户登录任务的应用
4. 按类别排序和显示任务
5. 实现设置任务截止日期的功能，并在截止日期临近时收到通知
6. 当任务完成后，它将被列为已完成的任务
7. 显示任务详细信息，以便确认详细信息
8. 持久化功能（通过 json 文件管理）
9. 期限：32 小时
