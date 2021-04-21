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


# 判断当前站台是否是个换乘站
def get_station_type(sta_1):
    if sta_1 in ex_stations:
        return 1
    else:
        return 0


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


# 定义一个判断相邻2站所走线路的函数,输出的直接就是线路号，因为后面加了1
def which_line2(sta1, sta2):
    return list(set(which_line(sta1)) & set(which_line(sta2)))[0] + 1


# 定义一个判断站点是否在一条直线上的函数，一条直线为1，不是为0
def if_straight(stat1, stat2):
    if stat1[0] != stat2[0] and stat1[1] != stat2[1]:
        return 0
    else:
        return 1


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


