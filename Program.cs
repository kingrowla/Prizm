using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PowerPoint = Microsoft.Office.Interop.PowerPoint;
using Microsoft.Office.Core;
namespace powerPointExtract
{
    /*
     * program is for extracting notes out of MS powerpoint slides
     * next steps are to take the extracted notes and convert them into
     * a formatted xml document to be read by the GUI
     */
    class Program
    {
        static void Main(string[] args)
        {
            //Microsoft.Office.Interop.PowerPoint.Presentation presentation = multi_presentations.Open(@"C:\Users\terrellj\Desktop\C1_2_1-replace-force-generator_final.ppt");
            Microsoft.Office.Interop.PowerPoint.Application PowerPoint_App = new Microsoft.Office.Interop.PowerPoint.Application();
            Microsoft.Office.Interop.PowerPoint.Presentations multi_presentations = PowerPoint_App.Presentations;
            Microsoft.Office.Interop.PowerPoint.Presentation presentation = multi_presentations.Open(@"C:\Users\terrellj\Desktop\C1_2_1-replace-force-generator_final.ppt");
            string presentation_text = "";
            for (int i = 0; i < presentation.Slides.Count; i++)
            {
                var textRange = presentation.Slides[i + 1].NotesPage.Shapes[2].TextFrame.TextRange;
                var text = textRange.Text;
                System.Diagnostics.Debug.WriteLine(textRange.Text + "\n\n");
                //Console.Write(textRange.Text + "\n\n");
            }
            PowerPoint_App.Quit();
        }
    }
}
