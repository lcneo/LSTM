
% filepath = "data/outputs/"+strylabel+"/"+strxlabel+"/"+type;
csv = csvread('data/pressure/threed.csv',1,0);
 
data = csv(:,4);

figure
plot(data)
xlabel("Month")
ylabel("Cases")
title("Monthy Cases of Chickenpox")



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
    'MaxEpochs',250, ...
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

% YPred = sig*YPred + mu;

% rmse = sqrt(mean((YPred-YTest).^2));


net = resetState(net);
net = predictAndUpdateState(net,XTrain);

YPred = [];
numTimeStepsTest = numel(XTest);
for i = 1:numTimeStepsTest
    [net,YPred(1,i)] = predictAndUpdateState(net,XTest(i));
end


YPred = sig*YPred + mu;

rmse = sqrt(mean((YPred-YTest).^2));

figure
plot(data(1:numTimeStepsTrain))
hold on
idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
plot(idx,[data(numTimeStepsTrain) YPred],'.-')
hold off
xlabel("HPA")
ylabel("3 day")
title("Forecast")
legend(["Observed" "Forecast"])

fend = figure;
subplot(2,1,1)
plot(YTest)
hold on
plot(YPred,'.-')
hold off
legend(["Observed" "Predicted"])
ylabel("HPA")
title("Forecast with Updates")

subplot(2,1,2)
stem(YPred - YTest)
xlabel("3 day")
ylabel("Error")
title("RMSE = " + rmse(:,end))
% set(fend,"position",[0,0,1920,1080]);
% saveas(fend,"data/outputs/test.jpg","position",[0,0,1920,1080]);