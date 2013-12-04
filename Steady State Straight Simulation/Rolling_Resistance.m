function Fr = Rolling_Resistance(speed, rolling_coef, Total_Mass, g)
    % Function to calculate the Rolling Resistance based on speed

    Fr = rolling_coef * Total_Mass * g;
end