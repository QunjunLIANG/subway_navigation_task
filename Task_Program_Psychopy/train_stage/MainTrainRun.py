#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from __future__ import absolute_import, division, print_function
from builtins import str
from builtins import range
from psychopy import visual, event, core, gui
import random


info = {'name': '', 'age': '', 'num': ''}
infoDlg = gui.DlgFromDict(dictionary=info, title=u'基本信息', order=['num', 'name', 'age'])
if infoDlg.OK == 0:
    core.quit()

dataFile = open("%s.csv" % (info['num']+'_'+info['name']+'_train1'), 'a')
dataFile.write(info['num']+','+info['name']+','+info['age']+'\n')
dataFile.write(u'训练次数, 小测次数, 界面, 当前站, 终点站, ACC\n')
win = visual.Window(fullscr=1, color=(-1, -1, -1))
globalClock = core.Clock()

# 欢迎页
text_11 = visual.TextStim(win, text=u'', height=0.1, pos=(0.0, 0.2), color='white', bold=True, italic=0)
text_12 = visual.TextStim(win, text=u'', height=0.1, pos=(0.0, -0.1), color='white', bold=True, italic=False)
text_11.text = u'同学您好，欢迎参加我们的实验！'
text_12.text = u'通过本程序，您将学习一个虚拟的地图'

text_13 = visual.TextStim(win, text=u'', height=0.05, pos=(0.0, -0.7), bold=True, italic=False, color='white')
text_13.text = u'请听主试叙述指导语，然后按任意键继续'

text_11.draw() 
text_12.draw()
text_13.draw()
win.flip() 
core.wait(0) 
k_continue = event.waitKeys()


# 站点和线路信息
s1 = (1, 3)
s2 = (2, 3)
s3 = (3, 3)
s4 = (3, 2)
s5 = (3, 1)
s6 = (3, 0)
s7 = (3, -1)
s8 = (3, -2)
s9 = (3, -3)
s10 = (3, -4)
s11 = (2, 2)
s12 = (1, 2)
s13 = (0, 2)
s14 = (-1, 2)
s15 = (-1, 1)
s16 = (-1, 0)
s17 = (-1, -1)
s18 = (-1, -2)
s19 = (-1, -3)
s20 = (-4, 0)
s21 = (-3, 0)
s22 = (-2, 0)
s23 = (0, 0)
s24 = (1, 0)
s25 = (1, -1)
s26 = (1, -2)
s27 = (1, -3)
s28 = (1, -4)
s29 = (-3, -2)
s30 = (-2, -2)
s31 = (0, -2)
s32 = (2, -2)
s33 = (4, -2)
s34 = (4, -3)
s35 = (4, -4)

line_1 = [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10]
line_2 = [s4, s11, s12, s13, s14, s15, s16, s17, s18, s19]
line_3 = [s20, s21, s22, s16, s23, s24, s25, s26, s27, s28]
line_4 = [s29, s30, s18, s31, s26, s32, s8, s33, s34, s35]

line_list = [line_1, line_2, line_3, line_4]

station_list = [s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14,
                s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s25, s26, s27,
                s28, s29, s30, s31, s32, s33, s34, s35]

station_list_str = [u'黄花园', u'后滩', u'新桥', u'平安里', u'翠屏山', u'石桥', u'博学路', u'临江', u'观音桥', u'北苑', u'古亭', u'紫荆山', u'中华门',
                    u'林场', u'鸡鸣寺', u'大钟寺', u'红星路', u'汉阳', u'旅顺', u'大柏树', u'沙湾', u'新塘', u'天府', u'牡丹园', u'明故宫',
                    u'中央大街', u'朝阳门', u'象山', u'迎宾路', u'香榭里', u'夫子庙', u'文化宫', u'人民路', u'人民公园', u'凤凰山']

pic_str = ['huanghuayuan.jpg', 'houtan.jpg', 'xinqiao.jpg', 'pinganli.jpg', 'cuipingshan.jpg', 'shiqiao.jpg',
           'boxuelu.jpg', 'linjiang.jpg', 'guanyinqiao.jpg', 'beiyuan.jpg', 'guting.jpg', 'zijingshan.jpg',
           'zhonghuamen.jpg', 'linchang.jpg', 'jimingsi.jpg', 'dazhongsi.jpg', 'hongxinglu.jpg', 'hanyang.jpg',
           'lvshun.jpg', 'dabaishu.jpg', 'shawan.jpg', 'xintang.jpg', 'tianfu.jpg', 'mudanyuan.jpg', 'minggugong.jpg',
           'zhongyangdajie.jpg', 'chaoyangmen.jpg', 'xiangshan.jpg', 'yingbinlu.jpg', 'xiangxieli.jpg', 'fuzimiao.jpg',
           'wenhuagong.jpg', 'renminlu.jpg', 'renmingongyuan.jpg', 'fenghuangshan.jpg']

