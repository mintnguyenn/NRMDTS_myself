f1 = imread('square_example_545_2_2.png');
f2 = imread('square_example_545_4.png');

f3 = imread('square_example_551_1_2.png');
f4 = imread('square_example_551_2_2.png');
f5 = imread('square_example_551_3_2.png');
f6 = imread('square_example_551_4.png');

f7 = imread('square_example_565_2_2.png');
f8 = imread('square_example_565_4.png');

result = imadd(0.4*f1, 0.6*f2);
imwrite(result, 'square_example_merged_545_2.png');
result1 = imadd(0.5*f3, 0.5*f4);
result2 = imadd(0.3*f5, 0.7*f6);
result = imadd(0.4*result1, 0.6*result2);
imwrite(result, 'square_example_merged_551_2.png');
result = imadd(0.4*f7, 0.6*f8);
imwrite(result, 'square_example_merged_565_2.png');

