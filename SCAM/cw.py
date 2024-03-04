import sys
import pwd
import os
sys.path += ['/home/' + pwd.getpwuid(os.getuid())[0] + '/Projects/SWCAM']
from swcam import *

upz = 10
sxy = 300
sz = 80
td3 = 3.175
td2 = 2.0
tdft = 20.5

nema_pos = []

prof_top = [[5,11], [5,31], [25,31], [25,11], [5,11]]
prof_top_3 = [[6,11.5], [6,30.5], [24,30.5], [24,11.5], [6,11.5]]
prof_deep_top = [[7,11.7], [7,30.3], [23,30.3], [23,11.7], [7,11.7]]
bias_top = [[1,1], [1,-1], [-1,-1], [-1,1], [1,1]]
prof_deep = [[9,12], [9, 30], [21,30], [21,12], [9,12]]
bias_deep = bias_top
#prof_deep = [[8,6], [27,6], [27,8], [33,8], [33,22], [27,22], [27,24], [8,24], [8,6]]
#bias_deep = [[1,1],  [-1,1], [-1,1], [-1,1], [-1,-1], [-1,-1], [-1,-1], [1,-1], [1,1]]

prof_car = [[5, 30], [5, 30-6.9], [9, 30-6.9], [9, 10+6.9], [5, 10+6.9], [5,10],
            [25, 10], [25, 10+6.9], [21, 10+6.9], [21,30-6.9], [25,30-6.9],[25,30],[5,30]]

prof_car_abs = [[-10,11], [-10,10-6.9],[-6,10-6.9],[-6,-10+6.9],[-10,-10+6.9],[-10,-10],
                [10,-10],[10,-10+6.9],[6,-10+6.9],[6,10-6.9],[10,10-6.9],[10,11],[-10,11]]

bias_car = [[1,-1], [1,1], [1,1], [1, -1], [1, -1], [1,1],
            [-1, 1], [-1, -1], [-1, -1], [-1, 1], [-1, 1], [-1, -1], [1, -1]]

top_depth = 5
deep_depth = 20
deep_top_depth = 30

def x2y(points):
    for p in points:
        x=p[0]
        p[0]=p[1]
        p[1]=x
    

def prof2points(prof, bias, place):
    points = []
    for ip in range(len(prof)):
        points += [[prof[ip][0] + place * bias[ip][0], prof[ip][1] + place * bias[ip][1]]]
    return points

def go_deep_prof():
    code = g00_z(upz)
    points = prof2points(prof_deep, bias_deep, td3/2)
    code += g00_xy(points[0][0], points[0][1])
    code += g00_z(-top_depth)
    for iz in range(top_depth, deep_depth):
        code += g01_z(-(iz+1), sz)
        for ix in range(3):
            points = prof2points(prof_deep, bias_deep, (ix+1)*td3/2)
            code += g01_list(points, sxy)
    code += g00_z(upz)
    return code

def go_deep_prof_top():
    code = g00_z(upz)
    points = prof2points(prof_deep_top, bias_deep, td3/2)
    code += g00_xy(points[0][0], points[0][1])
    code += g00_z(-top_depth)
    for iz in range(top_depth, deep_top_depth):
        code += g01_z(-(iz+1), sz)
        for ix in range(5):
            points = prof2points(prof_deep_top, bias_deep, (ix+1)*td3/2)
            code += g01_list(points, sxy)
    code += g00_z(upz)
    return code

def go_top_prof_3():
    code = g00_z(upz)
    points = prof2points(prof_top_3, bias_top, td3/2)
    code += g00_xy(points[0][0], points[0][1])
    code += g00_z(0)
    for iz in range(top_depth):
        code += g01_z(-(iz+1), sz)
        for ix in range(5):
            points = prof2points(prof_top_3, bias_top, (ix+1)*td3/2)
            code += g01_list(points, sxy)
    code += g00_z(upz)
    return code

def go_top_prof(prof_depth = top_depth):
    code = g00_z(upz)
    points = prof2points(prof_top, bias_top, td2/2)
    code += g00_xy(points[0][0], points[0][1])
    code += g00_z(0)
    for iz in range(prof_depth):
        code += g01_z(-(iz+1), sz)
        code += g01_list(points, sxy)
    code += g00_z(upz)
    return code

