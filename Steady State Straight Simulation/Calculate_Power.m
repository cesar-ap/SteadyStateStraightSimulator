function power = Calculate_Power(Torque,RPM,print)
% This function calculates the Power deliverd by an engine given its RPM
% and Torque values.

    power=zeros(1,length(Torque)); % array to keep the power at every RPM range
    for i=1:length(Torque)
        power(i) = Torque(i) * RPM(i) / (60 * 1000 / (2*pi)); % power in KW
        power(i) = power(i) * 1.341; % power in BHP   
    end
    
    if strcmp(print,'yes')
        set(figure,'Name','Torque-Power-RPM','NumberTitle','off');
        plot(RPM,Torque,RPM,power);
        grid on;
        legend('Torque [Nm]','Power [BHP]')
        xlabel('RPM');
    end

end