tic
N_of_proj = 18;
%This is an input image matrix
dim = 512;
myim = imread('tomo.png');
dim_zeros = dim*2;
diff = dim_zeros - dim;
c_diff = ceil(diff/2);
G = zeros(dim_zeros);
G(c_diff:c_diff+dim-1,c_diff:c_diff+dim-1) = myim(:,:,2);


N_of_sensor = 200;
%Create Projection Matrix
P = zeros(N_of_proj,N_of_sensor);

X = 1:dim_zeros;
Y = 1:dim_zeros;
% 
for a = 0:pi/N_of_proj:pi
 
for i = (-dim_zeros/2):(1535/N_of_sensor):(dim_zeros/2)
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
    

    
%   X,y  x,Y
    plot(x,Y,'r')
    plot(sX,sY,'g')
    pause(0.005);

end
 
   
hold off;
image(G);
colormap bone;
hold on;
xlim([-300 dim_zeros+300]) 
ylim([-300 dim_zeros+300])

end
toc

