function Fd = Aero_Resistance(drag_coef, Area, air_t, atm_p, speed)
    % Function to calculate the Aero Downforce Resistance based on
    % speed
    air_d = 1.2255 * (15+273) / (air_t + 273) * atm_p / 1000;
    Fd = 0.5 * air_d * drag_coef * Area * speed^2;
end