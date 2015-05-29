function [] = print_conf_matrix( TP, FP, TN, FN, varargin )

% Parse optional arguments.
parser = inputParser;
addOptional(parser, 'fileId', 1, @isnumeric);

parse(parser, varargin{:});
fileId = parser.Results.fileId;

fprintf(fileId, '                   Predicted Class  \n');
fprintf(fileId, '                .---------.--------.\n');
fprintf(fileId, '                |   Pos.  |   Neg. |\n');
fprintf(fileId, '        .-------|---------|--------|\n');
fprintf(fileId, ' Actual | Pos.  | %6d  | %5d  |\n', TP, FN);
fprintf(fileId, ' Class  | Neg.  | %6d  | %5d  |\n', FP, TN);
fprintf(fileId, '        `--------------------------´\n\n\n'); 
fprintf(fileId, 'Accuracy = %.3f\n', (TP+TN)/(TP + FP + TN + FN)); 
fprintf(fileId, 'Precision = %.3f\n', TP/(TP + FP)); 
fprintf(fileId, 'Sensitivity = %.3f\n', TP/(TP + FN)); 
end