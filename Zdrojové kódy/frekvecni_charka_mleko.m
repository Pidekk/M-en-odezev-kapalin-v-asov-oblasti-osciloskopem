clc
close all
clear all

name = {'50mv_100.csv','100mv_100.csv','300mv_100.csv','500mv_100.csv'};



for m = 1:numel(name)
    data = csvread(name{m},2,0);
    frequency(:,m) = data(:,2);
    u1(:,m) = data(:,3);
    gain(:,m) = data(:,4);
    phase(:,m) = data(:,5) +180;

end
Rref = [100]; % feedback resistor


for n = 1:numel(u1(1,:))
    for u = 1:numel(u1(:,1))
        u2(u,n) = 10^(gain(u,n)/20)*u1(u,n);
        Rload(u,n) = (u1(u,n)/u2(u,n))*Rref;
        RloaddB(u,n) = 20*log(Rload(u,n));

        if phase(u,n) > 90
            phase(u,n) = phase(u,n) - 360;
        elseif phase(u,n) < -90
            phase(u,n) = phase(u,n) + 360;
        end
        z(u,n) = Rload(u,n)*(cos(deg2rad(phase(u,n)))+1j*sin(deg2rad(phase(u,n))));
    end
end
figure;
subplot(2,1,1)
semilogx(frequency,Rload);
xline(1e6,'--r','Omezení aparaturou');
%title('Impedanční charakterisktika plnotučného mléka');
legend('50 mVpp','100mVpp','200mVpp','500mVpp','Location','north' );
ylabel('Impedance [\Omega]');
xlabel('Frekvence [Hz]');
grid on;
hold on;
subplot(2,1,2)
semilogx(frequency,phase);
xline(1e6,'--r');
%title('Fázová charakterisktika plnotučného mléka');
ylabel('Fázový posun [\circ]');
xlabel('Frekvence [Hz]');
grid on;

figure;
hold on;
for n = 1:numel(name)
    plot(real(z(:,n)), imag(z(:,n)), 'DisplayName', name{1});
end
xlabel('Reálná část');
ylabel('Imaginární část');
title('Nyquistův diagram výstupní impedance');
legend('show');
grid on;


