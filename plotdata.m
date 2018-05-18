function plotdata()
path = 'data/pressure/oned.csv'
data = csvread(path,1,0);

ymax = data(:,2);
ymin = data(:,3);
ymean = data(:,4);
ymedian = data(:,5);

subplot(2,2,1)
plot(ymax)
title('MAX')
xlabel('day')
ylabel('HPA')

subplot(2,2,2)
plot(ymin)
title('MIN')
xlabel('day')
ylabel('HPA')


subplot(2,2,3)
plot(ymean)
title('MEAN')
xlabel('day')
ylabel('HPA')


subplot(2,2,4)
plot(ymedian)
title('MEDIAN')
xlabel('day')
ylabel('HPA')

end
