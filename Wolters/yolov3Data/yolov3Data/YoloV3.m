% Get YOLO detector
preTrainedDetector = yolov3ObjectDetector('tiny-yolov3-coco');

% Define the groundtruth boxes for image coco2
coco2GTboxesXYXY = [103 238 228 317;
                    283 219 373 294;
                    352 228 439 294;
                    447 227 520 285;
                    469 224 553 283;
                    575 218 632 262];
coco2GTboxesXYWH = coco2GTboxesXYXY;
coco2GTboxesXYWH(:, 3) = coco2GTboxesXYXY(:, 3) - coco2GTboxesXYXY(:, 1);
coco2GTboxesXYWH(:, 4) = coco2GTboxesXYXY(:, 4) - coco2GTboxesXYXY(:, 2);
coco2GTboxesXYWH2 = coco2GTboxesXYWH;
coco2GTboxesXYWH2(:,3) = coco2GTboxesXYWH(:,3)*1.2;
coco2GTboxesXYWH2(:,1) = coco2GTboxesXYWH(:,1)-coco2GTboxesXYWH(:,3)*0.1;
% Read image and detect objects
testImage = imread(".\coco2.jpg");
[predictedBboxes,predictedScores,predictedLabels] = detect(preTrainedDetector, testImage, SelectStrongest=false, Threshold=0.3); % Enabling SelectStrongest applies non-maximum suppression.

groundTruthVisualization =    insertObjectAnnotation(testImage,'rectangle', coco2GTboxesXYWH, "zebra");
groundTruthVisualization2 = insertObjectAnnotation(testImage,'rectangle', coco2GTboxesXYWH2, "zebra");
predictedScoreVisualization = insertObjectAnnotation(testImage,'rectangle',predictedBboxes,predictedScores);
predictedLabelVisualization = insertObjectAnnotation(testImage,'rectangle',predictedBboxes,predictedLabels);

% Visualize
f = figure(1);
f.Position = [0,0, 1920, 1080];
subplot(1,2,1)
imshow(groundTruthVisualization)
title('Ground truth labels')
subplot(1,2,2)
imshow(predictedScoreVisualization) % Feel free to replace with predictedLabelVisualization
title('YOLO predicted boxes with scores')
% Your code for the assignment here:
IoUs = [0.1,0.3,0.5,0.7,0.9];

for i = 1:length(IoUs)
    [predictedBboxes,predictedScores,predictedLabels] = detect(preTrainedDetector, testImage, SelectStrongest=false, Threshold=IoUs(i));
    predictedScoreVisualization = insertObjectAnnotation(testImage,'rectangle',predictedBboxes,predictedScores);

    figure(i+1)
    filename = strcat("Exports/confidence_",string(IoUs(i)*10),".png");
    imshow(predictedScoreVisualization);
    saveas(gcf,filename);
end

% 4b

f = figure(2);
f.Position = [0,0, 1920, 1080];
subplot(1,2,1)
imshow(groundTruthVisualization)
title('Ground truth labels')
subplot(1,2,2)
imshow(groundTruthVisualization2) % Feel free to replace with predictedLabelVisualization
title('Ground truth labels 20% wider')
% Your code for the assignment here:
IoUs = [0.1,0.3,0.5,0.7,0.9];
