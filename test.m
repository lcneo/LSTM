data = csvread('data/pressure/threed.csv',1,0);
y = data(1:50,4);
plot(y)
xlabel('3 day')
ylabel('HPA')
title('data')