# BOTTOM

def bot_prof_3():
    code = g00_z(upz)
    code += g_rect_f(15, 21, 20-td3, 20-td3, 5, sxy, sz, upz, 1, td3/2)
    code += g_rect(15, 21, 12-td3, 18-td3, 20, sxy, sz, upz, 1.5, start_depth = 5)
    code += g00_z(upz)
    return code

def bot_prof_2():
    code = g00_z(upz)
    code += g_rect(15, 21, 20.1-td2, 20.1-td2, 5, sxy, sz, upz, 2)
    code += g00_z(upz)
    return code

def bot_side_drill():
    code = g_drill_quadro(19, 21, 31, 16, sz, upz, 6.0, dofast=True)
    code += g00_z(upz)
    code += g02_rxys(11-td3/2, 19, 21, 29, sxy, sz, 1.5)
    code += g00_z(upz)
    return code

def bot_side_drill_rotX():
    code = g_drill_quadro(19, 19, 31, 16, sz, upz, 6.0, dofast=True)
    code += g00_z(upz)
    code += g02_rxys(11-td3/2, 19, 19, 2.0, sxy, sz, 2.0)
    code += g00_z(upz)
    return code

def bot_front_deep():
    code += g00_z(upz)

# TOP

def top_prof_3(depth):
    code = g00_z(upz)
    code += g_rect_f(15, 21, 20-td3, 20-td3, 5, sxy, sz, upz, 1, td3/2)
    code += g_rect_f(15, 21, 16-td3, 18-td3, depth, sxy, sz, upz, 1.5, td3/2, start_depth = 5)
    code += g00_z(upz)
    return code

def top_nut_3(depth):
    code = g00_z(upz)
    code += g02_rxysf(16/2-td3/2, 15, 21, 5, sxy, sz, 2, td3/2)
    code += g02_rxys(5/2-td3/2, 15,21, depth, sxy, sz, 2, start_depth = 5)
    code += g00_z(upz)
    return code

def top_2ghdr(x, d):
    #x = 10, 5, 15/2, d = 3, 3, 4
    w=15
    h=17
    th=1.5
    fd = 3
    code = g00_z(upz)
    if d <= fd:
        code += g_drill(x, h/2, 2, 20)
    else:
        code += g02_rxys(d/2-fd/2, x, h/2, th, 200, 20, 0.5)
    code += g00_z(upz)
    if d <= fd:
        code += g_drill(x, h/2 + h + fd, 2, 20)
    else:
        code += g02_rxys(d/2-fd/2, x, h/2 + h + fd, th, 200, 20, 0.5)
    code += g00_z(upz)
    code += g_cut([[2, h + fd/2], [w-2, h+fd/2]], th, 200, 20, 0.5, upz)
    code += g00_z(upz)
    code += g_cut([[2, 2*h + fd + fd/2], [w-2, 2*h + fd + fd/2]], th, 200, 20, 0.5, upz)
    code += g00_z(upz)
    return code

def top_2ghdr_fin():
    fd=3
    h=17
    code = g00_z(upz)
    code += g02_rxysf(9.5/2-fd/2, 15/2, h/2, 14.5, 200, 20, 0.5, 2, start_depth = 13)
    code += g00_z(upz)
    code += g02_rxysf(9.5/2-fd/2, 15/2, h/2 + h + fd, 14.5, 200, 20, 0.5, 2, start_depth = 13)
    code += g00_z(upz)
    return code

# CAR
def go_car_prof_2(car_depth):
    code = g00_z(upz)
    points = prof2points(prof_car_abs, bias_car, td2/2 - 0.2)
    move_2d(points, 20, 19.5)
    x2y(points)
    code += g00_xy(points[0][0], points[0][1])
    code += g00_z(0)
    for iz in range(car_depth):
        code += g01_z(-(iz+1), sz)
        code += g01_list(points, sxy)
    code += g00_z(upz)
    return code

