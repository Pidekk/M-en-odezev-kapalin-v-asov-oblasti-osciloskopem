clc
clear all
close all
% Načtení dat z CSV souboru
name1 = {'30_50mv.csv','30_100mv.csv','30_300mv.csv','30_500mv.csv','30_1v.csv','30_3v.csv','30_5v.csv'};

name2 = {'100_50mv.csv','100_100mv.csv','100_300mv.csv','100_500mv.csv','100_1v.csv','100_3v.csv'};

name3 = {'100k_50mv.csv','100k_100mv.csv','100k_300mv.csv','100k_500mv.csv','100k_1v.csv'};

name = name3;

A = {'50mV','100mV', '300mV','500mV','1V','3V','5V'};

% Výstupní složka pro uložení grafů
outputFolder = '30Hz';
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
fmax = fy(1,end)/5; % Maximum frekveční osy

X = fft(u1); % FFT signálu
P4 = abs(X/N); % Dvojstranné spektrum
P3 = P4(1:N/2+1); % Jednostranné spektrum
P3(2:end-1) = 2*P3(2:end-1); % Korekce amplitudy
fx = Fs*(0:(N/2))/N; % Frekvenční osy
fmax = fx(1,end)/1; % Maximum frekveční osy

figure
% subplot(2,1,1)
plot(fy,P1);
title(['Spektrum sinusového signálu pln. mléka s amplitudou',A(n)]);
ylabel('Amplituda [V]');
xlabel('Frekvence [Hz]');
xticks([0,30:60:1e7])
grid on;
% 
% subplot(2,1,2)
% plot(fx,P3);
% title(['Spektrum sinusového signálu pln. mléka s amplitudou',A(n)]);
% xticks([0,100:200:10e6]);
% xlim([0 fmax]);
% ylabel('Amplituda [V]');
% xlabel('Frekvence [Hz]');
% grid on;
% hold on;

% % Uložení grafu
% outputFileName = fullfile(outputFolder, ['30Hz_' A{n} '.jpg']);
% saveas(gcf, outputFileName); % Uloží graf jako JPG
% close(gcf); % Zavře aktuální graf
% end


%%Zobrazení výsledku
% figure;
% plot(f, P1);
% xlabel('Frekvence (Hz)');
% ylabel('P1(f)');

% 