filepath = "data/outputs/HPA/";
mkdir(filepath);
a = [1:2:100];


h = figure;

plot(a);
set(h,"position",[0,0,1080,1920]);
saveas(h,filepath+"hello",'jpg')