def go_car_prof_3(car_depth):
    code = g00_z(upz)
    points = prof2points(prof_car_abs, bias_car, td3/2)
    move_2d(points, 20, 19.5)
    x2y(points)
    code += g00_xy(points[0][0], points[0][1])
    code += g00_z(0)
    for iz in range(car_depth):
        code += g01_z(-(iz+1), sz)
        code += g01_list(points, sxy)
    code += g00_z(upz)
    return code

def go_car_snell_2(cx = 19/2, cy = 30):
    prof_w = 7.2
    prof_h = 10.45
    code = g00_z(upz)
    points = [[-prof_w/2+1, 1], [prof_w/2-1, 1], [prof_w/2-1,-prof_h+1],[-prof_w/2+1,-prof_h+1],[-prof_w/2+1,1]]
    move_2d(points, cx, cy)
    code += g00_xy(points[0][0], points[0][1])
    code += g00_z(0)
    for iz in range(7):
        code += g01_z(-(iz+1), sz)
        code += g01_list(points, sxy)
    code += g00_z(upz)

    return code

def go_car_snell_2_full(cx = 19/2, cy = 30):
    code = go_car_snell_2()
    code += go_car_snell_2(cx = 40-19/2)
    code += g00_z(upz)
    code += g_cut([[20,0],[20,30]], 10, sxy, sz, 1, upz)
    code += g00_z(upz)
    return code

def car_hex():

    points = [[3, 5], [3, 15], [27.5, 5], [27.5, 15]]

    code = g00_z(upz)

    for p in points:
        code += g_hex(p[0], p[1], 5.5 - 2, 2.5, sxy, sz, upz, 1.0)
        code += g00_z(upz)
    return code

def car_drill(depth):

    points = [[3, 5], [3, 15], [27.5, 5], [27.5, 15]]

    code = g00_z(upz)

    code += g_drill_points(points, depth, sz, upz, 1.0, dofast=True)

    return code

def car_belt(cx,cy):

    wx = 30
    wy = 20

    wb = 12

    code = g00_z(upz)

    for ib in range(5):
        points = [[cx + wx/2 - wb/2, cy + 1.5 + ib*2], [cx + wx/2 + wb/2, cy + 1.5 + ib*2],
                  [cx + wx/2 + wb/2, cy + 1.2 + ib*2], [cx + wx/2 - wb/2, cy + 1.2 + ib*2]]
        code += g00_xy(points[0][0], points[0][1])
        code += g01_z(0, 100)
        for iz in range(2):
            code += g01_z(-(iz+1)*0.5, sz)
            code += g01_list(points, 200)
        code += g01_z(3, 100)

    for ib in range(5):
        points = [[cx + wx/2 - wb/2, cy + wy - 1.5 - ib*2], [cx + wx/2 + wb/2, cy + wy - 1.5 - ib*2],
                  [cx + wx/2 + wb/2, cy + wy - 1.2 - ib*2], [cx + wx/2 - wb/2, cy + wy - 1.2 - ib*2]]
        code += g00_xy(points[0][0], points[0][1])
        code += g01_z(0, 100)
        for iz in range(2):
            code += g01_z(-(iz+1)*0.5, sz)
            code += g01_list(points, 200)
        code += g01_z(3, 100)

    return code

def car_top_pe(cx, cy):

    wx = 30
    wy = 20

    points = [[3, 5], [3, 15], [27.5, 5], [27.5, 15]]
    for p in points:
        p[0] += cx
        p[1] += cy

    code = g00_z(upz)

    code += g_drill_points(points, 2.2, sz, upz, 1.1, dofast=True)

    cpoints = [[cx - td3/2, cy - td3/2], [cx + wx + td3/2, cy - td3/2],
               [cx + wx + td3/2, cy + wy + td3/2], [cx - td3/2, cy + wy + td3/2],
               [cx - td3/2, cy - td3/2]]
    
    code += g00_z(upz)

    code += g00_xy(cpoints[0][0], cpoints[0][1])
    code += g01_z(0, 100)
    for iz in range(2):
        code += g01_z(-(iz+1), sz)
        code += g01_list(cpoints, 200)
    code += g00_z(upz)
    return code

