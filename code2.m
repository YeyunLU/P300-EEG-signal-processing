 clear all
% 
% %% load data
%% 加载数据 
load('train3.mat');
load('test3.mat');
%% 选取通道
 train=train(:,:,[34,11,51,62,9,13]);
 test=test(:,:,[34,11,51,62,9,13]);
 train=reshape(train,[size(train,1) size(train,2)*size(train,3)]);
 test=reshape(test,[size(test,1) size(test,2)*size(test,3)]);

TRUE_A='WQXPLZCOMRKO97YFZDEZ1DPI9NNVGRQDJCUVRMEUOOOJD2UFYPOO6J7LDGYEGOA5VHNEHBTXOO1TDOILUEE5BFAEEXAW_K4R3MRU';
%TRUE_B='MERMIROOMUHJPXJOHUVLEORZP3GLOO7AUFDKEFTWEOOALZOP9ROCGZET1Y19EWX65QUYU7NAK_4YCJDVDNGQXODBEV2B5EFDIDNR';
%% 6 X 6 onscreen matrix
screen=char('A','B','C','D','E','F',...
            'G','H','I','J','K','L',...
            'M','N','O','P','Q','R',...
            'S','T','U','V','W','X',...
            'Y','Z','1','2','3','4',...
            '5','6','7','8','9','_');
% %     
% % %% 通道选取,PCA降维
% %rate=zeros(3060,64);
% %sum_num=0;
% for i=1:3060
% feature=train_avg(i,:,:);
% feature=reshape(feature,240,64);
% [pc,score,latent,tsquare] = pca(feature);
% tran=pc(:,1:8);
% feature= bsxfun(@minus,feature,mean(feature,1));
% PCA_train(i,:,:)= feature*tran;
% end
% train=reshape(PCA_train,[3060 240*8]);
% 
% 
% for i=1:18000
% feature2=test(i,:,:);
% feature2=reshape(feature2,240,64);
% [pc2,score2,latent2,tsquare2] = pca(feature2);
% tran2=pc(:,1:8);
% feature2= bsxfun(@minus,feature2,mean(feature2,1));
% PCA_test(i,:,:)= feature2*tran2;
% end
% test=reshape(PCA_test,[18000 240*8]);
  

%%  归一化   
%[train_scale,test_scale,ps] =scaleForSVM(train(:,:,11),test(:,:,11),0,1);%单通道
[train_scale,test_scale,ps]=scaleForSVM(train,test,0,1);%多通道
 
%%  参数寻优  
[bestacc,bestc,bestg]=SVMcgForClass(label,train_scale,2,5,-3,0,5,0.5,0.5,4.5);
 
%%   训练与测试   
 model = libsvmtrain(label,train_scale,'-c 4 -g 0.25');
[predict_label,accuracy,scores]=libsvmpredict(test_label,test_scale,model);

%%   字符预测
pre_colrow=zeros(100,12);
in=zeros(100,1);
acc=0;
for i=1:100   
        ind=(i-1)*12;
        pre_colrow(i,:)=scores(ind+1:ind+12);   
       [~,col]=max(pre_colrow(i,1:6));
       [~,row]=max(pre_colrow(i,7:12));
       index(i)=(row-1)*6+col;  
       if (screen(index(i))==TRUE_A(i))
          acc=acc+1;
       end
end
final_acc=acc/100
