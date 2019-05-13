pageextension 50007 "PageExtension50007" extends "Registered Pick Subform"
{
    layout
    {
        addafter("Unit of Measure Code")
        {
            field(NoOfPackages; "No. of Packages")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the number of packages.';
            }
        }
    }
}