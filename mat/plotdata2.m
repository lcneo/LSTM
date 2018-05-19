function plotdata2()
path1 = 'data/pressure/oneh.csv';
path2 = 'data/pressure/threeh.csv';
path3 = 'data/pressure/oned.csv';
path4 = 'data/pressure/threed.csv';


oneh = csvread(path1,1,0);
threeh = csvread(path2,1,0);
oned = csvread(path3,1,0);
threed = csvread(path4,1,0);

oneh = oneh(:,4);
threeh = threeh(:,4);
oned = oned(:,4);
threed = threed(:,4);


subplot(2,2,1)
plot(oneh)
title('one hour a point (mean)')
xlabel('hour')
ylabel('HPA')


subplot(2,2,2)
plot(threeh)
title('three hours a point (mean)')
xlabel('3 hour')
ylabel('HPA')


subplot(2,2,3)
plot(oned)
title('one day a point (mean)')
xlabel('day')
ylabel('HPA')


subplot(2,2,4)
plot(threed)
title('three days a point(mean)')
xlabel('3 day')
ylabel('HPA')


end