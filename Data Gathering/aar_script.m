model = "aar";
handle = load_system(model);
sim_in = [Simulink.SimulationInput(model)];
inputs = zeros([2 25]);

% Parameters
% Demand Response: "final_demand"
% Solar Panel Response: "solar_cap" and "initial_amp"
% Battery Power Capacity: "battery_cap"
% Virtual Inertia: "inertia_const"
% Transmission Line "transmission_lim"
demand_sweep = [1 0.98 0.96 0.94 0.92];
battery_sweep = [1e-9 500 1000 1500 2000];
inertia_sweep = [0 1 2 3 4];
amp_sweep = [0.8792 0.90323 0.91151 0.9173 0.9217];
trans_sweep = [1000 2000 3000 4000 5000];
for i=1:5
    for j=1:5
        index = 5*(i-1)+j;
        inputs(1,index) = inertia_sweep(i);
        inputs(2,index) = demand_sweep(j);
    
        sim_in(index) = Simulink.SimulationInput(model);
        sim_in(index) = setVariable(sim_in(index),'inertia_const',inputs(1,index),"Workspace",model);
        sim_in(index) = setVariable(sim_in(index),'final_demand',inputs(2,index),"Workspace",model);
    end
end

out = [inputs; zeros([1 length(inputs)])];
sim_out = sim(sim_in, 'ShowSimulationManager', 'on');

for i=1:length(inputs)
    out(3,i) = min(getElement(get(sim_out(i),"logsout"),"Generator Frequency 3").Values.Data);
end

out = out.';
writematrix(out, "output.csv");