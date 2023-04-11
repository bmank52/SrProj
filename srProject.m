clc
clear all
close all
monthlyData = fopen('USAemissionsdata.txt'); #opens file,  fileID = variable
list = fscanf(monthlyData, '%f');
fclose('USAemissionsdata.txt') #closes file

function ton = kg_to_ton(kg) 
  ton = 0.00110231 * kg;  #kg to ton conversion factor
end

function kg = ton_to_kg(ton)
  kg = 907.185 * ton;
end

function burned = ton_kr_burned(CO2) #how much fuel is burned based off CO2 emitted by kerosene
  burned = ton_to_kg(CO2) / 3.16;
end

function newPrice = change_fuel_price(p, t, r) #change in fuel price based on starting price, time, rate of change
  newPrice = p ./ r .* (e .^ (r .^ t) - 1);
end

standardFuelRate = 1;
allSAF = list * 0.2;  #ideal rate in research paper
halfSAF = list * 0.5 + allSAF * 0.5;
quarterSAF = list * 0.75 + allSAF * 0.25;
threeQuarterSAF = list * 0.25 + allSAF * 0.75;
x = linspace(0, 540, 540);
subplot(1,2,1)

plot(x, list, x, allSAF, x, halfSAF, x, quarterSAF, x, threeQuarterSAF);
title('CO2 Emissions from 2014-2022 per month');
xlabel('Months starting at Jan 2014');
ylabel('Tons of CO2 Emitted');
legend('Standard Jet Fuel' , 'All SAF', 'Half SAF', 'Quarter SAF', '3/4 SAF');


costOfKr = 1018.30; # $ per ton of kr
costOfSaf = costOfKr * 2.2;
KrPrice = change_fuel_price(costOfKr, x/12, 1.01);
SafPrice = change_fuel_price(costOfSaf, x/12, .9775)
subplot(1,2,2)
#plot(x, change_fuel_price(costOfKr, x / 12, 1.01) * ton_kr_burned(list), x, change_fuel_price(costOfSaf, x / 12, .9775) * ton_kr_burned(list))
plot(x, KrPrice, x, SafPrice, x, KrPrice * 0.5 + SafPrice * 0.5, x, KrPrice * 0.75 + SafPrice * 0.25, x, KrPrice *0.25 + SafPrice * 0.75)
title('Cost of Fuels');
xlabel('Month starting in 2014');
ylabel('cost of fuel per metric ton ($)');
legend('Standard Jet Fuel', 'All Saf', 'Half Saf', 'Quarter Saf', '3/4 Saf');

