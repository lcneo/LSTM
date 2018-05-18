% data = csvread('data/pressure/threed.csv',1,0);
% y = data(1:50,4);
% b = [1:10];
% plot(y)
% xlabel('3 day')
% ylabel('HPA')
% title("data" + b)

lstmfitting('data/pressure/oned.csv',5,"day","PHA",800);