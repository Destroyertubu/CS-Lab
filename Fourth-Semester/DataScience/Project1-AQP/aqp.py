'''
Description: Coding The World!
Version: 2.0
Author: LostMagician
Date: 2023-05-03 14:36:06
LastEditors: LostMagician
LastEditTime: 2023-05-07 10:37:02
'''
import pandas as pd
import numpy as np
import json

DataSize = 1000000

bucket_num = 45
global_bucket = {}
global_bucket_border = {}

global_average = {}
global_sum = {}
global_count = {}

prefix_array = {}

total_average = {}
total_sum = {}
total_count = {}

global_sum_group_df = {}
global_average_group_df = {}
global_count_group_df = {}


year_date_step_list = []
dep_delay_step_list = []
taxi_out_step_list = []
taxi_in_step_list = []
arr_delay_step_list = []
air_time_step_list = []
distance_step_list = []

nonum_columns = ['UNIQUE_CARRIER', 'ORIGIN', 'ORIGIN_STATE_ABR', 'DEST',
               'DEST_STATE_ABR']

num_columns = ['DEP_DELAY', 'TAXI_OUT', 'TAXI_IN', 'ARR_DELAY',
               'AIR_TIME', 'DISTANCE', 'YEAR_DATE']

all_columns = ['YEAR_DATE', 'UNIQUE_CARRIER', 'ORIGIN', 'ORIGIN_STATE_ABR', 'DEST',
               'DEST_STATE_ABR', 'DEP_DELAY', 'TAXI_OUT', 'TAXI_IN', 'ARR_DELAY',
               'AIR_TIME', 'DISTANCE']


def aqp_online(data: pd.DataFrame, Q: list) -> list:
    queries = []
    for i in Q:
        queries.append(json.loads(i))

    results = []
    for i in queries:
        j = i['result_col']
        tmp = 0
        if len(j) == 1:
            if j[0][0] == 'avg':
                single_average = find_average_single(j[0][1])   # 直接将要求平均值的列名输入
                results.append([])
                # df3 = pd.DataFrame({})
                # df3[j[0][1]] = single_average
                # for j in df3.itertuples(): #DataFrame是列储存，我们需要转换为行储存，且要把结果list编码为json字符串
                #      results[-1].append(list(j)[1 : len(j)])
                results[-1].append([float(single_average)])
                results[-1] = json.dumps(results[-1], ensure_ascii=False)
                continue
                

            if j[0][0] == 'sum':
                single_sum = find_sum_single(i['predicate'], j[0][1])
                results.append([])
                # df3 = pd.DataFrame({})
                # df3[j[0][1]] = single_sum
                # for j in df3.itertuples(): #DataFrame是列储存，我们需要转换为行储存，且要把结果list编码为json字符串
                #      results[-1].append(list(j)[1 : len(j)])
                results[-1].append([float(single_sum)])
                results[-1] = json.dumps(results[-1], ensure_ascii=False)
                continue
                

            if j[0][0] == 'count':
                single_count = find_count_single(i['predicate'], j[0][1])
                results.append([])
                # df3 = pd.DataFrame({})
                # df3['YEAR_DATE'] = single_count
                # for j in df3.itertuples(): #DataFrame是列储存，我们需要转换为行储存，且要把结果list编码为json字符串
                #      results[-1].append(list(j)[1 : len(j)])
                results[-1].append([float(single_count)])
                results[-1] = json.dumps(results[-1], ensure_ascii=False)
                continue
                
            # print(results[-1])

        else:
            if j[1][0] == 'avg':
                df = find_avg_groupby(j[0][0])    #* j[0][0]是分组的依据列，直接返回平均值
            elif j[1][0] == 'sum':
                df = find_sum_groupby(i['predicate'], j[0][0])
            else:
                df = find_count_groupby(i['predicate'], j[0][0])
            
            result = pd.DataFrame({})
            
            # print(df)  # todo
            
            result[j[0][0]] = list(df.index)
            if j[1][1] == '*':
                result[j[1][0]] = list(df[list(df.columns)[0]])
            else:
                result[j[1][0] + j[1][1]] = list(df[j[1][1]])
            
            results.append([])
            for j in result.itertuples(): #DataFrame是列储存，我们需要转换为行储存，且要把结果list编码为json字符串
                 results[-1].append(list(j)[1 : len(j)])
                 
            
            results[-1] = json.dumps(results[-1], ensure_ascii=False)

    # print(results)
    return results

