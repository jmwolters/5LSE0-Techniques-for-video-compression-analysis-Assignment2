clear all
close all

run('Wolters/mnist/load_test.m')

%% 3a

test_size = size(test_digits);

test_summed_row = sum(test_digits,2)/7140;

test_set_row = test_summed_row(:,:,1:5000);
test_control_row = test_summed_row(:,:,5001:10000);

test_set_label = test_labels(1:5000);
test_control_label = test_labels(5001:10000);

means_row = zeros(10,28);
stds_row = zeros(10,28);
% figure(1)
% hold on
% grid on


for i = 1
    index = find(test_set_label == i-1);

    % Find means and STDs for rows
    test_set_index_row = test_set_row(1:28,:,index);
    means_row(i,1:28) = mean(test_set_index_row(1:28,:,length(index)),2);
    stds_row(i,1:28) = sqrt(var(test_set_index_row(1:28,:,1:length(index)),1,3));
end

close all

probs_row = zeros(10,28);
value_row = zeros(1,28);

guess = zeros(5000,2);

for g = 1:5000
    for z = 1:28
        for i = 1:10
            probs_row(i,z) = normpdf(test_control_row(z,1,g),means_row(i,z),stds_row(i,z));
            plot(normpdf(-20:0.01:20,means_row(i,z),stds_row(i,z)));
        end
        probs_total = probs_row;
        probs_total(isnan(probs_total)) = 0;

        [prob, value] = max(probs_total);
        guess(g) = mode(value)-1;
    end
end
guess = guess(:,1);

accuracy = length(find(guess == test_control_label))/5000;
final_control = [test_control_label,guess];

%% Create confusion matrix
con_matrix = zeros(10,10);
for i = 1:10
   con_matrix(i,:) = histcounts(final_control(find(final_control(:,1)==i-1),2),10);
end