function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

%Theta1:25*401  Theta2: 10 * 26
X_1 =[ones(m,1) X]; %5000 *401
z_2 = X_1 * Theta1';%5000 * 25
a_2=sigmoid(z_2); %5000 * 25
a_2_temp=[ones(m,1) a_2]; %5000 * 26
h = sigmoid(a_2_temp * Theta2'); %5000 * 10
% 设置5000 * 10的y
y_temp = ones(m, num_labels);
for i = 2:num_labels
	y_temp(:,i) = i;
end
ym = y_temp == y;

%[val,ind] = max(h,[],2);
%p = ind;
%hm = y_temp == p;

J = -1.0/m * sum(sum(ym .* log(h) + (1-ym) .* log(1-h))) ;

%for i=1:m
%	z_2 = Theta1*X_1(i,:)';%25*1
%	z_3 = Theta2 * [1;sigmoid(z_2)];%10*1
%	a_3 = sigmoid(z_3);%10*1
%	J = J + 1.0/m * (-ym(i,:) * log(a_3) - (1-ym(i,:)) * log(1-a_3));
%end
J = J+lambda/(2*m)*(sum(sum(Theta2(:,2:end).^2))+sum(sum(Theta1(:,2:end).^2)));

%part2 backpropagation

delta3 = h - ym; %5000 * 10  %%%%%%%%%%%%%%  h  or  hm
delta2 = delta3 * Theta2(:,2:end) .* sigmoidGradient(z_2); %5000*25

Delta2 = 1.0/m * delta3' * a_2_temp; % 10* 26
Delta1 = 1.0/m * delta2' * X_1; % 25 * 401

Theta2_lam = Theta2;
Theta2_lam(:,1) = 0;
Theta2_grad = Delta2 + lambda/m * Theta2_lam;
Theta1_lam = Theta1;
Theta1_lam(:,1) = 0;
Theta1_grad = Delta1 + lambda/m * Theta1_lam;





% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
