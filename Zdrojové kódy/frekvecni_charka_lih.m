clc
close all
clear all

name = {'lih_1.csv','lih_2.csv','lih_3.csv','lih_4.csv','lih_5.csv'};



for m = 1:numel(name)
    data = csvread(name{m},2,0);
    frequency(:,m) = data(:,2);
    u1(:,m) = data(:,3);
    gain(:,m) = data(:,4);
    phase(:,m) = data(:,5) + 180;
end
Rref = [10e3 10e3 10e3 1e3 1e3]; % feedback resistor


for n = 1:numel(u1(1,:))
    for u = 1:numel(u1(:,1))
        u2(u,n) = 10^(gain(u,n)/20)*u1(u,n);
        Rload(u,n) = (u1(u,n)/u2(u,n))*Rref(n);
        if phase(u,n) > 90
           phase(u,n) = phase(u,n) - 360;
        elseif phase(u,n) < -90
           phase(u,n) = phase(u,n) + 360;
        end
    end
end

figure;
subplot(2,1,1)
semilogx(frequency,Rload);
xline(1e6,'--r','Omezení aparaturou');
%title('Impedanční charakterisktika 96% ethanolu');
legend('300 mVpp','500mVpp','1Vpp','3Vpp','5Vpp','Location','southwest' );
ylabel('Impedance [\Omega]');
xlabel('Frekvence [Hz]');
grid on;
hold on;
subplot(2,1,2)
semilogx(frequency,phase);
xline(1e6,'--r');
%title('Fázová charakterisktika 96% ethanolu');
ylabel('Fázový posun [\circ]');
xlabel('Frekvence [Hz]');
grid on

