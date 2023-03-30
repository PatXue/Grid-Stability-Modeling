param_names = ["storage" "trans" "inertia" "demand"];
axis_names = ["Battery Power Cap (MW)" "Transmission Line Cap (MW)" "Inertia Constant (s)" "Final Demand"];

for i=1:3
    for j=i+1:4
        param1 = param_names(i);
        param2 = param_names(j);

        data = readmatrix("Data/" + param1 + "-" + param2 + ".csv");
        data = data.';
        
        x_data = data(1,1:5:end);
        y_data = data(2,1:5);
        freq_data = reshape(data(3,:),[5 5]);
        
        surf(x_data, y_data,freq_data)
        hold on
        xlabel(axis_names(i))
        ylabel(axis_names(j))
        zlabel("Minimum Frequency (Hz)")
        hold off
        
        %exportgraphics(gca,"Graphs/" + param1 + "-" + param2 + "-graph.png")
    end
end