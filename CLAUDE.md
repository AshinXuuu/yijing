# 周易研习 · 项目记忆

> 这份文件是项目的"工作记忆"。任何新会话进入这个目录，先读这份，再读代码——所有约定、状态、模板、部署都在这里。

---

## 一、项目本质

一个"一日一卦"的易经研习站。每天一篇 HTML 课程，循序渐进。

- **用户**：ashin（ashinxu@yeah.net）
- **目标**：先八卦入门 8 课，再六十四卦 64 课，共 **72 课**
- **每课形式**：自包含静态 HTML，配统一 CSS，无 JS，无构建
- **每日节奏**：每天中午 12:00 由 Claude 自动生成下一课（cron 任务已配置）

---

## 二、目录与基础设施

### 本地路径
```
/Users/ashin/Desktop/日报/知识/易经/
├── CLAUDE.md              ← 你正在读的这份记忆
├── index.html             ← 首页（八卦九宫 + 64卦九宫 + 进度）
├── deploy.sh              ← 一键发布脚本：commit + push + ssh git pull
├── .gitignore
├── assets/
│   └── style.css          ← 共用样式（古典雅致主题 + 黑体 + 移动适配）
├── bagua/                 ← 八卦入门 8 课
│   ├── 01-qian.html       ✓ 乾（天）
│   ├── 02-kun.html        ✓ 坤（地）
│   ├── 03-zhen.html       震（雷）——下一课文件名
│   ├── 04-xun.html        巽（风）
│   ├── 05-kan.html        坎（水）
│   ├── 06-li.html         离（火）
│   ├── 07-gen.html        艮（山）
│   └── 08-dui.html        兑（泽）
└── hexagrams/             ← 六十四卦 64 课（待开）
    └── 01-qian.html ... 64-weiji.html
```

### GitHub
- **仓库**：`git@github.com:AshinXuuu/yijing.git`（SSH，public）
- **主分支**：`main`

### 部署
- **平台**：腾讯云轻量应用服务器，`124.222.164.101`
- **SSH 用户**：`ubuntu`（Mac 已 ssh-copy-id 免密）
- **服务器路径**：`/var/www/yijing`（owned by ubuntu，nginx 用 www-data 读）
- **Nginx 配**：`/etc/nginx/sites-available/yijing.conf`
- **HTTPS**：Let's Encrypt（Certbot 自动续签）
- **公网访问**：https://yijing.xxcode.work
- **更新流程**：本地改 → `./deploy.sh "..."` 一键完成
  - 脚本做：`git add -A → commit → push → ssh ubuntu@... "cd /var/www/yijing && git pull"`

### deploy.sh 配置（已填好的）
```bash
SSH_USER="ubuntu"
SSH_HOST="124.222.164.101"
SSH_PORT="22"
REMOTE_PATH="/var/www/yijing"
SITE_URL="https://yijing.xxcode.work"
```

---

## 三、当前进度（每生成一课更新这块）

| # | 卦 | 文件 | 状态 |
|---|---|---|---|
| 1 | 乾 ☰ | `bagua/01-qian.html` | ✅ 已完成 |
| 2 | 坤 ☷ | `bagua/02-kun.html` | ✅ 已完成 |
| 3 | 震 ☳ | `bagua/03-zhen.html` | ✅ 已完成 |
| 4 | 巽 ☴ | `bagua/04-xun.html` | ✅ 已完成 |
| 5 | 坎 ☵ | `bagua/05-kan.html` | ✅ 已完成 |
| 6 | 离 ☲ | `bagua/06-li.html` | ✅ 已完成 |
| 7 | 艮 ☶ | `bagua/07-gen.html` | ⏳ **下一课** |
| 8 | 兑 ☱ | `bagua/08-dui.html` | 待开 |
| 9–72 | 六十四卦 | `hexagrams/01-qian.html` 起 | 待开 |

**判断"下一课"的方法**：
1. 检查 `bagua/` 已有 `01-...` 到 `NN-...`，下一课是第 `NN+1` 课
2. 如果 `bagua/` 已完成 8 课，转入 `hexagrams/`，开始第 1 卦

---

## 四、视觉与风格规范

