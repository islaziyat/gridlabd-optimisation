%     n = csvread(current_file,2,1);
%     linenumber = length(n(:,1));
%     for phase = 1:3
%         current(:,phase) =  n(:,(phase-1)*2 + 1) + j*n(:,(phase-1)*2 + 2);
%     end
%     
%     current = [current; current(linenumber,:)];
