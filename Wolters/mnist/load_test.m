test_file = ['scrambled_test.bin'];
fid = fopen(test_file, 'r');

[number, count] = fread(fid, 1, 'int32');
if count ~= 1
    disp('failed to read number');
end

[test_permutation, count] = fread(fid, number, 'int32');
if count ~= test_permutation
    disp('failed to read number');
end


[test_labels, count] = fread(fid, number, 'uchar');
if count ~= number
    disp('failed to read number');
end
    
test_digits = fread(fid, [28, 28 * number], 'uchar');
test_digits = reshape(test_digits, [28, 28, number]);

fclose(fid);
disp('loaded test digits');