### 主题
- **风格**：古典雅致（宣纸底 + 墨黑 + 印章红 + 古铜）
- **字体**：黑体栈 `"PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "Heiti SC", "WenQuanYi Micro Hei", sans-serif`
- **配色变量**（已定义在 `:root`）：
  - `--paper` 宣纸底 `#f3e7cf`
  - `--ink` 墨色 `#2b2520`
  - `--seal-red` 印章红 `#a93226`
  - `--bronze` 古铜 `#8b6f47`

### 已存在的 CSS 类（直接复用，不要新发明）
- 布局：`.container .chapter .chapter-head .ch-num .ch-title .ch-en`
- Hero：`.hero .hero-lesson .hero-name .hero-pin .hero-meta`
- 卦象：`.trigram` `.trigram.large` `.trigram.huge`；`.yao` `.yao.yin`
- 原文：`.classic-text .source`
- 注家：`.commentary .commentary-card .author .author.wang/.cheng/.zhu/.nan .quote`
- 三才：`.three-powers .tp-row .tp-label .tp-sub .tp-yao .tp-text`
- 六爻：`.six-dragons .dragon-row .dr-pos .dr-body .dr-yao .dr-meaning .dr-story`
- 故事：`.story` `.story h4 .era .moral`
- 应用：`.application ul`
- 速查：`.attr-table`
- 反观：`.reflection .q .a`
- 翻页：`.pager`
- 内联引用：`.inline-quote`
- 工具：`.mt-32 .mt-48 .mb-24 .lead-list .muted .center`

⚠️ **不要在 HTML 写内联 style 包含 font-family**——会和已统一的黑体冲突。

### 移动端
已有 `@media (max-width: 720px)` 和 `@media (max-width: 380px)` 两段适配，覆盖了字号/间距/letter-spacing/grid 列布局/翻页堆叠/SVG 自适应。**新课无需再写媒体查询**。

---

## 五、每课内容模板（10 章节，雷打不动）

按这个顺序、章节数、命名风格做。乾（01-qian）和坤（02-kun）是范例，可直接参考它们的 HTML 结构。

```
面包屑（href="../index.html" + Lesson N of 72）
Hero：     DAY · NN · TRIGRAM / 卦名 / 拼音 + 英文意 / 大卦象 / hero-meta 5项
一、开篇     PROLOGUE — 1~2 段引入，附 SVG 插图（自然意象）
二、卦象     THE SYMBOL — 阴阳爻基础 + 该卦的爻排列特征
三、爻位     THE THREE POWERS — 三才之道 + 本卦三爻的层意
四、六爻     THE SIX [DRAGONS/...] — 六十四卦对应卦的爻辞 + 历史人物
五、原文     THE CLASSIC — 说卦传相关段落 + 来源
六、四家注   FOUR COMMENTARIES — 王弼/程颐/朱熹/南怀瑾，顺序固定
七、史证     A HISTORICAL TALE — 一个完整的历史故事印证卦德
八、致用     MODERN APPLICATION — 5–6 条现实场景对应六爻
九、速查     QUICK REFERENCE — 表格，最后两行加"对照"行
十、反观     THREE QUESTIONS — 3 问，引读者照见自身
翻页：上一课 / HOME / 下一课
页脚：N · 第 N 课 · 毕 + Day N of 72
```

### 关键内容来源
- **原文**：以《说卦传》（八卦入门）和《周易》卦/爻辞（六十四卦）为主
- **四家注**：王弼《周易注》、程颐《伊川易传》、朱熹《周易本义》、南怀瑾《易经杂说》
- **六爻历史人物**：每爻配一个真实历史人物，体现该爻位的精神
- **史证故事**：以中国正史人物为主（《史记》《资治通鉴》层级），700–1000 字

### 八卦入门各课的核心要点（已规划，照此生成）

