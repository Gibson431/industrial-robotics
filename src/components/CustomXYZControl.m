classdef CustomXYZControl
    properties (Access = public)
        GridLayout matlab.ui.container.GridLayout
        PX matlab.ui.control.Button
        NX matlab.ui.control.Button
        PY matlab.ui.control.Button
        NY matlab.ui.control.Button
        PZ matlab.ui.control.Button
        NZ matlab.ui.control.Button
    end

    methods (Access = public)
        function self = CustomXYZControl(parent, app)
            self.GridLayout = uigridlayout(parent);
            self.GridLayout.ColumnWidth = {'1x','1x','1x','1x','1x'};
            self.GridLayout.RowHeight = {'1x','1x'};

            self.PX = uibutton(self.GridLayout);
            self.PX.Layout.Column = 3;
            self.PX.Layout.Row = 2;
            self.PX.Text = "X +";

            self.NX = uibutton(self.GridLayout);
            self.NX.Layout.Column = 1;
            self.NX.Layout.Row = 2;
            self.NX.Text = "X -";

            self.PY = uibutton(self.GridLayout);
            self.PY.Layout.Column = 2;
            self.PY.Layout.Row = 1;
            self.PY.Text = "Y +";

            self.NY = uibutton(self.GridLayout);
            self.NY.Layout.Column = 2;
            self.NY.Layout.Row = 2;
            self.NY.Text = "Y -";

            self.PZ = uibutton(self.GridLayout);
            self.PZ.Layout.Column = 5;
            self.PZ.Layout.Row = 1;
            self.PZ.Text = "Z +";

            self.NZ = uibutton(self.GridLayout);
            self.NZ.Layout.Column = 5;
            self.NZ.Layout.Row = 2;
            self.NZ.Text = "Z-";

        end
    end
end