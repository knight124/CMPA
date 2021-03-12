clc;clear;close all

Is = 0.01e-12;
Ib = 0.1e-12;
Vb = 1.3;
Gp = 0.1;

V= linspace(-1.95, 0.7,200);

I = Is*(exp((1.2/0.025)*V)-1)+Gp*V-Ib*(exp((-1.2/0.025)*(V+Vb))-1);
sigma =0.2*I;
I_rand = I+randn(length(V), 1)'.*sigma;



Ipoly4 = polyfit(V,I,4);
Ipoly8 = polyfit(V,I,8);
Ipoly4_rand = polyfit(V,I,4);
Ipoly8_rand = polyfit(V,I,8);

fo0 = fittype('A.*(exp(1.2*x/25e-3)-1) + 0.1.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
fo1 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
fo2 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)');
ff = fit(V',I',fo0);
ff1= fit(V',I',fo1);
ff2= fit(V',I',fo2);

ff = fit(V',I_rand',fo0);
ff1= fit(V',I_rand',fo1);
ff2= fit(V',I_rand',fo2);

If =ff(V);
If1=ff1(V);
If2=ff2(V);

If3 =ff(V);
If4=ff1(V);
If5=ff2(V);
plot(V,I,'--',V,I_rand ,':',  V, polyval(Ipoly4,V), V, polyval(Ipoly8,V), V, polyval(Ipoly4_rand,V), V, polyval(Ipoly8_rand,V))
legend('expected', 'expected + noise', 'polyfit4 expected', 'polyfit8 expected', 'polyfit4 expected+ noise' , 'polyfit8 expected+ noise')
figure
% log plot not usefull for plotting values less than zero
% log plot also distorts fitted polynomials
semilogy(V,I,'--',V,I_rand,':', V, polyval(Ipoly4,V), V, polyval(Ipoly8,V), V, polyval(Ipoly4_rand,V), V, polyval(Ipoly8_rand,V))
legend('expected', 'expected + noise', 'polyfit4 expected', 'polyfit8 expected', 'polyfit4 expected+ noise' , 'polyfit8 expected+ noise')
figure
% the fit with one degree of fredom more closly approximates the given
% equation 
% two degrees does not approxmat the sub threshold region well
plot(V,I,'--',V,I_rand ,':',  V, If, V, If1, V, If2)
legend('expected', 'expected + noise', 'fitted plot one', 'fitted plot two', 'fitted plot three')
figure
plot(V,I,'--',V,I_rand ,':',  V, If3, V, If4, V, If5)
legend('expected', 'expected + noise', 'fitted plot one + noise', 'fitted plot two + noise', 'fitted plot three + noise')
% net is good at approximating small changes but needs more time to find
% the expodentail changes at the eadges.
figure
inputs = V;
targets = I;
hiddenLayersSize = 10;
net=fitnet(hiddenLayersSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs)
view(net)
Inn = outputs