| 卦 | 自然 | 性 | 家庭 | 身 | 物 | 大象传 | 史证候选 |
|---|---|---|---|---|---|---|---|
| 1 乾 ☰ | 天 | 健 | 父 | 首 | 马 | 天行健，君子以自强不息 | ✅ 文王羑里演易 |
| 2 坤 ☷ | 地 | 顺 | 母 | 腹 | 牝马 | 地势坤，君子以厚德载物 | ✅ 大舜耕历山 |
| 3 震 ☳ | 雷 | 动 | 长男 | 足 | 龙 | 洊雷震，君子以恐惧修省 | 商汤革命 / 越王勾践卧薪尝胆 |
| 4 巽 ☴ | 风 | 入 | 长女 | 股 | 鸡 | 随风巽，君子以申命行事 | 子产铸刑书（潜移默化）/ 张良运筹 |
| 5 坎 ☵ | 水 | 陷 | 中男 | 耳 | 豕 | 水洊至，习坎，君子以常德行 | 司马迁忍辱著《史记》 |
| 6 离 ☲ | 火 | 丽 | 中女 | 目 | 雉 | 明两作，离，大人以继明照四方 | 唐太宗以人为镜 |
| 7 艮 ☶ | 山 | 止 | 少男 | 手 | 狗 | 兼山艮，君子以思不出其位 | 范蠡知止 / 孔子"君子思不出其位" |
| 8 兑 ☱ | 泽 | 悦 | 少女 | 口 | 羊 | 丽泽兑，君子以朋友讲习 | 孔门讲学 / 鲍叔牙荐管仲 |

---

## 六、每生成一课，要做四件事

1. **新建** `bagua/NN-名.html`（用 lesson 1/2 的结构）
2. **改 index.html**：
   - 上一课卡片：`class="bagua-card current"` → `class="bagua-card done"`
   - 本课卡片：`class="bagua-card locked"` → `class="bagua-card current"`
   - 进度条：`width:N.N%;` 和文字 `N / 72`、`入门：N/8`
3. **运行解析校验**：用 bash 跑 html.parser，确认 0 错误、0 font 残留、0 style 引号嵌套
4. **输出给用户的最后一句**：必须包含部署命令——
   ```bash
   cd "/Users/ashin/Desktop/日报/知识/易经"
   ./deploy.sh "lesson N: 卦名（自然）"
   ```

---

## 七、生成新课的具体步骤（给未来 Claude 看）

```
1. 读 CLAUDE.md（这份） → 知道当前进度
2. ls bagua/ → 确认最新一课文件名
3. 决定下一课的卦名（见上表）
4. 参考 bagua/01-qian.html 和 bagua/02-kun.html 的结构，写 bagua/NN-名.html
   - 保持 10 章节顺序
   - 复用所有 CSS class，不发明新 class
   - 不要在 HTML 内联 style 里写 font-family（让 body 默认接管）
   - 历史人物典故必须真实，参考正史
5. Edit index.html 三处：
   - 上一卡片 current → done
   - 本卡片 locked → current
   - 进度行 + 进度条宽度
6. 跑校验 bash 脚本（见下方代码块）
7. 更新本 CLAUDE.md 的"当前进度"表格
8. 给用户输出：
   - 简短介绍本课重点
   - 部署命令一行
```

### 标准校验脚本
```bash
cd "/Users/ashin/Desktop/日报/知识/易经" && python3 << 'PYEOF'
import re, html.parser, os
class V(html.parser.HTMLParser):
    def __init__(self): super().__init__(); self.errors=[]
    def error(self, msg): self.errors.append(msg)
files = ['index.html'] + sorted([f'bagua/{f}' for f in os.listdir('bagua') if f.endswith('.html')])
for f in files:
    p = V()
    with open(f, encoding='utf-8') as fh: t = fh.read()
    p.feed(t)
    broken = re.findall(r'style="[^"]*"[A-Za-z][^>]*"[^>]*"', t)
    leftovers = re.findall(r'(Kaiti|Songti|STKaiti|STSong|SimSun)\w*', t)
    print(f, '|', 'ok' if not p.errors else p.errors, '| broken:', len(broken), '| font:', set(leftovers) or 'clean')
PYEOF
```

---

## 八、用户偏好（实测得出）

- 喜欢**深度内容**，不要浅尝辄止——爻位、三才、历史典故要展开
- 喜欢**对照式讲解**——乾↔坤、阳↔阴，相互映照说理最清晰
- 偏好**正史人物典故**，越具体越好（人名+年份+情节）
- 喜欢"**现代应用**"章节给出可操作的反观条目
- 黑体（已切换，不要回头用楷宋）
- HTML 用 class 不用内联 style（避免引号嵌套问题）
- 一切发布走 `./deploy.sh`，不要让用户手敲 git 命令

---

最后更新：2026-05-29（完成第六课 · 离／火 · 唐太宗以人为镜，魏徵谏诤）
