#!/usr/bin/env python2
# -*- coding: utf-8 -*-

from __future__ import absolute_import, division, print_function
from builtins import str
from psychopy import visual, event, core, gui
import random
import time

import make_journey
import judge_function
import parameter_function
import optimal_math


# 被试信息输入
info = {'name': '', 'num': '', 'RUN': ''}
infoDlg = gui.DlgFromDict(dictionary=info, title=u'基本信息', order=['num', 'name', 'RUN'])
if infoDlg.OK == 0:
    core.quit()

# 生成行为文件（我将界面，标准时间，界面开始, 界面结束，持续时间，五个变量加入到数据表格记录中）
# 其中标准时间和界面开始时间都是根据trigger开始的一刻进行计算的
dataFile = open("%s.csv" % (info['num']+'_'+info['name']+'_'+info['RUN']+'_before_scan'), 'a')
dataFile.write(info['num']+','+info['name']+','+info['RUN']+'\n')
dataFile.write(u'导航编号, 界面, 标准时间, 界面开始, 界面结束, 持续时间, 起点, 终点, 最佳步数, '
               u'按键次数, 反应时, 选择方向, 到达站点\n')


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

ex_stations = [s4, s8, s16, s18, s26]

cross_stations = [s4, s8, s16, s18, s26, s3, s14, s24, s33]

# 检查是否全屏
win = visual.Window(fullscr=1, color=(-1, -1, -1))

# 训练2的指导界面
text_01 = visual.TextStim(win, text=u'', height=0.10, pos=(0.0, 0.2), color='white', bold=True, italic=0)
text_02 = visual.TextStim(win, text=u'', height=0.10, pos=(0.0, 0.0), color='white', bold=True, italic=0)
text_03 = visual.TextStim(win, text=u'', height=0.05, pos=(0.0, -0.7), color='white', bold=True, italic=0)
text_01.text = u'该程序的目的是帮助您熟悉扫描时的任务流程和相应操作'
text_02.text = u'此外，您将在扫描前重新复习一次地图，时间为2分钟'
text_03.text = u'按下任意键进入复习，复习结束后自动进入模拟的测试程序'
text_01.draw()
text_02.draw()
text_03.draw()
win.flip()
core.wait(0)
K_training2 = event.waitKeys()

# 额外2分钟的地图重新识记时间
text_04 = visual.TextStim(win, text=u'', height=0.07, pos=(0.0, 0.3), color='white', bold=True, italic=0)
text_04.text = u'您将有2分钟的时间对地图进行复习'
map_pic = visual.ImageStim(win, image='map.png', pos=(0.0, 0), size=1.75)
text_04.draw()
map_pic.draw()
win.flip()
# 检查地图呈现的时间
core.wait(120)

# 欢迎页
text_11 = visual.TextStim(win, text=u'', height=0.1, pos=(0.0, 0.9), color='white', bold=True, italic=0)
text_12 = visual.TextStim(win, text=u'', height=0.1, pos=(0.0, 0.8), color='white', bold=True, italic=False)
text_11.text = u'同学您好！'
text_12.text = u'欢迎您来参加我们的实验'

text_13 = visual.TextStim(win, text=u'', height=0.1, pos=(0.0, 0.4), bold=True, italic=False, color='white')
text_14 = visual.TextStim(win, text=u'', height=0.1, pos=(0.0, 0.2), bold=True, italic=False, color='white')
text_15 = visual.TextStim(win, text=u'', height=0.1, pos=(0.0, 0.0), bold=True, italic=False, color='white')
text_16 = visual.TextStim(win, text=u'', height=0.1, pos=(0.0, -0.2), bold=True, italic=False, color='white')
text_17 = visual.TextStim(win, text=u'', height=0.1, pos=(0.0, -0.4), bold=True, italic=False, color='white')
text_18 = visual.TextStim(win, text=u'', height=0.1, pos=(0.0, -0.6), bold=True, italic=False, color='white')
text_13.text = u'您需要根据线索，'
text_14.text = u'通过左边按键（上下）右边按键（左右）完成正确的路线导航。'
text_15.text = u'如果您以最短的路线完成了导航，还会获得相应的积分，'
text_16.text = u'积分可以兑换真实的金钱奖赏。'
text_17.text = u'您将扮演一位公司职员，现在您有一个会议要开，'
text_18.text = u'为了赶时间，你需要乘坐地铁'

text_11.draw()
text_12.draw()
text_13.draw()
text_14.draw()
text_15.draw()
text_16.draw()
text_17.draw()
text_18.draw()
win.flip()
core.wait(0)
k_syn = event.waitKeys()
globaltime = core.MonotonicClock()     # 记录从该语句开始的，绝对不会被重设的时间，用于计算每个界面的开始时间


