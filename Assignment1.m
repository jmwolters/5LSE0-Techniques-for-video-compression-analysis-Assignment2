%% Assignment 1 Gabor analysis
clear all
close all
% 1a
[X, Y] = meshgrid(-5:0.1:5);

% figure(1)
% imagesc(X);
% figure(2)
% imagesc(Y);

% 1b Gabor function 


sigma = 1;
U = 2;
V = -2;

gaus_env = 1/(sqrt(2*pi)*sigma)*exp(-((X).^2+(Y).^2)/(2*sigma^2));
gaus_osc = exp(1j*2*pi*(U.*X+V.*Y));



H = (gaus_env).*real(gaus_osc);
% figure(10)
% imagesc(H)
% 
% angles = [45,0,135,90];
% 
% for i = 1:length(angles)
%     % gabor_wave = gabor_filt0(angles(i),1,5,2,X,Y);
%     gabor_wave = gabor_filtO(angles(i),1,1,X,Y)
%     subplot(2,4,i)
%     imagesc(gabor_wave)
%     subplot(2,4,i+4)
%     plot(abs(gabor_wave))
%     % plot(fft(gabor_wave))
% end


gabor_wave = gabor_filtO(0,1,1,Y,X)
imagesc(gabor_wave)

function gabor_round = gabor_filtO(theta,magnitude,sigma,X,Y)
    U = magnitude*cosd(theta);
    V = magnitude*sind(theta);

    gaus_env = 1/(sqrt(2*pi)*sigma)*exp(-((X).^2+(Y).^2)/(2*sigma^2));
    gaus_osc = exp(1j*2*pi*(U*X+V*Y));

    gabor_round = gaus_env.*real(gaus_osc);
end

% function gabor_oval = gabor_filt0(theta,f0,gamma,eta,X,Y)
%     x = X*cosd(theta) + Y*sind(theta);
%     y = -X*sind(theta) + Y*cosd(theta);
% 
%     gabor_oval = f0/(pi*gamma*eta)*exp(-((f0^2/gamma^2)*x.^2 + (f0^2/eta^2)*y.^2)).*real(exp(1j*2*pi*f0*x));
% end