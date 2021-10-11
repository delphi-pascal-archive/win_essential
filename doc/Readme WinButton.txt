TWinButton
by MARTINEAU Emeric
Version 1.3
Sep - 03, 2007
this component is Freeware
----------
TWinButton
by Jose Maria Ferri
Version 1.2
Aug - 16, 2002
this component is Freeware

********************************************************************************************
**#### THE ONLY SENSE OF USING THIS BUTTON IS WHEN USING WINDOWS XP WITH ITS NEW LOOK ####**
********************************************************************************************

***##################################################***
**###### NOTE VERY IMPORTANT, SEE "USE" SECTION ######**
***##################################################***


DESCRIPTION:
------------

TWinButton is a Button that admits a bitmap. This button descends from windows buttons so it takes
new windows XP look if using


INSTALLATION: (delphi 6)
------------------------

Unzip WinButton.zip

Open Delphi 6, select Components->Install Component

Browse for WinButton.pas in "Unit name"

Press "Ok" button and then press "Compile" button

It will be installed in "Win32" tab


USE:
----

Drop a TWinButton component on your form. You'll see classical buttons but when running you'll
see a new Windows XP button.

IF YOU DON'T SEE THE BUTTON WITH NEW LOOK AT RUN TIME, IT ISN'T THIS BUTTON PROBLEM, BUT DELPHI (I THINK) PROBLEM.
YOU CAN SOLVE THIS BY CREATING A FILE WITH SAME NAME AS YOUR EXECUTABLE FILE (INCLUDING .EXE EXTENSION)
AND ADDING A SECOND EXTENSION: .manifest WITH THIS CODE:

<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">

<dependency>
    <dependentAssembly>
        <assemblyIdentity
            type="win32"
            name="Microsoft.Windows.Common-Controls"
            version="6.0.0.0"
            processorArchitecture="X86"
            publicKeyToken="6595b64144ccf1df"
            language="*"
        />
    </dependentAssembly>
</dependency>
</assembly>


For example, if your executable file is MyFirstProgram.exe, create a file called MyFirstProgram.exe.manifest
with that code inside.

Note:
If you find for .manifest files in your hard disk you'll see that windows XP has created a lot of them

NEW PROPERTIES:
---------------

* Bitmap
  Set bitmap for button

* BitmapLayout
  Set Top, left, botton or right aligment of bitmap

* ShowCaption
  Set whether show caption or not. The reason is that if caption is empty but shown and
  bitmap is, for example, on top, TWinButton saves room for text on the bottom, but if ShowCaption is false,
  bitmap is centered on button

* HotImage
  image show when mouse is in componant

* TextColor
  color of text

* HotTextColor
  color of text when mouso is in componant

* DropDownMenu
  menu who show when you click on button

* DropDownArrow
  bitmap arrow show when button have drop down menu

* ShowDropDownArrow
  show arrow or not when button have drop down menu

* WordWrap
  wrop text if too long

* ShowFocusRect
  show focus rectangle or not

* ToggleImage
  Image show all of X millisecondes

* Interval
  Millisecond to toggle between ToggleImage and Image

* OnTimer
  Event when timer are done
