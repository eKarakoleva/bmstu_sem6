function Lab2()
%% ���������� ������������� ���������� ��� ��������������� �������� �
%��������� ���������� ��������� ��������
%������� � 8

    sample = importdata('data.txt');
    
    [exp, s2] = CalcExpDisp(sample);
    fprintf('mat. expectation: %.6f\ndispersion: %.6f\n', exp, s2);
    
    gamma = input('Input gamma: ');
    if isempty(gamma) gamma = 0.9; disp(gamma); end
    N = input('Input N: ');
    if isempty(N) N = length(sample); disp(N); end
    
    [lowM, highM] = CalcBordersExp(exp, s2, gamma, N);
    [lowD, highD] = CalcBordersDisp(s2, gamma, N);
    fprintf('mat.exp. borders: (%.6f .. %.6f)\n', lowM, highM);
    fprintf('dispersion borders: (%.6f .. %.6f)\n', lowD, highD);
    
    figure(1);
    hold on;
    PlotMathExps(sample, gamma, N);
    
    figure(2);
    hold on;
    PlotDispersions(sample, gamma, N);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [exp, s2] = CalcExpDisp(sample)
%% ���������� �������� ������ ��������������� �������� � ���������

    n = length(sample);

    exp = sum(sample) / n;
    if n > 1
        s2 = sum((sample - exp).^2) / (n-1);
    else
        s2 = 0;
    end
end


function [lowM, highM] = CalcBordersExp(exp, s2, gamma, N)
%% ���������� ������ � ������� ������ �����������

    %���������� ����������� � ���������, ��������� �����������;
    %���������� ~St(n-1): P{|(m - mu^)/sqrt(s2)*sqrt(n)| < q_alpha} = gamma
    alpha = 1 - (1 - gamma) / 2;
    quantile = tinv(alpha, N-1);
    
    border = quantile * sqrt(s2) / sqrt(N);
    lowM = exp - border;
    highM = exp + border;
    
end


function [lowD, highD] = CalcBordersDisp(s2, gamma, N)
%% ���������� ������ � ������� ������ ���������

    %���������� ����������� � ���������, ��������� ���������;
    %���������� ~chi2(n-1): P{ q_low < s2*(n-1)/disp < q_high } = gamma
    
    low = (1 - gamma) / 2;
    a_quantile = chi2inv(low, N-1);
    highD = s2*(N-1) / a_quantile;
    
    high = 1 - low;
    a_quantile = chi2inv(high, N-1);
    lowD = s2*(N-1) / a_quantile;
    
end


function PlotMathExps(sample, gamma, N)
%% �� ������������ ��������� Oyn ��������� ������ y=mu^(x_N), � �����
%������� ������� mu^(x_n), mu_down(x_n), mu_up(x_n) ��� ������� �� ������ n
%�������, ��� n ���������� �� 1 �� N

start = 15;

    %���������� ����������� � ��������� ��� ������ n
    mu = zeros(N,1);
    s2 = zeros(N,1);
    for i = 1:N
        part = sample(1:i);
        [mu(i), s2(i)] = CalcExpDisp(part);
    end
    
    %��������� ������ �������� ��� ������
    mu_line = zeros(N,1);
    mu_line(1:N) = mu(N);
    
    %��������� ������� �������� ��� ������
    mu_down = zeros(N,1);
    mu_up = zeros(N,1);
    for i = 1:N
        [mu_down(i), mu_up(i)] = CalcBordersExp(mu(i), s2(i), gamma, i);
    end
    
    plot((start:N), mu_line(start:N), 'g');
    plot((start:N), mu(start:N), 'k');
    plot((start:N), mu_up(start:N), 'b');
    plot((start:N), mu_down(start:N), 'r');
    grid on;
    xlabel('n');
    ylabel('\mu');
    legend('\mu\^(x_N)', '\mu\^(x_n)', '\mu^{up}(x_n)', '\mu_{down}(x_n)');    
end


function PlotDispersions(sample, gamma, N)
%% �� ������������ ��������� Ozn ��������� ������ y=S2(x_N), � �����
%������� ������� S2(x_n), sigma_down(x_n), sigma_up(x_n) ��� ������� ��
%������ n �������, ��� n ���������� �� 1 �� N

%�� ����� n ��������� ������� �� 300, ������ �������� �� ����������
start = 20;


    %���������� ����������� � ��������� ��� ������ n
    mu = zeros(N,1);
    s2 = zeros(N,1);
    for i = start:N
        part = sample(1:i);
        [mu(i), s2(i)] = CalcExpDisp(part);
    end
    
    %��������� ������ �������� ��� ������
    s2_line = zeros(N,1);
    s2_line(1:N) = s2(N);
    
    %��������� ������� �������� ��� ������
    sigma_down = zeros(N,1);
    sigma_up = zeros(N,1);
    for i = start:N
        [sigma_down(i), sigma_up(i)] = CalcBordersDisp(s2(i), gamma, i);
    end
    
    nvalues = (start:N);
    plot(nvalues, s2_line(nvalues), 'g');
    plot(nvalues, s2(nvalues), 'k');
    plot(nvalues, sigma_up(nvalues), 'b');
    plot(nvalues, sigma_down(nvalues), 'r');
    grid on;
    xlabel('n');
    ylabel('\sigma');
    legend('S^2(x_N)', 'S^2(x_n)', '\sigma^{up}(x_n)', '\sigma_{down}(x_n)');
end
