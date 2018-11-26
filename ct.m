clear all;
clc;
tic
N_of_proj = 50;
N_of_sensor = 1024;
N_of_sensor = N_of_sensor - 1;
%This is an input image matrix

myim = imread('tomo.png');
dim = length(myim);
dim_zeros = dim*2;
diff = dim_zeros - dim;
c_diff = ceil(diff/2);
G = zeros(dim_zeros);
G(c_diff:c_diff+dim-1,c_diff:c_diff+dim-1) = myim(:,:,2);
% G(c_diff:c_diff+dim-1,c_diff:c_diff+dim-1) = 255;


%Create Projection Matrix
P = zeros(N_of_proj,N_of_sensor);

X = 1:dim_zeros;
Y = 1:dim_zeros;
% 
deg = 1;
sensor=1;
for a =0:pi/N_of_proj:pi-0.0001
    
for i = (-dim_zeros/2):(dim_zeros/N_of_sensor):(dim_zeros/2)
    if(a<=pi/2)
    % BEAM STARTS
    y = tan(a)*(X-(dim_zeros/2)+i)+(dim_zeros/2)+i;
    x = (cot(a))*(Y-(dim_zeros/2)-i)+(dim_zeros/2)-i;
    sX = [X x];
    sY = [Y y];
    sX = sort(sX);
    sY = sort(sY);
    end
    if(a>pi/2)
    % BEAM STARTS
    y = tan(a)*(X-(dim_zeros/2)-i)+(dim_zeros/2)+i;
    x = (cot(a))*(Y-(dim_zeros/2)-i)+(dim_zeros/2)+i;
    sX = [X x];
    sY = [Y y];
    sX = sort(sX);
    sY = fliplr(sort(sY));
    end
%     Boundry by dim_zeros
    ind = find(sX<0 | sX>=dim_zeros | sY<0 | sY>=dim_zeros);
    sX(ind)=[];
    sY(ind)=[];
    sum = 0;
    for j = 1:length(sX)-1
        gX = ceil(sX(j));
        gY = ceil(sY(j));
        if(gX == 0)
            gX = 1;
        end
        if(gY == 0)
            gY = 1;
        end
        val = G(gX,gY);
        l = ((sX(j+1)-sX(j))^2+(sY(j+1)-sY(j))^2)^0.5;
        sum = sum +l*val;
    end
    
    P(deg,sensor) = sum/length(sX);
    sensor = sensor + 1;
%    
%     plot(sX,sY,'g')
%     pause(0.005);
%     
  
end
    sensor = 1;
    deg =deg +1;
% hold off;
% image(G);
% colormap bone;
% hold on;
% xlim([-300 dim_zeros+300]) 
% ylim([-300 dim_zeros+300])

end
toc
%% ANIMATE PROJECTÝONS
P(isnan(P))=0;
for i = 1:N_of_proj
    
    plot(P(i,:));
    pause(0.1);
end
