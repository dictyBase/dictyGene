

/*
	 Milonic DHTML Website Navigation Menu
	 Written by Andy Woolley - Copyright 2003 (c) Milonic Solutions Limited. All Rights Reserved
	 Please visit http://www.milonic.co.uk/ for more information

	 Although this software may have been freely downloaded, you must obtain a license before using it in any production environment
	 The free use of this menu is only available to Non-Profit, Educational & Personal Web Sites who have obtained a license to use 
	 
	 Free, Commercial and Corporate Licenses are available from our website at http://www.milonic.co.uk/menu/supportcontracts.php
	 You also need to include a link back to http://www.milonic.co.uk/ if you use the free license
	 
	 All Copyright notices MUST remain in place at ALL times
	 If you cannot comply with all of the above requirements, please contact us to arrange a license waiver
*/



//The following line is critical for menu operation, and MUST APPEAR ONLY ONCE.
menunum=0;menus=new Array();_d=document;function addmenu(){menunum++;menus[menunum]=menu;}function dumpmenus(){mt="<scr"+"ipt language=JavaScript>";for(a=1;a<menus.length;a++){mt+=" menu"+a+"=menus["+a+"];"}mt+="<\/scr"+"ipt>";_d.write(mt)}
//Please leave the above line intact. The above also needs to be enabled if it not already enabled unless you have more than one _array.js file


////////////////////////////////////
// Editable properties START here //
////////////////////////////////////

timegap=500                   // The time delay for menus to remain visible
followspeed=5                 // Follow Scrolling speed
followrate=40                 // Follow Scrolling Rate
suboffset_top=0              // Sub menu offset Top position
suboffset_left=0             // Sub menu offset Left position


MenuStyle=[                  // PlainStyle is an array of properties. You can have as many property arrays as you need
"4E387E",                     // Mouse Off Font Color
"F3F2FF",                     // Mouse Off Background Color (use zero for transparent in Netscape 6)
"f7f7f7",                     // Mouse On Font Color
"4E387E",                     // Mouse On Background Color
"4E387E",                     // Menu Border Color
"12",                         // Font Size (default is px but you can specify mm, pt or a percentage)
"normal",                     // Font Style (italic or normal)
"bold",                       // Font Weight (bold or normal)
"Verdana, Tahoma, Arial, Helvetica",// Font Name
5,                            // Menu Item Padding or spacing
,                             // Sub Menu Image (Leave this blank if not needed)
0,                            // 3D Border & Separator bar
"FFFF00",                     // 3D High Color
,                     // 3D Low Color
,                     // Current Page Item Font Color (leave this blank to disable)
,                       // Current Page Item Background Color (leave this blank to disable)
,                             // Top Bar image (Leave this blank to disable)
"CCCCCC",                     // Menu Header Font Color (Leave blank if headers are not needed)
"000099",                     // Menu Header Background Color (Leave blank if headers are not needed)
,                             // Menu Item Separator Color
]


addmenu(menu=[
"genome_browser",                   // Menu Name - This is needed in order for this menu to be called
,                          // Menu Top - The Top position of this menu in pixels
,                          // Menu Left - The Left position of this menu in pixels
140,                          // Menu Width - Menus width in pixels
2,                            // Menu Border Width
,                             // Screen Position - here you can use "center;left;right;middle;top;bottom" or a combination of "center:middle"
MenuStyle,              // Properties Array - this array is declared higher up as you can see above
0,                            // Always Visible - allows this menu item to be visible at all time (1=on or 0=off)
,                             // Alignment - sets this menu elements text alignment, values valid here are: left, right or center
"Fade(duration=0.25)",         // Filter - Text variable for setting transitional effects on menu activation - see above for more info
0,                            // Follow Scrolling Top Position - Tells this menu to follow the user down the screen on scroll placing the menu at the value specified.
0,                            // Horizontal Menu - Tells this menu to display horizontaly instead of top to bottom style (1=on or 0=off)
0,                            // Keep Alive - Keeps the menu visible until the user moves over another menu or clicks elsewhere on the page (1=on or 0=off)
,                             // Position of TOP sub image left:center:right
,                             // Set the Overall Width of Horizontal Menu to specified width or 100% and height to a specified amount
0,                            // Right To Left - Used in Hebrew for example. (1=on or 0=off)
0,                            // Open the Menus OnClick - leave blank for OnMouseover (1=on or 0=off)
,                             // ID of the div you want to hide on MouseOver (useful for hiding form elements)
,                             // Background image for menu Color must be set to transparent for this to work
0,                            // Scrollable Menu
,                             // Miscellaneous Menu Properties
,"scaffold_1","/[%species%]/gbrowse?name=scaffold_1:1..30000",,,0
,"scaffold_2","/gbrowse?name=scaffold_2:1..30000",,,0
,"scaffold_3","/gbrowse?name=scaffold_3:1..30000",,,0
,"scaffold_4","/gbrowse?name=scaffold_4:1..30000",,,0
,"Many More...","/downloads/contig_information.html",,,0
])


