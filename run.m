function digital= run(img)
addpath(genpath('lib'));

load('300w.mat');
im = img;

imGray = rgb2gray(im);

% Run face detector and initialize
bbox = runFaceDet(imGray);
iPts = initPts(model, bbox, 0.75);

pts = SDMApply(imGray, iPts, model);

a=norm([pts(21,1) pts(21,2)]-[pts(25,1) pts(25,2)]);%����Ƥ������Ƥ�ľ���
b=norm([pts(22,1) pts(22,2)]-[pts(24,1) pts(24,2)]);
c=norm([pts(27,1) pts(27,2)]-[pts(31,1) pts(31,2)]);
d=norm([pts(28,1) pts(28,2)]-[pts(30,1) pts(30,2)]);
e=norm([pts(20,1) pts(20,2)]-[pts(23,1) pts(23,2)]);%���۽Ǽ����۽�
f=norm([pts(26,1) pts(26,2)]-[pts(29,1) pts(29,2)]);
digital=((a+b+c+d)/4)/((e+f)/2);
%pts����20-31���۾���21 21  27 28�������ĸ��㣬24 25 30 31�������ĸ���
%21-25   22-24   27-31  28-30