ex_stations = [s4, s8, s16, s18, s26]

quizz_dictionary = {1: [s1, s5, '0'],
                    2: [s10, s31, '1'],
                    3: [s10, s34, '1'],
                    4: [s11, s1, '0'],
                    5: [s11, s16, '9'],
                    6: [s11, s15, '9'],
                    7: [s12, s2, '0'],
                    8: [s12, s23, '9'],
                    9: [s12, s16, '9'],
                    10: [s12, s22, '9'],
                    11: [s13, s17, '9'],
                    12: [s13, s2, '0'],
                    13: [s13, s23, '9'],
                    14: [s13, s24, '9'],
                    15: [s14, s20, '2'],
                    16: [s14, s21, '2'],
                    17: [s14, s3, '0'],
                    18: [s14, s30, '2'],
                    19: [s15, s25, '2'],
                    20: [s15, s29, '2'],
                    21: [s15, s30, '2'],
                    22: [s16, s12, '1'],
                    23: [s16, s29, '2'],
                    24: [s17, s20, '1'],
                    25: [s17, s27, '2'],
                    26: [s17, s8, '2'],
                    27: [s18, s21, '1'],
                    28: [s18, s7, '0'],
                    29: [s19, s23, '1'],
                    30: [s19, s24, '1'],
                    31: [s19, s24, '1'],
                    32: [s2, s13, '0'],
                    33: [s20, s15, '0'],
                    34: [s20, s18, '0'],
                    35: [s21, s13, '0'],
                    36: [s21, s14, '0'],
                    37: [s21, s25, '0'],
                    38: [s22, s26, '0'],
                    39: [s22, s30, '0'],
                    40: [s23, s27, '0'],
                    41: [s23, s8, '0'],
                    42: [s23, s29, '9'],
                    43: [s24, s14, '9'],
                    44: [s24, s33, '2'],
                    45: [s24, s20, '9'],
                    46: [s25, s15, '1'],
                    47: [s25, s19, '2'],
                    48: [s25, s6, '2'],
                    49: [s26, s10, '0'],
                    50: [s26, s35, '0'],
                    51: [s26, s29, '9'],
                    52: [s27, s23, '1'],
                    53: [s27, s29, '1'],
                    54: [s28, s18, '1'],
                    55: [s28, s9, '1'],
                    56: [s28, s17, '1'],
                    57: [s29, s25, '0'],
                    58: [s3, s14, '2'],
                    59: [s3, s8, '2'],
                    60: [s3, s7, '2'],
                    61: [s30, s21, '0'],
                    62: [s30, s22, '0'],
                    63: [s31, s10, '0'],
                    64: [s31, s7, '0'],
                    65: [s31, s22, '9'],
                    66: [s32, s16, '9'],
                    67: [s32, s5, '0'],
                    68: [s32, s19, '9'],
                    69: [s32, s30, '9'],
                    70: [s33, s24, '9'],
                    71: [s33, s27, '9'],
                    72: [s33, s4, '9'],
                    73: [s33, s25, '9'],
                    74: [s33, s31, '9'],
                    75: [s34, s26, '1'],
                    76: [s34, s31, '1'],
                    77: [s34, s10, '1'],
                    78: [s35, s6, '1'],
                    79: [s35, s9, '1'],
                    80: [s4, s33, '2'],
                    81: [s4, s15, '9'],
                    82: [s4, s9, '2'],
                    83: [s5, s13, '1'],
                    84: [s5, s26, '2'],
                    85: [s5, s32, '2'],
                    86: [s5, s10, '2'],
                    87: [s6, s1, '1'],
                    88: [s6, s27, '2'],
                    89: [s6, s34, '2'],
                    90: [s6, s35, '2'],
                    91: [s7, s11, '1'],
                    92: [s7, s25, '2'],
                    93: [s7, s28, '2'],
                    94: [s7, s18, '2'],
                    95: [s8, s17, '9'],
                    96: [s8, s24, '9'],
                    97: [s8, s18, '9'],
                    98: [s9, s18, '1'],
                    99: [s9, s35, '1'],
                    100: [s9, s4, '1']}


