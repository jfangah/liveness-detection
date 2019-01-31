clc;
imageList = '300W_train_images.txt';
landmarkList = '300W_train_pts.txt';
addpath(genpath('lib'));
model = SDMInitModel('sdm-68');
nSynth = 5;
data = SDMAddDataMemoryFrugal(imageList, landmarkList, nSynth, model)