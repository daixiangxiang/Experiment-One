%% ȫ�����㷨��Full Search/Exhaustive Search
function [motionVect,blk_center,counter, tStop] = fullSearch(imgP, imgI, mbSize, wind)
% Input
%   	img : ��ǰ֡
%   	imgI : �ο�֡
%   	mbSize : MB�ߴ�
%   	wind : �������ڴ�С��2wind+1������2wind+1��
% Ouput
%   	motionVect : �����ؾ���MV
%   	blk_center�����ĵ�����
%       counter����������
%       tStop����������ʱ��
    [row, col] = size(imgP);
    blk_center = zeros(2, row*col/(mbSize^2)); 
    %����ÿ��������ĵ�λ��
    motionVect = zeros(2,row*col/(mbSize^2)); %����ÿ������˶�ʸ��
    costs = ones(2*wind+1,2*wind+1)*100000;
    counter = 0; %�����ĵ���֮��
    mb_cnt= 1;
    tic; 
    for i = 1:mbSize:row-mbSize+1     %��ǰ֡��ʼ��������Χ�������ǿ��� 
        for j = 1:mbSize:col-mbSize+1 %��ǰ֡��ʼ��������Χ�������ǿ���
            for m= -wind: wind
                for n= -wind: wind
                    ref_blk_row = i+m; %�ο�֡��������ʼ��
                    ref_blk_col = j+n; %�ο�֡��������ʼ��
                    %����������Χ
                    if (ref_blk_row<1||ref_blk_row+mbSize-1>row||ref_blk_col<1||ref_blk_col+mbSize-1>col)                     
                        continue;                                                            
                    end
                    %����SAD
                    costs(m+wind+1,n+wind+1) =...
                        costSAD(imgP(i:i+mbSize-1,j:j+mbSize-1),imgI(ref_blk_row:ref_blk_row+mbSize-1,ref_blk_col:ref_blk_col+mbSize-1));
                    counter = counter+1;
                end
            end
      
            blk_center(1,mb_cnt) = i+ mbSize/2-1; %��¼���ĵ�������                     
            blk_center(2,mb_cnt) = j+ mbSize/2-1; %��¼���ĵ�������
            [dx,dy]=minCost(costs); %�ҳ�����С���۵Ŀ���±�
            motionVect(1,mb_cnt) = dx-wind-1; %��ֱ�˶�ʸ��
            motionVect(2,mb_cnt) = dy-wind-1; %ˮƽ�˶�ʸ��
            mb_cnt = mb_cnt+1;
            costs = ones(2*wind+1,2*wind+1)*100000; %���¸�ֵ
         end
    end 
    tStop = toc;  
 
end