classdef NedAndElleApp < matlab.apps.AppBase

    properties (Access = public)
        UIFigure matlab.ui.Figure
        GridLayout matlab.ui.container.GridLayout

        LeftPanel  matlab.ui.container.Panel
        LeftGrid matlab.ui.container.GridLayout
        LeftPanelTitle matlab.ui.control.Label
        LeftTranslationGroup CustomXYZControl
        LeftRotationGroup CustomRPYControl
        LeftSliderGroup CustomJointControl

        CentrePanel matlab.ui.container.Panel
        CentreGrid matlab.ui.container.GridLayout
        AutoSwitch matlab.ui.control.RockerSwitch
        AutoSwitchLabel matlab.ui.control.Label
        EStopSwitch matlab.ui.control.Switch
        EStopSwitchLabel matlab.ui.control.Label

        RightPanel  matlab.ui.container.Panel
        RightGrid matlab.ui.container.GridLayout
        RightPanelTitle matlab.ui.control.Label
        RightTranslationGroup CustomXYZControl
        RightRotationGroup CustomRPYControl
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
        function LeftTranslationButtonPressed(app, event)
            xDot = [0 0 0 0 0 0];
            switch event.Source.Text
                case 'X +'
                    xDot(1) = 1;
                case 'X -'
                    xDot(1) = -1;
                case 'Y +'
                    xDot(2) = 1;
                case 'Y -'
                    xDot(2) = -1;
                case 'Z +'
                    xDot(3) = 1;
                case 'Z -'
                    xDot(3) = -1;
            end
            app.NedRobot.jogRMRC(xDot);
            app.updateLeftSliders();
        end

        function LeftRotationButtonPressed(app, event)
            xDot = [0 0 0 0 0 0];
            switch event.Source.Text
                case 'X +'
                    xDot(4) = 1;
                case 'X -'
                    xDot(4) = -1;
                case 'Y +'
                    xDot(5) = 1;
                case 'Y -'
                    xDot(5) = -1;
                case 'Z +'
                    xDot(6) = 1;
                case 'Z -'
                    xDot(6) = -1;
            end
            app.NedRobot.jogRMRC(xDot);
            app.updateLeftSliders();
        end

        function RightTranslationButtonPressed(app, event)
            xDot = [0 0 0 0 0 0];
            switch event.Source.Text
                case 'X +'
                    xDot(1) = 1;
                case 'X -'
                    xDot(1) = -1;
                case 'Y +'
                    xDot(2) = 1;
                case 'Y -'
                    xDot(2) = -1;
                case 'Z +'
                    xDot(3) = 1;
                case 'Z -'
                    xDot(3) = -1;
            end

            app.ElleRobot.jogRMRC(xDot);
            app.updateRightSliders();
        end

        function RightRotationButtonPressed(app, event)
            xDot = [0 0 0 0 0 0];
            switch event.Source.Text
                case 'X +'
                    xDot(4) = 1;
                case 'X -'
                    xDot(4) = -1;
                case 'Y +'
                    xDot(5) = 1;
                case 'Y -'
                    xDot(5) = -1;
                case 'Z +'
                    xDot(6) = 1;
                case 'Z -'
                    xDot(6) = -1;
            end
            app.ElleRobot.jogRMRC(xDot);           
            app.updateRightSliders();
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
        function app = updateLeftSliders(app)
            q = app.NedRobot.model.getpos();
            qDeg = rad2deg(q);
            app.LeftSliderGroup.Link0.Value = qDeg(1);
            app.LeftSliderGroup.Link1.Value = qDeg(2);
            app.LeftSliderGroup.Link2.Value = qDeg(3);
            app.LeftSliderGroup.Link3.Value = qDeg(4);
            app.LeftSliderGroup.Link4.Value = qDeg(5);
            app.LeftSliderGroup.Link5.Value = qDeg(6);
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

        function app = updateRightSliders(app)
            q = app.ElleRobot.model.getpos();
            qDeg = rad2deg(q);
            app.RightSliderGroup.Link0.Value = qDeg(1);
            app.RightSliderGroup.Link1.Value = qDeg(2);
            app.RightSliderGroup.Link2.Value = qDeg(3);
            app.RightSliderGroup.Link3.Value = qDeg(4);
            app.RightSliderGroup.Link4.Value = qDeg(5);
            app.RightSliderGroup.Link5.Value = qDeg(6);
        end

        function EStopValueChanged(app, event)
            % app.eStop = event.Value;
            app.AutoSwitch.Value = "Off";
        end
        function AutoValueChanged(app, event)
            % app.eStop = event.Value;
            if event.Value == "On"
                app.NedRobot.stepList = [];
                app.ElleRobot.stepList = [];
            end
            disp(event);
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
            app.LeftGrid.RowHeight = {'1x', '3x','3x','8x'};
            app.LeftGrid.ColumnSpacing = 2.5;
            app.LeftGrid.Padding = [5 5 5 5];

            % Create LeftPanelTitle
            app.LeftPanelTitle = uilabel(app.LeftGrid);
            app.LeftPanelTitle.Text = 'Ned Robot';
            app.LeftPanelTitle.Layout.Column = 1;
            app.LeftPanelTitle.Layout.Row = 1;
            app.LeftPanelTitle.HorizontalAlignment = 'center';

            % Create LeftTranslationGroup
            app.LeftTranslationGroup = CustomXYZControl(app.LeftGrid, app);
            app.LeftTranslationGroup.GridLayout.Layout.Column = 1;
            app.LeftTranslationGroup.GridLayout.Layout.Row = 2;
            app.LeftTranslationGroup.PX.ButtonPushedFcn = createCallbackFcn(app, @LeftTranslationButtonPressed, true);
            app.LeftTranslationGroup.NX.ButtonPushedFcn = createCallbackFcn(app, @LeftTranslationButtonPressed, true);
            app.LeftTranslationGroup.PY.ButtonPushedFcn = createCallbackFcn(app, @LeftTranslationButtonPressed, true);
            app.LeftTranslationGroup.NY.ButtonPushedFcn = createCallbackFcn(app, @LeftTranslationButtonPressed, true);
            app.LeftTranslationGroup.PZ.ButtonPushedFcn = createCallbackFcn(app, @LeftTranslationButtonPressed, true);
            app.LeftTranslationGroup.NZ.ButtonPushedFcn = createCallbackFcn(app, @LeftTranslationButtonPressed, true);

            % Create LeftRotationGroup
            app.LeftRotationGroup = CustomRPYControl(app.LeftGrid, app);
            app.LeftRotationGroup.GridLayout.Layout.Column = 1;
            app.LeftRotationGroup.GridLayout.Layout.Row = 3;
            app.LeftRotationGroup.PX.ButtonPushedFcn = createCallbackFcn(app, @LeftRotationButtonPressed, true);
            app.LeftRotationGroup.NX.ButtonPushedFcn = createCallbackFcn(app, @LeftRotationButtonPressed, true);
            app.LeftRotationGroup.PY.ButtonPushedFcn = createCallbackFcn(app, @LeftRotationButtonPressed, true);
            app.LeftRotationGroup.NY.ButtonPushedFcn = createCallbackFcn(app, @LeftRotationButtonPressed, true);
            app.LeftRotationGroup.PZ.ButtonPushedFcn = createCallbackFcn(app, @LeftRotationButtonPressed, true);
            app.LeftRotationGroup.NZ.ButtonPushedFcn = createCallbackFcn(app, @LeftRotationButtonPressed, true);

            % Create LeftSliderGroup
            app.LeftSliderGroup = CustomJointControl(app.LeftGrid, app.NedRobot.model);
            app.LeftSliderGroup.GridLayout.Layout.Column = 1;
            app.LeftSliderGroup.GridLayout.Layout.Row = 4;
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
            app.CentreGrid.RowHeight = {'1x','4x','2x','1x','2x'};
            app.CentreGrid.Padding = [10 10 10 10];

            % Create AutoSwitchLabel
            app.AutoSwitchLabel = uilabel(app.CentreGrid);
            app.AutoSwitchLabel.Text = 'Auto';
            app.AutoSwitchLabel.HorizontalAlignment = 'center';
            app.AutoSwitchLabel.Layout.Row = 1;
            app.AutoSwitchLabel.Layout.Column = 1;

            % Create AutoSwitch
            app.AutoSwitch = uiswitch(app.CentreGrid, 'rocker');
            app.AutoSwitch.Layout.Row = 2;
            app.AutoSwitch.Layout.Column = 1;
            app.AutoSwitch.ValueChangedFcn = createCallbackFcn(app, @AutoValueChanged, true);

            % Create EStopSwitchLabel
            app.EStopSwitchLabel = uilabel(app.CentreGrid);
            app.EStopSwitchLabel.Text = 'E-Stop';
            app.EStopSwitchLabel.HorizontalAlignment = 'center';
            app.EStopSwitchLabel.Layout.Row = 4;
            app.EStopSwitchLabel.Layout.Column = 1;

            % Create EStopSwitch
            app.EStopSwitch = uiswitch(app.CentreGrid, 'slider');
            app.EStopSwitch.Layout.Row = 5;
            app.EStopSwitch.Layout.Column = 1;
            app.EStopSwitch.ValueChangedFcn = createCallbackFcn(app, @EStopValueChanged, true);



            % Create RightPanel
            app.RightPanel = uipanel(app.GridLayout);
            app.RightPanel.Layout.Row = 1;
            app.RightPanel.Layout.Column = 1;

            % Create RightGrid
            app.RightGrid = uigridlayout(app.RightPanel);
            app.RightGrid.ColumnWidth = {'1x'};
            app.RightGrid.RowHeight = {'1x','3x','3x','8x'};
            app.RightGrid.ColumnSpacing = 2.5;
            app.RightGrid.Padding = [5 5 5 5];

            % Create RightPanelTitle
            app.RightPanelTitle = uilabel(app.RightGrid);
            app.RightPanelTitle.Text = 'Elle Robot';
            app.RightPanelTitle.Layout.Column = 1;
            app.RightPanelTitle.Layout.Row = 1;
            app.RightPanelTitle.HorizontalAlignment = 'center';

            % Create RightButtonGroup
            app.RightTranslationGroup = CustomXYZControl(app.RightGrid, app);
            app.RightTranslationGroup.GridLayout.Layout.Column = 1;
            app.RightTranslationGroup.GridLayout.Layout.Row = 2;
            app.RightTranslationGroup.PX.ButtonPushedFcn = createCallbackFcn(app, @RightTranslationButtonPressed, true);
            app.RightTranslationGroup.NX.ButtonPushedFcn = createCallbackFcn(app, @RightTranslationButtonPressed, true);
            app.RightTranslationGroup.PY.ButtonPushedFcn = createCallbackFcn(app, @RightTranslationButtonPressed, true);
            app.RightTranslationGroup.NY.ButtonPushedFcn = createCallbackFcn(app, @RightTranslationButtonPressed, true);
            app.RightTranslationGroup.PZ.ButtonPushedFcn = createCallbackFcn(app, @RightTranslationButtonPressed, true);
            app.RightTranslationGroup.NZ.ButtonPushedFcn = createCallbackFcn(app, @RightTranslationButtonPressed, true);

            % Create RightRotationGroup
            app.RightRotationGroup = CustomRPYControl(app.RightGrid, app);
            app.RightRotationGroup.GridLayout.Layout.Column = 1;
            app.RightRotationGroup.GridLayout.Layout.Row = 3;
            app.RightRotationGroup.PX.ButtonPushedFcn = createCallbackFcn(app, @RightRotationButtonPressed, true);
            app.RightRotationGroup.NX.ButtonPushedFcn = createCallbackFcn(app, @RightRotationButtonPressed, true);
            app.RightRotationGroup.PY.ButtonPushedFcn = createCallbackFcn(app, @RightRotationButtonPressed, true);
            app.RightRotationGroup.NY.ButtonPushedFcn = createCallbackFcn(app, @RightRotationButtonPressed, true);
            app.RightRotationGroup.PZ.ButtonPushedFcn = createCallbackFcn(app, @RightRotationButtonPressed, true);
            app.RightRotationGroup.NZ.ButtonPushedFcn = createCallbackFcn(app, @RightRotationButtonPressed, true);

            % Create RightSliderGroup
            app.RightSliderGroup = CustomJointControl(app.RightGrid, app.ElleRobot.model);
            app.RightSliderGroup.GridLayout.Layout.Column = 1;
            app.RightSliderGroup.GridLayout.Layout.Row = 4;
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

            % Create Environment
            origin = SE3(transl(0,0,0));
            app = CreateAppEnvironment(app, origin);

            % Create UIFigure and components
            creatComponents(app);

            % Register the app with App Designer
            registerApp(app, app.UIFigure);

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
                if (app.EStopSwitch.Value == "Off" && app.AutoSwitch.Value == "On")
                    app.stepsComplete = app.stepsComplete + 1;
                    app.ElleRobot.doStep();
                    if (app.stepsComplete >= 25)
                        app.NedRobot.doStep();
                    end
                    app.updateLeftSliders();
                    app.updateRightSliders();
                    pause(0.2);
                else
                    pause(0.1);
                end
            end
        end
    end
end