def aqp_offline(data: pd.DataFrame, Q: list) -> None:
    pre_process(data)
    create_bucket(data)
    calc_global_val(data)
    create_df()

def find_average_single(condition: list):
    # print(global_average.keys())   # todo
    return total_average[condition]

def find_count_single(condition: list, res_col_name: str) -> pd.DataFrame:
    ratio = 1
    res_count = DataSize
    flag = True
    for i in condition:
        if i['lb'] == i['ub']:
            # if flag:
            #     res_count = global_count[i['col']][i['lb']][list(global_count[i['col']][i['lb']].keys())[0]]    # 由于count之后跟的一定是*，所以这里直接取第一个值
            #     flag = False
            # else:
            ratio *= global_count[i['col']][i['lb']][list(global_count[i['col']][i['lb']].keys())[0]] / DataSize
        else:
            upper = DataSize
            lower = 0
            if i['ub'] != '_None_':
                upper = find_bucket_border(i['col'], i['ub'])
            if i['lb'] != '_None_':
                lower = find_bucket_border(i['col'], i['lb'])

            ratio *= (upper - lower) / DataSize
    res_count = res_count * ratio
    return res_count

def find_sum_single(condition: list, res_col_name: str):
    ratio = 1
    res_sum = total_sum[res_col_name]
    flag = True
    for i in condition:
        if i['lb'] == i['ub']:
            # print(global_sum[i['col']][i['lb']])  # todo
            # if flag:
            #     res_sum = global_sum[i['col']][i['lb']][res_col_name]
            #     flag = False
            # else:
            ratio *= global_count[i['col']][i['lb']][list(global_count[i['col']][i['lb']].keys())[0]] / DataSize
        else:
            upper = DataSize
            lower = 0
            if i['ub'] != '_None_':
                upper = find_bucket_border(i['col'], i['ub'])
            if i['lb'] != '_None_':
                lower = find_bucket_border(i['col'], i['lb'])

            ratio *= (upper - lower) / DataSize    # todo 通过所选数据的比例对最终结果进行调整
    res_sum = res_sum * ratio
    return res_sum

def find_avg_groupby(condition):
    # df = pd.DataFrame(global_average[condition])
    # df = df.T
    return global_average_group_df[condition]

def get_ratio(condition):
    ratio = 1
    for i in condition:
        if i['lb'] == i['ub']:
            # print()
            ratio *= global_count[i['col']][i['lb']][list(global_count[i['col']][i['lb']].keys())[0]] / DataSize  # todo 这里有错误，需要修改
            # 由于count之后跟的一定是*，所以这里直接取第一个值
        else:
            upper = DataSize
            lower = 0
            if i['ub'] != '_None_':
                upper = find_bucket_border(i['col'], i['ub'])
            if i['lb'] != '_None_':
                lower = find_bucket_border(i['col'], i['lb'])

            ratio *= (upper - lower) / DataSize    # todo 通过所选数据的比例对最终结果进行调整
    return ratio

def create_df():
    for i in nonum_columns:
        global_sum_group_df[i] = pd.DataFrame(global_sum[i])
        global_sum_group_df[i] = global_sum_group_df[i].T
        
        global_average_group_df[i] = pd.DataFrame(global_average[i])
        global_average_group_df[i] = global_average_group_df[i].T
        
        global_count_group_df[i] = pd.DataFrame(global_count[i])
        global_count_group_df[i] = global_count_group_df[i].T
        

def find_sum_groupby(condition, res_col_name):
    # print(res_col_name)
    
    # df = pd.DataFrame(global_sum[res_col_name])
    # df = df.T
    
    df = global_sum_group_df[res_col_name]
    ratio = get_ratio(condition)
    return df * ratio
    # return df

