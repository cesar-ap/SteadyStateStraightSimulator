function Fb = Brakes_Force(Brakes_G_Force, Total_Mass)
    Fb = Total_Mass * Brakes_G_Force * 9.81;
end