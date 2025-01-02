clc
clear all
close all
% Načtení dat z CSV souboru

name1 = {'30_50mv_sq.csv','30_100mv_sq.csv','30_300mv_sq.csv','30_500mv_sq.csv','30_1v_sq.csv','30_3v_sq.csv'};
name2 ={'100_50mv_sq.csv','100_100mv_sq.csv','100_300mv_sq.csv','100_500mv_sq.csv','100_1v_sq.csv','100_3v_sq.csv'};
name3 ={'100k_50mv_sq.csv','100k_100mv_sq.csv','100k_300mv_sq.csv','100k_500mv_sq.csv','100k_1v_sq.csv'};
obrazek = {'30_500mv_sq.csv','100_100mv_sq.csv'};
name = name3;


A = {'50mV','100mV', '300mV','500mV','1V','3V'};

% Výstupní složka pro uložení grafů
outputFolder = '30Hzsq';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder); % Vytvoří složku, pokud neexistuje
end

for n= 1:numel(name)
data = csvread(name{n},2,0); 
time = data(:,1); 
u1 = data(:,2);
u2 = data(:,3); 
xx = max(u2(n));
% Výpočet délky signálu a vzorkovací frekvence
N = length(time); % Počet vzorků
T = mean(diff(time)); % Doba mezi vzorky (předpokládáme rovnoměrné vzorkování)
Fs = 1/T; % Vzorkovací frekvence




Y = fft(u2); % FFT signálu
P2 = abs(Y/N); % Dvojstranné spektrum
P1 = P2(1:N/2+1); % Jednostranné spektrum
P1(2:end-1) = 2*P1(2:end-1); % Korekce amplitudy
fy = Fs*(0:(N/2))/N; % Frekvenční osy
fmax = fy(1,end)/1; % Maximum frekveční osy

X = fft(u1); % FFT signálu
P4 = abs(X/N); % Dvojstranné spektrum
P3 = P4(1:N/2+1); % Jednostranné spektrum
P3(2:end-1) = 2*P3(2:end-1); % Korekce amplitudy
fx = Fs*(0:(N/2))/N; % Frekvenční osy
fmax = fx(1,end)/1; % Maximum frekveční osy

figure
%subplot(2,1,1)
plot(fy,P1);
title(['Spektrum obdélníkového signálu pln. mléka signálu',A(n)]);
%title('a)');
ylabel('Amplituda [V]');
xlabel('Frekvence [Hz]');
xticks([0,100e3:200e3:1e7]);
grid on;

% subplot(2,1,2)
% plot(fy,P1);
% title(['Spektrum obdélníkového signálu plnotučného mléka s amplitudou',A(n)]);
% %title('b)')
% xticks([0,1e5:2e5:10e6]);
% ylabel('Amplituda [V]');
% xlabel('Frekvence [Hz]');
% grid on;


% % Uložení grafu
% outputFileName = fullfile(outputFolder, ['30Hz_sq' A{n} '.jpg']);
% saveas(gcf, outputFileName); % Uloží graf jako JPG
% close(gcf); % Zavře aktuální graf

end

