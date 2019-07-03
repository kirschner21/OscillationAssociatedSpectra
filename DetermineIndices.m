function indices = DetermineIndices(in_array,first,last)
% DetermineIndices find the indices that correspond to a range in an array

% handle if the input array is not sorted
[sorted_array, indices] = sort(in_array);

% finds indices in an array
fi = find(sorted_array > first, 1); %find lower bound
li = find(sorted_array > last, 1) - 1; %find upper bound

% assign an output value if the last value is too high
if isempty(li)
    li=length(sorted_array);
end

% get the output values
indices = [indices(fi),indices(li)];

end

