import random

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


# 生成随机路线的起点和终点
def make_journey(plan=0):
    global ex_station
    optimal_step = random.randint(4, 5)
    choices = plan

    if plan == 0:
        choices = random.randint(1, 3)

    if choices == 1:
        line_cur = line_list[random.randint(0, 3)]
        ps = pe = 0
        while line_cur[ps][0] == line_cur[pe][0] or line_cur[ps][1] == line_cur[pe][1]:
            ps = random.randint(0, 9)
            if ps < optimal_step:
                pe = ps + optimal_step
            if optimal_step <= ps <= 9 - optimal_step:
                pat_rand = random.randint(0, 1)
                if pat_rand == 1:
                    pe = ps + optimal_step
                if pat_rand == 0:
                    pe = ps - optimal_step
            if ps > 9 - optimal_step:
                pe = ps - optimal_step
        else:
            we_get = [line_cur[ps], line_cur[pe], optimal_step, choices]
            return we_get

    if choices == 2:
        station_start = s17
        station_end = s24
        while (station_start, station_end) == (s23, s26) or (station_start, station_end) == (s26, s23) or \
                (station_start, station_end) == (s17, s24) or (station_start, station_end) == (s24, s17) or \
                (station_start, station_end) == (s31, s16) or (station_start, station_end) == (s16, s31) or \
                (station_start, station_end) == (s25, s18) or (station_start, station_end) == (s18, s25) or \
                (station_start, station_end) == (s25, s16) or (station_start, station_end) == (s16, s25) or \
                (station_start, station_end) == (s31, s24) or (station_start, station_end) == (s24, s31) or \
                (station_start, station_end) == (s17, s26) or (station_start, station_end) == (s26, s17) or \
                (station_start, station_end) == (s23, s18) or (station_start, station_end) == (s18, s23):
            ex_station = ex_stations[random.randint(0, 4)]
            d1 = random.randint(1, optimal_step - 1)
            d2 = optimal_step - d1
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
            we_get = [station_start, ex_station, station_end, optimal_step, choices]
        return we_get

    if choices == 3:
        station_start = s16
        station_end = s25
        while (station_start, station_end) == (s23, s26) or (station_start, station_end) == (s26, s23) or \
                (station_start, station_end) == (s17, s24) or (station_start, station_end) == (s24, s17) or \
                (station_start, station_end) == (s31, s16) or (station_start, station_end) == (s16, s31) or \
                (station_start, station_end) == (s25, s18) or (station_start, station_end) == (s18, s25) or \
                (station_start, station_end) == (s25, s16) or (station_start, station_end) == (s16, s25) or \
                (station_start, station_end) == (s31, s24) or (station_start, station_end) == (s24, s31) or \
                (station_start, station_end) == (s17, s26) or (station_start, station_end) == (s26, s17) or \
                (station_start, station_end) == (s23, s18) or (station_start, station_end) == (s18, s23):
            ex_station_group = [(s16, s18), (s18, s26), (s26, s8)]   # 定义两换乘可能经过的站台
            a = random.randint(0, 2)       # 对可能站台组合进行随机抽取
            ex_stations_cur = ex_station_group[a]
            ex_station1 = ex_stations_cur[0]    # 单独选出换乘站
            ex_station2 = ex_stations_cur[1]
            if ex_stations_cur == (s16, s18):   # 定义两个换乘站的中间路线
                line_mid = line_2
            if ex_stations_cur == (s18, s26):
                line_mid = line_4
            if ex_stations_cur == (s26, s8):
                line_mid = line_4

            if ex_station1 in line_1 and line_mid != line_1:    # 定义两端路线之一
                line_ex_1 = line_1
            if ex_station1 in line_2 and line_mid != line_2:
                line_ex_1 = line_2
            if ex_station1 in line_3 and line_mid != line_3:
                line_ex_1 = line_3
            if ex_station1 in line_4 and line_mid != line_4:
                line_ex_1 = line_4

            if ex_station2 in line_1 and line_mid != line_1:    # 定义两端路线之二
                line_ex_2 = line_1
            if ex_station2 in line_2 and line_mid != line_2:
                line_ex_2 = line_2
            if ex_station2 in line_3 and line_mid != line_3:
                line_ex_2 = line_3
            if ex_station2 in line_4 and line_mid != line_4:
                line_ex_2 = line_4

            pex_mid_1 = line_mid.index(ex_station1)   # 调取两个换乘站在中间路线中的位置
            pex_mid_2 = line_mid.index(ex_station2)
            d_mid = abs(pex_mid_1 - pex_mid_2)        # 计算两个换乘站之间的位置差值(i.e. 2)

            d1 = random.randint(1, optimal_step - d_mid - 1)
            d2 = optimal_step - d_mid - d1     # 计算两端路线可走的步数

            pex1 = line_ex_1.index(ex_station1)  # 检索两个换乘站在两端路线中分别的位置
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
                p2 = pex2 - d2
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
            we_get = [station_start, ex_station1, ex_station2, station_end, optimal_step, choices]
        return we_get