def make_journey(plan=0):
    step = random.randint(4, 5)
    choices = plan

    if plan == 0:
        choices = random.randint(1, 3)

    if choices == 1:
        line_cur = line_list[random.randint(0, 3)]
        ps = pe = 0
        while line_cur[ps][0] == line_cur[pe][0] or line_cur[ps][1] == line_cur[pe][1]:
            ps = random.randint(0, 9)
            if ps < step:
                pe = ps + step
            if step <= ps <= 9 - step:
                pat_rand = random.randint(0, 1)
                if pat_rand == 1:
                    pe = ps + step
                if pat_rand == 0:
                    pe = ps - step
            if ps > 9 - step:
                pe = ps - step
        else:
            we_get = [line_cur[ps], line_cur[pe], step]
            return we_get

    if choices == 2:
        station_start = s17
        station_end = s24
        while (station_start, station_end) == (s23, s26) or \
                        (station_start, station_end) == (s26, s23) or \
                        (station_start, station_end) == (s17, s24) or \
                        (station_start, station_end) == (s24, s17) or \
                        (station_start, station_end) == (s31, s16) or \
                        (station_start, station_end) == (s16, s31) or \
                        (station_start, station_end) == (s25, s18) or \
                        (station_start, station_end) == (s18, s25) or \
                        (station_start, station_end) == (s25, s16) or \
                        (station_start, station_end) == (s16, s25) or \
                        (station_start, station_end) == (s31, s24) or \
                        (station_start, station_end) == (s24, s31) or \
                        (station_start, station_end) == (s17, s26) or \
                        (station_start, station_end) == (s26, s17) or \
                        (station_start, station_end) == (s23, s18) or \
                        (station_start, station_end) == (s18, s23):
            pex = random.randint(0, 4)
            ex_station = ex_stations[pex]
            d1 = random.randint(1, step - 1)
            d2 = step - d1
            if ex_station in list(set(line_1) & set(line_2)):
                line_cur1 = line_1
                line_cur2 = line_2
            if ex_station in list(set(line_1) & set(line_4)):
                line_cur1 = line_1
                line_cur2 = line_4
            if ex_station in list(set(line_2) & set(line_3)):
                line_cur1 = line_2
                line_cur2 = line_3
            if ex_station in list(set(line_2) & set(line_4)):
                line_cur1 = line_2
                line_cur2 = line_4
            if ex_station in list(set(line_3) & set(line_4)):
                line_cur1 = line_3
                line_cur2 = line_4
            pex1 = line_cur1.index(ex_station)
            pex2 = line_cur2.index(ex_station)

            if pex1 < d1:
                p1 = pex1 + d1
            if d1 <= pex1 <= 9 - d1:
                pat_rand = random.randint(0, 1)
                if pat_rand == 1:
                    p1 = pex1 + d1
                if pat_rand == 0:
                    p1 = pex1 - d1
            if pex1 > 9 - d1:
                p1 = pex1 - d1
            station_start = line_cur1[p1]

            if pex2 < d2:
                p2 = pex2 + d2
            if d2 <= pex2 <= 9 - d2:
                pat_rand = random.randint(0, 1)
                if pat_rand == 1:
                    p2 = pex2 + d2
                if pat_rand == 0:
                    p2 = pex2 - d2
            if pex2 > 9 - d2:
                p2 = pex2 - d2
            station_end = line_cur2[p2]

            qq = random.randint(0, 1)
            if qq == 1:
                x1 = station_end
                x2 = station_start
                station_start = x1
                station_end = x2
        else:
            we_get = [station_start, ex_station, station_end, step]
        return we_get

    if choices == 3:
        station_start = s16
        station_end = s25
        while (station_start, station_end) == (s23, s26) or \
                        (station_start, station_end) == (s26, s23) or \
                        (station_start, station_end) == (s17, s24) or \
                        (station_start, station_end) == (s24, s17) or \
                        (station_start, station_end) == (s31, s16) or \
                        (station_start, station_end) == (s16, s31) or \
                        (station_start, station_end) == (s25, s18) or \
                        (station_start, station_end) == (s18, s25) or \
                        (station_start, station_end) == (s25, s16) or \
                        (station_start, station_end) == (s16, s25) or \
                        (station_start, station_end) == (s31, s24) or \
                        (station_start, station_end) == (s24, s31) or \
                        (station_start, station_end) == (s17, s26) or \
                        (station_start, station_end) == (s26, s17) or \
                        (station_start, station_end) == (s23, s18) or \
                        (station_start, station_end) == (s18, s23):
            ex_station_group = [(s16, s18), (s18, s26), (s26, s8)]
            a = random.randint(0, 2)
            ex_stations_cur = ex_station_group[a]
            ex_station1 = ex_stations_cur[0]
            ex_station2 = ex_stations_cur[1]
            if ex_stations_cur == (s16, s18):
                line_mid = line_2
            if ex_stations_cur == (s18, s26):
                line_mid = line_4
            if ex_stations_cur == (s26, s8):
                line_mid = line_4

            if ex_station1 in line_1 and line_mid != line_1:
                line_ex_1 = line_1
            if ex_station1 in line_2 and line_mid != line_2:
                line_ex_1 = line_2
            if ex_station1 in line_3 and line_mid != line_3:
                line_ex_1 = line_3
            if ex_station1 in line_4 and line_mid != line_4:
                line_ex_1 = line_4

            if ex_station2 in line_1 and line_mid != line_1:
                line_ex_2 = line_1
            if ex_station2 in line_2 and line_mid != line_2:
                line_ex_2 = line_2
            if ex_station2 in line_3 and line_mid != line_3:
                line_ex_2 = line_3
            if ex_station2 in line_4 and line_mid != line_4:
                line_ex_2 = line_4

            pex_mid_1 = line_mid.index(ex_station1)
            pex_mid_2 = line_mid.index(ex_station2)
            d_mid = abs(pex_mid_1 - pex_mid_2)

            d1 = random.randint(1, step - d_mid - 1)
            d2 = step - d_mid - d1

            pex1 = line_ex_1.index(ex_station1)
            pex2 = line_ex_2.index(ex_station2)

            if pex1 < d1:
                p1 = pex1 + d1
            if d1 <= pex1 <= 9 - d1:
                pat_rand = random.randint(0, 1)
                if pat_rand == 1:
                    p1 = pex1 + d1
                if pat_rand == 0:
                    p1 = pex1 - d1
            if pex1 > 9 - d1:
                p1 = pex1 - d1
            station_start = line_ex_1[p1]

            if pex2 < d2:
                p2 = pex2 + d2
            if d2 <= pex2 <= 9 - d2:
                pat_rand = random.randint(0, 1)
                if pat_rand == 1:
                    p2 = pex2 + d2
                if pat_rand == 0:
                    p2 = pex2 - d2
            if pex2 > 9 - d2:
                p2 = pex1 - d2
            station_end = line_ex_2[p2]

            qq = random.randint(0, 1)
            if qq == 1:
                x1 = station_end
                x2 = station_start
                x3 = ex_station1
                x4 = ex_station2
                station_start = x1
                station_end = x2
                ex_station1 = x4
                ex_station2 = x3
        else:
            we_get = [station_start, ex_station1, ex_station2, station_end, step]
        return we_get


