import csv
import jieba
from collections import Counter
from wordcloud import WordCloud
import matplotlib.pyplot as plt

# 读取CSV文件
with open('Notice_re.csv', 'r', encoding='utf-8') as f:
    reader = csv.reader(f)
    next(reader)  # 跳过表头
    data = [row[2] for row in reader]  # 取第2列数据作为文本数据

# 将文本数据合并为一个字符串
text = ''.join(data)

# 分词
words = jieba.lcut(text)

# 去除停用词
with open('stopwords.txt', 'r', encoding='utf-8') as f:
    stopwords = [line.strip() for line in f]
words = [word for word in words if word not in stopwords]

# 统计词频
word_counts = Counter(words)

# 生成词云图
wc = WordCloud(
    font_path='simsun.ttc',  # 指定中文字体
    background_color='white',
    width=800,
    height=600
)
wc.generate_from_frequencies(word_counts)

# 显示词云图
plt.imshow(wc)
plt.axis('off')
plt.show()

# 保存词云图到本地
wc.to_file('wordcloud_re.png')
