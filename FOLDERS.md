# Folder Structure
## CALSource

This folder exists if:
* The extension was initialy made in CAL and converted to AL
* The extension was made in AL and downgraded to CAL 

Folder Structure

```
CALDownGrade
+-- NAV Version
    +-- Localization
       +-- Cumulative Update
           +-- Orginal  (*)
           +-- Modified (*)
``` 

(*) CAL source code folders should contain text files of **seperate objects** in order to make full use of source control. Splitting object text files should only be done through PowerShell, cause different tools may have different results, therefore creating differences in source control.

```PowerShell
Split-NAVApplicationObjectFile -Source <String> -Destination <String> -PreserveFormatting
```

## Documentation

Contains extra **technical** information releated to the extension. Preferably in [Markdown](https://www.markdownguide.org/), for legacy  reasons Word documents are allowed as wel. However, for new extensions one should consider using Markdown.
 Documentation coming from other parties is also allowed in other formats (pdf).

## InstallUpgrade
Contains codeunits for installing and upgrading the extension.

## Media
Can contain different types of binary media required.

## PermissionSets

Contains xml with [permission set](https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-export-permission-sets) definitions, at least 2 should be incuded:

* SETUP: All permissions on all objects.
* BASIC: Read & execute permissions on all objects.

## Rdlc

Location for report rdlc files

## Test
Contains test codeunits for the extension. Abecon standard extension *should* have test codeunits.
Customer extensions *can* have test codeunits, only if agreed on by customer.

## Translations
Contains xlf files with translations.