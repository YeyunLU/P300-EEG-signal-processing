

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

% [b,a] = butter(1,12*2/240);%8�װ�����˹��ͨ�˲�������ֹƵ��Ϊ12Hz
% for i=1:85
%     for j=1:64
%         sig_filter=Signal(i,:,j);
%         Signal(i,:,j)=filter(b,a,sig_filter);
%     end
% end

[b,a] = cheby2(8,40,12*2/240);%8���б�ѩ���˲�������ֹƵ��Ϊ12Hz
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
    % get reponse samples at start of each Flash ����1-12��˳��洢�Ե��ź����ݵ�response
    rowcolcnt=ones(1,12);
    for n=2:7560%
        if Flashing(epoch,n)==0 && Flashing(epoch,n-1)==1 %һ����˸�Ŀ�ʼ
            rowcol=StimulusCode(epoch,n-1);%��ȡ�д���
               
            responses((rowcol-1)*15+rowcolcnt(rowcol),:,:)=Signal(epoch,n-24:n+window-25,:);%response�������ַ�n��n�ļ���������ʱ�䴰�ڵ����ݣ�64ͨ����Signal���ַ������ڣ�64��ͨ��
            rowcolcnt(rowcol)=rowcolcnt(rowcol)+1;%ʵ�ּ������ܣ��������StimulusCode������Code
         
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