# 定义一个判断站点在哪一条线上的函数，输出的是以数字为元素的列表
def which_line(sta1):
    line_of_sta1 = []
    if sta1 in line_1:
        line_of_sta1.append(0)
    if sta1 in line_2:
        line_of_sta1.append(1)
    if sta1 in line_3:
        line_of_sta1.append(2)
    if sta1 in line_4:
        line_of_sta1.append(3)
    return line_of_sta1


# 定义一个判断2个站点是否在同一条线上的函数，输出的是数字0和1.该函数的调用是在上面的函数的基础上
def if_same_line(sta1, sta2):
    if set(which_line(sta1)) & set(which_line(sta2)) != set([]):
        return 1
    else:
        return 0


# 定义一个线路颜色的函数，输出的是颜色的字符串
def line_color(sta1):
    if sta1 in ex_stations:
        color_of_line = 'white'
    else:
        if which_line(sta1) == [0]:
            color_of_line = 'orange'
        if which_line(sta1) == [1]:
            color_of_line = (0, 0.74, 1)
        if which_line(sta1) == [2]:
            color_of_line = 'green'
        if which_line(sta1) == [3]:
            color_of_line = 'red'
    return color_of_line


# 相邻2站小路的颜色，输出的是颜色的字符串
def line_color_2(sta1, sta2):
    line_both = list(set(which_line(sta1)) & set(which_line(sta2)))
    if line_both == [0]:
        color_of_line = 'orange'
    if line_both == [1]:
        color_of_line = (0, 0.74, 1)
    if line_both == [2]:
        color_of_line = 'green'
    if line_both == [3]:
        color_of_line = 'red'
    return color_of_line


def quizz_journey():    # 在测试过程中，需要对所有list取到元素才能进行下一步，为什么这里不会报错
    a = random.choice(number_list)
    number_list.remove(a) 
    return quizz_dictionary[a]


def mappage():
    pic_map = visual.ImageStim(win, image='map.png', pos=(0, 0), size=1.75)
    pic_map.draw()
    win.flip()
    core.wait(10)        # 地图呈现的时间