def find_count_groupby(condition, res_col_name):
    # df = pd.DataFrame(global_count[res_col_name])
    # df = df.T
    
    df = global_count_group_df[res_col_name]
    ratio = get_ratio(condition)
    return df * ratio
    # return df

def f_where(data: pd.DataFrame, predicate: list) -> pd.DataFrame:
    x = data
    for i in predicate:
        if i['lb'] == i['ub']:
            x = x.where(x[i['col']] == i['lb'])
        else:
            if i['lb'] != '_None_':
                x = x.where(x[i['col']] >= i['lb'])
            if i['ub'] != '_None_':
                x = x.where(x[i['col']] <= i['ub'])
    return x


def f_agg(data: pd.DataFrame, agg_func: str) -> pd.DataFrame:
    df_func = {'count': 'count()', 'sum': 'sum()', 'avg': 'mean()'}
    return eval('data.' + df_func[agg_func])


def pre_process(data):
    # global_sum['YEAR_DATE'] = {}
    # global_average['YEAR_DATE'] = {}
    # global_count['YEAR_DATE'] = {}

    # year_date_sum = data.groupby('YEAR_DATE').sum()
    # year_date_average = data.groupby('YEAR_DATE').mean()
    # year_date_count = data.groupby('YEAR_DATE').count()
    # years = data['YEAR_DATE'].unique()

    # for j in years:
    #     global_sum['YEAR_DATE'][j] = {}
    #     global_average['YEAR_DATE'][j] = {}
    #     global_count['YEAR_DATE'][j] = {}
    #     for i in num_columns:
    #         global_sum['YEAR_DATE'][j][i] = year_date_sum.loc[j, i]
    #         global_average['YEAR_DATE'][j][i] = year_date_average.loc[j, i]

    #     for i in all_columns:
    #         if i != 'YEAR_DATE':
    #             global_count['YEAR_DATE'][j][i] = year_date_count.loc[j, i]

    # ------------------ 1.1 ------------------

    global_sum['UNIQUE_CARRIER'] = {}
    global_count['UNIQUE_CARRIER'] = {}
    global_average['UNIQUE_CARRIER'] = {}

    unique_carrier_sum = data.groupby('UNIQUE_CARRIER').sum()
    unique_carrier_count = data.groupby('UNIQUE_CARRIER').count()
    unique_carrier_average = data.groupby('UNIQUE_CARRIER').mean()
    unique_carrier = data['UNIQUE_CARRIER'].unique()

    for i in unique_carrier:
        global_average['UNIQUE_CARRIER'][i] = {}
        global_count['UNIQUE_CARRIER'][i] = {}
        global_sum['UNIQUE_CARRIER'][i] = {}
        for j in num_columns:
            global_sum['UNIQUE_CARRIER'][i][j] = unique_carrier_sum.loc[i, j]
            global_average['UNIQUE_CARRIER'][i][j] = unique_carrier_average.loc[i, j]

        for j in all_columns:
            if j != 'UNIQUE_CARRIER':
                global_count['UNIQUE_CARRIER'][i][j] = unique_carrier_count.loc[i, j]

    # ------------------ 1.1 ------------------

    global_sum['ORIGIN'] = {}
    global_average['ORIGIN'] = {}
    global_count['ORIGIN'] = {}

    origin_sum = data.groupby('ORIGIN').sum()
    origin_average = data.groupby('ORIGIN').mean()
    origin_count = data.groupby('ORIGIN').count()
    origin = data['ORIGIN'].unique()

    for i in origin:
        global_count['ORIGIN'][i] = {}
        global_sum['ORIGIN'][i] = {}
        global_average['ORIGIN'][i] = {}
        for j in num_columns:
            global_sum['ORIGIN'][i][j] = origin_sum.loc[i, j]
            global_average['ORIGIN'][i][j] = origin_average.loc[i, j]

        for j in all_columns:
            if j != 'ORIGIN':
                global_count['ORIGIN'][i][j] = origin_count.loc[i, j]

    # ------------------ 1.1 ------------------

    global_sum['ORIGIN_STATE_ABR'] = {}
    global_average['ORIGIN_STATE_ABR'] = {}
    global_count['ORIGIN_STATE_ABR'] = {}

    origin_state_abr_average = data.groupby('ORIGIN_STATE_ABR').mean()
    origin_state_abr_count = data.groupby('ORIGIN_STATE_ABR').count()
    origin_state_abr_sum = data.groupby('ORIGIN_STATE_ABR').sum()
    origin_state_abr = data['ORIGIN_STATE_ABR'].unique()

    for i in origin_state_abr:
        global_average['ORIGIN_STATE_ABR'][i] = {}
        global_count['ORIGIN_STATE_ABR'][i] = {}
        global_sum['ORIGIN_STATE_ABR'][i] = {}
        for j in num_columns:
            global_average['ORIGIN_STATE_ABR'][i][j] = origin_state_abr_average.loc[i, j]
            global_sum['ORIGIN_STATE_ABR'][i][j] = origin_state_abr_sum.loc[i, j]

        for j in all_columns:
            if j != 'ORIGIN_STATE_ABR':
                global_count['ORIGIN_STATE_ABR'][i][j] = origin_state_abr_count.loc[i, j]

    # ------------------ 1.1 ------------------

    global_sum['DEST'] = {}
    global_average['DEST'] = {}
    global_count['DEST'] = {}

    dest_average = data.groupby('DEST').mean()
    dest_count = data.groupby('DEST').count()
    dest_sum = data.groupby('DEST').sum()
    dest = data['DEST'].unique()

    for i in dest:
        global_sum['DEST'][i] = {}
        global_count['DEST'][i] = {}
        global_average['DEST'][i] = {}
        for j in num_columns:
            global_sum['DEST'][i][j] = dest_sum.loc[i, j]
            global_average['DEST'][i][j] = dest_average.loc[i, j]

        for j in all_columns:
            if j != 'DEST':
                global_count['DEST'][i][j] = dest_count.loc[i, j]
             
    # ------------------ 1.1 ------------------        
        
    global_count['DEST_STATE_ABR'] = {}
    global_average['DEST_STATE_ABR'] = {}
    global_sum['DEST_STATE_ABR'] = {}

    dest_state_abr_sum = data.groupby('DEST_STATE_ABR').sum()
    dest_state_abr_average = data.groupby('DEST_STATE_ABR').mean()
    dest_state_abr_count = data.groupby('DEST_STATE_ABR').count()
    dest_state_abr = data['DEST_STATE_ABR'].unique()

    for i in dest_state_abr:
        global_sum['DEST_STATE_ABR'][i] = {}
        global_average['DEST_STATE_ABR'][i] = {}
        global_count['DEST_STATE_ABR'][i] = {}
        for j in num_columns:
            global_sum['DEST_STATE_ABR'][i][j] = dest_state_abr_sum.loc[i, j]
            global_average['DEST_STATE_ABR'][i][j] = dest_state_abr_average.loc[i, j]
            global_count['DEST_STATE_ABR'][i][j] = dest_state_abr_count.loc[i, j]
        

