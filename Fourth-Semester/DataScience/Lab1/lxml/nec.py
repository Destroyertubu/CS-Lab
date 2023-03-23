import csv
import jieba
from collections import Counter
from wordcloud import WordCloud
import matplotlib.pyplot as plt
import numpy as np
from PIL import Image
from docx import Document
import imageio.v2 as imageio
import re
import jieba.posseg as pseg

from imageio import imread


# 将文本数据合并为一个字符串

doc = Document('参考文献(3).docx')

# 去除停用词
with open('hit_stopwords.txt', 'r', encoding='utf-8') as f:
    stopwords = [line.strip() for line in f]



text = ''
for paragraph in doc.paragraphs:
    text += paragraph.text
# word_list = jieba.cut(text)
# word_list = pseg.cut(text)
word_list = pseg.cut(text)
filtered_words = [word for word, flag in word_list if flag != "nr" and not re.match(r'^[a-zA-Z]+$', word) and not re.match(r'^\d+(\.)*$', word) and word not in stopwords]


words = [word for word in filtered_words if word not in stopwords]

# 统计词频
word_counts = Counter(words)


bg_pic = imageio.imread('mask6.png')

# 生成词云图
wc = WordCloud(
    font_path='simsun.ttc',  # 指定中文字体
    background_color='white',
    width=800,
    height=600,
    mask=bg_pic,
    prefer_horizontal=0.9
)
wc.generate_from_frequencies(word_counts)

# 显示词云图
plt.imshow(wc)
plt.axis('off')
plt.show()

# 保存词云图到本地
wc.to_file('wordcloud.png')