def CUEpage():
    journey_cur = make_journey()
    global station_1
    global station_0
    global station_2
    global step
    
    station_1 = journey_cur[0]
    station_0 = station_1
    station_2 = journey_cur[-2]
    step = journey_cur[-1]

    text_cue1 = visual.TextStim(win, text=u'', height=0.2, pos=(-0.4, 0.378),
                                color='white', bold=1, italic=0)
    text_cue1.text = u'起点'

    text_cue2 = visual.TextStim(win, text=u'', height=0.2, pos=(0.4, 0.378),
                                color='white', bold=1, italic=0)
    text_cue2.text = u'终点'

    text_cue3 = visual.TextStim(win, text=u'', height=0.2, pos=(-0.4, -0.1),
                                bold=True, italic=0)
    text_cue3.text = station_list_str[station_list.index(station_1)]
    text_cue3.color = line_color(station_1)

    text_cue4 = visual.TextStim(win, text=u'', height=0.2, pos=(0.4, -0.1),
                                bold=True, italic=0)
    text_cue4.text = station_list_str[station_list.index(station_2)]
    text_cue4.color = line_color(station_2)

    text_cue5 = visual.TextStim(win, text=u'', height=0.05, pos=(0.0, -0.7),
                                bold=True, italic=False, color='white')
    text_cue5.text = u'请按任意键开始'

    text_cue1.draw()
    text_cue2.draw() 
    text_cue3.draw()
    text_cue4.draw()
    text_cue5.draw()
    win.flip()
    core.wait(0)
    k_continue = event.waitKeys()


pic_c1 = visual.ImageStim(win, image='1.png', pos=(0, 0))
pic_c2 = visual.ImageStim(win, image='3.png', pos=(0, 0))
pic_c3 = visual.ImageStim(win, image='2.png', pos=(0, 0))
pic_c4 = visual.ImageStim(win, image='4.png', pos=(0, 0))


def c1_page():    # 就不能用一个for语句把所有的时钟放在一起吗……
    pic_station_cur = visual.ImageStim(win, image=pic_str[station_list.index(trail_truth[ppp - 1])], size=2, pos=(0, 0))
    pic_station_cur.draw()
    text_train1 = visual.TextStim(win, text=u'', height=0.3, pos=(0, 0.7), bold=True, italic=0)
    text_train1.text = station_list_str[station_list.index(trail_truth[ppp - 1])]
    text_train1.color = line_color(trail_truth[ppp - 1])
    text_train2 = visual.TextStim(win, text=u'', height=0.3, pos=(0, -0.7), bold=True, italic=0)
    text_train2.text = station_list_str[station_list.index(station_2)]
    text_train2.color = line_color(station_2)
    pic_c1.draw()
    text_train1.draw()
    text_train2.draw()
    win.flip()
    core.wait(0.2)


def c2_page():
    pic_station_cur = visual.ImageStim(win, image=pic_str[station_list.index(trail_truth[ppp - 1])], size=2, pos=(0, 0))
    pic_station_cur.draw()
    text_train1 = visual.TextStim(win, text=u'', height=0.3, pos=(0, 0.7), bold=True, italic=0)
    text_train1.text = station_list_str[station_list.index(trail_truth[ppp - 1])]
    text_train1.color = line_color(trail_truth[ppp - 1])
    text_train2 = visual.TextStim(win, text=u'', height=0.3, pos=(0, -0.7), bold=True, italic=0)
    text_train2.text = station_list_str[station_list.index(station_2)]
    text_train2.color = line_color(station_2)
    pic_c2.draw()
    text_train1.draw()
    text_train2.draw()
    win.flip()
    core.wait(0.2)


def c3_page():
    pic_station_cur = visual.ImageStim(win, image=pic_str[station_list.index(trail_truth[ppp - 1])], size=2, pos=(0, 0))
    pic_station_cur.draw()
    text_train1 = visual.TextStim(win, text=u'', height=0.3, pos=(0, 0.7), bold=True, italic=0)
    text_train1.text = station_list_str[station_list.index(trail_truth[ppp - 1])]
    text_train1.color = line_color(trail_truth[ppp - 1])
    text_train2 = visual.TextStim(win, text=u'', height=0.3, pos=(0, -0.7), bold=True, italic=0)
    text_train2.text = station_list_str[station_list.index(station_2)]
    text_train2.color = line_color(station_2)
    pic_c3.draw()
    text_train1.draw()
    text_train2.draw()
    win.flip()
    core.wait(0.2)


def c4_page():
    pic_station_cur = visual.ImageStim(win, image=pic_str[station_list.index(trail_truth[ppp - 1])], size=2, pos=(0, 0))
    pic_station_cur.draw()
    text_train1 = visual.TextStim(win, text=u'', height=0.3, pos=(0, 0.7), bold=True, italic=0)
    text_train1.text = station_list_str[station_list.index(trail_truth[ppp - 1])]
    text_train1.color = line_color(trail_truth[ppp - 1])
    text_train2 = visual.TextStim(win, text=u'', height=0.3, pos=(0, -0.7), bold=True, italic=0)
    text_train2.text = station_list_str[station_list.index(station_2)]
    text_train2.color = line_color(station_2)
    pic_c4.draw()
    text_train1.draw()
    text_train2.draw()
    win.flip()
    core.wait(0.2)