def car_top_al(cx, cy):
    wx = 30
    wy = 20

    points = [[3, 5], [3, 15], [27.5, 5], [27.5, 15]]
    for p in points:
        p[0] += cx
        p[1] += cy

    code = g00_z(upz)

    code += g_drill_points(points, 2.2, 25, upz, 0.5, dofast=True)

    cpoints = [[cx - 3.0/2, cy - 3.0/2], [cx + wx + 3.0/2, cy - 3.0/2],
               [cx + wx + 3.0/2, cy + wy + 3.0/2], [cx - 3.0/2, cy + wy + 3.0/2],
               [cx - 3.0/2, cy - 3.0/2]]
    
    code += g00_z(upz)

    code += g00_xy(cpoints[0][0], cpoints[0][1])
    code += g01_z(0, 100)
    for iz in range(4):
        code += g01_z(-(iz+1)*0.5, 25)
        code += g01_list(cpoints, 150)
    code += g00_z(upz)
    return code

# FISHTOP

def ft_sq(depth, width):
    y1 = width/2-15/2
    y2 = width/2+15/2
    prof_ftsq = [[0,y1+td3/2], [0,y2-td3/2], [30,y2-td3/2], [30,y1+td3/2], [0,y1+td3/2]]
    code = g00_z(upz)
    code += g00_xy(prof_ftsq[0][0], prof_ftsq[0][1])
    code += g00_z(0)
    cur_depth = 0
    step_z = 1.7
    while cur_depth < depth:
        cur_depth += step_z
        if cur_depth > depth:
            cur_depth = depth
        code += g00_xy(prof_ftsq[0][0], prof_ftsq[0][1])
        code += g01_z(-cur_depth, sz)
        for ix in range(3):
            points = prof2points(prof_ftsq, bias_deep, (ix)*td3*0.75)
            code += g01_list(points, sxy)
    code += g00_z(upz)
    return code

def ft_run(depth, width):
    code = g00_z(upz)
    code += g00_xy(-tdft/2-2, width/2)
    code += g00_z(-depth)
    code += g01_xy(tdft/2+5+30, width/2, 500)
    code += g00_z(upz)
    return code

# Other
def x_stopplate():
    code = g00_z(upz)
    l=135
    points = [[7.5, 7.5], [25, 7.5], [25, 30-7.5], [7.5, 30], [7.5, 60],[7.5, 90], [7.5, 128]]
    for p in points:
        code += g02_rxys(6/2-td3/2, p[0], p[1], 10, 300, 30, 0.75)
        code += g00_z(upz)
    code += g_cut([[35+td3/2, 2], [35+td3/2, l-2]], 10, 500, 30, 0.5, upz)
    code += g00_z(upz)
    return code

def lazer_hldr():
    shd = 69.5
    lw = 33
    pw5 = 4.9
    code = g00_z(upz)
    return code
    
    

if __name__ == "__main__":

    code = g_start()

    code += g00_z(upz)

    #code += bot_side_drill_rotX()
    #code += bot_prof_2()
    
    #code += top_prof_3(30)
    #code += top_nut_3(12);
    #code += top_2ghdr_fin()
    code += x_stopplate()

    #code += g02_rxys(2.5-td3/2, 21, 21, 7, sxy, sz, 1.0)
    
    #code += g02_rxys(19/2-td3/2, 19, 19, 16, sxy, sz, 1.0)

    # code += g_hex(21,21,8-2,4,sxy,sz,upz,1.0,0)

    #code += go_car_prof_2(12)
    #code += go_car_snell_2()
    #code += ft_sq(5, 40)
    #code += ft_run(5, 40)

    #code += car_hex()

    #code += car_drill(30)

    #code += car_belt(20,20)

    #code += car_top_pe(20,20)
    #code += car_top_al(5,20)

    code += g00_z(upz)

    code += g00_xy(0,0)

    f = open('xstopplate.gcode', 'wb')
    f.write(bytes(code, encoding='UTF-8'))
    f.close()
    
