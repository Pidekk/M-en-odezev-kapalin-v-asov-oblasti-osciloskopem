clc
clear all
close all
% Načtení dat z CSV souboru

name1 = {'1k_50mv.csv','1k_100mv.csv','1k_300mv.csv','1k_500mv.csv','1k_1v.csv','1k_3v.csv','1k_5v.csv','1k_10v.csv','1k_15v.csv','1k_20v.csv'};
name2 ={'60k_50mv.csv','60k_100mv.csv','60k_300mv.csv','60k_500mv.csv','60k_1v.csv','60k_3v.csv','60k_5v.csv','60k_10v.csv','60k_15v.csv','60k_20v.csv'};
name3 = {'200k_50mv.csv','200k_100mv.csv','200k_300mv.csv','200k_500mv.csv','200k_1v.csv','200k_3v.csv','200k_5v.csv','200k_10v.csv','200k_15v.csv','200k_20v.csv'};
obrazek = {'1k_50mv.csv','1k_20v.csv','200k_50mv.csv','200k_20v.csv'};
name = name3;

%Vektor stringů pro hodnoty v titulu grafu
A = {'50mV','100mV', '300mV','500mV','1V','3V','5V','10V','15V','20V'};
Title = {'a)','b)','c)','d)'};

% Výstupní složka pro uložení grafů
outputFolder = '60kHz';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder); % Vytvoří složku, pokud neexistuje
end

for n= 1:numel(name)
data = csvread(name{n},2,0);
time = data(:,1); 
u1 = data(:,2);
u2 = data(:,3); 

% Výpočet délky signálu a vzorkovací frekvence
N = length(time); % Počet vzorků
T = mean(diff(time)); % Doba mezi vzorky (předpokládáme rovnoměrné vzorkování)
Fs = 1/T; % Vzorkovací frekvence

%FFT signálu a korefkce spektra
Y = fft(u2); % FFT signálu
P2 = abs(Y/N); % Dvojstranné spektrum
P1 = P2(1:N/2+1); % Jednostranné spektrum
P1(2:end-1) = 2*P1(2:end-1); % Korekce amplitudy
fy = Fs*(0:(N/2))/N; % Frekvenční osy
fmax = fy(1,end)/5; % Maximum frekveční osy

%FFT signálu generátoru pro porovnání
% X = fft(u1); 
% P4 = abs(X/N); 
% P3 = P4(1:N/2+1); 
% P3(2:end-1) = 2*P3(2:end-1); 
% fx = Fs*(0:(N/2))/N; 
% fmax = fx(1,end)/1; 

%Graf výsledného spektra
figure
plot(fy,P1);
title(['Spektrum sinusového signálu des. vody s amplitudou',A(n)]);
ylabel('Amplituda [V]');
xlabel('Frekvence [Hz]');
%xlim([0 fmax]);
xticks([0,200e3:400e3:10e6])
grid on;
hold on;
% 
% Uložení grafu
outputFileName = fullfile(outputFolder, ['60kHz_' A{n} '.jpg']);
saveas(gcf, outputFileName); % Uloží graf jako JPG
close(gcf); % Zavře aktuální graf

%%Subplot pro přůřezové výsledky

% subplot(2,2,n)
% plot(fy,P1);
% title(Title(n));
% xlim([0 fmax]);
% ylabel('Amplituda [V]');
% xlabel('Frekvence [Hz]');
% grid on;
% 
% 
% subplot(2,2,n)
% plot(fy,P1);
% title(Title(n));
% xlim([0 fmax]);
% ylabel('Amplituda [V]');
% xlabel('Frekvence [Hz]');
% grid on;
% 
% 
% subplot(2,2,n)
% plot(fy,P1);
% title(Title(n));
% xlim([0 fmax]);
% ylabel('Amplituda [V]');
% xlabel('Frekvence [Hz]');
% grid on;
% 
% subplot(2,2,n)
% plot(fy,P1);
% title(Title(n));
% xlim([0 fmax]);
% ylabel('Amplituda [V]');
% xlabel('Frekvence [Hz]');
% grid on;
% 
% sgtitle('Spektrum sinusového signálu v destilované vodě');

end

