param_names = ["demand" "trans" "storage" "inertia" "solar"];
axis_names = ["Final Demand" "Transmission Line Cap (MW)" "Storage Capacity (MW)" "Inertia Constant (s)" "Solar Capacity"];

for i=1:4
    for j=i+1:5
        param1 = param_names(i);
        param2 = param_names(j);

        data = readmatrix("../Data/Normalized Data/" + param1 + "-" + param2 + ".csv");
        data = data.';
        
        x_data = data(1,1:5:end);
        y_data = data(2,1:5);
        freq_data = reshape(data(3,:),[5 5]);
        
        surf(x_data, y_data,freq_data)
        hold on
        xlabel(axis_names(i))
        ylabel(axis_names(j))
        zlabel("Frequency Change (Hz)")
        hold off
        
        exportgraphics(gca,"../Graphs/Surface Plots/" + param1 + "-" + param2 + "-graph.png")
    end
end