function plotdata(path)
data = csvread(path,1,0);

ymax = data(:,2);
ymin = data(:,3);
ymean = data(:,4);
ymedian = data(:,5);

subplot(2,2,1)
plot(ymax)
title('MAX')

subplot(2,2,2)
plot(ymin)
title('MIN')

subplot(2,2,3)
plot(ymean)
title('MEAN')

subplot(2,2,4)
plot(ymedian)
title('MEDIAN')
end
