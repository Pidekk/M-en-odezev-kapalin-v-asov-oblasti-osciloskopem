clc
clear all;
close all;

% Změna cesty k souboru
folder = uigetdir(pwd, 'Vyberte složku s CSV soubory');
cd(folder);
if folder == 0
    error('Nebyla vybrána žádná složka. Skript ukončen.');
end
display('[1] Frekvenční analýza (FRA)');
display('[2] FFT')
display('[3] XY zobrazení')
display('[4] Odezvy na jednotkový skok')
display('[5] Závislost koncentrace na frekvenci (soubory ke zpracování musí být ve zvláštní složce)')
selectCSV = input('Vyberte způsob prezentace vašich .csv souborů:');

if selectCSV < 1 || selectCSV > 5
    error('Nebylo zvoleno číslo mezi 1 a 5');
end
prefix =   '0_3';


Files = dir(fullfile(folder, [prefix, '*.csv']));
% Amp =  {'100mV','300mV','500mV', '1V', '3V', '5V', '10V','15V','20V'};

Amp = {'1V','1V','1V','10V','10V','10V','10V','10V','10V'};
Rref = [ 1e5 1e5 1e5 1e5 1e5 1e5 1e5 1e5 1e5 1e5 1e5]; % Hodnota prevodnich odporu (zvlast pro kazdy soubor)


switch selectCSV
    
    case 1
        %% Frekvencni analyza

        % Rozdeleni dat do jednotlivych promennych
        for m = 1:numel(Files)
            FileName =string({Files.name});
            data = csvread(FileName{m},2,0);
            frequency(:,m) = data(:,2);
            u1(:,m) = data(:,3);
            gain(:,m) = data(:,4);
            phase(:,m) = data(:,5) +180;
        end

        
        for n = 1:numel(u1(1,:))
            for u = 1:numel(u1(:,1))
                u2(u,n) = 10^(gain(u,n)/20)*u1(u,n); %Prepocet z dB na Volty
                Rload(u,n) = (u1(u,n)/u2(u,n))*Rref(n); %Vypocet impedance
                %% Korekce faze
                if phase(u,n) > 180
                    phase(u,n) = phase(u,n) - 360;
                elseif phase(u,n) < -180
                    phase(u,n) = phase(u,n) + 360;
                end
            phase(u,n) = -phase(u,n);
            end
        end
        
        % Zobrazeni vysledku
        figure;
        subplot(2,1,1)
        loglog(frequency,Rload);
