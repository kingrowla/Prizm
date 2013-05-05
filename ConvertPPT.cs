using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using PowerPoint = Microsoft.Office.Interop.PowerPoint;
using Microsoft.Office.Core;
namespace storyboardToPPTConverter
{
    /*
     * program is for extracting notes out of MS powerpoint slides
     * next steps are to take the extracted notes and convert them into
     * a formatted xml document to be read by the GUI
     */
    class ConvertPPT
    {
        internal static string Conversion(string path)
        {
            Microsoft.Office.Interop.PowerPoint.Application PowerPoint_App = new Microsoft.Office.Interop.PowerPoint.Application();
            Microsoft.Office.Interop.PowerPoint.Presentations multi_presentations = PowerPoint_App.Presentations;
            Microsoft.Office.Interop.PowerPoint.Presentation presentation = multi_presentations.Open(@path);
            string presentationText = "";

            //slides do not start at 0 index//
            for (int i = 1; i < presentation.Slides.Count + 1; i++)
            {
                //loop again inside each individual slide to check the notes section//
                for (int b = 1; b <= presentation.Slides[i].NotesPage.Shapes.Count; b++)
                {
                    var noteShape = presentation.Slides[i].NotesPage.Shapes[b];
                    if (noteShape.Type == Microsoft.Office.Core.MsoShapeType.msoPlaceholder)
                    {
                        if (noteShape.PlaceholderFormat.Type == PowerPoint.PpPlaceholderType.ppPlaceholderBody)
                        {
                            if (noteShape.HasTextFrame == MsoTriState.msoTrue)
                            {
                                presentationText = noteShape.TextFrame.TextRange.Text;
                                System.Diagnostics.Debug.WriteLine(presentationText);
                            }
                        }
                    }
                }
            }
            //end main for loop//
            PowerPoint_App.Quit();
            return presentationText;
        }
    }
}

