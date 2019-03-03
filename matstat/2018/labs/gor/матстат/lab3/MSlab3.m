
function Main()
    Y = importdata('dataY(v5).txt');
    T1 = importdata('dataT(v5).txt');
    T2 = T1.^2;
    T0(1:length(T1), 1)=1;
    
    psi = horzcat(T0,T1,T2);
    psiT = transpose(psi);
    %���������� ��� ������ ������� theta
    theta = inv(psiT*psi)*psiT*Y;
    Yt = theta(1) + theta(2)*T1 + theta(3)*T2;
    fprintf("theta1 = %.2f\n",theta(1));
    fprintf("theta2 = %.2f\n",theta(2));
    fprintf("theta3 = %.2f\n",theta(3));
    Ystr = sprintf("Yt = %.2f + %.2f*t + %.2f*t^2\n", theta(1), theta(2), theta(3));
    fprintf(Ystr);
    
    %���������� ������������������� ���������� ���������� ������ 
    %�� ����������� ���������
    delta = sqrt(sum((Y-Yt).^2));
    fprintf("delta=%.3f\n",delta);
   
    figure(1);
    xlabel('T');
    ylabel('Y');
    plot(T1, Y, '.r'); %�����������   
    hold on;
    plot(T1, Yt, 'b'); %��������
    legend("������� ����� (t_i,y_i)", Ystr);
    grid on;
end