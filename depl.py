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
with open('/home/nils/Desktop/LCR_PY_PLOT/testfile.csv','r') as csvfile:
    plots = csv.reader(csvfile, delimiter=' ')
    next(plots)#headers
    for row in plots:
        x.append(float(row[5]))
        y.append(float(row[1]))        
x=np.array(x)
y=np.array(y)

gx=np.logical_and(x>80,x<160)
"""
while x:
	element=x.pop(0)
	element1=y.pop(0)
	if element >80 and element <160:
		sortx.append(element)
		sorty.append(element1)
"""
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
x2=np.arange(80,160,0.1)
plt.figure()
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
def lnfunc(a,b,c,x):
    return a/(b*np.log(c*x))
plt.figure(1)
plt.plot(x,lnfunc(x,1,1,5))
plt.show()

    




#fit_params =np.array([1.0,1.0,2.0])
#fit_params.add('a', value=1)
#fit_params.add('b', value=1)
#fit_params.add('c', value=2)
fit_params = Parameters()
fit_params.add('a', value=13.0)
fit_params.add('b', value=2)
fit_params.add('c', value=1.0)
fit_params.add('x', value=0.02)


f=f[fitgrenze]
d=d[fitgrenze]
out1 = minimize(lnfunc,fit_params, args=(f,))

print(fit_report(out1))
plt.figure()
plt.plot(f,d)
plt.plot(f, out1.best_fit, 'r-', label='best fit')
plt.legend(loc='best')
plt.show()




#const_model=ConstantModel(d[-1])
step_mod = StepModel(form='erf', prefix='step_')
line_mod = LinearModel(prefix='line_')
exp_mod = ExponentialModel(prefix='exp_')

#pars = line_mod.make_params(intercept=y.min(), slope=0)
#pars += step_mod.guess(d, x=f, center=xmin)
pars = exp_mod.guess(d, x=f)
mod = step_mod + line_mod
out = mod.fit(d, pars, x=f)
print(out.fit_report())




plt.figure()
plt.plot(f,d)
plt.plot(f, out.best_fit, 'r-', label='best fit')
plt.legend(loc='best')
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




