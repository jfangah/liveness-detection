function [result2,pic] = test(img)
        image = img;
        image = imresize(image, [200 200]);%将图像resize成200*200大小
        Highlight=image;
        I=rgb2gray(image); %彩色图转成灰度图
        [x,y]=size(I);   %获取图像的大小
        BW=edge(I);%,'canny');      %获得图像的边缘

        rho_max=floor(sqrt(x^2+y^2))+1; %由原图数组坐标算出ρ最大值，并取整数部分加1
        %此值作为ρ，θ坐标系ρ最大值
        accarray=zeros(rho_max,180); %定义ρ，θ坐标系的数组，初值为0。
        %θ的最大值，180度

        Theta=[0:pi/180:pi]; %定义θ数组，确定θ取值范围

        for n=1:x,
            for m=1:y
                if BW(n,m)==1
                    for k=1:180
                        %将θ值代入hough变换方程，求ρ值
                        rho=(m*cos(Theta(k)))+(n*sin(Theta(k)));
                        %将ρ值与ρ最大值的和的一半作为ρ的坐标值（数组坐标），这样做是为了防止ρ值出现负数
                        rho_int=round(rho/2+rho_max/2);
                        %在ρθ坐标（数组）中标识点，即计数累加
                        accarray(rho_int,k)=accarray(rho_int,k)+1;
                    end
                end
            end
        end

        %=======利用hough变换提取直线======%
        %寻找100个像素以上的直线在hough变换后形成的点
        K=1; %存储数组计数器
        for rho_n=1:rho_max %在hough变换后的数组中搜索
            for theta_m=1:180
                if accarray(rho_n,theta_m)>=100 %设定直线的最小值。
                    case_accarray_n(K)=rho_n; %存储搜索出的数组下标
                    case_accarray_m(K)=theta_m;
                    K=K+1;
                end
            end
        end

       %=====把这些点构成的直线提取出来,输出图像数组为I_out===%
        I_out=zeros(x,y);
        I_jiao_class=zeros(x,y);
        count_all=zeros(1,K-1);
        dis_all=zeros(1,K-1);
        for n=1:x,
            for m=1:y
                 if BW(n,m)==1
                     for k=1:180
                      rho=(m*cos(Theta(k)))+(n*sin(Theta(k)));
                      rho_int=round(rho/2+rho_max/2);
                      %如果正在计算的点属于100像素以上点，则把它提取出来
                        for a=1:K-1
                            if rho_int==case_accarray_n(a)&k==case_accarray_m(a)%%%==gai==%%% k==case_accarray_m(a)&rho_int==case_accarray_n(a)
                                I_out(n,m)=BW(n,m);    
                                % fprintf('( %d ,%d)\n',n,m);
                                %计算边界像素点的像素和（像素差体现不出黑白像素之间的差异
                                 if m>=197 || m<=3 || n>=197 || n<=3 %边界点像素点之和
                                    distance = 50;
                                    minnum = 100;
                                 else
                                     distance = abs(double(I(n-3,m))+double(I(n+3,m))) + abs(double(I(n,m-3))+double(I(n,m+3)));%非边界点像素值之和，可调整阈值
                                     minnum = min([double(I(n-3,m)), double(I(n+3,m)), double(I(n,m-3)), double(I(n,m+3))]);
                                     maxnum = max([double(I(n-3,m)), double(I(n+3,m)), double(I(n,m-3)), double(I(n,m+3))]);
                                     %distance = abs(double(I(n-1,m))-double(I(n+1,m))) + abs(double(I(n,m-1))-double(I(n,m+1)));

                                 end
                                %计算每一个边界数组的像素和平均用于判别真假边界
                                count_all(a)=count_all(a)+1;
                                dis_all(a)=dis_all(a)+double(distance);
                                meandistance(a)=dis_all(a)/count_all(a);
                                %像素和小于500判定为真边界，否则为假边界，此步不知道放的循环位置对不对，应在直线判断完毕的像素中进行再判断
                                if meandistance(a) <= 650 && minnum <= 50 %可调整阈值，真假边框判断条件之一
%                                     I_out(n,m)=1;
                                    if 3<=m<=197 && 3<=n<=197
                                        I_out(n,m)=1;
                                    end
                                    %fprintf('black bord photo');
                                else
                                    I_out(n,m)=0;
                                   % fprintf('no black bord photo');
                                end
                                %for p=0:5 %在原RGB图像上高亮
                                %Highlight(n,m+p,1)=255;
                                %Highlight(n,m+p,2)=0;
                                %Highlight(n,m+p,3)=0;
                                %end
                                %I_jiao_class(n,m)=k;
                            end 
                        end
                     end
                 end
            end
        end
        %统计直线检测结果中直线包含像素的个数，超过一定阈值则判断为黑框
        thereshold = sum(I_out(:)==1);
        if thereshold > 30
            result2 = 1;%有黑框
        else
            result2 = 0;%无黑框
        end
        pic=I_out;

%             figure;
%             subplot(1,3,1);
%             imshow(image);
%             title('原图');
% 
%             
%             % figure;
%             subplot(1,3,2);
%             imshow(BW);
%             title('边缘检测图');
% 
%             
%             % figure;
%             subplot(1,3,3);
%             imshow(I_out);
%             title('Hough变换检测出的直线');
end
            
            
            