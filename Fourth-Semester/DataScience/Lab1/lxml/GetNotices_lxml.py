import requests
from lxml import etree
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
    # print(html)
    return html


def get_item_text(url):
    pass


def geteveryitem(html):
    # print(html)
    element = etree.HTML(html)

    Notice_URL_List = element.xpath('//*[@id="wrap"]/div[5]/table/tbody/tr')

    # print(Notice_URL_List)

    Notice_list = []

    for item in Notice_URL_List:

        notice_url = item.xpath('./th/a[1]/@href')[0]
        company_name = item.xpath('./th/a[1]/text()')[0]
        notice_type = item.xpath('./td[1]/text()')[0]

        # print(notice_type)

        # print(company_name)
        # print(notice_url)
        if '：' in company_name:
            company_name = company_name.split('：')[0]
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

                item_dict = {}

                #
                # print(ALL_company)

                notice_url = prev_url + notice_url
                ntc_html = getsource(notice_url)
                ntc_element = etree.HTML(ntc_html)

                title = ntc_element.xpath('//*[@id="allbulletin"]/thead/tr/th/text()')[0].replace('\t',"")
                date = ntc_element.xpath('//*[@id="allbulletin"]/tbody/tr[1]/td/text()')[0].split(":")[1]
                content = ntc_element.xpath('//*[@id="content"]/p/text()')
                # print(title)
                # print(date)
                # print(content)

                item_dict['title'] = title
                item_dict['date'] = date
                item_dict['content'] = content
                item_dict['type'] = notice_type
                if content != []:
                    ALL_company += temp_list

                    Notice_list.append(item_dict)

                    if(len(ALL_company) >= 100):
                        return Notice_list

    return Notice_list




def writedata(itemlist):
    with open('Notice.csv', mode='w', encoding='utf-8', newline="")as f:
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
        item_list = geteveryitem(html)

        notices_List += item_list
        if(len(ALL_company) >= 100):
            break

    end_time = time.time()

    writedata(notices_List)
    print(end_time - start_time)

