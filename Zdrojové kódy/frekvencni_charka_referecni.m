clc
close all
clear all

% Rload 100k
name1 = {'1Vpp__ref10k_load100k.csv','100mVpp_ref10k_load100k.csv','1Vpp_ref1k_load100k.csv'};

%Rload 10k
name2 = {'1vpp_ref10k_load10k.csv','100mvpp_ref10k_load10k.csv','1vpp_ref1k_load10k.csv','100mvpp_ref1k_load10k.csv','1vpp_ref100_load10k.csv','100mvpp_ref100_load10k.csv'};

%Rload 1k
name3 = {'100mvpp_ref_10k_load1k.csv','100mvpp_ref1k_load1k.csv','1vpp_ref100_load1k.csv','100mvp_ref100_load1k.csv'};

%Rload 110
name4 = {'100mvpp_ref1k_load110.csv','1vpp_ref100_load110.csv','100mvpp_ref100_load110.csv','1vpp_ref10_load110.csv'};

%Rload 10
name5 = {'100mvpp_ref100_load10.csv','1vpp_ref10_load10.csv','100mvpp_ref10_load10.csv'};

name = name3;


for m = 1:numel(name)
    data = csvread(name{m},2,0);
    frequency(:,m) = data(:,2);
    u1(:,m) = data(:,3);
    gain(:,m) = data(:,4);
    phase(:,m) = data(:,5);
end

Rref = [10e3,1000,100,100]; % feedback resistor

for n = 1:numel(u1(1,:))
    for u = 1:numel(u1(:,1))
        u2(u,n) = 10^(gain(u,n)/20)*u1(u,n);
        Rload(u,n) = (u1(u,n)/u2(u,n))*Rref(n);
    
    end
end

%subplot(2,1,1);
semilogx(frequency,Rload);
xline(1e6,'--r','Validní data');
%title('Frekvenční charakterisktika rezistivní záteže 1k\Omega');
legend('Rf 10k\Omega, 100mVpp', 'Rf 1k\Omega, 100mVpp','Rf 100\Omega, 1Vpp','Rf 100\Omega, 100mVpp','Location','northwest');
yticks([0,1000:2000:20000]);
ylabel('Odpor [\Omega]');
xlabel('Frekvence [Hz]');
grid on;
hold on;

% subplot(2,1,2);
% semilogx(frequency,phase);  
% xline(1e6,'--r');
% ylabel('Fázový posun \phi [\circ]');
% xlabel('Frekvence [Hz]');
% grid on;