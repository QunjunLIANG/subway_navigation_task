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

line_dic = {1: line_1, 2: line_2, 3: line_3, 4: line_4}
for key in line_dic.keys():
    value = line_dic[key]
stations = set()
for key in line_dic.keys():
    stations.update(set(line_dic[key]))
system = {}
for station in stations:
    next_station = {}
    for key in line_dic:
        if station in line_dic[key]:
            line = line_dic[key]
            idx = line.index(station)
            if idx == 0:
                next_station[line[1]] = key
            elif idx == len(line)-1:
                next_station[line[idx-1]] = key
            else:
                next_station[line[idx-1]] = key
                next_station[line[idx+1]] = key
    system[station] = next_station


def short_path(start, goal):
    if start == goal:
        return [start]
    explored = set()
    queue = [[start]]
    while queue:
        path = queue.pop(0)
        s = path[-1]
        for state, action in system[s].items():
            if state not in explored:
                explored.add(state)
                path2 = path + [action, state]
                if state == goal:
                    return path2
                else:
                    queue.append(path2)


def path_search(start, goal):
    if start == goal:
        return [start]
    explored = set()
    queue = [[start, ('', 0)]]
    while queue:
        path = queue.pop(0)
        s = path[-2]
        line_num, change_times = path[-1]
        if s == goal:
            return path
        for state, action in system[s].items():
            if state not in explored:
                line_change = change_times
                explored.add(state)
                if line_num != action:
                    line_change += 1
                path2 = path[:-1] + [action, state, (action, line_change)]
                queue.append(path2)
                queue.sort(key=lambda path: path[-1][-1])


def get_need_steps(start, goal):
    need_steps = (len(short_path(start, goal))-1)/2
    need_steps = int(need_steps)
    return need_steps


def get_idea_trail(start, goal):
    idea_trail = path_search(start, goal)[::2]
    return idea_trail


def get_idea_line(start, goal):
    idea_line = path_search(start, goal)[1::2]
    idea_line.pop()
    return idea_line


def get_idea_line_number(start, goal):
    return len(list(set(get_idea_line(start, goal))))



