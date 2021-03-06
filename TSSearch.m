%% 三步法算法：TSS
function [vectors,blk_center, counter, tStop] = TSSearch(imgP, imgI, mbSize, p)
% Input
%   	img : 当前帧
%   	imgI : 参考帧
%   	mbSize : MB尺寸
%   	p: 搜索窗口大小（2wind+1）×（2wind+1）
% Ouput
%   	vectors : 整像素精度MV
%   	blk_center：中心点坐标
%       counter：搜索次数
%       tStop：搜索运行时间

    [row, col] = size(imgP);
    blk_center = zeros(2, row*col/(mbSize^2)); 
    %定义每个宏块中心点位置
    vectors = zeros(2,row*col/(mbSize^2)); %定义每个宏块运动矢量
    costs = ones(3,3)*100000;
    counter = 0; %搜索的点数之和
    
    %求步数
    L=floor(log10(p+1)/log10(2));
    stepMax=2^(L-1);
    
    
    %从左上角开始
    mb_cnt= 1;
    tic; 
    
    for i = 1:mbSize:row-mbSize+1     %当前帧起始行搜索范围，步长是块数 
        for j = 1:mbSize:col-mbSize+1 %当前帧起始列搜索范围，步长是块数
            
            %TSS，每步评估9个元素
            x=i;
            y=j;
            
            costs(2,2) =...
                        costSAD(imgP(i:i+mbSize-1,j:j+mbSize-1),imgI(i:i+mbSize-1,j:j+mbSize-1));
            %counter = counter+1;
            stepSize= stepMax;
            while(stepSize>=1)   
                for m= -stepSize: stepSize:stepSize
                    for n= -stepSize: stepSize:stepSize
                    ref_blk_row = x+m; %参考帧搜索框起始行
                    ref_blk_col = y+n; %参考帧搜索框起始列
                    %超出搜索范围
                        if (ref_blk_row<1||ref_blk_row+mbSize-1>row||ref_blk_col<1||ref_blk_col+mbSize-1>col)                     
                            continue;                                                            
                        end

                        costRow=m/stepSize + 2;
                        costCol=n/stepSize + 2;
                        if(costRow==2&& costCol==2)
                            continue;                                                            
                        end
                    %计算SAD
                    costs(costRow,costCol) =...
                        costSAD(imgP(i:i+mbSize-1,j:j+mbSize-1),imgI(ref_blk_row:ref_blk_row+mbSize-1,ref_blk_col:ref_blk_col+mbSize-1));
                    counter = counter+1;
                end
            end
            [dx,dy]=minCost(costs); %找出有最小代价的块的下标
            x=x+(dx-2)*stepSize;
            y=y+(dy-2)*stepSize;
            
            stepSize=stepSize/2;
            costs(2,2)=costs(dx,dy);
         end
            
           
            vectors(1,mb_cnt) = x-i; %垂直运动矢量
            vectors(2,mb_cnt) = y-j; %水平运动矢量
            blk_center(1,mb_cnt) = i+ mbSize/2-1; %记录中心点行坐标                     
            blk_center(2,mb_cnt) = j+ mbSize/2-1; %记录中心点列坐标
            mb_cnt = mb_cnt+1;
            costs = ones(3,3)*65537;
         end
    end 
    tStop = toc; 

end