# 赏金信息
def info_reward():
    global reward
    text_success_reward = visual.TextStim(win, text=u'', height=0.1, pos=(0.7, 0.9), color='white', bold=True, italic=0)
    text_success_reward.text = u'当前赏金：' + str(reward)
    text_success_reward.draw()


# 呈现线索界面
def CUEpage():
    global station_1
    global station_0
    global station_2
    global step
    global date
    global screen_begin
    global screen_end
    global lasting
    global choices
    global ex_station
    screen_begin = globaltime.getTime()    # 记录该界面开始的程序时间
    date = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))    # 记录该界面开始的标准时间
    journey_cur = make_journey.make_journey()

    station_1 = journey_cur[0]
    station_0 = station_1
    station_2 = journey_cur[-3]
    step = journey_cur[-2]
    choices = journey_cur[-1]
    ex_station = journey_cur[1]

    text_cue1 = visual.TextStim(win, text=u'', height=0.2, pos=(-0.4, 0.378), color='white', bold=1, italic=0)
    text_cue1.text = u'起点'

    text_cue2 = visual.TextStim(win, text=u'', height=0.2, pos=(0.4, 0.378), color='white', bold=1, italic=0)
    text_cue2.text = u'终点'

    text_cue3 = visual.TextStim(win, text=u'', height=0.2, pos=(-0.4, -0.1), bold=True, italic=0)
    text_cue3.text = station_list_str[station_list.index(station_1)]
    text_cue3.color = judge_function.line_color(station_1)

    text_cue4 = visual.TextStim(win, text=u'', height=0.2, pos=(0.4, -0.1), bold=True, italic=0)
    text_cue4.text = station_list_str[station_list.index(station_2)]
    text_cue4.color = judge_function.line_color(station_2)

    text_cue1.draw()
    text_cue2.draw() 
    text_cue3.draw()
    text_cue4.draw()
    info_reward()
    win.flip()
    core.wait(3)
    screen_end = globaltime.getTime()     # 记录该界面结束的时间
    lasting = screen_end - screen_begin       # 记录该界面的持续时间


# 呈现导航界面（这里比较特殊，尽管界面的开始可以记录，其结束并不是可以在这个模块写入的……那还不如直接在主程序模块里写）
def judge_page():
    global up_station
    global down_station
    global left_station
    global right_station
    global k_list
# 利用坐标，制作可通行标志三角形的大小和形状
    triang_1_vert = [[0, 0.10], [-0.10, -0.10], [0.10, -0.10]]
    triang_4_vert = [[-0.10, 0.10], [0.10, 0], [-0.10, -0.10]]
    triang_2_vert = [[-0.10, 0.10], [0.10, 0.10], [0, -0.10]]
    triang_3_vert = [[-0.10, 0], [0.10, 0.10], [0.10, -0.10]]
# 将上面制作好的三角形呈现，不描边，填充白色，透明度0.3，定位
    triang_1 = visual.ShapeStim(win, lineColor=None, fillColor='white', vertices=triang_1_vert, pos=(0, 0.1))
    triang_2 = visual.ShapeStim(win, lineColor=None, fillColor='white', vertices=triang_2_vert, pos=(0, -0.3))
    triang_3 = visual.ShapeStim(win, lineColor=None, fillColor='white', vertices=triang_3_vert, pos=(-0.2, -0.1))
    triang_4 = visual.ShapeStim(win, lineColor=None, fillColor='white', vertices=triang_4_vert, pos=(0.2, -0.1))
# 表示不能通行的标志圆形，不再需要坐标来确定形状
    cri_1 = visual.Circle(win, radius=0.1, edges=32, lineColor=None, fillColor='white', opacity=0.3, pos=(0, 0.1))
    cri_2 = visual.Circle(win, radius=0.1, edges=32, lineColor=None, fillColor='white', opacity=0.3, pos=(0, -0.3))
    cri_3 = visual.Circle(win, radius=0.1, edges=32, lineColor=None, fillColor='white', opacity=0.3, pos=(-0.2, -0.1))
    cri_4 = visual.Circle(win, radius=0.1, edges=32, lineColor=None, fillColor='white', opacity=0.3, pos=(0.2, -0.1))
# 生成起点和终点站的中文名称（需要加上“当前站台”和“终点”字样吗？）
    text_53 = visual.TextStim(win, text=u'', height=0.2, pos=(0, 0.4), color='white', bold=True, italic=0)
    text_53.text = station_list_str[station_list.index(station_1)]
    text_54 = visual.TextStim(win, text=u'', height=0.2, pos=(0, -0.6), bold=True, italic=0)
    text_54.text = station_list_str[station_list.index(station_2)]
    text_54.color = judge_function.line_color(station_2)
    text_53.draw()
    text_54.draw()
