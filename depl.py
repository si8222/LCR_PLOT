import pandas as pd
import matplotlib.pyplot as plt
import csv
import numpy as np
from scipy.interpolate import CubicSpline as cp
from lmfit.models import ExponentialModel,LinearModel, StepModel,ConstantModel
from lmfit import Parameters, fit_report, minimize
x = []
y = []
z = []
with open('/home/nils/Desktop/depletion.csv','r') as csvfile:
    plots = csv.reader(csvfile, delimiter=' ')
    next(plots)#headers
    for row in plots:
        x.append(float(row[5]))
        y.append(float(row[1]))        
x=np.array(x)
y=np.array(y)
plt.figure(1)
plt.plot()
plt.xlabel('Voltage')
plt.ylabel('cp')
plt.plot(x,y,'b.',label='rawdata')#Rawdatafit
plt.legend()
plt.show()

gx=np.logical_and(x>80,x<160)#data limitation and transformation to numpy
xlim=x[gx]
ylim=y[gx]
f2 = cp(xlim,ylim)#definition of f2 with limited data
xmin=xlim[f2(xlim,1)==min(f2(xlim,1))][0]#minimum of 1. diff of f2 -> [0]array to float



print("Turningpoint: ",xmin)
aftermin=np.logical_and(x>xmin,x<160)#data after turningpoint
deplV = x[aftermin]
deplC = y[aftermin]

int1=np.arange(80,140,0.1)#set up interpolation
plt.figure(2)
plt.plot(xlim,ylim,'r+',label='Data')
plt.plot(int1,f2(int1),'.',lw=2,color="blue", label='Interpolation')#plot interpolation
plt.legend()
plt.xlabel('Voltage')
plt.ylabel('cp')
plt.show()



x3=np.arange(xmin,160,0.01)#
f3 = cp(deplV,deplC)
depldata = []
f3=f3(x3,2)#f3 always y-values, f3(data,n-diff)
depldata=x3[np.logical_or(f3<0, f3==0)][0]
print("DepletionData: ",depldata)
#1. negative value in 2.Diff-> almost0->turning point for f(x)-> turning in depletion region



fitgrenze=np.logical_and(xlim>=xmin-20, xlim<=xlim[-1])#set up limits for fitfunc
xlim=xlim[fitgrenze]
ylim=ylim[fitgrenze]
step_mod = StepModel(form='linear', prefix='step_')#fit step_model
line_mod = LinearModel(prefix='line_')#fit lin_model
#exp_mod = ExponentialModel(prefix='exp_')
pars = line_mod.make_params(intercept=xlim.min(), slope=0)#initial conditions for both mods
pars += step_mod.guess(ylim, x=xlim, center=xmin)
#pars = exp_mod.guess(d, x=f)
mod = step_mod + line_mod
out = mod.fit(ylim, pars, x=xlim)

plt.figure(3)
plt.plot(xlim,ylim,'r+', label='Data')
plt.plot(xlim, out.best_fit, 'b-', label='Fit (Line, Linear_Step)')
plt.legend(loc='best')
plt.xlabel('Voltage')
plt.ylabel('cp')
plt.show()#plot of data and fit

spfit=cp(xlim,out.best_fit)
diff1=spfit(int1,1)
diff2=spfit(int1,2)
vdep1=int1[diff2==max(diff2)][0]
print("DepletionFit: ",vdep1)


plt.figure(4)
plt.plot(int1,diff1,"r+", label='1. Diff interpolation')
plt.plot(int1,diff2,"b.", label='2. Diff interpolation')
plt.legend()
plt.xlabel('Voltage')
plt.ylabel('cp')
plt.show()

#plt.figure()
#plt.plot(x2, f2(x2,1),'-o',lw=2,color="blue")
#plt.ylabel("Cp [F]", fontsize=16, color="blue")
#plt.xlabel("Bias [V]", fontsize=16)
#plt.show()
#
#plt.figure()
#plt.plot(x2, f2(x2,2),'-o',lw=2,color="blue")
#plt.ylabel("Cp [F]", fontsize=16, color="blue")
#plt.xlabel("Bias [V]", fontsize=16)
#plt.show()




