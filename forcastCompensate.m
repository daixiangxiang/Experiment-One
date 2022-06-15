%% ��Ԥ��֡�ĺ������ɸ������˶�ʸ�������˶���������Ԥ��֡
function imgCompensate = forcastCompensate(imgI, motionVect, mbSize)
% Input
%       imgI : �ο�֡
%       motionVect : MV��dxΪ��ֱ������dyΪˮƽ������
%   	mbSize : MB�ߴ�
% Ouput
%   	imgComp : �˶��������ͼ��
    [row,col]=size(imgI);
    mb_cnt=1;
    for i = 1:mbSize:row-mbSize+1                
        for j = 1:mbSize:col-mbSize+1 
             ref_blk_row=i+motionVect(1,mb_cnt); %�ο�֡��������ʼ��
             ref_blk_col=j+motionVect(2,mb_cnt); %�ο�֡��������ʼ��
             imgCompensate(i:i+mbSize-1,j:j+mbSize-1)=imgI(ref_blk_row:ref_blk_row+mbSize-1,ref_blk_col:ref_blk_col+mbSize-1);   
             mb_cnt=mb_cnt+1;
        end
    end
end