addmenu(menu=[
"research_tools",                   // Menu Name - This is needed in order for this menu to be called
,                          // Menu Top - The Top position of this menu in pixels
,                          // Menu Left - The Left position of this menu in pixels
180,                          // Menu Width - Menus width in pixels
2,                            // Menu Border Width
,                             // Screen Position - here you can use "center;left;right;middle;top;bottom" or a combination of "center:middle"
MenuStyle,              // Properties Array - this array is declared higher up as you can see above
0,                            // Always Visible - allows this menu item to be visible at all time (1=on or 0=off)
,                             // Alignment - sets this menu elements text alignment, values valid here are: left, right or center
"Fade(duration=0.25)",         // Filter - Text variable for setting transitional effects on menu activation - see above for more info
0,                            // Follow Scrolling Top Position - Tells this menu to follow the user down the screen on scroll placing the menu at the value specified.
0,                            // Horizontal Menu - Tells this menu to display horizontaly instead of top to bottom style (1=on or 0=off)
0,                            // Keep Alive - Keeps the menu visible until the user moves over another menu or clicks elsewhere on the page (1=on or 0=off)
,                             // Position of TOP sub image left:center:right
,                             // Set the Overall Width of Horizontal Menu to specified width or 100% and height to a specified amount
0,                            // Right To Left - Used in Hebrew for example. (1=on or 0=off)
0,                            // Open the Menus OnClick - leave blank for OnMouseover (1=on or 0=off)
,                             // ID of the div you want to hide on MouseOver (useful for hiding form elements)
,                             // Background image for menu Color must be set to transparent for this to work
0,                            // Scrollable Menu
,                             // Miscellaneous Menu Properties
,"Techniques",          "/techniques/index.html",,,0
,"Franke Dictyostelium Reference Library",     "/reference_database/index.html",,,0
,"Mutant Phenotypes",     "/Downloads/all-curated-mutants.html",,,0
,"Mutant Movies",     "/phenotype/movies/index_dictybase.php",,,0
,"Axenic Strains History"             ,"/strain_history.htm",,,0
,"Vectors"             ,"/Vector_sequences_web/",,,0
,"STKE: cAMP Signaling",              "/STKE.htm",,,0
,"Codon Bias Table"                  ,"http://www.kazusa.or.jp/codon/cgi-bin/showcodon.cgi?species=Dictyostelium+discoideum+[gbinv]",,,0
,"Nomenclature Guidelines"             ,"/Dicty_Info/nomenclature_guidelines.html",,,0
,"Citing dictyBase and the Dictyostelium Genome Project","/CitingDictyBase.htm",,,0
,"Biochemical Pathways","/Dicty_Info/dictycyc_info.html",,,0
])


addmenu(menu=[
"colleagues",                   // Menu Name - This is needed in order for this menu to be called
,                          // Menu Top - The Top position of this menu in pixels
,                          // Menu Left - The Left position of this menu in pixels
200,                          // Menu Width - Menus width in pixels
2,                            // Menu Border Width
,                             // Screen Position - here you can use "center;left;right;middle;top;bottom" or a combination of "center:middle"
MenuStyle,              // Properties Array - this array is declared higher up as you can see above
0,                            // Always Visible - allows this menu item to be visible at all time (1=on or 0=off)
,                             // Alignment - sets this menu elements text alignment, values valid here are: left, right or center
"Fade(duration=0.25)",         // Filter - Text variable for setting transitional effects on menu activation - see above for more info
0,                            // Follow Scrolling Top Position - Tells this menu to follow the user down the screen on scroll placing the menu at the value specified.
0,                            // Horizontal Menu - Tells this menu to display horizontaly instead of top to bottom style (1=on or 0=off)
0,                            // Keep Alive - Keeps the menu visible until the user moves over another menu or clicks elsewhere on the page (1=on or 0=off)
,                             // Position of TOP sub image left:center:right
,                             // Set the Overall Width of Horizontal Menu to specified width or 100% and height to a specified amount
0,                            // Right To Left - Used in Hebrew for example. (1=on or 0=off)
0,                            // Open the Menus OnClick - leave blank for OnMouseover (1=on or 0=off)
,                             // ID of the div you want to hide on MouseOver (useful for hiding form elements)
,                             // Background image for menu Color must be set to transparent for this to work
0,                            // Scrollable Menu
,                             // Miscellaneous Menu Properties
,"Search the Colleagues Database"                ,    "/",,,0
,"Update/Add Yourself to the Colleagues Database",     "/",,,0
])

