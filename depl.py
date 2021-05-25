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
plt.plot(x,y,'.')
gx=np.logical_and(x>80,x<160)

f=x[gx]
d=y[gx]

#print(deplV,deplC)


f2 = cp(f,d)
xmin=f[f2(f,1)==min(f2(f,1))][0]



print("Minimum: ",xmin)
aftermin=np.logical_and(x>xmin,x<160)
deplV = x[aftermin]
deplC = y[aftermin]

#print(f2(f))
x2=np.arange(80,140,0.1)
plt.figure(2)
plt.plot(f,d,'r+')
plt.plot(x2,f2(x2),'.',lw=2,color="blue")
plt.show()

x3=np.arange(xmin,160,0.01)
f3 = cp(deplV,deplC)


#print("f3: ",f3(x3,2))

neglist = []
f3=f3(x3,2)#f3 sind immer die y-werte

neglist=x3[np.logical_or(f3<0, f3==0)][0]
print("neglist: ",neglist)
#1. negative value in 2.Diff-> almost0->turning point for f(x)-> turning in depletion region



fitgrenze=np.logical_and(f>=xmin-20, f<=f[-1])

f=f[fitgrenze]
d=d[fitgrenze]
#out1 = minimize(lnfunc,fit_params, args=(f,))
#const_model=ConstantModel(d[-1])
step_mod = StepModel(form='linear', prefix='step_')
line_mod = LinearModel(prefix='line_')
exp_mod = ExponentialModel(prefix='exp_')

pars = line_mod.make_params(intercept=f.min(), slope=0)
pars += step_mod.guess(d, x=f, center=xmin)
#pars = exp_mod.guess(d, x=f)
mod = step_mod + line_mod
out = mod.fit(d, pars, x=f)

#print(out.fit_report())

plt.figure(3)
plt.plot(f,d,'+')
plt.plot(f, out.best_fit, 'r-', label='best fit')
plt.legend(loc='best')
plt.show()

spfit=cp(f,out.best_fit)
diff1=spfit(x2,1)
diff2=spfit(x2,2)
vdep1=x2[diff2==max(diff2)][0]
print("Depletionfit: ",vdep1)


plt.figure(4)
plt.plot(x2,diff1,".")
plt.plot(x2,diff2,"+")
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




