%% �������㷨��TSS
function [vectors,blk_center, counter, tStop] = TSSearch(imgP, imgI, mbSize, p)
% Input
%   	img : ��ǰ֡
%   	imgI : �ο�֡
%   	mbSize : MB�ߴ�
%   	p: �������ڴ�С��2wind+1������2wind+1��
% Ouput
%   	vectors : �����ؾ���MV
%   	blk_center�����ĵ�����
%       counter����������
%       tStop����������ʱ��

    [row, col] = size(imgP);
    blk_center = zeros(2, row*col/(mbSize^2)); 
    %����ÿ��������ĵ�λ��
    vectors = zeros(2,row*col/(mbSize^2)); %����ÿ������˶�ʸ��
    costs = ones(3,3)*100000;
    counter = 0; %�����ĵ���֮��
    
    %����
    L=floor(log10(p+1)/log10(2));
    stepMax=2^(L-1);
    
    
    %�����Ͻǿ�ʼ
    mb_cnt= 1;
    tic; 
    
    for i = 1:mbSize:row-mbSize+1     %��ǰ֡��ʼ��������Χ�������ǿ��� 
        for j = 1:mbSize:col-mbSize+1 %��ǰ֡��ʼ��������Χ�������ǿ���
            
            %TSS��ÿ������9��Ԫ��
            x=i;
            y=j;
            
            costs(2,2) =...
                        costSAD(imgP(i:i+mbSize-1,j:j+mbSize-1),imgI(i:i+mbSize-1,j:j+mbSize-1));
            %counter = counter+1;
            stepSize= stepMax;
            while(stepSize>=1)   
                for m= -stepSize: stepSize:stepSize
                    for n= -stepSize: stepSize:stepSize
                    ref_blk_row = x+m; %�ο�֡��������ʼ��
                    ref_blk_col = y+n; %�ο�֡��������ʼ��
                    %����������Χ
                        if (ref_blk_row<1||ref_blk_row+mbSize-1>row||ref_blk_col<1||ref_blk_col+mbSize-1>col)                     
                            continue;                                                            
                        end

                        costRow=m/stepSize + 2;
                        costCol=n/stepSize + 2;
                        if(costRow==2&& costCol==2)
                            continue;                                                            
                        end
                    %����SAD
                    costs(costRow,costCol) =...
                        costSAD(imgP(i:i+mbSize-1,j:j+mbSize-1),imgI(ref_blk_row:ref_blk_row+mbSize-1,ref_blk_col:ref_blk_col+mbSize-1));
                    counter = counter+1;
                end
            end
            [dx,dy]=minCost(costs); %�ҳ�����С���۵Ŀ���±�
            x=x+(dx-2)*stepSize;
            y=y+(dy-2)*stepSize;
            
            stepSize=stepSize/2;
            costs(2,2)=costs(dx,dy);
         end
            
           
            vectors(1,mb_cnt) = x-i; %��ֱ�˶�ʸ��
            vectors(2,mb_cnt) = y-j; %ˮƽ�˶�ʸ��
            blk_center(1,mb_cnt) = i+ mbSize/2-1; %��¼���ĵ�������                     
            blk_center(2,mb_cnt) = j+ mbSize/2-1; %��¼���ĵ�������
            mb_cnt = mb_cnt+1;
            costs = ones(3,3)*65537;
         end
    end 
    tStop = toc; 

end