addmenu(menu=[
"links",                   // Menu Name - This is needed in order for this menu to be called
,                          // Menu Top - The Top position of this menu in pixels
,                          // Menu Left - The Left position of this menu in pixels
200,                          // Menu Width - Menus width in pixels
2,                            // Menu Border Width
,                             // Screen Position - here you can use "center;left;right;middle;top;bottom" or a combination of "center:middle"
MenuStyle,              // Properties Array - this array is declared higher up as you can see above
0,                            // Always Visible - allows this menu item to be visible at all time (1=on or 0=off)
,                             // Alignment - sets this menu elements text alignment, values valid here are: left, right or center
"Fade(duration=0.25)",         // Filter - Text variable for setting transitional effects on menu activation - see above for more info
0,                            // Follow Scrolling Top Position - Tells this menu to follow the user down the screen on scroll placing the menu at the value specified.
0,                            // Horizontal Menu - Tells this menu to display horizontaly instead of top to bottom style (1=on or 0=off)
0,                            // Keep Alive - Keeps the menu visible until the user moves over another menu or clicks elsewhere on the page (1=on or 0=off)
,                             // Position of TOP sub image left:center:right
,                             // Set the Overall Width of Horizontal Menu to specified width or 100% and height to a specified amount
0,                            // Right To Left - Used in Hebrew for example. (1=on or 0=off)
0,                            // Open the Menus OnClick - leave blank for OnMouseover (1=on or 0=off)
,                             // ID of the div you want to hide on MouseOver (useful for hiding form elements)
,                             // Background image for menu Color must be set to transparent for this to work
0,                            // Scrollable Menu
,                             // Miscellaneous Menu Properties
,"dictyBase" , "http://dictybase.org",,,0
])


addmenu(menu=[
"faq",                   // Menu Name - This is needed in order for this menu to be called
,                          // Menu Top - The Top position of this menu in pixels
,                          // Menu Left - The Left position of this menu in pixels
150,                          // Menu Width - Menus width in pixels
2,                            // Menu Border Width
,                             // Screen Position - here you can use "center;left;right;middle;top;bottom" or a combination of "center:middle"
MenuStyle,              // Properties Array - this array is declared higher up as you can see above
0,                            // Always Visible - allows this menu item to be visible at all time (1=on or 0=off)
,                             // Alignment - sets this menu elements text alignment, values valid here are: left, right or center
"Fade(duration=0.25)",         // Filter - Text variable for setting transitional effects on menu activation - see above for more info
0,                            // Follow Scrolling Top Position - Tells this menu to follow the user down the screen on scroll placing the menu at the value specified.
0,                            // Horizontal Menu - Tells this menu to display horizontaly instead of top to bottom style (1=on or 0=off)
0,                            // Keep Alive - Keeps the menu visible until the user moves over another menu or clicks elsewhere on the page (1=on or 0=off)
,                             // Position of TOP sub image left:center:right
,                             // Set the Overall Width of Horizontal Menu to specified width or 100% and height to a specified amount
0,                            // Right To Left - Used in Hebrew for example. (1=on or 0=off)
0,                            // Open the Menus OnClick - leave blank for OnMouseover (1=on or 0=off)
,                             // ID of the div you want to hide on MouseOver (useful for hiding form elements)
,                             // Background image for menu Color must be set to transparent for this to work
0,                            // Scrollable Menu
,                             // Miscellaneous Menu Properties
,"dictyBaseDP Help Files (coming soon)" , "#",,,0
])

