function [] = View_compare_SVR(experiment_name)
% look at results generated by running compare_SVR.m

SVR_performances = load(['~/predicting_consistency/outputs/svr/' experiment_name '.mat']);
setup = load(['~/predicting_consistency/outputs/svr/' experiment_name '_setup.mat']);

models = setup.models;
score_types = setup.score_types;
score_types_short  = cellfun(@(x) x(1:end-7), score_types, 'UniformOutput', false);
kernels = setup.kernels;
features = setup.features;
norm_funs = setup.norms;



% turn of TeX interpreter
set(0,'DefaultTextInterpreter','none');

% input = SVR_performances.Correlation;
% type = 'Correlation';

% input = SVR_performances.Error_performance;
% type = 'Error'

input = SVR_performances.SpearCorrelation;
type = 'Spearman Correlation'


% A figure for each model, with subplots for each metric
plt(input, type, models, 'Algorithms', score_types_short, 'Metric', features, 'features', [1,2,4,3])

if 0
    
    % A figure for each metric, with subplots for each feature
    plt(input, type, score_types_short, 'Metric', features, 'features', models, 'Algorithms', [2,4,1,3])
    
    % A figure for each model, with subplots for each metric
    plt(input, type, models, 'Algorithms', score_types_short, 'Metric', features, 'features', [1,2,4,3])
    
    % A figure for each model with subplots for each feature
    plt(input, type, models, 'Algorithms', features, 'features', score_types_short, 'Metric', [1,4,2,3])
    
    % A figure for each feature, with subplots for each model
    plt(input, type, features, 'features', models, 'Algorithms', score_types_short, 'Metric', [4,1,2,3])
    
    % A figure for each feature, with subplots for each metric
    plt(input, type, features, 'features', score_types_short, 'Metric', models, 'Algorithms', [4,2,1,3])
end

    function [] = plt(input, type, outer, outer_name, inner, inner_name, bars, bars_name, permutation)
        % permutation should be [outer, inner, ..., kernel],
        % if i wanted outer to be features and inner to be models
        % then permuation = [4,1,2,3]
        input = permute(input, permutation);
        bars = strrep(bars, '_', ' ');
        handles = [];
        best_upper = 0;
        best_lower = Inf;
        for x = 1:numel(outer)
%             str = sprintf('\n%s \t: %s', outer_name, outer{x});
%             disp(str)
            hfig = figure;
            set(hfig,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
            num_tile = ceil(sqrt(numel(inner)));
%             fmt=[repmat('%s | ',1,length(bars))];
%             str = sprintf(['|%s \t|', fmt], '', bars{:});
%            disp(str)
            for y = 1:numel(inner)
                hx = subplot(num_tile, num_tile, y);
                data = squeeze(input(x, y, :, :));
%                 fmt=[repmat('%0.2f | ',1,length(data))];
%                 str = sprintf(['|%s \t|:', fmt], inner{y}, data);
%                 disp(str)
                h = bar(data);
                title(inner{y})
                set(gca, 'XTick', 1:numel(bars))
                set(gca,'XTickLabel', bars)
                rotateXLabels( gca, 45 )
                %   set(gca, 'XTickLabelRotation', 90)
                set(gca, 'PlotBoxAspectRatio', [2,1,1])
                if y == 1
                    legend(kernels);
                end
                
                handles = [handles hx];
                lims = ylim(hx);
                
                if lims(2) > best_upper
                    best_upper = lims(2);
                end
                
                if lims(1) < best_lower
                    best_lower = lims(1);
                end
                
            end
            for m = 1:length(handles)
                set(handles(m),'YLim',[best_lower, best_upper])
            end
            str = [type ' with ' outer{x} ' ' outer_name ' for different ' bars_name ' by ' inner_name ];
            suptitle(str)
        end
    end
end

