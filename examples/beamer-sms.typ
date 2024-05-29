#import "@preview/touying:0.4.2": *
#import "@preview/unify:0.6.0": num
#import "/themes/seu-beamer.typ" as theme-seu

#let s = theme-seu.register(aspect-ratio: "4-3")
#let s = (s.methods.info)(
  self: s,
  title: [Sending out an SMS: Characterizing the Security of the SMS Ecosystem with Public Gateways],
  short-title: [Sending out an SMS],
  subtitle: [利用公共网关的SMS生态系统的安全性描述],
  author: [QuadnucYard],
  date: datetime.today(),
  institution: [Florida Institute for Cybersecurity Research (FICS)\
    University of Florida],
)
#let (init, slides, touying-outline, alert, speaker-note, tblock) = utils.methods(s)
#show: init

// #show strong: alert

#let (slide, empty-slide, title-slide, outline-slide, new-section-slide, ending-slide) = utils.slides(s)
#show: slides.with(title-slide: false)

#title-slide(authors: [Bradley Reaves, Nolen Scaife, Dave Tian, Logan Blue, \
  Patrick Traynor and Kevin R.B. Butler \

  #set text(size: 0.9em)
  {reaves, scaife, daveti, bluel}\@ufl.edu \ {traynor, butler}\@cise.ufl.edu
])

#outline-slide()

= 引言

== 引言

#tblock(title: [研究背景])[
  - 短信息（SMS）成为现代通讯的重要组成部分
  - 很多组织或网站使用短信息作为身份验证的辅助通道
  - 现代短消息的发送，在抵达终端之前不接触蜂窝网络
]

#tblock(title: [主要工作])[
  - 对SMS数据进行迄今为止最大的挖掘分析
  - 评估良性短消息服务的安全态势
  - 刻画通过SMS网关进行的恶意行为
]

#new-section-slide(short-title: [系统])[现代SMS生态系统]

== 短消息服务中心（SMSC）

#figure(
  image("figures/figure1.png", width: 90%),
  caption: [短消息服务中心],
) <fig:SMSC>

*短消息服务中心*通过运营商网络路由消息，是SMS系统的核心。\
SMSC接受文本消息，并将消息转发到蜂窝网络中的移动用户。

== 外部短消息实体（ESME）

#figure(
  image("figures/figure2.png", width: 90%),
  caption: [外部短消息实体],
) <fig:ESME>

*外部短消息实体*为外部组织提供针对运营商网络的短消息接入服务。\
ESME可以用于紧急通报、慈善捐款、或接受一次性验证码等功能。

== OTT服务

#figure(
  image("figures/figure3.png", width: 90%),
  caption: [OTT服务],
) <fig:OTT>

*OTT服务*支持在数据网络上提供短信和语音等第三方服务。\
OTT可以使用云服务来存储和同步SMS到用户的其他设备。

#new-section-slide(short-title: [方法])[研究方法与数据集特征]

== 爬取公共短消息网关

#slide[
  #set text(0.8em)

  - 使用Scrapy框架爬取公共网关
  - 收集8个公共短信网关在14个月的数据
  - 共抓取 #num(386327) 条数据
][
  #show table: set text(0.8em)

  #figure(
    table(
      columns: 2,
      [*Site*], [*Messages*],
      [receivesmsonline.net], [81313],
      [receive-sms-online.info], [69389],
      [receive-sms-now.com], [63797],
      [hs3x.com], [55499],
      [receivesmsonline.com], [44640],
      [receivefreesms.com], [37485],
      [receive-sms-online.com], [27094],
      [e-receivesms.com], [7107],
    ),
    caption: [公共网关及抓取的信息数],
  ) <tab:gateways>
]

== 消息聚类分析

#tblock(title: [基本思路])[
  - 使用编辑距离矩阵将类似的消息归于一张连通图中。
  - 使用固定值替换感兴趣的消息，如代码、email地址。
  - 查找归一化距离小于阈值的消息，并确定聚类边界。
]

