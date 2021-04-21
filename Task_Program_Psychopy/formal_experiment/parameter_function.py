import judge_function


# 计算拐点的函数
def get_turn_time(trail_truth):    # 我想这里说的shadows name的错误应该是局部变量的调用问题
    turn_time = 0                  # 这些变量都需要在主程序中生成，然后再到作用域里进行运算，不会被忽视吗？明天问一下王帅
    p_cross_stations = []
    if len(trail_truth) > 2:
        for cross_station in judge_function.cross_stations:
            if cross_station in trail_truth:
                p_cross_station = [i for i, v in enumerate(trail_truth) if v == cross_station]
                p_cross_stations += p_cross_station
        p_cross_stations = list(set(p_cross_stations))
    for pp in p_cross_stations:
        if pp != 0 and pp != len(trail_truth) - 1:
            if judge_function.if_straight(trail_truth[pp-1], trail_truth[pp+1]) == 0:
                turn_time += 1
    return turn_time


# 计算换线次数的函数
def get_ex_line_time(trail_truth):
    ex_line_time = 0
    p_ex_stations = []
    if len(trail_truth) > 2:
        for ex_station in judge_function.ex_stations:
            if ex_station in trail_truth:
                p_ex_station = [i for i, v in enumerate(trail_truth) if v == ex_station]
                p_ex_stations += p_ex_station
        p_ex_stations = list(set(p_ex_stations))
    for pp in p_ex_stations:
        if pp != 0 and pp != len(trail_truth) - 1:
            if judge_function.if_same_line(trail_truth[pp - 1], trail_truth[pp + 1]) == 0:
                ex_line_time += 1
    return ex_line_time


# 计算被试某次按键反应为switch或stay
def get_response_type(trail_truth):
    if len(trail_truth) > 2 and judge_function.if_straight(trail_truth[len(trail_truth)-1], trail_truth[len(trail_truth)-3]) == 0:
        return 'switch'
    else:
        return 'stay'


# 计算路途中换乘站的个数
def get_ex_sta_num(station, trail_truth):
    ex_sta_num = 0
    for i in judge_function.ex_stations:
        i_time = trail_truth.count(i)
        ex_sta_num += i_time
    if station in judge_function.ex_stations:
        ex_sta_num -= 1
    return ex_sta_num


# 计算生成的随机路线中需要经过几个换乘站,输出的是数字
def get_optimal_ex(choices, ex_station, station_0, station_2):
    if choices == 1:
        com_line = judge_function.line_list[list((set(judge_function.which_line(station_0)) &
                                                  set(judge_function.which_line(station_2))))[0]]           # 得到起点终点之间的路线
        if com_line.index(station_0) < com_line.index(station_2):
            between_line = com_line[com_line.index(station_0):com_line.index(station_2)+1]   # 得到该旅途中的所有站点列表
        else:
            between_line = com_line[com_line.index(station_2):com_line.index(station_0)+1]
        overlap_line = list(set(between_line) & set(judge_function.ex_stations))      # 得到上列表和换乘站列表之间的交集
        optimal_ex_station = len(overlap_line)                         # 计算交集的数量
        return optimal_ex_station
    if choices == 2:
        com_line_1 = judge_function.line_list[list(set(judge_function.which_line(station_0)) &
                                                   set(judge_function.which_line(ex_station)))[0]]
        if com_line_1.index(station_0) < com_line_1.index(ex_station):
            between_line_1 = com_line_1[com_line_1.index(station_0):com_line_1.index(ex_station)+1]
        else:
            between_line_1 = com_line_1[com_line_1.index(ex_station):com_line_1.index(station_0)+1]
        overlap_line_1 = list(set(between_line_1) & set(judge_function.ex_stations))

        com_line_2 = judge_function.line_list[list(set(judge_function.which_line(station_2)) &
                                                   set(judge_function.which_line(ex_station)))[0]]
        if com_line_2.index(ex_station) < com_line_2.index(station_2):
            between_line_2 = com_line_2[com_line_2.index(ex_station):com_line_2.index(station_2)+1]
        else:
            between_line_2 = com_line_2[com_line_2.index(station_2):com_line_2.index(ex_station)+1]
        overlap_line_2 = list(set(between_line_2) & set(judge_function.ex_stations))

        optimal_ex_station = len(overlap_line_1) + len(overlap_line_2) - 1   # 注意该计算会把中间换乘站算两次，所以减一
        return optimal_ex_station
    else:
        return 2
