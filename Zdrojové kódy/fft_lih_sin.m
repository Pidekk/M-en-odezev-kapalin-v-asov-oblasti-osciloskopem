clc
clear all
close all
% Načtení dat z CSV souboru
name1 = {'0_100_1v.csv','0_100_5v.csv','0_100_10v.csv','0_100_15v.csv','0_100_20v.csv'};
name2 = {'0_30k_1v.csv','0_30k_5v.csv','0_30k_10v.csv','0_30k_15v.csv','0_30k_20v.csv'};
name3 = {'0_500k_1v.csv','0_500k_5v.csv','0_500k_10v.csv','0_500k_15v.csv','0_500k_20v.csv'};

name = name3;

A = {'1V','5V', '10V','15V','20V'};

% Výstupní složka pro uložení grafů
outputFolder = '500kHz';
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
% plot(fx,P3);
% title(['Spektrum zdroje sinusového signálu',A(n)]);
% ylabel('Amplituda [V]');
% xlabel('Frekvence [Hz]');
% grid on;
% subplot(2,1,2)
plot(fy,P1);
title(['Spektrum sinusového signálu ethanolu s amplitudou',A(n)]);
%xlim([0 fmax]);
xticks([0,500e3:1e6:100e6])
ylabel('Amplituda [V]');
xlabel('Frekvence [Hz]');
grid on;
hold on;

% % Uložení grafu
% outputFileName = fullfile(outputFolder, ['500kHz' A{n} '.jpg']);
% saveas(gcf, outputFileName); % Uloží graf jako JPG
% close(gcf); % Zavře aktuální graf
end


% Zobrazení výsledku
% figure;
% plot(f, P1);
% xlabel('Frekvence (Hz)');
% ylabel('P1(f)');

% 