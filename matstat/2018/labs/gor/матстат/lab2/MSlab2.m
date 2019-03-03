%��� ������� ������ n �� ���������� ����������� ������������ X ����������� � 
%���� ��������� �� ���:
 

function main()
    sample = importdata('data(var5).txt');
    N = length(sample);
    
    %�)���������� �������� ������ �(~xn)� S2(~xn)��������������� �������� MX � 
    %��������� DX ��������������;
    [mu] = GetMuExpectedValue(sample);
    [s2] = GetS2DispersionValue(sample);
    
    fprintf("mu: %.4f\n",mu);
    fprintf("s2: %.4f\n",s2);
    
    %�)���������� ������ � ������� ������ �(~xn),�(~xn)��� gamma-�������������� ���������
    %��� ��������������� �������� MX;
    gam = 0.9;
    [lM, hM] = GetBordersForExpectedValue(gam, s2, mu, N);
    
    fprintf("MX borders with gamma=%.2f: (%.4f .. %.4f)\n", gam, lM, hM);
    
    %�)���������� ������ � ������� ������ ?2(~xn),?2(~xn)��� ?-�������������� 
    %��������� ��� ��������� DX; 
    [lD, hD] = GetBordersForDispersionValue(gam, s2, N);
    
    fprintf("DX borders with gamma=%.2f: (%.4f .. %.4f)\n", gam, lD, hD);
    
    %�� ������������ ��������� Oyn ��������� ������ y=? �(~xN),
    %����� ������� ������� y=? �(~xn),y=�(~xn)� y=�(~xn)��� ������� ������ n 
    %�������, ��� n ���������� �� 1 �� N;
    
    figure(1);
    hold on;
    GetGraphMX(sample, N, gam);
    
    %�� ������ ������������ ��������� Ozn ��������� ������ z=S2(~xN), 
    %����� ������� ������� z=S2(~xn),z=?2(~xn)� z=?2(~xn)��� ������� 
    %������ n �������, ��� n ���������� �� 1 �� N
    
    figure(2);
    hold on;
    GetGraphDX(sample, N, gam); 
end

function [Mu] = GetMuExpectedValue(sample)
    n = length(sample);
    Mu = sum(sample)/n;
end

function [s2] = GetS2DispersionValue(sample)
    n = length(sample);
    m = GetMuExpectedValue(sample);
    if n > 1
        s2 = sum((sample-m).^2)/(n-1);
    else
        s2 = 0;
    end
end

function [lM, hM] = GetBordersForExpectedValue(gam, s2, mu, n)
    alpha = (1 + gam)/2;
    quantile = tinv(alpha, n-1);
    border = quantile * sqrt(s2) / sqrt(n);
    
    lM = mu - border;
    hM = mu + border;
end

function [lD, hD] =  GetBordersForDispersionValue(gam, s2, n)    
    alpha1 = (1 - gam)/2;
    alpha2 = (1 + gam)/2;
    
    quantile1 = chi2inv(alpha1, n-1);
    quantile2 = chi2inv(alpha2, n-1);
    
    lD = s2*(n-1)/quantile2;
    hD = s2*(n-1)/quantile1;    
end

function GetGraphMX(sample, n, gam)
    mu = zeros(n,1);
    s2 = zeros(n,1);
    lMu = zeros(n,1);
    hMu = zeros(n,1);
    
    for i = 1:n
        part = sample(1:i);
        [mu(i)] = GetMuExpectedValue(part);
        [s2(i)] = GetS2DispersionValue(part);
        [lMu(i), hMu(i)] = GetBordersForExpectedValue(gam, s2(i), mu(i), i);
    end

    line = zeros(n,1);
    line(1:n) = mu(n);
    
    plot(line, 'g');
    plot(lMu, 'r');
    plot(hMu, 'b');
    plot(mu, 'k');
    grid on;
    xlabel('n');
    ylabel('\mu');
    legend('\mu\^(x_N)','_{--}\mu^(x_n)', '^{--}\mu^(x_n)', '\mu\^(x_n)');
end

function GetGraphDX(sample, n, gam)
    s2 = zeros(n,1);
    lSigma = zeros(n,1);
    hSigma = zeros(n,1);
    
    startI = 3;
    
    for i = startI:n
        part = sample(1:i);
        [s2(i)] = GetS2DispersionValue(part);
        [lSigma(i), hSigma(i)] = GetBordersForDispersionValue(gam, s2(i), i);
    end

    line = zeros(n,1);
    line(startI:n) = s2(n);
    
    plot((startI:n), line(startI:n), 'g');
    plot((startI:n), lSigma(startI:n), 'r');
    plot((startI:n), hSigma(startI:n), 'b');
    plot((startI:n), s2(startI:n), 'k');
    grid on;
    xlabel('n');
    ylabel('\sigma');
    legend('S^2(x_N)','_{--}\sigma^2(x_n)', '^{--}\sigma^2(x_n)', 'S^2(x_n)');
end
    