def c_page():
    c1_page()
    c2_page()
    c3_page()
    c4_page()
    c1_page()


def train_judegpage():
    global station_1
    global station_2
    global up_station
    global down_station
    global lift_station
    global right_station
    global k_list
# 当前站点的图片作为背景呈现
    pic_station_cur = visual.ImageStim(win, image=pic_str[station_list.index(station_1)], size=2, pos=(0, 0))
    pic_station_cur.draw()
# 利用坐标，制作可通行标志三角形的大小和形状
    triang_1_vert = [[0, 0.15], [-0.15, -0.15], [0.15, -0.15]]
    triang_4_vert = [[-0.15, 0.15], [0.15, 0], [-0.15, -0.15]]
    triang_2_vert = [[-0.15, 0.15], [0.15, 0.15], [0, -0.15]]
    triang_3_vert = [[-0.15, 0], [0.15, 0.15], [0.15, -0.15]]
# 将上面制作好的三角形呈现，不描边，填充为空，定位
    triang_1 = visual.ShapeStim(win, lineColor=None,
                                vertices=triang_1_vert,
                                pos=(0, 0.3))

    triang_2 = visual.ShapeStim(win, lineColor=None,
                                vertices=triang_2_vert,
                                pos=(0, -0.3))

    triang_3 = visual.ShapeStim(win, lineColor=None,
                                vertices=triang_3_vert,
                                pos=(-0.3, 0))

    triang_4 = visual.ShapeStim(win, lineColor=None,
                                vertices=triang_4_vert,
                                pos=(0.3, 0))
# 表示不能通行的标志圆形，不再需要坐标来确定形状
    cri_1 = visual.Circle(win, radius=0.15, edges=32,
                          lineColor=None,
                          fillColor='white',
                          opacity=0.3,
                          pos=(0, 0.3))

    cri_2 = visual.Circle(win, radius=0.15, edges=32,
                          lineColor=None,
                          fillColor='white',
                          opacity=0.3,
                          pos=(0, -0.3))

    cri_3 = visual.Circle(win, radius=0.15, edges=32,
                          lineColor=None,
                          fillColor='white',
                          opacity=0.3,
                          pos=(-0.3, 0))

    cri_4 = visual.Circle(win, radius=0.15, edges=32,
                          lineColor=None,
                          fillColor='white',
                          opacity=0.3,
                          pos=(0.3, 0))

    text_train1 = visual.TextStim(win, text=u'', height=0.3, pos=(0, 0.7), bold=True, italic=0)
    text_train1.text = station_list_str[station_list.index(station_1)]
    text_train1.color = line_color(station_1)
    
    text_train2 = visual.TextStim(win, text=u'', height=0.3, pos=(0, -0.7), bold=True, italic=0)
    text_train2.text = station_list_str[station_list.index(station_2)]
    text_train2.color = line_color(station_2)
# 定义上下左右按键的数学关系
    up_station = (station_1[0], station_1[1] + 1)
    down_station = (station_1[0], station_1[1] - 1)
    lift_station = (station_1[0] - 1, station_1[1])
    right_station = (station_1[0] + 1, station_1[1])
# 生成指示方向的标志，同时限定被试能够进行判断的按键
    k_list = []
    if up_station in station_list and if_same_line(up_station, station_1) == 1:
        triang_1.fillColor = line_color_2(up_station, station_1)
        triang_1.draw()
        k_list.append('1')
    else:
        cri_1.draw()

    if down_station in station_list and if_same_line(down_station, station_1) == 1:
        triang_2.fillColor = line_color_2(down_station, station_1)
        triang_2.draw()
        k_list.append('2')
    else:
        cri_2.draw()

    if lift_station in station_list and if_same_line(lift_station, station_1) == 1:
        triang_3.fillColor = line_color_2(lift_station, station_1)
        triang_3.draw()
        k_list.append('9')
    else:
        cri_3.draw()

    if right_station in station_list and if_same_line(right_station, station_1) == 1:
        triang_4.fillColor = line_color_2(right_station, station_1)
        triang_4.draw()
        k_list.append('0')
    else:
        cri_4.draw()

    text_train1.draw()
    text_train2.draw()
    win.flip()


