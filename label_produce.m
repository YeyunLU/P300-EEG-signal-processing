TRUE_A='WQXPLZCOMRKO97YFZDEZ1DPI9NNVGRQDJCUVRMEUOOOJD2UFYPOO6J7LDGYEGOA5VHNEHBTXOO1TDOILUEE5BFAEEXAW_K4R3MRU';
%TRUE_B='MERMIROOMUHJPXJOHUVLEORZP3GLOO7AUFDKEFTWEOOALZOP9ROCGZET1Y19EWX65QUYU7NAK_4YCJDVDNGQXODBEV2B5EFDIDNR';
%TRUE_A='EAEVQTDOJG8RBRGONCEDHCTUIDBPUHMEM6OUXOCFOUKWA4VJEFRZROLHYNQDW_EKTLBWXEPOUIKZERYOOTHQI';
screen=char('A','B','C','D','E','F',...
            'G','H','I','J','K','L',...
            'M','N','O','P','Q','R',...
            'S','T','U','V','W','X',...
            'Y','Z','1','2','3','4',...
            '5','6','7','8','9','_');
epoch=100;%100/85    
blo_num=1;%1:15
label=zeros(epoch*blo_num*12,1);
for i=1:epoch
    index=find(screen(:)==TRUE_A(i));
    if (mod(index,6)==0)
        col=6;
        row=fix(index/6)+6;
    else
        row=fix(index/6)+1+6;
        col=mod(index,6);
    end
    for j=1:blo_num
       label((i-1)*12*blo_num+(j-1)*12+col)=1;
       label((i-1)*12*blo_num+(j-1)*12+row)=1;
    end
end
%改为正负1的label，方便w设置
for i=1:size(label)
    if (label(i)==0)
        label(i)=-1;
    end
end
%save test_label