%         title(sprintf('Frekveční charakteristika octu'),sprintf('v %s roztoku cukru', Conc));
        lgd =legend('100mV, Rf 100k\Omega','1V, Rf 100k\Omega','100mV, Rf 1k\Omega',...
            '1V, Rf 10\Omega','1V, Rf 100\Omega','1V, Rf 1k\Omega','Location','southwest','NumColumns',1 );        
        ylabel('Impedance [\Omega]');
        xlabel('Frekvence [Hz]');
        grid on;
        hold on;

        subplot(2,1,2)
        semilogx(frequency,phase);
        ylabel('Fázový posun [\circ]');
        xlabel('Frekvence [Hz]');
        grid on;

    
    case 2  
        %% FFT
        for n = 1:numel({Files.name})

            % Rozdeleni dat do jednotlivych promennych
            fn = Files(n).name;
            FileName =string({Files.name});
            data = csvread(FileName{n},2,0);
            time = data(:,1); 
            u1 = data(:,2);
            u2 = data(:,3); 
            i1 = -(u2./Rref(n));
           
            % Vypocet delky signalu a vzorkovaci frekvence
            N = length(time);
            T = mean(diff(time)); 
            Fs = 1/T; % Vzorkovaci frekvence

            % Vystupni signal
            Y = fft(i1); 
            P2 = abs(Y/N); % Dvojstranne spektrum
            P1 = P2(1:N/2+1); % Jednostranne spektrum
            P1(2:end-1) = 2*P1(2:end-1); % Korekce amplitudy
            fy = Fs*(0:(N/2))/N; % Frekvencni osa
            
            % Signal generatoru
            X = fft(u1); 
            P4 = abs(X/N);
            P3 = P4(1:N/2+1); 
            P3(2:end-1) = 2*P3(2:end-1); 
            fx = Fs*(0:(N/2))/N; 
 
            %Zobrazeni spektra
            figure;
            yyaxis left;
            stem(fy,P3,'o-');
            set(gca, 'YScale', 'log');
            title( sprintf('Spektrum záteže 100Ω, %s',Amp{n}));%,sprintf('v %s roztoku cukru',Conc) );
            ylabel('Amplituda budícího signálu[V]');
            yyaxis ('right') ;
            stem(fx,P1,'x-');
            set(gca, 'YScale', 'log');
            grid on;
            ylabel('Amplituda odezvy [A]');
            xlabel('Frekvence [Hz]');
            hold on;
        end
    
    case 3
        %% XY zobrazeni
        for n = 1:numel({Files.name})
            % Rozdeleni dat do jednotlivych promennych
            fn = Files(n).name;
            FileName =string({Files.name});
            data = csvread(FileName{n},2,0);
            time = data(:,1); 
            u1 = data(:,2);
            u2 = data(:,3); 
            i1 = -(u2./Rref(n)); %Vypocet proudu vzorku
            

            % Zobrazeni vysledku
            figure;
            plot(u1,i1);
            xlabel('Budicí napětí [V]');
            ylabel('Proudová odezva [A]');
            title(sprintf('Nelinearita rezistoru 100kΩ 300Hz, %s',Amp{n}));%,sprintf('v %s roztoku cukru',Conc));
            grid on;
            hold on; 
        end
    case 4 
        %% Odezvy na jednotkovy impuls
        for n = 1:numel({Files.name})          
            % Rozdeleni dat do jednotlivych promennych
            FileName =string({Files.name});
            data = csvread(FileName{n},2,0);
            time = data(:,1); 
            u1 = data(:,2);
            u2 = data(:,3); 
            i1 = -(u2./Rref(n)); %Vypocet proudu vzorku  

            % Zobrazeni vysledku
            figure;
            yyaxis 'left'
            plot(time,u1);
            ylabel('Budící napětí [V]');
            hold on;
            yyaxis 'right'
            plot(time,i1);
            title(sprintf('Odezva na jednotkový skok rezistoru 100kΩ 1kHz, %s, Rf %gΩ',Amp{n},Rref(n)));%,sprintf('v %s roztoku cukru',Conc));
            xlabel('Čas [s]');
            ylabel('Proudová odezva odezvy [A]');
            grid on;

        end
    case 5
        %% Závislost impedance na koncentraci
        conc_vec = [0:5:50]; % vektor koncetrací  [začátek:krok:konec] (osa X)
        for n = 1:numel(name)
            % Nacteni dat do jednotlivych promenych
            data = csvread(name{n},2,0);
            time = data(:,1); 
            u1 = data(:,2);
            u2 = data(:,3); 
            i1 = -(u2./Rref(n));

            %Nalezeni peak to peak hodnot a vypocet impedance
            u1max(n) = max(u1);
            u1min(n) = min(u1);
            i1max(n) = max(i1);
            i1min(n) = min(i1);
            u1pp(n) = u1max(n)-u1min(n);
            i1pp(n) = i1max(n)-i1min(n);
            R(n) = u1pp(n)./i1pp(n);
        end

        %Zobrazeni vysledku
        figure;
        pol = polyfit(conc_vec,R,5); %Vytvoreni polynomu 5. radu
        pol_val = polyval(pol,conc_vec); %Vypocet polynomu v intervalu koncentraci
        scatter(conc_vec,R,'Marker','X');
        hold on; 
        plot(conc_vec,pol_val,'-r');
        title('Závislost impedance na koncetraci cukru v mléce');
        xlabel('Koncetrace [%]');
        ylabel('Impedance [\Omega]');
        grid on;
end