

close all; 
clear all; clc

TargetChar=[];
%StimulusType=[];

fprintf(1, 'Collecting Responses and Performing classification... \n\n' );
%load 'Subject_A_Train.mat' % load data file
load 'Subject_A_Test.mat'
window=240; % window after stimulus (700ms)
%channel=11; % only using Cz for analysis and plots
blo_num=1;
mean_num=15/blo_num;


% convert to double precision
Signal=double(Signal);
Flashing=double(Flashing);
StimulusCode=double(StimulusCode);
%StimulusType=double(StimulusType);

% [b,a] = butter(1,12*2/240);%8阶巴特沃斯低通滤波器，截止频率为12Hz
% for i=1:85
%     for j=1:64
%         sig_filter=Signal(i,:,j);
%         Signal(i,:,j)=filter(b,a,sig_filter);
%     end
% end

[b,a] = cheby2(8,40,12*2/240);%8阶切比雪夫滤波器，截止频率为12Hz
for i=1:size(Signal,1)
    for j=1:64
        sig_filter=Signal(i,:,j);
        Signal(i,:,j)=filter(b,a,sig_filter);
    end
end

% 6 X 6 onscreen matrix
screen=char('A','B','C','D','E','F',...
            'G','H','I','J','K','L',...
            'M','N','O','P','Q','R',...
            'S','T','U','V','W','X',...
            'Y','Z','1','2','3','4',...
            '5','6','7','8','9','_');

% for each character epoch

responses=zeros(180,240,64);
test=zeros(100*12*blo_num,240,64);
train=zeros(85*12*blo_num,240,64);
for epoch=1:size(Signal,1)%85
    % get reponse samples at start of each Flash 按照1-12的顺序存储脑电信号数据到response
    rowcolcnt=ones(1,12);
    for n=2:7560%
        if Flashing(epoch,n)==0 && Flashing(epoch,n-1)==1 %一次闪烁的开始
            rowcol=StimulusCode(epoch,n-1);%读取行代码
               
            responses((rowcol-1)*15+rowcolcnt(rowcol),:,:)=Signal(epoch,n-24:n+window-25,:);%response包含，字符n，n的计数次数，时间窗口的数据，64通道；Signal：字符，窗口，64个通道
            rowcolcnt(rowcol)=rowcolcnt(rowcol)+1;%实现计数功能，计数获得StimulusCode提名的Code
         
        end
    end
   
    % average and group responses by letter
    
    for rowcol=1:12 %for train data
      for block_num=1:blo_num
            index=(rowcol-1)*15+(block_num-1)*mean_num;
            mid=responses((index+1):(index+mean_num),:,:);
            test((epoch-1)*blo_num*12+(blo_num-1)*12+rowcol,:,:)=mean(mid,1); 
      end
    end
    
    
    %test((epoch-1)*180+(1:180),:,:)=responses(:,:,:); %for test data
    
end

