function [result2,pic] = test(img)
        image = img;
        image = imresize(image, [200 200]);%��ͼ��resize��200*200��С
        Highlight=image;
        I=rgb2gray(image); %��ɫͼת�ɻҶ�ͼ
        [x,y]=size(I);   %��ȡͼ��Ĵ�С
        BW=edge(I);%,'canny');      %���ͼ��ı�Ե

        rho_max=floor(sqrt(x^2+y^2))+1; %��ԭͼ����������������ֵ����ȡ�������ּ�1
        %��ֵ��Ϊ�ѣ�������ϵ�����ֵ
        accarray=zeros(rho_max,180); %����ѣ�������ϵ�����飬��ֵΪ0��
        %�ȵ����ֵ��180��

        Theta=[0:pi/180:pi]; %��������飬ȷ����ȡֵ��Χ

        for n=1:x,
            for m=1:y
                if BW(n,m)==1
                    for k=1:180
                        %����ֵ����hough�任���̣����ֵ
                        rho=(m*cos(Theta(k)))+(n*sin(Theta(k)));
                        %����ֵ������ֵ�ĺ͵�һ����Ϊ�ѵ�����ֵ���������꣩����������Ϊ�˷�ֹ��ֵ���ָ���
                        rho_int=round(rho/2+rho_max/2);
                        %�ڦѦ����꣨���飩�б�ʶ�㣬�������ۼ�
                        accarray(rho_int,k)=accarray(rho_int,k)+1;
                    end
                end
            end
        end

        %=======����hough�任��ȡֱ��======%
        %Ѱ��100���������ϵ�ֱ����hough�任���γɵĵ�
        K=1; %�洢���������
        for rho_n=1:rho_max %��hough�任�������������
            for theta_m=1:180
                if accarray(rho_n,theta_m)>=100 %�趨ֱ�ߵ���Сֵ��
                    case_accarray_n(K)=rho_n; %�洢�������������±�
                    case_accarray_m(K)=theta_m;
                    K=K+1;
                end
            end
        end

       %=====����Щ�㹹�ɵ�ֱ����ȡ����,���ͼ������ΪI_out===%
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
                      %������ڼ���ĵ�����100�������ϵ㣬�������ȡ����
                        for a=1:K-1
                            if rho_int==case_accarray_n(a)&k==case_accarray_m(a)%%%==gai==%%% k==case_accarray_m(a)&rho_int==case_accarray_n(a)
                                I_out(n,m)=BW(n,m);    
                                % fprintf('( %d ,%d)\n',n,m);
                                %����߽����ص�����غͣ����ز����ֲ����ڰ�����֮��Ĳ���
                                 if m>=197 || m<=3 || n>=197 || n<=3 %�߽�����ص�֮��
                                    distance = 50;
                                    minnum = 100;
                                 else
                                     distance = abs(double(I(n-3,m))+double(I(n+3,m))) + abs(double(I(n,m-3))+double(I(n,m+3)));%�Ǳ߽������ֵ֮�ͣ��ɵ�����ֵ
                                     minnum = min([double(I(n-3,m)), double(I(n+3,m)), double(I(n,m-3)), double(I(n,m+3))]);
                                     maxnum = max([double(I(n-3,m)), double(I(n+3,m)), double(I(n,m-3)), double(I(n,m+3))]);
                                     %distance = abs(double(I(n-1,m))-double(I(n+1,m))) + abs(double(I(n,m-1))-double(I(n,m+1)));

                                 end
                                %����ÿһ���߽���������غ�ƽ�������б���ٱ߽�
                                count_all(a)=count_all(a)+1;
                                dis_all(a)=dis_all(a)+double(distance);
                                meandistance(a)=dis_all(a)/count_all(a);
                                %���غ�С��500�ж�Ϊ��߽磬����Ϊ�ٱ߽磬�˲���֪���ŵ�ѭ��λ�öԲ��ԣ�Ӧ��ֱ���ж���ϵ������н������ж�
                                if meandistance(a) <= 650 && minnum <= 50 %�ɵ�����ֵ����ٱ߿��ж�����֮һ
%                                     I_out(n,m)=1;
                                    if 3<=m<=197 && 3<=n<=197
                                        I_out(n,m)=1;
                                    end
                                    %fprintf('black bord photo');
                                else
                                    I_out(n,m)=0;
                                   % fprintf('no black bord photo');
                                end
                                %for p=0:5 %��ԭRGBͼ���ϸ���
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
        %ͳ��ֱ�߼������ֱ�߰������صĸ���������һ����ֵ���ж�Ϊ�ڿ�
        thereshold = sum(I_out(:)==1);
        if thereshold > 30
            result2 = 1;%�кڿ�
        else
            result2 = 0;%�޺ڿ�
        end
        pic=I_out;

%             figure;
%             subplot(1,3,1);
%             imshow(image);
%             title('ԭͼ');
% 
%             
%             % figure;
%             subplot(1,3,2);
%             imshow(BW);
%             title('��Ե���ͼ');
% 
%             
%             % figure;
%             subplot(1,3,3);
%             imshow(I_out);
%             title('Hough�任������ֱ��');
end
            
            
            