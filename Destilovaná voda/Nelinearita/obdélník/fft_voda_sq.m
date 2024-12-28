clc
clear all
close all
% Načtení dat z CSV souboru
name1 = {'1k_50mv_sq.csv','1k_100mv_sq.csv','1k_300mv_sq.csv','1k_500mv_sq.csv','1k_1v_sq.csv','1k_3v_sq.csv','1k_5v_sq.csv','1k_10v_sq.csv','1k_15v_sq.csv','1k_20v_sq.csv'};

name2 ={'60k_50mv_sq.csv','60k_100mv_sq.csv','60k_300mv_sq.csv','60k_500mv_sq.csv','60k_1v_sq.csv','60k_3v_sq.csv','60k_5v_sq.csv','60k_10v_sq.csv','60k_15v_sq.csv','60k_20v_sq.csv'};

name3 = {'200k_50mv_sq.csv','200k_100mv_sq.csv','200k_300mv_sq.csv','200k_500mv_sq.csv','200k_1v_sq.csv','200k_3v_sq.csv','200k_5v_sq.csv','200k_10v_sq.csv','200k_15v_sq.csv','200k_20v_sq.csv'};

name = name1;

A = {'50mV','100mV', '300mV','500mV','1V','3V','5V','10V','15V','20V'};

% Výstupní složka pro uložení grafů
outputFolder = '1kHzsq';
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
% subplot(2,1,1)
% plot(fx,P3);
% title(['Spektrum zdroje obdélníkového signálu ',A(n)]);
% ylabel('Amplituda [V]');
% xlabel('Frekvence [Hz]');
% xticks([0,200e3:400e3:10e6])
% grid on;
% subplot(2,1,2)
plot(fy,P1);
title(['Spektrum obdélníkového signálu des. vody s amplitudou',A(n)]);
%xlim([0 fmax]);
xticks([0,1e3:2e3:10e6])
ylabel('Amplituda [V]');
xlabel('Frekvence [Hz]');
grid on;
hold on;

%Uložení grafu
outputFileName = fullfile(outputFolder, ['1kHz_sq' A{n} '.jpg']);
saveas(gcf, outputFileName); % Uloží graf jako JPG
close(gcf); % Zavře aktuální graf
% figure
% plot(time,u1);
% hold on;
% plot(time,u2);
end


%%Zobrazení výsledku
% figure;
% plot(f, P1);
% xlabel('Frekvence (Hz)');
% ylabel('P1(f)');

% 