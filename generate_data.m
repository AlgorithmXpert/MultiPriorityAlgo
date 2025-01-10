function data = generate_data(num_packets, max_priority)
    % Generate num_packets number of data packets
    % Each packet has a random priority between 1 and max_priority
    
    data = zeros(num_packets, 3);
    
    data(:,2) = randi(max_priority, num_packets, 1);
    
    data(:,3) = exprnd(1, num_packets, 1); % Exponentially distributed arrival times

    data(:,1) = 1:num_packets;
end
