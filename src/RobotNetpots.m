classdef RobotNetpots < handle
    %ROBOTCOWS A class that creates a herd of robot cows
    %   The cows can be moved around randomly. It is then possible to query
    %   the current location (base) of the cows

    properties (Constant)
        %> Max height is for plotting of the workspace
        maxHeight = 10;
    end

    properties
        %> Number of bricks
        netpotCount = 16;

        %> A cell structure of \c cowCount cow models
        netpotModel;

        %> paddockSize in meters
        paddockSize = [2,2];

        %> Dimensions of the workspace in regard to the padoc size
        workspaceDimensions;
    end

    methods
        %% ...structors
        function self = RobotNetpots(numPots)
            self.workspaceDimensions = [-self.paddockSize(1)/2, self.paddockSize(1)/2 ...
                ,-self.paddockSize(2)/2, self.paddockSize(2)/2 ...
                ,0,self.maxHeight];

            steps = numPots;
            for i = 1:steps
                self.netpotModel{i} = self.GetBrickModel(['Netpot',num2str(i)]);

                if i < 5
                    self.netpotModel{i}.base = SE3(transl(1.4, -0.35, 0.1-(i-1)*0.02)) * SE3(trotx(-pi/2));
                end
                if  5 <= i
                    self.netpotModel{i}.base = SE3(transl(1.5, -0.35, 0.1-(i-5)*0.02)) * SE3(trotx(-pi/2));
                end
                if 8 < i
                    self.netpotModel{i}.base = SE3(transl(1.6, -0.35, 0.1-(i-9)*0.02)) * SE3(trotx(-pi/2));
                end
                if 12 < i
                    self.netpotModel{i}.base = SE3(transl(1.7, -0.35, 0.1-(i-13)*0.02)) * SE3(trotx(-pi/2));
                end
                
                % Plot 3D model
                color = {'white'};
                plot3d(self.netpotModel{i},0,'workspace',self.workspaceDimensions,'view',[-30,30],'delay',0,'noarrow','nowrist','color',color,'notiles');

                % Hold on after the first plot (if already on there's no difference)
                if i == 1
                    hold on;
                end
            end

            axis equal
            if isempty(findobj(get(gca,'Children'),'Type','Light'))
                camlight
            end
        end

        %% TestPlotManyStep
        % Go through and plot many random walk steps
        function TestPlotManyStep(self,numSteps,delay)
            if nargin < 3
                delay = 0;
                if nargin < 2
                    numSteps = 200;
                end
            end
            for i = 1:numSteps
                self.PlotSingleRandomStep();
                pause(delay);
            end
        end
    end

    methods (Static)
        %% GetBrickModel
        function model = GetBrickModel(name)
            if nargin < 1
                name = 'Netpot';
            end
            [faceData,vertexData] = plyread('Net_Pot.ply','tri');
            link1 = Link('alpha',pi/2,'a',0,'d',0,'offset',0);
            model = SerialLink(link1,'name',name);

            % Changing order of cell array from {faceData, []} to
            % {[], faceData} so that data is attributed to Link 1
            % in plot3d rather than Link 0 (base).
            model.faces = {[], faceData};

            % Changing order of cell array from {vertexData, []} to
            % {[], vertexData} so that data is attributed to Link 1
            % in plot3d rather than Link 0 (base).
            model.points = {[], vertexData};
        end
    end
end