addmenu(menu=[
"blast",                   // Menu Name - This is needed in order for this menu to be called
,                          // Menu Top - The Top position of this menu in pixels
,                          // Menu Left - The Left position of this menu in pixels
175,                          // Menu Width - Menus width in pixels
2,                            // Menu Border Width
,                             // Screen Position - here you can use "center;left;right;middle;top;bottom" or a combination of "center:middle"
MenuStyle,              // Properties Array - this array is declared higher up as you can see above
0,                            // Always Visible - allows this menu item to be visible at all time (1=on or 0=off)
,                             // Alignment - sets this menu elements text alignment, values valid here are: left, right or center
"Fade(duration=0.25)",         // Filter - Text variable for setting transitional effects on menu activation - see above for more info
0,                            // Follow Scrolling Top Position - Tells this menu to follow the user down the screen on scroll placing the menu at the value specified.
0,                            // Horizontal Menu - Tells this menu to display horizontaly instead of top to bottom style (1=on or 0=off)
0,                            // Keep Alive - Keeps the menu visible until the user moves over another menu or clicks elsewhere on the page (1=on or 0=off)
,                             // Position of TOP sub image left:center:right
,                             // Set the Overall Width of Horizontal Menu to specified width or 100% and height to a specified amount
0,                            // Right To Left - Used in Hebrew for example. (1=on or 0=off)
0,                            // Open the Menus OnClick - leave blank for OnMouseover (1=on or 0=off)
,                             // ID of the div you want to hide on MouseOver (useful for hiding form elements)
,                             // Background image for menu Color must be set to transparent for this to work
0,                            // Scrollable Menu
,                             // Miscellaneous Menu Properties
,"Blast Server" , "/tools/blast",,,0
])

addmenu(menu=[
"stock_center",                   // Menu Name - This is needed in order for this menu to be called
,                          // Menu Top - The Top position of this menu in pixels
,                          // Menu Left - The Left position of this menu in pixels
220,                          // Menu Width - Menus width in pixels
2,                            // Menu Border Width
,                             // Screen Position - here you can use "center;left;right;middle;top;bottom" or a combination of "center:middle"
MenuStyle,              // Properties Array - this array is declared higher up as you can see above
0,                            // Always Visible - allows this menu item to be visible at all time (1=on or 0=off)
,                             // Alignment - sets this menu elements text alignment, values valid here are: left, right or center
"Fade(duration=0.25)",         // Filter - Text variable for setting transitional effects on menu activation - see above for more info
0,                            // Follow Scrolling Top Position - Tells this menu to follow the user down the screen on scroll placing the menu at the value specified.
0,                            // Horizontal Menu - Tells this menu to display horizontaly instead of top to bottom style (1=on or 0=off)
0,                            // Keep Alive - Keeps the menu visible until the user moves over another menu or clicks elsewhere on the page (1=on or 0=off)
,                             // Position of TOP sub image left:center:right
,                             // Set the Overall Width of Horizontal Menu to specified width or 100% and height to a specified amount
0,                            // Right To Left - Used in Hebrew for example. (1=on or 0=off)
0,                            // Open the Menus OnClick - leave blank for OnMouseover (1=on or 0=off)
,                             // ID of the div you want to hide on MouseOver (useful for hiding form elements)
,                             // Background image for menu Color must be set to transparent for this to work
0,                            // Scrollable Menu
,                             // Miscellaneous Menu Properties
,"Dicty Stock Center Home" , "/StockCenter/StockCenter.html",,,0
,"Ordering Information"  , "/StockCenter/OrderInfo.html",,,0
,"Search the Dicty Stock Center"  , "/db/cgi-bin/dictyBase/SC/searchform.pl",,,0
,"Strain Catalog"  , "/db/cgi-bin/dictyBase/SC/strainlist.pl",,,0
,"Bacterial strain Catalog"  , "/db/cgi-bin/dictyBase/SC/bacterial_strainlist.pl",,,0
,"Plasmid Catalog"  , "/db/cgi-bin/dictyBase/SC/plasmid_catalog.pl",,,0
,"Procedure for Strain and Plasmid Deposits"  , "/StockCenter/Deposit.html",,,0
,"Nomenclature Guidelines"  , "/Dicty_Info/nomenclature_guidelines.html",,,0
,"Culture Media and Techniques"  , "/techniques/index.html#stockcenter",,,0
,"Other Stock Centers"  , "/StockCenter/OtherStockCenters.html",,,0
,"About Dicty Stock Center"  , "/StockCenter/AboutStockCenter.htm",,,0
])




dumpmenus();
	