def create_bucket(data):
    
    year_date_max = data['YEAR_DATE'].max()
    year_date_min = data['YEAR_DATE'].min()
    global_bucket['YEAR_DATE'] = []
    
    prefix_sum = 0
    prefix_array['YEAR_DATE'] = []
    prefix_array['YEAR_DATE'].append(0)
    
    year_date_step = (year_date_max - year_date_min) / bucket_num
    
    for i in range(bucket_num):
        year_date_step_list.append(year_date_min + year_date_step * i)
        
    year_date_step_list.append(year_date_max + 1)
    
    for i in range(len(year_date_step_list) - 1):
        l = len(data[(data['YEAR_DATE'] >= year_date_step_list[i]) & (data['YEAR_DATE'] < year_date_step_list[i + 1])])
        global_bucket['YEAR_DATE'].append(l)
        prefix_sum += l
        prefix_array['YEAR_DATE'].append(prefix_sum)
        
    global_bucket_border['YEAR_DATE'] = year_date_step_list
    # ------------------ 1.2 ------------------
    
    
    
    dep_delay_max = data['DEP_DELAY'].max()
    dep_delay_min = data['DEP_DELAY'].min()
    global_bucket['DEP_DELAY'] = []

    prefix_sum = 0
    prefix_array['DEP_DELAY'] = []
    prefix_array['DEP_DELAY'].append(0)

    dep_delay_step = (dep_delay_max - dep_delay_min) / bucket_num
    # dep_delay_step_list = []
    for i in range(bucket_num):
        dep_delay_step_list.append(dep_delay_min + dep_delay_step * i)    # todo 计算每个bin的边界

    dep_delay_step_list.append(dep_delay_max + 1)

    for i in range(len(dep_delay_step_list) - 1):
        l = len(data[(data['DEP_DELAY'] >= dep_delay_step_list[i])
                     & (data['DEP_DELAY'] < dep_delay_step_list[i + 1])]['DEP_DELAY'])
        global_bucket['DEP_DELAY'].append(l)
        prefix_sum += l
        prefix_array['DEP_DELAY'].append(prefix_sum)    # todo 前缀和，表示前i个bin的总数

    global_bucket_border['DEP_DELAY'] = dep_delay_step_list
    # ------------------ 1.2 ------------------

    global_bucket['TAXI_OUT'] = []
    taxi_out_max = data['TAXI_OUT'].max()
    taxi_out_min = data['TAXI_OUT'].min()

    prefix_sum = 0
    prefix_array['TAXI_OUT'] = []
    prefix_array['TAXI_OUT'].append(0)

    taxi_out_step = (taxi_out_max - taxi_out_min) / bucket_num

    # taxi_out_step_list = []

    for i in range(bucket_num):
        taxi_out_step_list.append(taxi_out_min + taxi_out_step * i)

    taxi_out_step_list.append(taxi_out_max + 1)

    for i in range(len(taxi_out_step_list) - 1):
        l = len(data[(data['TAXI_OUT'] >= taxi_out_step_list[i])
                                                  & (data['TAXI_OUT'] < taxi_out_step_list[i + 1])]['TAXI_OUT'])
        global_bucket['TAXI_OUT'].append(l)
        prefix_sum += l
        prefix_array['TAXI_OUT'].append(prefix_sum)
        
        

    global_bucket_border['TAXI_OUT'] = taxi_out_step_list

    # ------------------ 1.2 -------------------
    global_bucket['TAXI_IN'] = []

    taxi_in_max = data['TAXI_IN'].max()
    taxi_in_min = data['TAXI_IN'].min()

    prefix_sum = 0
    prefix_array['TAXI_IN'] = []
    prefix_array['TAXI_IN'].append(0)

    taxi_in_step = (taxi_in_max - taxi_in_min) / bucket_num

    # taxi_in_step_list = []

    for i in range(bucket_num):
        taxi_in_step_list.append(taxi_in_min + taxi_in_step * i)

    taxi_in_step_list.append(taxi_in_max + 1)

    for i in range(len(taxi_in_step_list) - 1):
        l = len(data[(data['TAXI_IN'] >= taxi_in_step_list[i])
                                                 & (data['TAXI_IN'] < taxi_in_step_list[i + 1])]['TAXI_IN'])
        global_bucket['TAXI_IN'].append(l)
        prefix_sum += l
        prefix_array['TAXI_IN'].append(prefix_sum)

    global_bucket_border['TAXI_IN'] = taxi_in_step_list
    # global_bucket['TAXI_IN']

    # ------------------ 1.2 ------------------

    global_bucket['ARR_DELAY'] = []

    arr_delay_max = data['ARR_DELAY'].max()
    arr_delay_min = data['ARR_DELAY'].min()

    prefix_sum = 0
    prefix_array['ARR_DELAY'] = []
    prefix_array['ARR_DELAY'].append(0)

    arr_delay_step = (arr_delay_max - arr_delay_min) / bucket_num

    # arr_delay_step_list = []

    for i in range(bucket_num):
        arr_delay_step_list.append(arr_delay_min + arr_delay_step * i)

    arr_delay_step_list.append(arr_delay_max + 1)

    for i in range(len(arr_delay_step_list) - 1):
        l = len(data[(data['ARR_DELAY'] >= arr_delay_step_list[i])
                                                   & (data['ARR_DELAY'] < arr_delay_step_list[i + 1])]['ARR_DELAY'])
        global_bucket['ARR_DELAY'].append(l)
        prefix_sum += l
        prefix_array['ARR_DELAY'].append(prefix_sum)

    # global_bucket['ARR_DELAY']
    global_bucket_border['ARR_DELAY'] = arr_delay_step_list
    # ------------------ 1.2 ------------------

    global_bucket['AIR_TIME'] = []

    air_time_max = data['AIR_TIME'].max()
    air_time_min = data['AIR_TIME'].min()

    prefix_sum = 0
    prefix_array['AIR_TIME'] = []
    prefix_array['AIR_TIME'].append(0)

    air_time_step = (air_time_max - air_time_min) / bucket_num

    # air_time_step_list = []

    for i in range(bucket_num):
        air_time_step_list.append(air_time_min + air_time_step * i)

    air_time_step_list.append(air_time_max + 1)

    for i in range(len(air_time_step_list) - 1):
        l = len(data[(data['AIR_TIME'] >= air_time_step_list[i])
                                                  & (data['AIR_TIME'] < air_time_step_list[i + 1])]['AIR_TIME'])
        global_bucket['AIR_TIME'].append(l)
        prefix_sum += l
        prefix_array['AIR_TIME'].append(prefix_sum)

    # global_bucket['AIR_TIME']
    global_bucket_border['AIR_TIME'] = air_time_step_list
    # ------------------ 1.2 ------------------

    global_bucket['DISTANCE'] = []

    distance_max = data['DISTANCE'].max()
    distance_min = data['DISTANCE'].min()

    prefix_sum = 0
    prefix_array['DISTANCE'] = []
    prefix_array['DISTANCE'].append(0)

    distance_step = (distance_max - distance_min) / bucket_num
    # distance_step_list = []

    for i in range(bucket_num):
        distance_step_list.append(distance_min + distance_step * i)

    distance_step_list.append(distance_max + 1)

    for i in range(len(distance_step_list) - 1):
        l = len(data[(data['DISTANCE'] >= distance_step_list[i])
                                                  & (data['DISTANCE'] < distance_step_list[i + 1])]['DISTANCE'])
        global_bucket['DISTANCE'].append(l)
        prefix_sum += l
        prefix_array['DISTANCE'].append(prefix_sum)

    global_bucket_border['DISTANCE'] = distance_step_list
    # global_bucket['DISTANCE']


