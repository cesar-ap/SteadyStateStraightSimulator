Steady State Straight Simulator
============================

Steady State Straight Simulator v0.1

After the Steady State Corner Simulator, the next step was to make some kind of simulation for the straight segments. I started coding the acceleration phase on a straight basing my calculations on the Torque delivered by the engine at every RPM range. Few other parameters, such as Total Mass, traction tire radius and gearbox ratios are needed to calculate what is the acceleration capacity of the vehicle. The speed at the point n is calculated based on the speed in n-1 and the acceleration given by the engine at the point n.

Besides, the code calculates what is the best gear for the given gear ratios and the current speed by looking for the RPM range that gives the highest torque at that speed at the wheel.

Regarding the braking phase I supposed a constant braking force of 1G. The deceleration on every point is calculated based on the speed in the next point and the braking force provided by the brakes.

The initial conditions for the straight simulation are the straight length, initial speed and final speed.
