function [success_rate, avg_delay, estimated_lambda] = simulate_spma_with_little_law(data, service_rate)
    % Simulate the SPMA protocol using a multi-priority queue with Little's Law for performance estimation
    % data: Matrix of generated data packets
    % service_rate: The rate at which packets are serviced (exponentially distributed service times)
    
    max_priority = max(data(:,2));
    num_packets = size(data, 1); 

    % Initialize queues for each priority
    queues = cell(max_priority, 1);
    
    % Sort packets by arrival time
    data = sortrows(data, 3);
    
    current_time = 0;
    total_delay = 0;
    total_queue_length = 0;
    successful_transmissions = 0;
    
    % Process packets based on priorities
    for i = 1:num_packets
        packet = data(i, :);
        arrival_time = packet(3);
        priority = packet(2);
        
        % Add packet to corresponding priority queue
        queues{priority} = [queues{priority}; packet];
        
        % Calculate queue length at this point (L)
        total_queue_length = total_queue_length + length(queues{priority});
        
        % Service the highest priority queue first
        for p = 1:max_priority
            if ~isempty(queues{p}) 
                packet_to_send = queues{p}(1, :); 
                service_time = exprnd(1/service_rate);
                departure_time = max(current_time, packet_to_send(3)) + service_time; 
                delay = departure_time - packet_to_send(3);
                total_delay = total_delay + delay;
                successful_transmissions = successful_transmissions + 1;
                
                % Remove the packet from the queue after servicing
                queues{p}(1, :) = [];
                current_time = departure_time;
                break; 
            end
        end
    end
    
    % Calculate success rate and average delay
    success_rate = successful_transmissions / num_packets;
    
    % Average delay calculation from Little’s Law
    avg_delay = total_delay / successful_transmissions;
    
    % Estimate the arrival rate lambda from the data (estimated as number of packets / total simulation time)
    total_time = data(end, 3); 
    estimated_lambda = num_packets / total_time;
    
    % Apply Little’s Law for delay estimation
    if estimated_lambda > 0
        estimated_avg_delay = total_queue_length / (num_packets * estimated_lambda);
    else
        estimated_avg_delay = 0;
    end
    
    % Displaying estimated delay from Little’s Law (optional)
    disp(['Estimated average delay using Little\'s Law: ', num2str(estimated_avg_delay)]);
end
