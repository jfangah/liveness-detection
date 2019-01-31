% 
% 
% make video from the camera
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%
%   written by alphashi            %
%   04\13\2013                        %
%   xdyxshi@sina.com             %
% %%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function MakeVideo( vid, filename, nframe,  N, Vformat )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% InPut:
%                vid��video input object
%       filename��name of the video
%         nframe��frame number of the video
%                  N�� frame rate per second
%      Vformat��video format     1��gray
%                                          others��color
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if Vformat == 1
    movieformat = 'grayscale';
    colorformat = 'gray';
else
    movieformat = 'rgb';
    colorformat = [];
end

%preview(vid);
set(1,'visible','off');
set(vid,'ReturnedColorSpace',movieformat);

writerObj = VideoWriter( [filename '.avi'] );
writerObj.FrameRate = N;
open(writerObj);

figure(2);
for ii = 1: nframe
    frame = getsnapshot(vid);
    imshow(frame);
    f.cdata = frame;
    f.colormap = colormap(colorformat) ;
    writeVideo(writerObj,f);
end
close(writerObj);
closepreview
close(figure(2));
    
    
    






