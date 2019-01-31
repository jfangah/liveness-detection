function varargout = final(varargin)
% FINAL MATLAB code for final.fig
%      FINAL, by itself, creates a new FINAL or raises the existing
%      singleton*.
%
%      H = FINAL returns the handle to a new FINAL or the handle to
%      the existing singleton*.
%
%      FINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL.M with the given input arguments.
%
%      FINAL('Property','Value',...) creates a new FINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final

% Last Modified by GUIDE v2.5 11-May-2018 23:17:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final_OpeningFcn, ...
                   'gui_OutputFcn',  @final_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before final is made visible.
function final_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final (see VARARGIN)

% Choose default command line output for final
handles.output = hObject;
imaqhwinfo('winvideo');
vid1=videoinput('winvideo',1,'YUY2_640x480');
handles.vid1 = vid1;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes final wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = final_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vid1 = handles.vid1;
preview(vid1);
filename = 'film';
nframe = 45;       
nrate = 15;
MakeVideo(vid1, filename, nframe, nrate,0);
filename1='film.avi';
set(handles.text11, 'string', filename1);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
obj = VideoReader('film.avi');  
fnum = obj.NumberOfFrames;  
temp=0;
resultnum=0;%活体检测结果，0表示不通过，1表示通过
flag1=0;%摩尔纹检测初始化为0,0为通过摩尔纹检测,-1表示未进行检测
flag2=0;%黑框检测初始化为0,0为通过黑框检测，-1表示未进行检测
 for i = 1:2:fnum  
    I=read(obj,i);
    digital=run(I);
    if digital<0.25
        temp=temp+1;
    end                      %%眨眼检测，0表示不通过，通过测显示眨眼次数
 end 
 
 if temp>2
     for i=1:5:fnum
        I=read(obj,i); 
        [result2,pic] = test(I);  %黑框检测
        if result2==1
            flag2=1;
            flag1=-1;
            resultnum=0;
            break;
        end
        result = moerDetection(I);  %摩尔纹检测
        if result==1
            flag1=1;
            resultnum=0;
            break;
        end
%         [result2,pic] = test(I);  %黑框检测
%         if result2==1
%             flag2=1;
%         end
        resultnum=1;
     end
 else
     temp=0;
     flag1=-1;
     flag2=-1;
     resultnum=0;
 end
temp;
set(handles.text7, 'string', temp);
flag1;
set(handles.text8, 'string', flag1);
flag2;
set(handles.text9, 'string', flag2);
set(handles.text10, 'string', resultnum);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete('*.avi');
filename2='无视频';
set(handles.text11, 'string', filename2);
