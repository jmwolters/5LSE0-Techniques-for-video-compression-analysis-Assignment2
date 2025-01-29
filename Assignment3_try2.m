clear all
close all

run('Wolters/mnist/load_test.m')

%% 3a

test_size = size(test_digits);

rows = sum(test_digits,2)/(255*28);

train_set = rows(:,:,1:5000);
control_set = rows(:,:,5001:10000);

test_label = test_labels(1:5000);
control_label = test_labels(5001:10000);

means = zeros(10,28);
stds = zeros(10,28);

for i = 1:10
    index = find(test_label == i-1);
    train_number = train_set(1:28,:,index);
    train_number = squeeze(train_number)';

    means(i,1:28) = mean(train_number);
    stds(i,1:28) = sqrt(var(train_number));
end

probs = zeros(10,1);
guess = zeros(length(train_set),1);
P_guess = zeros(length(train_set),1);

for num = 1:length(control_set)
    for i = 1:10
        num_vector = control_set(1:28,:,num);
        likelihoods(1:28) = normcdf(num_vector(1:28)',means(i,1:28),stds(i,1:28));
        probs(i,num) = HMM_estimator(i,num_vector',means,stds); % Why are probabilities insanely high?
        
        [P_guess(num,1), guess(num,1)] = max(probs(:,num));
        guess(num,1) = guess(num,1) - 1;
    end
end

accuracy = length(find(guess == control_label))/length(control_label);
final_check = [control_label guess];

% X is the number that is guessed
% Y is the number from the label
con_matrix = confusionmat(final_check(:,1),final_check(:,2));


function [prob, likelihoods] = HMM_estimator(number,observation,means,stds)
    
    likelihoods =zeros(1,28);
    for s = 1:28
        if stds(number,s) == 0
            if means(number,s) == observation(s)
                likelihoods(s) = 1;
            else
                likelihoods(s) = 0;
            end
        else
            likelihoods(s) = normpdf(observation(s),means(number,s),stds(number,s));
        end
    end
    prob = prod(likelihoods);
end

