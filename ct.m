
function ct(proj,sensor,dim_func,path)
tic;
N_of_proj = proj;
N_of_sensor = sensor;
N_of_sensor = N_of_sensor - 1;
%This is an input image matrix
myim = imread(path);
dim = length(myim);
dim_zeros = dim*2;
diff = dim_zeros - dim;
c_diff = ceil(diff/2);
G = zeros(dim_zeros);
G(c_diff:c_diff+dim-1,c_diff:c_diff+dim-1) = myim(:,:,2);
%G(c_diff:c_diff+dim-1,c_diff:c_diff+dim-1) = 255;


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
%   Boundry by dim_zeros
    ind = find(sX<0 | sX>=dim_zeros | sY<0 | sY>=dim_zeros);
    sX(ind)=[];
    sY(ind)=[];
    sum  = 0;
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

    P(deg,sensor) = sum;
    sensor = sensor + 1;
% %     image(B);
%     pause(0.005);
%     
%    
%     plot(sX,sY,'g')
%     pause(0.005);
    
end
    sensor = 1;
    deg    = deg +1;
% hold off;
% image(G);
% colormap bone;
% hold on;
% xlim([-300 dim_zeros+300]) 
% ylim([-300 dim_zeros+300])

end
P(isnan(P))=0;
toc;
filter = ones(1,N_of_sensor+1);
a = 10;
b = 90;

filter(1:a+1) = sin(0:((pi/2)/(a)):(pi/2));
filter(b:N_of_sensor+1) = cos(0:((pi/2)/(N_of_sensor-b+1)):(pi/2));

P(isnan(P))=0;
i_ff = zeros(N_of_proj,N_of_sensor+1);
for i = 1:N_of_proj
    i_ff(i,:) = abs(ifft((fft(P(i,:)).*filter)));
end
deg = 1;
sensor=1;
dim_back = dim_func;
Xp = 1:dim_back;
Yp = 1:dim_back;
B  = zeros(dim_back);
for a =0:pi/N_of_proj:pi-0.0001
    
for i = (-dim_back/2):(dim_back/N_of_sensor):(dim_back/2)
    if(a<=pi/2)
    % BEAM STARTS
    yp = tan(a)*(Xp-(dim_back/2)+i)+(dim_back/2)+i;
    xp = (cot(a))*(Yp-(dim_back/2)-i)+(dim_back/2)-i;
    sXp = [Xp xp];
    sYp = [Yp yp];
    sXp = sort(sXp);
    sYp = sort(sYp);
    end
    if(a>pi/2)
    % BEAM STARTS
    yp = tan(a)*(Xp-(dim_back/2)-i)+(dim_back/2)+i;
    xp = (cot(a))*(Yp-(dim_back/2)-i)+(dim_back/2)+i;
    sXp = [Xp xp];
    sYp = [Yp yp];
    sXp = sort(sXp);
    sYp = fliplr(sort(sYp));
    end
%   Boundry by dim_zeros
    indp = find(sXp<0 | sXp>=dim_back | sYp<0 | sYp>=dim_back);
    sXp(indp)=[];
    sYp(indp)=[];
    sum  = 0;
    
    for j = 1:length(sXp)-1
        gXp = ceil(sXp(j));
        gYp = ceil(sYp(j));
        if(gXp == 0)
            gXp = 1;
        end
        if(gYp == 0)
            gYp = 1;
        end
        B(gXp,gYp) = B(gXp,gYp) + i_ff(deg,sensor);
    end
    sensor = sensor + 1;
end
    sensor = 1;
    deg    = deg +1;
    colormap bone;
    imagesc(B);
    pause(0.05);
end
