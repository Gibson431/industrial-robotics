classdef NedAndElleApp < matlab.apps.AppBase

    properties (Access = public)
        UIFigure matlab.ui.Figure
        GridLayout matlab.ui.container.GridLayout

        LeftPanel  matlab.ui.container.Panel
        LeftGrid matlab.ui.container.GridLayout
        LeftPanelTitle matlab.ui.control.Label
        LeftButtonGroup CustomXYZControl
        LeftSliderGroup CustomJointControl

        CentrePanel matlab.ui.container.Panel
        CentreGrid matlab.ui.container.GridLayout
        EStopSwitch matlab.ui.control.Switch
        EStopSwitchLabel matlab.ui.control.Label

        RightPanel  matlab.ui.container.Panel
        RightGrid matlab.ui.container.GridLayout
        RightPanelTitle matlab.ui.control.Label
        RightButtonGroup CustomXYZControl
        RightSliderGroup CustomJointControl

        NedRobot
        ElleRobot
        environment;

    end

    properties (Access = private)
        onePanelWidth = 576;
        twoPanelWidth = 768;
        eStop = false;
        stepsComplete = 0;
    end
    methods (Access = private)
        function LeftButtonPressed(app, event)
            disp(event.Source.Text);
            switch event.Source.Text
                case 'X +'
                    disp(['Left ', app.LeftButtonGroup.PX.Text])
                case 'X -'
                    disp(['Left ', app.LeftButtonGroup.NX.Text])
                case 'Y +'
                    disp(['Left ', app.LeftButtonGroup.PY.Text])
                case 'Y -'
                    disp(['Left ', app.LeftButtonGroup.NY.Text])
                case 'Z +'
                    disp(['Left ', app.LeftButtonGroup.PZ.Text])
                case 'Z -'
                    disp(['Left ', app.LeftButtonGroup.NZ.Text])
            end
        end

        function RightButtonPressed(app, event)
            disp(event.Source.Text);
            switch event.Source.Text
                case 'X +'
                    disp(['Right ', app.RightButtonGroup.PX.Text])
                case 'X -'
                    disp(['Right ', app.RightButtonGroup.NX.Text])
                case 'Y +'
                    disp(['Right ', app.RightButtonGroup.PY.Text])
                case 'Y -'
                    disp(['Right ', app.RightButtonGroup.NY.Text])
                case 'Z +'
                    disp(['Right ', app.RightButtonGroup.PZ.Text])
                case 'Z -'
                    disp(['Right ', app.RightButtonGroup.NZ.Text])
            end
        end

        function LeftSlidersMoved(app, ~)
            L0 = app.LeftSliderGroup.Link0.Value;
            L1 = app.LeftSliderGroup.Link1.Value;
            L2 = app.LeftSliderGroup.Link2.Value;
            L3 = app.LeftSliderGroup.Link3.Value;
            L4 = app.LeftSliderGroup.Link4.Value;
            L5 = app.LeftSliderGroup.Link5.Value;
            app.LeftSliderGroup.Link0
            qVals = deg2rad([L0 L1 L2 L3 L4 L5]);
            app.NedRobot.jog(qVals);
        end

        function RightSlidersMoved(app, ~)
            L0 = app.RightSliderGroup.Link0.Value;
            L1 = app.RightSliderGroup.Link1.Value;
            L2 = app.RightSliderGroup.Link2.Value;
            L3 = app.RightSliderGroup.Link3.Value;
            L4 = app.RightSliderGroup.Link4.Value;
            L5 = app.RightSliderGroup.Link5.Value;
            qVals = deg2rad([L0 L1 L2 L3 L4 L5]);
            app.ElleRobot.jog(qVals);
        end

        function EStopValueChanged(app, event)
            app.eStop = event.Value;
        end

        function updateAppLayout(app, ~)
            currentFigureWidth = app.UIFigure.Position(3);
            if(currentFigureWidth <= app.onePanelWidth)

                % Change to a 3x1 grid
                app.GridLayout.RowHeight = {480,480,480};
                app.GridLayout.ColumnWidth = {'1x'};
                app.CentrePanel.Layout.Row = 1;
                app.CentrePanel.Layout.Column = 1;
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 3;
                app.RightPanel.Layout.Column = 1;
            elseif(currentFigureWidth > app.onePanelWidth && currentFigureWidth <= app.twoPanelWidth)

                % Change to a 2x2 grid
                app.GridLayout.RowHeight = {480,480};
                app.GridLayout.ColumnWidth = {'1x', '1x'};
                app.CentrePanel.Layout.Row = 1;
                app.CentrePanel.Layout.Column = [1,2];
                app.LeftPanel.Layout.Row = 2;
                app.LeftPanel.Layout.Column = 1;
                app.RightPanel.Layout.Row = 2;
                app.RightPanel.Layout.Column = 2;
            else

                % Change to a 1x3 grid
                app.GridLayout.RowHeight = {'1x'};
                app.GridLayout.ColumnWidth = {'2x','1x','2x'};
                app.LeftPanel.Layout.Row = 1;
                app.LeftPanel.Layout.Column = 1;
                app.CentrePanel.Layout.Row = 1;
                app.CentrePanel.Layout.Column = 2;
                app.RightPanel.Layout.Row = 1;
                app.RightPanel.Layout.Column = 3;
            end
        end
    end

    % Component initialisation
    methods (Access = private)

        % Create UIFigure and components
        function creatComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible','off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 1000 540];
            app.UIFigure.Name = 'Ned and Elle App';
            app.UIFigure.SizeChangedFcn = createCallbackFcn(app, @updateAppLayout, true);

            % Create grid layout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {'1x', '1x', '1x'};
            app.GridLayout.RowHeight = {'1x'};
            app.GridLayout.ColumnSpacing = 0;
            app.GridLayout.RowSpacing = 0;
            app.GridLayout.Padding = [0 0 0 0];
            app.GridLayout.Scrollable = 'off';

            % Create LeftPanel
            app.LeftPanel = uipanel(app.GridLayout);
            app.LeftPanel.Layout.Row = 1;
            app.LeftPanel.Layout.Column = 1;

            % Create LeftGrid
            app.LeftGrid = uigridlayout(app.LeftPanel);
            app.LeftGrid.ColumnWidth = {'1x'};
            app.LeftGrid.RowHeight = {'1x', '3x','6x'};
            app.LeftGrid.ColumnSpacing = 2.5;
            app.LeftGrid.Padding = [5 5 5 5];

            % Create LeftPanelTitle
            app.LeftPanelTitle = uilabel(app.LeftGrid);
            app.LeftPanelTitle.Text = 'Ned Robot';
            app.LeftPanelTitle.Layout.Column = 1;
            app.LeftPanelTitle.Layout.Row = 1;
            app.LeftPanelTitle.HorizontalAlignment = 'center';

            % Create LeftButtonGroup
            app.LeftButtonGroup = CustomXYZControl(app.LeftGrid, app);
            app.LeftButtonGroup.GridLayout.Layout.Column = 1;
            app.LeftButtonGroup.GridLayout.Layout.Row = 2;
            app.LeftButtonGroup.PX.ButtonPushedFcn = createCallbackFcn(app, @LeftButtonPressed, true);
            app.LeftButtonGroup.NX.ButtonPushedFcn = createCallbackFcn(app, @LeftButtonPressed, true);
            app.LeftButtonGroup.PY.ButtonPushedFcn = createCallbackFcn(app, @LeftButtonPressed, true);
            app.LeftButtonGroup.NY.ButtonPushedFcn = createCallbackFcn(app, @LeftButtonPressed, true);
            app.LeftButtonGroup.PZ.ButtonPushedFcn = createCallbackFcn(app, @LeftButtonPressed, true);
            app.LeftButtonGroup.NZ.ButtonPushedFcn = createCallbackFcn(app, @LeftButtonPressed, true);

            % Create LeftSliderGroup
            app.LeftSliderGroup = CustomJointControl(app.LeftGrid);
            app.LeftSliderGroup.GridLayout.Layout.Column = 1;
            app.LeftSliderGroup.GridLayout.Layout.Row = 3;
            app.LeftSliderGroup.Link0.ValueChangedFcn = createCallbackFcn(app, @LeftSlidersMoved, true);
            app.LeftSliderGroup.Link1.ValueChangedFcn = createCallbackFcn(app, @LeftSlidersMoved, true);
            app.LeftSliderGroup.Link2.ValueChangedFcn = createCallbackFcn(app, @LeftSlidersMoved, true);
            app.LeftSliderGroup.Link3.ValueChangedFcn = createCallbackFcn(app, @LeftSlidersMoved, true);
            app.LeftSliderGroup.Link4.ValueChangedFcn = createCallbackFcn(app, @LeftSlidersMoved, true);
            app.LeftSliderGroup.Link5.ValueChangedFcn = createCallbackFcn(app, @LeftSlidersMoved, true);
            app.LeftSliderGroup.Link5.ValueChangedFcn = createCallbackFcn(app, @LeftSlidersMoved, true);



            % Create CentrePanel
            app.CentrePanel = uipanel(app.GridLayout);
            app.CentrePanel.Layout.Row = 1;
            app.CentrePanel.Layout.Column = 2;

            % Create CentreGrid
            app.CentreGrid = uigridlayout(app.CentrePanel);
            app.CentreGrid.ColumnWidth = {'1x'};
            app.CentreGrid.RowHeight = {'7x','1x','1x'};
            app.CentreGrid.Padding = [10 10 10 10];

            % Create EStopSwitchLabel
            app.EStopSwitchLabel = uilabel(app.CentreGrid);
            app.EStopSwitchLabel.Text = 'E-Stop';
            app.EStopSwitchLabel.HorizontalAlignment = 'center';
            app.EStopSwitchLabel.Layout.Row = 2;
            app.EStopSwitchLabel.Layout.Column = 1;

            % Create EStopSwitch
            app.EStopSwitch = uiswitch(app.CentreGrid, 'slider');
            app.EStopSwitch.Layout.Row = 3;
            app.EStopSwitch.Layout.Column = 1;
            app.EStopSwitch.ValueChangedFcn = createCallbackFcn(app, @EStopValueChanged, true);



            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 1;

            % Create RightGrid
            app.RightGrid = uigridlayout(app.RightPanel);
            app.RightGrid.ColumnWidth = {'1x'};
            app.RightGrid.RowHeight = {'1x','3x', '6x'};
            app.RightGrid.ColumnSpacing = 2.5;
            app.RightGrid.Padding = [5 5 5 5];

            % Create RightPanelTitle
            app.RightPanelTitle = uilabel(app.RightGrid);
            app.RightPanelTitle.Text = 'Elle Robot';
            app.RightPanelTitle.Layout.Column = 1;
            app.RightPanelTitle.Layout.Row = 1;
            app.RightPanelTitle.HorizontalAlignment = 'center';

            % Create RightButtonGroup
            app.RightButtonGroup = CustomXYZControl(app.RightGrid, app);
            app.RightButtonGroup.GridLayout.Layout.Column = 1;
            app.RightButtonGroup.GridLayout.Layout.Row = 2;
            app.RightButtonGroup.PX.ButtonPushedFcn = createCallbackFcn(app, @RightButtonPressed, true);
            app.RightButtonGroup.NX.ButtonPushedFcn = createCallbackFcn(app, @RightButtonPressed, true);
            app.RightButtonGroup.PY.ButtonPushedFcn = createCallbackFcn(app, @RightButtonPressed, true);
            app.RightButtonGroup.NY.ButtonPushedFcn = createCallbackFcn(app, @RightButtonPressed, true);
            app.RightButtonGroup.PZ.ButtonPushedFcn = createCallbackFcn(app, @RightButtonPressed, true);
            app.RightButtonGroup.NZ.ButtonPushedFcn = createCallbackFcn(app, @RightButtonPressed, true);

            % Create RightSliderGroup
            app.RightSliderGroup = CustomJointControl(app.RightGrid);
            app.RightSliderGroup.GridLayout.Layout.Column = 1;
            app.RightSliderGroup.GridLayout.Layout.Row = 3;
            app.RightSliderGroup.Link0.ValueChangedFcn = createCallbackFcn(app, @RightSlidersMoved, true);
            app.RightSliderGroup.Link1.ValueChangedFcn = createCallbackFcn(app, @RightSlidersMoved, true);
            app.RightSliderGroup.Link2.ValueChangedFcn = createCallbackFcn(app, @RightSlidersMoved, true);
            app.RightSliderGroup.Link3.ValueChangedFcn = createCallbackFcn(app, @RightSlidersMoved, true);
            app.RightSliderGroup.Link4.ValueChangedFcn = createCallbackFcn(app, @RightSlidersMoved, true);
            app.RightSliderGroup.Link5.ValueChangedFcn = createCallbackFcn(app, @RightSlidersMoved, true);

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';

        end


    end

    % App creation and deletion
    methods (Access = public)
        function app = NedAndElleApp
            close all;
            % Create UIFigure and components
            creatComponents(app);


            % Register the app with App Designer
            registerApp(app, app.UIFigure);


            % Create Environment
            origin = SE3(transl(0,0,0));
            app = CreateAppEnvironment(app, origin);

            app.processLoop();
            disp('process loop commented out');

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end

        function app = processLoop(app)
            while (true)
                if (app.EStopSwitch.Value == "Off")
                    app.stepsComplete = app.stepsComplete + 1;
                    app.ElleRobot.doStep();
                    if (app.stepsComplete >= 40)
                        app.NedRobot.doStep();
                    end
                    pause(0.2);
                else
                    pause(0.1);
                end
            end
        end
    end
end