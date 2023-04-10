model = "main-model";
handle = load_system(model);
sim_in = Simulink.SimulationInput(model);

% Parameters
% Demand Response: "final_demand"
% Solar Panel Response: "solar_cap"
% Battery Power Capacity: "battery_cap"
% Virtual Inertia: "inertia_const"
% Transmission Line "transmission_lim"
demand_sweep = 0.98:0.005:1;
battery_sweep = [0 500 1000 1500 2000];
inertia_sweep = [0 0.25 0.5 0.75 1];
solar_sweep = 1:0.0125:1.05;
trans_sweep = [1000 2000 3000 4000 5000];

var_sweeps = [demand_sweep; trans_sweep; battery_sweep; inertia_sweep; solar_sweep];
param_filenames = ["demand" "trans" "storage" "inertia" "solar"];
var_names = ["final_demand" "transmission_lim" "battery_cap" "inertia_const" "solar_cap"];

inputs = zeros([2 25]);

for p=4:4
    for q=p+1:5
        for i=1:5
            for j=1:5
                index = 5*(i-1)+j;
                inputs(1,index) = var_sweeps(p,i);
                inputs(2,index) = var_sweeps(q,j);
            
                sim_in(index) = Simulink.SimulationInput(model);
                sim_in(index) = setVariable(sim_in(index), var_names(p),inputs(1,index),"Workspace",model);
                sim_in(index) = setVariable(sim_in(index), var_names(q),inputs(2,index),"Workspace",model);
            end
        end
        
        out = [inputs; zeros([1 length(inputs)])];
        sim_out = sim(sim_in, 'ShowSimulationManager', 'on');
        
        for i=1:length(inputs)
            freq_data = getElement(get(sim_out(i),"logsout"),"Frequency 3").Values.Data;
            out(3,i) = freq_data(1) - min(freq_data);
        end
        
        writematrix(out.', "../Data/Raw Data/" + param_filenames(p) + "-" + param_filenames(q) + ".csv");
    end
end