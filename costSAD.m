%% SAD���㺯�����Ը��������������SADֵ
function cost = costSAD(currentBlk,refBlk)
% Input
%       currentBlk : ��ǰ��
%       refBlk : �ο���
% Output
%       cost : ������֮��������ۣ�SAD��
    cost=sum(sum(abs(currentBlk-refBlk))); 
end