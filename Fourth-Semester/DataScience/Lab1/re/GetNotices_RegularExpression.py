import csv
import requests
import re
import time

url = 'http://vip.stock.finance.sina.com.cn/corp/view/vCB_BulletinGather.php?page_index={}'

prev_url = 'http://vip.stock.finance.sina.com.cn'

ALL_company = []

# 定义一个函数用于获取网页源码并解析数据
def getsource(url):  # url 代表的每一个地区的url
    # 请求头
    # html = 1
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36'
    }
    response = requests.get(url, headers=headers)
    response.encoding = 'gbk'
    html = response.text

    return html




def geteveryitem(html):
    # print(html)
    company_list = re.match(r'.*?<tbody>(.*?)</tbody>.*?', html, re.S).group(1)

    tr_list = re.findall(r'<tr>.*?</tr>', company_list, re.S)

    Notice_list = []

    for item in tr_list:
        nt_url = re.match(r'.*?<th><a href="(.*?)" target="_blank">.*?', item, re.S).group(1)

        cp_name = re.match(r'.*?<th><a.*?>(.*?)</a>.*?', item, re.S).group(1)

        notice_type = re.match(r'.*?<td width="130">(.*?)</td>.*?', item, re.S).group(1)

        # print(notice_type)

        if "：" in cp_name:
            company_name = cp_name.split('：')[0]
            # print(notice_url)
            #     print(company_name)
            global ALL_company
            temp_list = []
            temp_list += company_name
            # print(temp_list)
            temp_list = "".join(temp_list)
            temp_list = [temp_list]
            # print(temp_list)
            if temp_list[0] not in ALL_company:
        #
                item_dict = {}
        #
        #         #
        #         # print(ALL_company)
        #
                notice_url = prev_url + nt_url
                nt_html = getsource(notice_url)

                title_c = re.match(r'.*?<thead>(.*?)</thead>.*?', nt_html, re.S)

                content = title_c.group(1)

                title_2 = re.match(r'.*?<tr.*?>.*?<th.*?>(.*?)<font.*?', content, re.S).group(1)

                # print(title_2)

                date_content = re.match(r'.*?<div.*?class="tagmain">.*?<table.*?<tbody>(.*?)</tbody>.*?', nt_html, re.S).group(1)

                # print(date_content)

                date = re.match(r'.*?<tr.*?<td.*?>(.*?)</td>.*?</tr>.*?', date_content, re.S).group(1)


                div_content_ps = re.match(r'.*?<div id="content">(.*?)</div>.*?',nt_html, re.S).group(1)

                # print(div_content_ps)

                p_list = re.findall(r'<p>.*?</p>', div_content_ps, re.S)

                # print(p_list)
                pattern = re.compile(r'<p>(.*?)</p>', re.S)

                content = []

                for i in p_list:
                    r = pattern.match(i)
                    content += r.group(1)
                    content = "".join(content)
                    content = [content]

                # print(content)
                item_dict['title'] = title_2
                item_dict['date'] = date
                item_dict['content'] = content
                item_dict['type'] = notice_type

                if content != []:
                    ALL_company += temp_list

                    Notice_list.append(item_dict)

                    if (len(ALL_company) >= 100):
                        return Notice_list

    return Notice_list

# 定义一个函数用于保存解析到的数据
def writedata(itemlist):
    with open('Notice_re.csv', mode='w', encoding='utf-8', newline="")as f:
        writer = csv.DictWriter(f, fieldnames=['title', 'date', 'content', 'type'])
        writer.writeheader()
        for i in itemlist:
            writer.writerow(i)


# 定义一个主函数用来执行各个函数
def main():
    alltemplist = []

    start_time = time.time()

    for i in range(1, 30):
        Notice_url = url.format(i)
        html = getsource(Notice_url)
        item_list = geteveryitem(html)
        alltemplist += item_list

        if (len(ALL_company) >= 100):
            break

    # 将获取的八大地区的数据进行一次写入
    end_time = time.time()


    writedata(alltemplist)

    print(end_time - start_time)



# 定义一个程序主入口 用于调用主函数
if __name__ == '__main__':
    main()
