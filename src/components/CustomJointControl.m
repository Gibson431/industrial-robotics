classdef CustomJointControl
    properties (Access = public)
        GridLayout matlab.ui.container.GridLayout
        Link0Label matlab.ui.control.Label
        Link0 matlab.ui.control.Slider

    end

    methods (Access = public)
        function self = CustomJointControl(parent)
            self.GridLayout = uigridlayout(parent);
            self.GridLayout.ColumnWidth = {'1x','1x'};
            self.GridLayout.RowHeight = {'1x','1x','1x','1x','1x','1x',};

            self.Link0Label = uilabel(self.GridLayout);
            self.Link0Label.Text = "Link 0";
            self.Link0.Layout.Column = 1;
            self.Link0.Layout.Row = 1;
            self.Link0 = uislider(self.GridLayout);
            self.Link0.Layout.Column = 2;
            self.Link0.Layout.Row = 1;
            

        end
    end
end