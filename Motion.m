clc;clear %��ʽ��

mbSize = 8;      % ��ߴ�Ϊ8*8
wind = 5;			  % ƥ�����Ϊ(2wind+1)*(2wind+1)

imgI = imread('18.png');     % ����ο�֡
img = imread('20.png');      % ���嵱ǰ֡
subplot(341); imshow(imgI); title('�ο�֡');
subplot(342); imshow(img); title('��ǰ֡');

%תΪ��ɫͼ��
imgI = double(rgb2gray(imgI));
img = double(rgb2gray(img));


%���ڿ��ȫ�����㷨 
[motionVect, blk_center,counter,t1] = fullSearch(img, imgI, mbSize, wind); 

subplot(345); imshow(uint8(img)); title('FS�˶�ʸ��ͼ'); hold on
% �ο�ָ֡��ǰ֡
%��ͼ�����е�ÿһ֡�ֳ���໥���ص��ĺ�飬
%��ÿ����鵽�ο�֡ĳһ�����ض�������Χ�ڸ���һ����ƥ��׼���ҳ���֮�����Ƶ�ƥ���
%���߼�����λ�Ƽ�Ϊ�˶�ʸ��
y = blk_center(1, : );
x = blk_center(2, : );
v = -motionVect(1, : );
u = -motionVect(2, : ); 
quiver(x, y, u, v, 'g');
hold on

%�˶��������ͼ�񣺸����˶�ʸ������Ԥ��֡��������в�֡
%ͨ����ǰ�ľֲ�ͼ����˶�ʸ����Ԥ�⡢������ǰ�ľֲ�ͼ��
imgComp = forcastCompensate(imgI, motionVect, mbSize); 

subplot(346); imshow(uint8(imgComp));
title('FSԤ��֡');
 
imgErr = img - imgComp; %�в�֡
cal = Calibration(imgErr); %�궨
subplot(347); imshow(cal); title('FS�в�֡');
 
%�����˶�ʸ��ָ����λ�ü��в�֡�ؽ�ͼ��
rebuild = imgComp + imgErr; 
subplot(348); imshow(uint8(rebuild)); title('FS�ؽ�֡');

fprintf('ƥ��׼���Ǿ������ͣ�\t���С��%d��\t������Χw��С��%d\n',mbSize,wind)
fprintf('ȫ����������������%d��\t����ʱ����%6.8f s\n',counter,t1)


%���ڿ�������������㷨 
[motionVect1, blk_center1,counter1,t2] = TSSearch(img, imgI, mbSize, wind);  

subplot(349); imshow(uint8(img)); title('TSS�˶�ʸ��ͼ'); hold on
% �ο�ָ֡��ǰ֡
y1 = blk_center1(1, : );
x1 = blk_center1(2, : );
v1 = -motionVect1(1, : );
u1 = -motionVect1(2, : ); 
quiver(x, y, u, v, 'g');
hold on

%�˶��������ͼ�񣺸����˶�ʸ������Ԥ��֡��������в�֡
imgComp1 = forcastCompensate(imgI, motionVect1, mbSize); 

subplot(3,4,10); imshow(uint8(imgComp1));
title('TSSԤ��֡');
 
imgErr1 = img - imgComp1; %�в�֡
cal1 = Calibration(imgErr1); %�궨
subplot(3,4,11); imshow(cal1); title('TSS�в�֡');
 
%�����˶�ʸ��ָ����λ�ü��в�֡�ؽ�ͼ��
rebuild1 = imgComp1 + imgErr1; 
subplot(3,4,12); imshow(uint8(rebuild1)); title('TSS�ؽ�֡');

fprintf('����������������������%d��\t����ʱ����%6.8f s\n',counter1,t2)