#tblock(title: [实现步骤])[
  + 加载所有消息。
  + 用固定的字符串替换数字、电子邮件和URL以预处理消息。
  + 将预处理后的信息按字母排序。
  + 通过使用编辑距离阈值（0.9）来确定聚类边界。
  + 手动标记各个聚类，以确定服务提供者、消息类别等。
]

== 消息分类结果

- *账户创建确认信息*：向来自服务提供者的用户提供了一个代码，该服务提供者需要在新帐户创建期间进行SMS验证。
- *活动确认信息*：向来自服务提供者的用户提供了请求授权进行活动的代码(例如，付款确认)。
- *一次性密码*：包含用户登录的代码的短信息。
- *用于绑定不同设备的一次性口令*：将消息发送给用户，以绑定一个新的电话号码或启用相应的移动应用程序。
- *重置密码口令*：包含密码重置密码的短信息。
- *其他*：其他未被指定为某种特定功能的消息。

== 消息分类结果

#slide[
  #set text(0.8em)

  - 账户创建和移动设备绑定占比最大，占51.6%
  - 一次性密码信息占7.6%
  - 密码重置消息占1.3%
  - 包含“测试”关键词的消息占0.8%
][
  #show table: set text(0.8em)

  #figure(
    image("figures/figure4.png"),
    caption: [消息的聚类],
  ) <fig:classification>
]

#new-section-slide(short-title: [分析])[SMS使用情况分析]

== 使用SMS作为安全信道

#tblock(title: [PII和其他敏感信息])[
  - 财务信息
  - 用户名和密码
  - 重置密码口令
  - 其他个人识别信息（PII）
  - 敏感程序的SMS活动
]

== 使用SMS作为安全信道

#tblock(title: [SMS编码熵])[
  使用 $chi^2$ 检验测试每组编码的熵。$chi^2$ 检验是一个零假设的显著性检验，用于测试SMS服务的编码是否是从低位到高位均匀分布的。若 $p$ 值小于 $0.01$，则表明观测值和理想均匀分布之间存在统计学上的显著差异。
  检验结果表明，$65%$ 的SMS服务的编码熵较低，容易被预测和攻击。
]

#grid(
  columns: (1fr, 1fr, 1fr),
  figure(
    image("figures/figure6.png"),
    caption: [WeChat],
  ),
  figure(
    image("figures/figure7.png"),
    caption: [Talk2],
  ),
  figure(
    image("figures/figure8.png"),
    caption: [Google],
  ),
)

== SMS的恶意应用

#tblock(title: [公共网关检测到的恶意信息])[
  - *泄露用户位置信息*：短URL可以用于确定消息的源和目的地，即会泄漏用户的位置信息。
  - *垃圾邮件宣传广告*：在公共网关服务中比例较低，约为1.0%。
  - *网络钓鱼活动*：试图欺骗用户，使其相信自己正与合法网站通信。
]

#grid(
  columns: (1fr, 1fr, 1fr),
  figure(
    image("figures/figure9.png"),
    caption: [SMS地址分布],
  ),
  figure(
    image("figures/figure10.png"),
    caption: [钓鱼短信实例],
  ),
  figure(
    image("figures/figure11.png"),
    caption: [钓鱼网站],
  ),
)

= 结论

== 结论

- SMS生态系统在智能手机时代出现了新的发展，加入了更多新的设备和参与者。
- 公共网关为用户提供了基于SMS的各种安全解决方案。
- 根据该研究，将SMS作为安全信道传递敏感信息存在一定的危险性。一些一次性的消息传递机制亟待改进。
- 至于短信滥用，公共网关可以用于规避一些安全性较差的认证机制，或进行PVA欺诈行为。

#ending-slide(title: [Thanks for Listening.])[
  Touying theme for Southeast University

  https://github.com/QuadnucYard/touying-theme-seu

  Welcome Star and Fork!
]
