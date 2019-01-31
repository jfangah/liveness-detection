function result = moerDetection(img)
caffe_path='F:\caffe\caffe-master\Build\x64\Release';
addpath(genpath(caffe_path));
model ='E:\浙大各科课程相关\大四\毕设\matlab\my\ResNet-50-deploy.prototxt';
weights = 'E:\浙大各科课程相关\大四\毕设\matlab\my\resnet-50_iter_20000.caffemodel';
th = 0.593;
% use cpu
caffe.set_mode_cpu();
% caffe.reset_all();
% load face model and creat network
net = caffe.Net(model, weights, 'test');
d = load('mean.mat');
mean_data = d.image_mean;

num = 0;
step = 1;
N = 224;

img = rgb2gray(img);
[height, width,~] = size(img);
count = 0;
score = 0;
if height < N && width < N
    img = imresize(img, [N, N]);
    im_data = permute(img, [2, 1]);  % flip width and height
    im_data = single(im_data);  % convert from uint8 to single
    %         im_data = imresize(im_data, [IMAGE_DIM IMAGE_DIM], 'bilinear');  % resize im_data
    im_data = im_data - mean_data;
    input_data = {im_data};
    scores = net.forward(input_data);
    Scores = scores{1}(2);
    cropNums = 1;
else
    if height < N
        img = imresize(img, [N, width]);
    elseif width < N
        img = imresize(img, [height, N]);
    end
    for m = 0.001 : step : height / N - 0.99
        for n = 0.001 : step : width / N - 0.99
            rect.x = ceil(n*N);
            rect.y = ceil(m*N);
            rect.width = N;
            rect.height = N;
            crop = img(rect.y : rect.y + rect.height-1, rect.x : rect.x + rect.width-1,:);
            count = count + 1;
            im_data = permute(crop, [2, 1]);  % flip width and height
            im_data = single(im_data);  % convert from uint8 to single
            %             im_data = imresize(im_data, [IMAGE_DIM IMAGE_DIM], 'bilinear');  % resize im_data
            im_data = im_data - mean_data;
            input_data = {im_data};
            scores = net.forward(input_data);
            score = score + scores{1}(2);
        end
    end
    Scores = score;
    cropNums = count;
end

value = Scores/cropNums;
if value >= th
    result = 1;
else
    result = 0;
end
end


