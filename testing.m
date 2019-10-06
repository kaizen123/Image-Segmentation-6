close all; clear variables;
image = imread('cow.jpg');
k = 0;
labeled_image = imSegment(image, k, 'lab', true);
figure,
imshow(label2rgb(labeled_image));