def successpage():
    text_success1 = visual.TextStim(win, text=u'', height=0.3, pos=(0, -0.3), color='white', bold=True, italic=0)
    text_success1.text = u'到达终点'
    text_success2 = visual.TextStim(win, text=u'', height=0.1, pos=(-0.5, 0.3), color='white', bold=True, italic=0)
    text_success2.text = u'最短到达的步数：' + str(step)
    text_success3 = visual.TextStim(win, text=u'', height=0.1, pos=(0.5, 0.3), color='white', bold=True, italic=0)
    text_success3.text = u'按键次数：' + str(trial_time)
    text_success1.draw()
    text_success2.draw()
    text_success3.draw()
    win.flip() 
    core.wait(3)


def beforequizzpage():
    text_before1 = visual.TextStim(win, text=u'', height=0.1, pos=(0.0, 0.2), color='white', bold=True, italic=0)
    text_before2 = visual.TextStim(win, text=u'', height=0.1, pos=(0.0, -0.1), color='white', bold=True, italic=False)
    text_before1.text = u'同学辛苦了！'
    text_before2.text = u'现在需要您进行测试'

    text_before3 = visual.TextStim(win, text=u'', height=0.05, pos=(0.0, -0.7), bold=True, italic=False, color='white')
    text_before3.text = u'请按任意键继续'

    text_before1.draw() 
    text_before2.draw()
    text_before3.draw()
    win.flip() 
    core.wait(0) 
    k_continue = event.waitKeys()


def quizzpage():
    journey_cur = quizz_journey()
    
    global station_1
    global station_2
    global choice
    
    station_1 = journey_cur[0]
    station_2 = journey_cur[1]
    choice = journey_cur[2]
    
    text_question = visual.TextStim(win, text=u'', height=0.2, pos=(0, 0.7), color='white', bold=1, italic=0)
    text_question.text = u'请选择第一步的方向'
    
    text_quizz1 = visual.TextStim(win, text=u'', height=0.2, pos=(-0.4, 0.378), color='white', bold=1, italic=0)
    text_quizz1.text = u'起点'

    text_quizz2 = visual.TextStim(win, text=u'', height=0.2, pos=(0.4, 0.378), color='white', bold=1, italic=0)
    text_quizz2.text = u'终点'

    text_quizz3 = visual.TextStim(win, text=u'', height=0.2, pos=(-0.4, -0.1), bold=True, italic=0)
    text_quizz3.text = station_list_str[station_list.index(station_1)]
    text_quizz3.color = line_color(station_1)

    text_quizz4 = visual.TextStim(win, text=u'', height=0.2, pos=(0.4, -0.1), bold=True, italic=0)
    text_quizz4.text = station_list_str[station_list.index(station_2)]
    text_quizz4.color = line_color(station_2)
    
# 利用坐标，制作可通行标志三角形的大小和形状
    triang_1_vert = [[0, 0.05], [-0.05, -0.05], [0.05, -0.05]]
    triang_4_vert = [[-0.05, 0.05], [0.05, 0], [-0.05, -0.05]]
    triang_2_vert = [[-0.05, 0.05], [0.05, 0.05], [0, -0.05]]
    triang_3_vert = [[-0.05, 0], [0.05, 0.05], [0.05, -0.05]]
# 将上面制作好的三角形呈现，不描边，填充白色，透明度0.3，定位
    triang_1 = visual.ShapeStim(win, lineColor=None,
                                fillColor='white',
                                opacity=0.3,
                                vertices=triang_1_vert,
                                pos=(0, -0.35))

    triang_2 = visual.ShapeStim(win, lineColor=None,
                                fillColor='white',
                                opacity=0.3,
                                vertices=triang_2_vert,
                                pos=(0, -0.65))

    triang_3 = visual.ShapeStim(win, lineColor=None,
                                fillColor='white',
                                opacity=0.3,
                                vertices=triang_3_vert,
                                pos=(-0.15, -0.5))

    triang_4 = visual.ShapeStim(win, lineColor=None,
                                fillColor='white',
                                opacity=0.3,
                                vertices=triang_4_vert,
                                pos=(0.15, -0.5))
    triang_1.draw()
    triang_2.draw()
    triang_3.draw()
    triang_4.draw()
    
    text_question.draw()
    text_quizz1.draw()
    text_quizz2.draw() 
    text_quizz3.draw()
    text_quizz4.draw()
    win.flip()
    core.wait(0)


def feedback_rightpage():
    text_feedback_1 = visual.TextStim(win, text=u'', height=0.2, pos=(0, 0.3), color='white', bold=1, italic=0)
    text_feedback_1.text = u'回答正确'
    text_feedback_2 = visual.TextStim(win, text=u'', height=0.2, pos=(0, -0.3), color='white', bold=1, italic=0)
    text_feedback_2.text = u'加1分'
    text_feedback_1.draw()
    text_feedback_2.draw()
    win.flip()
    core.wait(2)