# 定义上下左右按键的数学关系
    up_station = (station_1[0], station_1[1] + 1)
    down_station = (station_1[0], station_1[1] - 1)
    left_station = (station_1[0] - 1, station_1[1])
    right_station = (station_1[0] + 1, station_1[1])
# 生成指示方向的标志，同时限定被试能够进行判断的按键
    k_list = []
    if up_station in station_list and judge_function.if_same_line(up_station, station_1) == 1:
        triang_1.draw()
        k_list.append('1')
    else:
        cri_1.draw()

    if down_station in station_list and judge_function.if_same_line(down_station, station_1) == 1:
        triang_2.draw()
        k_list.append('2')
    else:
        cri_2.draw()

    if left_station in station_list and judge_function.if_same_line(left_station, station_1) == 1:
        triang_3.draw()
        k_list.append('9')
    else:
        cri_3.draw()

    if right_station in station_list and judge_function.if_same_line(right_station, station_1) == 1:
        triang_4.draw()
        k_list.append('0')
    else:
        cri_4.draw()
# 呈现当前的赏金信息和积累的奖赏总数
    info_reward()
    text_55 = visual.TextStim(win, text=u'', height=0.15, pos=(0, 0.7), color='white', bold=True, italic=0)
    text_55.text = '最短路线赏金:50'
    text_55.draw()

    win.flip()


# 导航取消界面
def cancel_page():
    global date
    global screen_begin
    global screen_end
    global lasting
    screen_begin = globaltime.getTime()
    date = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
    
    text_cancel1 = visual.TextStim(win, text=u'', height=0.2, pos=(0, 0.2), bold=True, italic=0)
    text_cancel2 = visual.TextStim(win, text=u'', height=0.2, pos=(0, -0.2), bold=True, italic=0)
    text_cancel1.text = u'抱歉!'
    text_cancel2.text = u'本次旅行取消'
        
    text_cancel1.draw()
    text_cancel2.draw()
    win.flip() 
    core.wait(2)
    screen_end = globaltime.getTime()
    lasting = screen_end - screen_begin


# 导航完成界面
def success_page():
    global date
    global screen_begin
    global screen_end
    global lasting
    global reward
    screen_begin = globaltime.getTime()
    date = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
    
    text_success0 = visual.TextStim(win, text=u'', height=0.2, pos=(0, 0.5), color='white', bold=True, italic=0)
    text_success0.text = u'额外赏金:0'
    text_success1 = visual.TextStim(win, text=u'', height=0.3, pos=(0, -0.2), color='white', bold=True, italic=0)
    text_success1.text = u'到达终点'
    text_success1.draw()
    text_success2 = visual.TextStim(win, text=u'', height=0.2, pos=(0, 0.5), color='white', bold=True, italic=0)
    text_success2.text = u'额外赏金:50'
    text_success3 = visual.TextStim(win, text=u'', height=0.2, pos=(0, 0.5), color='white', bold=True, italic=0)
    text_success3.text = u'额外赏金:10'
    pic_reward_5 = visual.ImageStim(win, image='reward_5.jpg', pos=(0, 0.3))
    pic_reward_1 = visual.ImageStim(win, image='reward_1.jpg', pos=(0, 0.3))
# 到达终点计算是否得到赏金
    if trial_time == step:
        reward += 50
        text_success2.draw()
        pic_reward_5.draw()
    else:
        if step == step_truth:
            reward += 10
            text_success3.draw()
            pic_reward_1.draw()
        else:
            text_success0.draw()
    info_reward()
    win.flip() 
    core.wait(3)
    screen_end = globaltime.getTime()
    lasting = screen_end - screen_begin


# run之后的休息界面
def rest_page():
    global date
    global screen_begin
    global screen_end
    global lasting
    screen_begin = globaltime.getTime()
    date = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
    
    text_rest1 = visual.TextStim(win, text=u'', height=0.2, pos=(0, 0), color='white', bold=True, italic=0)
    text_rest1.text = u'请您休息片刻'

    text_rest1.draw()
    win.flip()
    core.wait(2)
    screen_end = globaltime.getTime()
    lasting = screen_end - screen_begin


# 设定trial间间隔
def black_page(time1, time2):
    global date
    global screen_begin
    global screen_end
    global lasting
    screen_begin = globaltime.getTime()
    date = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
    black_time = random.uniform(time1, time2)
    info_reward()
    win.flip()
    core.wait(black_time)
    screen_end = globaltime.getTime()
    lasting = screen_end - screen_begin


# 初始化赏金为0
reward = 0

timer_run = core.Clock()
timer_run.reset()
timeUse_run = 0

journey_time = 0
while timeUse_run < 300:       # run的时间
    CUEpage()
    dataFile.write(str(journey_time) + ', ' + u'cue' + ', ' + str(date) + ', ' + str(screen_begin) + ', '
                   + str(screen_end) + ', ' + str(lasting) + '\n')
