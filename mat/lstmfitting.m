function  lstmfitting(path,strylabel,strxlabel,type,epoch)
%myFun - Description
%
% Syntax: output = myFun(input)
%
% Long description

filepath = "data/outputs/"+strylabel+"/"+strxlabel+"/"+type;

mkdir(filepath);
csvdata = csvread(path,1,0);

if type == "max";
    numm = 2;
elseif type == "min";
    numm = 3;
elseif type == "mean";
    numm = 4;
elseif type == "median";
    numm = 5;
end
    
data = csvdata(:,numm);



f1 = figure;
plot(data)
xlabel(strxlabel)
ylabel(strylabel)
title(strylabel +" / "+strxlabel+ " (" +type+")" );
% set(f1,"position",[5,5,1920,1029]);
saveas(f1,filepath+"/f1.fig");
saveas(f1,filepath+"/f1.jpg");



numTimeStepsTrain = floor(0.9*numel(data));
XTrain = data(1:numTimeStepsTrain);
YTrain = data(2:numTimeStepsTrain+1);
XTest = data(numTimeStepsTrain+1:end-1);
YTest = data(numTimeStepsTrain+2:end);


mu = mean(XTrain);
sig = std(XTrain);

XTrain = (XTrain - mu) / sig;
YTrain = (YTrain - mu) / sig;

XTest = (XTest - mu) / sig;

XTrain = XTrain';
YTrain = YTrain';

XTest = XTest';


inputSize = 1;
numResponses = 1;
numHiddenUnits = 200;

layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    regressionLayer];


opts = trainingOptions('adam', ...
    'MaxEpochs',epoch, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');

net = trainNetwork(XTrain,YTrain,layers,opts);

net = predictAndUpdateState(net,XTrain);
[net,YPred] = predictAndUpdateState(net,YTrain(end));

numTimeStepsTest = numel(XTest);
for i = 2:numTimeStepsTest
    [net,YPred(1,i)] = predictAndUpdateState(net,YPred(i-1));
end

YPred = sig*YPred + mu;

rmse = sqrt(mean((YPred-YTest).^2));


% figure
% subplot(2,1,1)
% plot(YTest)
% hold on
% plot(YPred,'.-')
% hold off
% legend(["Observed" "Forecast"])
% ylabel("HPA")
% title("Forecast")
% 
% subplot(2,1,2)
% stem(YPred - YTest)
% xlabel("3 day")
% ylabel("Error")
% title("RMSE = " + rmse(:,end))



net = resetState(net);
net = predictAndUpdateState(net,XTrain);

YPred = [];
numTimeStepsTest = numel(XTest);
for i = 1:numTimeStepsTest
    [net,YPred(1,i)] = predictAndUpdateState(net,XTest(i));
end


YPred = sig*YPred + mu;

rmse = sqrt(mean((YPred-YTest).^2));

f2 = figure;
plot(data(1:numTimeStepsTrain))
hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(idx,[data(numTimeStepsTrain) YPred],'.-')
hold off
xlabel(strxlabel)
ylabel(strylabel)
title("Forecast")
legend(["Observed" "Forecast"])
% set(f2,"position",[5,5,1920,1029]);
saveas(f2,filepath+"/f2.fig");
saveas(f2,filepath+"/f2.jpg");


f3 = figure;
subplot(2,1,1)
plot(YTest)
hold on
plot(YPred,'.-')
hold off
legend(["Observed" "Predicted"])
ylabel(strylabel)
xlabel(strxlabel)
title("Forecast with Updates")

subplot(2,1,2)
stem(YPred - YTest)
xlabel(strxlabel)
ylabel("Error")
title("RMSE = " + rmse(:,end))
% set(f3,"position",[5,5,1920,1029]);
saveas(f3,filepath+"/f3.fig");
saveas(f3,filepath+"/f3.jpg");

clear all
close all

end