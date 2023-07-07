"""
    Program Double Pendulum
    Muhammad Yasin
    NRP 07311740000019
    Teknik Biomedik
    Fakultas Teknologi Elektro
    Institut Teknologi Sepuluh Nopember
"""
import numpy as np
import matplotlib.pyplot as plt
from sympy.functions import sin, cos


################################ SET PARAMETER ################################

"""
m1 = int(input('Masukkan Massa Benda 1 : ' ))
m2 = int(input('Masukkan Massa Benda 2 : ' ))
l1 = int(input('Masukkan Panjang Benda 1 : ' ))
l2 = int(input('Masukkan Panjang Benda 2 : ' ))
sdt1 = int(input('Masukkan Sudut Benda 1 : ' ))
sdt2 = int(input('Masukkan Sudut Benda 2 : ' ))
"""

m1 = 1
m2 = m1
l1 = 1
l2 = l1
sdt1 = 30
sdt2 = 90

h = 0.1
g = 9.8
pi = 22/7

tet1 = sdt1*pi/180
tet2 = sdt2*pi/180

tetdot1 = 0
tetdot2 = 0

# HITUNG MOMEN INERSIA #

i1 = m1*l1*l1
i2 = m2*l2*l2


################################ PLOTTINGAN ################################

def plotpendulum(time, tet1, tet2, tetdot2):
    # PENDULUM #
    plt.figure(1).clear()
    plt.title('Pendulum')
    x1 = l1*sin(tet1)
    y1 = -l1*cos(tet1)
    x2 = l1*sin(tet1)+l2*sin(tet2)
    y2 = -l1*cos(tet1)-l2*cos(tet2)
    xx1 = [0,x1]
    yy1 = [0,y1]
    xx2 = [x1,x2]
    yy2 = [y1,y2]
    
    plt.xlim(-4,4)
    plt.ylim(-2,2)
    plt.plot(xx1,yy1)
    plt.plot(xx2,yy2)   
    plt.scatter((l1/2)*sin(tet1), -(l1/2)*cos(tet1))
    plt.scatter(x1+(l2/2)*sin(tet2),y1-(l2/2)*cos(tet2))

    # TRACK PENDULUM #
    plt.figure(2)
    plt.subplot(2,2,1)
    plt.xlabel('Time', size = 10)
    plt.ylabel('Teta 1')
    plt.scatter(time, tet1, s = 3, color = 'green')
    

    # TETA 1 TERHADAP TIME #
    plt.subplot(2,2,2)
    plt.xlim(-1.2,1.2)
    plt.ylim(-1.6,0)
    plt.scatter((l1/2)*sin(tet1), -(l1/2)*cos(tet1), s = 3, color = 'blue')
    plt.scatter(x1+(l2/2)*sin(tet2),y1-(l2/2)*cos(tet2), s = 3, color = 'orange')
    

    # TETA 2 TERHADAP TIME #
    plt.subplot(2,2,3)
    plt.xlabel('Time')
    plt.ylabel('Teta 2')
    plt.scatter(time, tet2, s = 3, color = 'red')

    # TETADOT 2 TERHADAP TETA 2 #  
    plt.subplot(2,2,4)
    plt.xlabel('Teta 2')
    plt.ylabel('Tetadot 2')
    plt.scatter(tet1, tet2, s = 3, color = 'blue')
    plt.pause(0.00001)
    

    
################################ PROSEDUR MENCARI MATRIKS ################################
    
def f(tet1, tet2, tetdot1, tetdot2):
    #### MATRIX M ######
    M1 = ((1/4)*m1+m2)*l1**2+i1
    M2 = (1/2)*m2*l1*l2*cos(tet1-tet2)
    M3 = (1/4)*m2*l2**2+i2
    M = np.matrix([[M1,M2],[M2,M3]], dtype='float')
    
    iM = np.linalg.inv(M)

    tau1 = 0
    tau2 = 0
    tau = np.matrix([[tau1],[tau2]])
    
    iM_tau =  np.matmul(iM,tau)

    #### MATRIX C ######

    C1 = (1/2)*m2*l1*l2*sin(tet1-tet2)*tetdot2
    C2 = (-1/2)*m2*l1*l2*sin(tet1-tet2)*(tetdot1-tetdot2)
    C3 = (-1/2)*m2*l1*l2*tetdot1*sin(tet1-tet2)
    C = np.matrix([[C1,C2],[C2,C3]], dtype='float')
    
    tetdot = np.matrix([[tetdot1], [tetdot2]])
    
    iM_C = np.matmul(iM,C)
    iM_C_tetdot = np.matmul(iM_C,tetdot)

    #### MATRIX G ######6
    G1 = ((1/2)*m1+m2)*g*l1*sin(tet1)
    G2 = (1/2)*m2*g*l2*sin(tet2)
    G = np.matrix([[G1], [G2]], dtype='float')
    iM_G = np.matmul(iM,G)

    global tetdotdot1, tetdotdot2
    tetdotdot = iM_tau - iM_C_tetdot - iM_G
    tetdotdot1 = float(tetdotdot[0])
    tetdotdot2 = float(tetdotdot[1])


    
################################ PROSEDUR RUNGE-KUTTA ################################
    
def RungeKutta(tet1, tet2, tetdot1,tetdot2):
    time = 0
    tmax = 10
    while time < tmax:

        f(tet1, tet2, tetdot1, tetdot2)
        k11 = h/2*tetdotdot1
        k21 = h/2*tetdotdot2
        
        ### UNTUK MENCARI K2 DAN K3###
        k1 = h/2*(tetdot1+k11/2)
        k2 = h/2*(tetdot2+k21/2)
        
        f(tet1+k1, tet2+k2, tetdot1+k11, tetdot1+k21)     
        k12 = h/2*tetdotdot1
        k22 = h/2*tetdotdot2
        
        f(tet1+k1, tet2+k2, tetdot1+k12, tetdot1+k22)  
        k13 = h/2*tetdotdot1
        k23 = h/2*tetdotdot2
        
        f(tet1+(h*(tetdot1+k13)), tet2+(h*(tetdot2+k23)), tetdot1+2*k13, tetdot2+2*k23)
        k14 = h/2*tetdotdot1
        k24 = h/2*tetdotdot2
        
        ### UPDATE TETA DAN TETADOT ###
        tet1 = tet1 + h*(tetdot1+(k11+k12+k13)/3)
        tet2 = tet2 + h*(tetdot2+(k21+k22+k23)/3)
        

        tetdot1 = tetdot1+(k11+2*k12+2*k13+k14)/3
        tetdot2 = tetdot2+(k21+2*k22+2*k23+k24)/3

        #print(tet1, tet2, tetdot1, tetdot2)

        ### PLOTTINGAN ###
        
        plotpendulum(time, tet1, tet2, tetdot2)
        
        time += h

### JALANKAN FUNGSI RUNGE-KUTTA ###
RungeKutta(tet1, tet2, tetdot1,tetdot2)
plt.show()
