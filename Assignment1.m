%% Assignment 1 Gabor analysis
clear all
close all
% 1a
[X, Y] = meshgrid(-5:0.1:5);

%% 1a
figure(1)
imagesc(X);
filename = string("Exports/Q1_a1.eps")
saveas(gcf,filename);
figure(2)
imagesc(Y);
filename = string("Exports/Q1_a2.eps")
saveas(gcf,filename);

% 1b Gabor function 
sigma = 1;
U = 2;
V = -2;

gabor_wave = gabor_filtO(0,1,1,X,Y);
figure(3)
imagesc(gabor_wave)
filename = string("Exports/Q1_b.eps")
saveas(gcf,filename);

% 1c
[gabor_wave, gabor_spectral]= gabor_filtO(0,1,1,Y,X);
figure(4)
imagesc(gabor_wave)
filename = string("Exports/Q1_c.eps")
saveas(gcf,filename);
% figure(5)
% plot(abs(fft2(gabor_wave)))

% 1d Gabor filter bank
angles = [0,45,90,135];
scales = [4.7,2,0.9];

for j = 1:length(scales)
    r(j) = abs(sqrt(log(sqrt(2)/2)/(2*pi^2.*scales(j)^2)));
end
d(1) = 0.08;
d(2) = 0.08+r(1)+r(2);
d(3) = 0.08+r(1)+2*r(2)+r(3);

for i = 1:length(angles)
    for j = 1:length(scales)
        % Spatial plot
        figure(6)
        subplot_index = (j-1)*4+i;
        gabor_wave = gabor_filtO(angles(i),5,scales(j),X,Y);
        subplot(3,4,subplot_index);
        imagesc(gabor_wave)

        % Spectral plot
        x = d(j)*cosd(angles(i));
        y = d(j)*sind(angles(i));
        figure(7)
        
        hold on
        circle = circle2(x,y,r(j),j);
    end
end


function [gabor_spatial,gabor_spectral] = gabor_filtO(theta,magnitude,sigma,X,Y)
    U = magnitude*cosd(theta);
    V = magnitude*sind(theta);

    gaus_env = 1/(sqrt(2*pi)*sigma)*exp(-((X).^2+(Y).^2)/(2*sigma^2));
    gaus_osc = exp(1j*2*pi*(U*X+V*Y));

    gabor_spatial = gaus_env.*real(gaus_osc);
    gabor_spectral = exp(-2*pi^2*sigma^2*(U.^2+V.^2));
end

function gabor_oval = gabor_filt0(theta,f0,gamma,eta,X,Y)
    x = X*cosd(theta) + Y*sind(theta);
    y = -X*sind(theta) + Y*cosd(theta);

    gabor_oval = f0/(pi*gamma*eta)*exp(-((f0^2/gamma^2)*x.^2 + (f0^2/eta^2)*y.^2)).*real(exp(1j*2*pi*f0*x));
end

function h = circle2(x,y,r,j)
colors = ["#0072BD","#EDB120","#D95319"];
d = r*2;
px = x-r;
py = y-r;
h = rectangle('Position',[px py d d],'Curvature',[1,1],'EdgeColor',colors(j));
daspect([1,1,1])
end