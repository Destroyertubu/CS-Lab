import requests
from lxml import etree
from bs4 import BeautifulSoup
import csv
import time

# 目标url 模板
Notice_url = 'http://vip.stock.finance.sina.com.cn/corp/view/vCB_BulletinGather.php?page_index={}'

prev_url = 'http://vip.stock.finance.sina.com.cn'

ALL_company = []

# 定义一个函数用来获取网页源代码
def getsource(pagelink):
    # 请求头
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'
    }
    # 获取源码
    response = requests.get(pagelink, headers=headers)
    response.encoding = 'gbk'
    html = response.text

    with open('example.html', 'w', encoding='utf-8') as file:
        file.write(html)
    # print(html)
    return html


def get_item_text(url):
    pass


def geteveryitem(html):

    # print(html)

    soup = BeautifulSoup(html, 'html5lib')

    # print(soup)
    tbody = soup.find('tbody')

    # print(tbody)
    Notice_list = []

    trs = tbody.find_all('tr')
    # print(trs)

    for tr in trs:
        th = tr.find_all('th')[0]
        a = th.find_all('a')[0]
        td = tr.find_all('td')[0]

        notice_type = td.text

        # print(notice_type)

        notice_url = a.get('href')

        notice_url = prev_url + notice_url
        company_name = a.text

        if '：' in company_name:
            company_name = company_name.split('：')[0]
            global ALL_company
            temp_list = []
            temp_list += company_name
            # print(temp_list)
            temp_list = "".join(temp_list)
            temp_list = [temp_list]
            # print(temp_list)

            if temp_list[0] not in ALL_company:

                item_dict = {}

                ntc_html = getsource(notice_url)
                ntc_element = BeautifulSoup(ntc_html, 'html5lib')


                title = ntc_element.find('div', class_="tagmain").find_all('table')[0].find_all('thead')[0].find_all('tr')[0].find_all('th')[0].text
                if title is None:
                    continue
                # print(title)
                date = ntc_element.find('div', class_="tagmain").find_all('table')[0].find_all('tbody')[0].find_all('tr')[0].find_all('td')[0].text

                # print(type(date))
                content = ntc_element.find('div', class_="tagmain").find_all('table')[0].find_all('tbody')[0].find_all('tr')[1].find('td').\
                    find('div').find('div').find_all('p')

                content_list = []
                if content:
                    for i in content:
                        content_list += i.text.replace('<p>',"").replace('</p>',"")
                else:
                    continue

                item_dict['title'] = title
                item_dict['date'] = date
                item_dict['content'] = content
                item_dict['type'] = notice_type

                if content != []:
                    ALL_company += temp_list

                    Notice_list.append(item_dict)

                    if (len(ALL_company) >= 100):
                        return Notice_list


    return Notice_list

            # print(notice_url)




def writedata(itemlist):
    with open('Notice_bs4.csv', mode='w', encoding='utf-8', newline="")as f:
        writer = csv.DictWriter(f, fieldnames=['title', 'date', 'content', 'type'])
        writer.writeheader()
        for i in itemlist:
            writer.writerow(i)



if __name__ == '__main__':

    notices_List = []

    start_time = time.time()

    for i in range(1, 30):

        pagelink = Notice_url.format(i)
        html = getsource(pagelink)

        # with open('example.html', 'r', encoding='utf-8') as file:
        #     html = file.read()

        # print(html)

        item_list = geteveryitem(html)

        notices_List += item_list
        if(len(ALL_company) >= 100):
            break

    end_time = time.time()

    writedata(notices_List)

    print(end_time - start_time)

