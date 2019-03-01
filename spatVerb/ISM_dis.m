function IR = ISM_dis(sourc_x,sourc_y,sourc_z,mic_x,mic_y,mic_z,width,large,...
    height,Fs)
%ISM_mov Based on 'ISM.m'. Distance damping coefficient was added.
       
% IR vector initialization
IR = [];

% Sound velocity
cSound = 340;
% Air damping coefficient
airDamp = 0.005;
% Number of reflections per axis
N = 50;
n = -N:N;
[l,m,n] = meshgrid(n,n,n);
% Absorption coefficients
coefabsor_x1 = 0.62; coefabsor_x2 = 0.62; 
coefabsor_y1 = 0.63; coefabsor_y2 = 0.85; 
coefabsor_z1 = 0.68; coefabsor_z2 = 0.99; 
coefAbsor = [coefabsor_x1,coefabsor_x2,coefabsor_y1,...
             coefabsor_y2,coefabsor_z1,coefabsor_z2];

% IR obtention procedures

% Image cell coordinates 
dx = ((width*l)+(((-1).^l)*sourc_x))-mic_x;
dy = ((large*m)+(((-1).^m)*sourc_y))-mic_y;
dz = ((height*n)+(((-1).^n)*sourc_z))-mic_z;
% Distances from image cell to listener
Dlmn = sqrt((dx.^2)+(dy.^2)+(dz.^2));
% Room absorption function per axis
coefAbsor = -abs(coefAbsor);
absorFunc_x = coefAbsor(1).^(abs(0.5.*l - 0.25 + 0.25.*(-1).^l)) +...
              coefAbsor(2).^(abs(0.5.*l + 0.25 - 0.25.*(-1).^l));
absorFunc_y = coefAbsor(3).^(abs(0.5.*m - 0.25 + 0.25.*(-1).^m)) +...
              coefAbsor(4).^(abs(0.5.*m + 0.25 - 0.25.*(-1).^m));
absorFunc_z = coefAbsor(5).^(abs(0.5.*n - 0.25 + 0.25.*(-1).^n)) +...
              coefAbsor(6).^(abs(0.5.*n + 0.25 - 0.25.*(-1).^n));    
absorFunc = absorFunc_x.*absorFunc_y.*absorFunc_z;        
% Air damping function
airDampFunc = exp(-airDamp*Dlmn);
% Damping coefficient
P = (1./Dlmn).*absorFunc.*airDampFunc;
% Delays due to distance
realTime = Dlmn/cSound;
nSample = round(realTime*Fs);
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
    power(-0.18-mic_z,2));
% Distance between source and mic
disSourMic = sqrt(((sourc_x-mic_x)^2)+((sourc_y-mic_y)^2)+...
    ((sourc_z-mic_z)^2));
% Damping coefficient (max value: 0.9, min value: 0.2)
disDamp = ((((1/disSourMic)-(1/maxDis))/((1/minDis)-(1/maxDis)))*0.7)+0.2;
%--------------------------------------------------------------------------
% Direct sound is damped by a factor of disDamp
IR(IR == max(IR)) = IR(IR == max(IR))*disDamp;
end