def feedback_wrongpage():
    text_feedback_1 = visual.TextStim(win, text=u'', height=0.2, pos=(0, 0), color='white', bold=1, italic=0)
    text_feedback_1.text = u'回答错误'
    text_feedback_1.draw()
    win.flip()
    core.wait(2)


def scorepage():
    score_list.append(score)
    text_score = visual.TextStim(win, text=u'', height=0.2, pos=(0, 0), color='white', bold=1, italic=0)
    text_score.text = u'第' + str(train_time) + u'次小测得分：' + str(score)
    text_score.draw()
    # dataFile.write(str(train_time) + ', ' + str(score) + '\n')
    text_score_1 = visual.TextStim(win, text=u'', height=0.05, pos=(0.0, -0.7), bold=True, italic=False, color='white')
    text_score_1.text = u'请按任意键继续'
    text_score_1.draw()
    win.flip() 
    core.wait(0)
    k_continue = event.waitKeys()


def restpage():
    text_rest1 = visual.TextStim(win, text=u'', height=0.2, pos=(0, 0.5), color='white', bold=True, italic=0)
    text_rest1.text = u'请您休息片刻'

    text_rest2 = visual.TextStim(win, text=u'', height=0.1, pos=(0, -0.3), color='white', bold=True, italic=0)
    text_rest2.text = u'如果您休息完毕，请按任意键继续'

    text_rest1.draw()
    text_rest2.draw()
    win.flip()
    core.wait(0) 
    k_rest1 = event.waitKeys()


def thankspage():
    text_thanks1 = visual.TextStim(win, text=u'', height=0.2, pos=(0, -0.3), color='white', bold=True, italic=0)
    text_thanks1.text = u'实验结束'

    text_thanks2 = visual.TextStim(win, text=u'', height=0.2, pos=(0, 0.3), color='white', bold=True, italic=0)
    text_thanks2.text = u'感谢您参加我们的实验'

    text_thanks1.draw()
    text_thanks2.draw()
    win.flip() 
    core.wait(3)


def blackpage(time1, time2):
    black_time = random.uniform(time1, time2)
    win.flip()
    core.wait(black_time)


def quizzse():
    global test_time
    global score
    global quizz_correct
    score = 0
    for test_time in list(range(1, 11)):   # 每次小测中的题目数量
        quizzpage()
        k_quizz = event.waitKeys(keyList=['1', '2', '9', '0'])
        if k_quizz[0] == choice:
            quizz_correct = '1'
            score += 1
            feedback_rightpage()
        else:
            quizz_correct = '0'
            feedback_wrongpage()
        dataFile.write(str(train_time) + ', ' + str(test_time) + ', 小测, ' + str(station_list_str[station_list.index(station_1)])
                       + ', ' + str(station_list_str[station_list.index(station_2)]) + ',' + str(quizz_correct) + '\n')
    scorepage()
    
    
def train():
    global station_1
    global station_2
    global trial_time
    global trail_truth
    global ppp

    timer_train = core.Clock()
    timer_train.reset()
    timeUse_train = 0

# 每个train所用的时间
    while timeUse_train < 200:
        trial_time = 0
        mappage()
        CUEpage()
        blackpage(2, 5)
        trail_truth = [station_1]
        while station_1 != station_2:
            trial_time += 1
            train_judegpage()
            k_train = event.waitKeys(keyList=k_list)
            if k_train[0] == '1':
                station_1 = up_station
            if k_train[0] == '0':
                station_1 = right_station
            if k_train[0] == '2':
                station_1 = down_station
            if k_train[0] == '9':
                station_1 = lift_station
            trail_truth.append(station_1)
            if len(trail_truth) > 2:
                ppp = max([i for i, v in enumerate(trail_truth) if v == station_1])
                if trail_truth[ppp - 1] in ex_stations:
                    if if_same_line(trail_truth[ppp - 2], station_1) == 0:
                        c_page()
                        k_space = event.waitKeys(keyList='space')
            blackpage(1, 3)
        else:
            successpage()
        timeUse_train = timer_train.getTime()


number_list = list(range(1, 101))
score_list = []
for train_time in list(range(1, 11)):   # 训练次数
    train()
    beforequizzpage()
    quizzse()
    dataFile.write(str(train_time) + ', ' + str(test_time) + ', 总分, ' + str(score) + '\n')
    if train_time == 10:
        break
    restpage()

# 感谢
thankspage()
# 结束
win.close()
core.quit()
