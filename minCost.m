%% �������С��������ֵ�ĺ������ҳ�������С���۵Ŀ���±�
function [dx,dy] = minCost(costs)
% Input
%       costs : ������ǰ��������˶����������۵�SAD����
% Output
%       dx : MV�Ĵ�ֱ��������λ�ƣ�
%       dy : MV��ˮƽ��������λ�ƣ�

    minc = min(min(costs));
    [dx, dy] = find(costs == minc);
    dx = dx(1);
    dy = dy(1);    
end