def calc_global_val(data):
    total_average['DEP_DELAY'] = data['DEP_DELAY'].mean()
    total_average['TAXI_OUT'] = data['TAXI_OUT'].mean()
    total_average['TAXI_IN'] = data['TAXI_IN'].mean()
    total_average['ARR_DELAY'] = data['ARR_DELAY'].mean()
    total_average['AIR_TIME'] = data['AIR_TIME'].mean()
    total_average['DISTANCE'] = data['DISTANCE'].mean()
    total_average['YEAR_DATE'] = data['YEAR_DATE'].mean()

    total_sum['DEP_DELAY'] = data['DEP_DELAY'].sum()
    total_sum['TAXI_OUT'] = data['TAXI_OUT'].sum()
    total_sum['TAXI_IN'] = data['TAXI_IN'].sum()
    total_sum['ARR_DELAY'] = data['ARR_DELAY'].sum()
    total_sum['AIR_TIME'] = data['AIR_TIME'].sum()
    total_sum['DISTANCE'] = data['DISTANCE'].sum()
    total_sum['YEAR_DATE'] = data['YEAR_DATE'].sum()


def find_bucket_border(col_name, single_data):    #* 返回小于single_data的所有bucket
    for i in range(len(global_bucket_border[col_name])):
        if single_data < global_bucket_border[col_name][i]:
            step_width = global_bucket_border[col_name][i] - global_bucket_border[col_name][i - 1]
            res = (single_data - global_bucket_border[col_name][i - 1]) / step_width * global_bucket_border[col_name][i] + prefix_array[col_name][i - 1]
            # return prefix_array[col_name][i]  # todo 这里可以按比例选择优化
            return res

