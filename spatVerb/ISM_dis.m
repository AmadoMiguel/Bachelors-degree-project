function IR = ISM_dis(sourc_x,sourc_y,sourc_z,mic_x,mic_y,mic_z,width,large,...
    height,Fs)
%ISM_mov Based on 'ISM.m'. Distance damping coefficient was added.
       
% IR vector initialization
IR = [];

% Sound velocity
cSound = 340;
% Air damping coefficient
airDamp = 0.009;
% Number of reflections per axis
N = 20;
n = -N:N;
[l,m,n] = meshgrid(n,n,n);
% Absorption coefficients
coefabsor_x = rand().^(1/20); 
coefabsor_y = rand().^(1/20); 
coefabsor_z = rand().^(1/20); 
coefAbsor = [coefabsor_x,coefabsor_y,coefabsor_z];

% IR obtention procedures

% Image cell coordinates 
dx = ((width*l)+(((-1).^l)*sourc_x))-mic_x;
dy = ((large*m)+(((-1).^m)*sourc_y))-mic_y;
dz = ((height*n)+(((-1).^n)*sourc_z))-mic_z;
% Distances from image cell to listener
Dlmn = sqrt((dx.^2)+(dy.^2)+(dz.^2));
% Room absorption function per axis
coefAbsor = -abs(coefAbsor);
absorFunc_x = coefAbsor(1).^(abs(0.5.*l - 0.25 + 0.25.*(-1).^l));
absorFunc_y = coefAbsor(2).^(abs(0.5.*m - 0.25 + 0.25.*(-1).^m));
absorFunc_z = coefAbsor(3).^(abs(0.5.*n - 0.25 + 0.25.*(-1).^n));    
absorFunc = absorFunc_x.*absorFunc_y.*absorFunc_z;        
% Air damping function
airDampFunc = exp(-airDamp*Dlmn);
% Damping coefficient
P = (1./(4*pi*(Dlmn.^2))).*absorFunc.*airDampFunc;
% Delays due to distance
realTime = Dlmn/cSound;
nSample = round(realTime*Fs,0);
% IR obtention
IR(nSample) = P;
% IR normalization
IR = IR/max(abs(IR)); 
%--------------------------------------------------------------------------
% Damping due to distance (some values were defined, based on the
% room dimensions).
maxDis = sqrt(power((width-1)-mic_x,2)+power((large-1)-mic_y,2)+...
    power((height-1)-mic_z,2));
minDis = sqrt(power(sourc_x-mic_x,2)+power(2-mic_y,2)+...
    power(-0.1-mic_z,2));
% Distance between source and mic
disSourMic = sqrt(((sourc_x-mic_x)^2)+((sourc_y-mic_y)^2)+...
    ((sourc_z-mic_z)^2));
% Damping coefficient (max value: 0.9, min value: 0.2)
disDamp = ((((1/disSourMic)-(1/maxDis))/((1/minDis)-(1/maxDis)))*0.7)+0.2;
%--------------------------------------------------------------------------
% Direct sound is damped by a factor of disDamp
IR = IR*disDamp;
end