# CUE之后的黑屏2~5秒
    black_page(2, 5)
    dataFile.write(str(journey_time) + ', ' + u'interval' + ', ' + str(date) + ', ' + str(screen_begin) + ', '
                   + str(screen_end) + ', ' + str(lasting) + '\n')
        
    journey_cancel = 1   # 原本是个随机算法
# 任务取消
    if journey_cancel == 0:
        journey_time += 1
        cancel_page()
        dataFile.write(str(journey_time) + ', ' + u'cancel' + ', ' + str(date) + ', ' + str(screen_begin) + ', '
                       + str(screen_end) + ', ' + str(lasting) + '\n')
# trial
    else:
        journey_time += 1

        trail_truth = [station_0]
        ex_line_time = 0
        trial_time = 0
        step_truth = 0
        while station_1 != station_2:
            # 按键页面呈现
            screen_begin = globaltime.getTime()
            date = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
                
            judge_page()
            timer = core.Clock()
            core.wait(0)
            timer.reset()  # 这里反应时开始计时
            k_1 = event.waitKeys(keyList=k_list, maxWait=3.0)  # 接受被试按键
# 被试3秒内没有做出反应
            while k_1 is None:
                trial_time += 1
# 计算导航界面的持续时间
                screen_end = globaltime.getTime()
                lasting = screen_end - screen_begin
# 写入表格
                dataFile.write(str(journey_time) + ', ' + u'navigation' + ', ' + str(date)
                               + ', ' + str(screen_begin) + ', ' + str(screen_end) + ', ' + str(lasting) + ', '
                               + station_list_str[station_list.index(station_0)] + ', '
                               + station_list_str[station_list.index(station_2)] + ', ' + str(step) + ', '
                               + str(trial_time) + ', ' + 'N/A' + ', ' + 'no_response' + ', '
                               + station_list_str[station_list.index(station_1)] + ', ' + '\n')
# 先呈现黑屏
                black_page(1, 3)
                dataFile.write(str(journey_time) + ', ' + u'interval' + ', ' + str(date) + ', ' + str(screen_begin)
                               + ', ' + str(screen_end) + ', ' + str(lasting) + '\n')
# 继续呈现按键页面
                screen_begin = globaltime.getTime()
                date = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(time.time()))
                judge_page()

                timer = core.Clock()
                core.wait(0)
                timer.reset()
                k_1 = event.waitKeys(keyList=k_list, maxWait=3.0)
            else:
                timeUse = timer.getTime()      # 反应时记录
                trial_time += 1
                step_truth += 1
                if k_1[0] == '1':
                    station_1 = up_station
                if k_1[0] == '0':
                    station_1 = right_station
                if k_1[0] == '2':
                    station_1 = down_station
                if k_1[0] == '9':
                    station_1 = left_station
# 被试所走的实际路线
                trail_truth.append(station_1)
# 计算导航界面的持续时间
                screen_end = globaltime.getTime()
                lasting = screen_end - screen_begin
# 写入表格
                dataFile.write(str(journey_time) + ' , ' + u'navigation' + ', ' + str(date) + ', ' + str(screen_begin) +
                               ', ' + str(screen_end) + ', ' + str(lasting) + ', '
                               + station_list_str[station_list.index(station_0)] + ', '
                               + station_list_str[station_list.index(station_2)] + ', ' + str(step)
                               + ', ' + str(trial_time) + ', ' + str(timeUse) + ', ' + str(k_1[0]) + ', '
                               + station_list_str[station_list.index(station_1)] + '\n')
# 每次按键后的黑屏1~3秒
                black_page(4-timeUse, 6-timeUse)
                dataFile.write(str(journey_time) + ', ' + u'interval' + ', ' + str(date) + ', ' + str(screen_begin)
                               + ', ' + str(screen_end) + ', ' + str(lasting) + '\n')
        else:
            # 成功到达（额外记录奖赏信息）
            success_page()
            dataFile.write(str(journey_time) + ', ' + u'trip-end' + ', ' + str(date) + ', '
                               + str(screen_begin) + ', ' + str(screen_end) + ', ' + str(lasting) + ', ' + str(reward) + '\n')
# 完成journey后的黑屏2~3秒
        black_page(2, 3)
        dataFile.write(str(journey_time) + ', ' + u'interval' + ', ' + str(date) + ', ' + str(screen_begin) + ', '
                       + str(screen_end) + ', ' + str(lasting) + '\n')
# run所用的时间
    timeUse_run = timer_run.getTime()

else:
    rest_page()
    dataFile.write(str(journey_time) + ', ' + u'run-rest' + ', ' + str(date) + ',' + str(screen_begin) + ','
                   + str(screen_end) + ', ' + str(lasting) + '\n')

# 结束
win.close()
core.quit()
