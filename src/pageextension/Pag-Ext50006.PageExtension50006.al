pageextension 50006 "PageExtension50006" extends "Whse. Pick Subform"
{
    layout
    {
        addbefore("Due Date")
        {
            field(NoOfPackages; "No. of Packages")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the number of packages.';
            }
        }
    }
}