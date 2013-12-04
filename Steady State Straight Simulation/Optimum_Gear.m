function [gear, highest_torque, E] = Optimum_Gear(W, gear_ratios, Final_ratio, Torque, RPM)
    % Returns the best gear and the torque for a given RPM figure
    highest_torque = 0;
    current_power=0;
    gear=1;
    E=0;

    for j=1:length(gear_ratios)
        current_E = W * Final_ratio * gear_ratios(j); % rpm at the Engine for Gear j
        if (current_E > RPM(1)) && (current_E < RPM(end)); % RPM should be on the table
            for k=1:(length(RPM)-1)
                if (current_E>RPM(k)) && (current_E<RPM(k+1))
                    % This is the RPM range where we are. We calculate
                    % the power here.
                    current_torque = (Torque(k)+Torque(k+1))/2;
                    current_power = current_torque * E / (60 * 1000 / (2*pi)); % power in KW
                    current_power = current_power * 1.341; % power in BHP   
%                         fprintf ('Gear %d\n',j);
%                         fprintf ('Power %d\n',power);
%                         fprintf ('Torque %d\n',torque);
%                         fprintf ('RPM %d\n',E);
%                         fprintf('-----------------\n')
                end
            end
            if current_torque>highest_torque
                gear = j;
                power=current_power;
                highest_torque = current_torque;
                E=current_E;
            end
        end
    end
%         fprintf ('\n--- FINAL ---\n');
%         fprintf ('Best gear %d\n',gear);
%         fprintf ('Max Power %d\n',power);
%         fprintf ('Torque %d\n',highest_torque);
%         fprintf ('RPM %d\n',E);     
end