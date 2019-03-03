function Main()
    sample = importdata('data(var5).txt');
    sample = [ sample zeros(1,200)+7];
    %sample = importdata('1.txt');
    sample = sort(sample);
    
    [Max] = getMaxValue(sample);
    [Min] = getMinValue(sample);
    [Range] = getRange(sample);
    fprintf("min value: %.2f \n", Min);
    fprintf("max value: %.2f \n", Max);
    fprintf("range    : %.2f \n", Range);
    
    [MX] = getExpectedValue(sample);
    [DX] = getDispersionValue(sample);
    fprintf("MX       : %.3f \n", MX);
    fprintf("DX       : %.3f \n", DX);
    
    [GroupTable, m] = Group(sample);
    for i=1:m-1
        fprintf("[%5.2f;%5.2f) ", GroupTable(1,i), GroupTable(1,i+1));
    end
    fprintf("[%5.2f;%5.2f]\n",GroupTable(1,m), Max);
    for i=1:m
        fprintf("%13d ", GroupTable(2,i));
    end
    fprintf("\n\n\n"); 
    
    figure(1);
    grid;
    hold on;
    HistogramAndDensity(sample)
    
    figure(2);
    grid;
    hold on;
    EmpiricalAndDensity(sample)
end

function [Max] = getMaxValue(sample)
	Max = max(sample);
end

function [Min] = getMinValue(sample)
	Min = min(sample);
end

function[Range] = getRange(sample)
	Range = getMaxValue(sample) - getMinValue(sample);
end

function [MX] = getExpectedValue(sample)
    n = length(sample);
    MX = sum(sample)/n;
end

function[DX] = getDispersionValue(sample)
    n = length(sample);
    MX = getExpectedValue(sample);
    DX = sum((sample - MX).^2) / (n-1);
end

function[GroupTable, m] = Group(sample)
    n = length(sample);
    m = floor(log2(n)) + 2;
    GroupTable = zeros(2,m);
    Delta = getRange(sample)/m;
    
    for k = 0:m-1
        GroupTable(1, k+1) = sample(1)+Delta*k;
    end
    
    count = 0;
    for i = 1:n
        for j = 1:m-1
            if sample(i) >=  GroupTable(1,j) && sample(i) < GroupTable(1, j+1)
                GroupTable(2, j) = GroupTable(2, j) + 1;
                count = count + 1;
                break;
            end    
        end    
    end
   GroupTable(2, m) = n - count;
end

function[] = HistogramAndDensity(sample)
    [min] = getMinValue(sample);
    [max] = getMaxValue(sample);
    count = 100;
    Delta = (max-min)/(count-1);

    Graph = zeros(2,count);
    [MX] = getExpectedValue(sample);
    [DX] = getDispersionValue(sample);
    
    for i = 1:count
        X = min + Delta*(i-1);
        Graph(1,i) = X;
        Graph(2,i) = NormalDensityDistribution(X, MX, DX);
    end
   
    [GroupTable, n] = Group(sample);
    x = zeros(n+1);
    y = zeros(n+1);
    znam = length(sample)*getRange(sample)/n;
    for i =1:n
        x(i) = GroupTable(1,i);
        y(i) = GroupTable(2,i) ./ znam;
        fprintf("%f %f \n", x(i), y(i));
    end
    x(n+1) = max;
    y(n+1) = y(n);
    
    %�����������
    stairs(x, y), grid;
    %������ ���������
    plot(Graph(1,:), Graph(2,:), 'r'),grid;
    
end

function[y] = NormalDensityDistribution(x, mx, dx) 
    y = exp(-((x-mx).^2)/2/dx)/sqrt(2*pi*dx);
end

function[y] = NormalDistribution(x,mx,dx)
    syms t;
    y = 1/sqrt(2*pi*dx) * int( exp(-((t-mx).^2)/2/dx), t, -Inf, x);
end

function EmpiricalAndDensity(sample)
    [min] = getMinValue(sample);
    [max] = getMaxValue(sample);
    count = 100;
    Delta = (max-min)/(count-1);

    Graph = zeros(2,count+100);
    [MX] = getExpectedValue(sample);
    [DX] = getDispersionValue(sample);
    
    for i = 1:count+100
        X = min + Delta*(i-1);
        Graph(1,i) = X;
        Graph(2,i) = NormalDistribution(X, MX, DX);
    end
    
    n = length(sample);
    F = zeros(n+1);
    for i = 1:n
       F(i) = EmpiricFunc(sample(i), sample, n);
    end
    F(n+1) = F(n);
    
    %������ ������� �������������
    plot(Graph(1,:), Graph(2,:), 'r'),grid;
    %������ ������������ �������
    sample2 = zeros(n+1);
    for i=1:n
        sample2(i) = sample(i);
    end
    sample2(n+1) = sample(n)+100*Delta;
    stairs(sample2, F),grid;
end

function[Fi] = EmpiricFunc(x, sample, n)
    count = 0;
    for i = 1:n
        if (sample(i) <= x)
            count = count + 1;
        else
            continue;
        end
    end
    Fi = count/n;
end

    
